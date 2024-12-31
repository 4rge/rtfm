#!/bin/bash

# Function to create man page content
create_man_page() {
    local program_name=$1
    local description=$2
    shift 2
    local options=("$@")
    local man_page=""

    man_page+=".TH ${program_name^^} 1 \"Date\" \"Version\" \"${program_name} manual\"\n"
    man_page+=".SH NAME\n"
    man_page+="${program_name} - ${description}\n"
    man_page+=".SH SYNOPSIS\n"
    man_page+=".B ${program_name}\n[options]\n"
    man_page+=".SH DESCRIPTION\n"
    man_page+="${description}\n"
    man_page+=".SH OPTIONS\n"

    for option in "${options[@]}"; do
        IFS='|' read -r flag desc <<< "$option"
        man_page+="\n.B $flag\n$desc\n"
    done

    man_page+=".SH EXAMPLES\n"
    
    return_string="$man_page"
    echo -e "$return_string"
}

# Function to gather user input
get_user_input() {
    local prompt="$1"
    read -p "$prompt " input
    echo "$input"
}

# Main script
main() {
    # Gather inputs
    program_name=$(get_user_input "Enter the program name:")
    description=$(get_user_input "Enter a short description:")

    options=()
    while true; do
        option_flag=$(get_user_input "Enter an option flag (or 'done' to finish):")
        if [[ $option_flag == "done" ]]; then
            break
        fi
        option_description=$(get_user_input "Enter the option description:")
        options+=("$option_flag|$option_description")
    done

    examples=()
    while true; do
        example=$(get_user_input "Enter an example command (or 'done' to finish):")
        if [[ $example == "done" ]]; then
            break
        fi
        examples+=("$example")
    done

    # Create man page content
    man_page_content=$(create_man_page "$program_name" "$description" "${options[@]}")

    # Save to a .1 file
    man_page_filename="${program_name}.1"
    echo -e "$man_page_content" > "$man_page_filename"

    # Run groff to format the man page into .txt
    output_file="${program_name}.txt"
    groff -Tascii -man "$man_page_filename" > "$output_file"

    echo "Man page for '$program_name' generated as '$man_page_filename'."
    echo "Formatted output created: '$output_file'."
}

# Invoke the main function
main
