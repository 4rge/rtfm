#!/bin/bash

# Function to create manpage content
create_man_page() {
    local program_name="$1" description="$2" version="$3" date="$4" exit_status="$5" options=("${@:6}")

    # Build man page
    man_page=".TH ${program_name^^} 1 \"$date\" \"$version\" \"${program_name} manual\"\n"
    
    [[ -n "$program_name" && -n "$description" ]] && man_page+=".SH NAME\n$program_name - $description\n"
    [[ -n "$program_name" ]] && man_page+=".SH SYNOPSIS\n.B $program_name\n"
    
    read -p "Include input files in the synopsis? (y/n): " include_input
    [[ $include_input =~ ^[Yy]$ ]] && man_page+="[input_file] "
    
    read -p "Include output files in the synopsis? (y/n): " include_output
    [[ $include_output =~ ^[Yy]$ ]] && man_page+="[output_file] \n"

    [[ -n "$description" ]] && man_page+=".SH DESCRIPTION\n$description\n"
    [[ -n "$exit_status" ]] && man_page+=".SH EXIT STATUS\n$exit_status\n"

    if [[ ${#options[@]} -gt 0 ]]; then
        man_page+=".SH OPTIONS\n"
        for option in "${options[@]}"; do
            IFS='|' read -r flag desc type default <<< "$option"
            man_page+="\n.B $flag\n$desc\n"
            [[ -n "$type" ]] && man_page+="Type: $type\n"
            [[ -n "$default" ]] && man_page+="Default: $default\n"
        done
    fi

    echo -e "$man_page"
}

# Function to gather user input with y/n prompts
get_user_input() {
    local prompt="$1" input
    read -p "$prompt" input
    echo "$input"
}

# Function to verify if groff is installed
check_groff_installed() {
    command -v groff &> /dev/null || { echo "Error: 'groff' not installed. Install it to generate the man page."; exit 1; }
}

# Generic gathering function
gather_section() {
    local section_name="$1" prompt="$2" array_name="$3"
    eval "$array_name=()"
    read -p "$prompt (y/n): " include
    if [[ $include =~ ^[Yy]$ ]]; then
        while :; do
            local entry="$(get_user_input "Enter a $section_name (or 'done' to finish): ")"
            [[ $entry == "done" ]] && break
            eval "$array_name+=(\"$entry\")"
        done
    fi
}

# Main script
main() {
    check_groff_installed

    program_name=$(get_user_input "Enter the program name: ")
    description=$(get_user_input "Enter a short description: ")
    version=$(get_user_input "Enter the version number: ")
    date=$(date +%Y-%m-%d)
    exit_status=$(get_user_input "Enter the exit status description: ")

    gather_section "option" "Include options in the man page?" "options"
    gather_section "example" "Include examples in the man page?" "examples"
    gather_section "file" "Include files in the man page?" "files"

    [[ -n $(get_user_input "Include functionality notes? (y/n): ") && "y" == "y" ]] && functionality_notes=$(get_user_input "Enter any functionality notes: ")
    gather_section "see also" "Include 'see also' references?" "see_also"

    man_page_content=$(create_man_page "$program_name" "$description" "$version" "$date" "$exit_status" "${options[@]}")
    
    man_page_filename="${program_name}.1"
    echo -e "$man_page_content" > "$man_page_filename" || { echo "Error: Can't write to '$man_page_filename'."; exit 1; }
    
    output_file="${program_name}.txt"
    groff -Tascii -man "$man_page_filename" > "$output_file" || { echo "Error: Failed to generate formatted output."; exit 1; }

    echo "Man page for '$program_name' generated as '$man_page_filename'."
    echo "Formatted output created: '$output_file'."
}

main
