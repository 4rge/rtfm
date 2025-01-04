#!/bin/bash

# Function to create man page content
create_man_page() {
    local program_name=$1
    local description=$2
    local version=$3
    local date=$4
    local exit_status=$5
    shift 5
    local options=("$@")
    local man_page=""

    # Header
    man_page+=".TH ${program_name^^} 1 \"$date\" \"$version\" \"${program_name} manual\"\n"

    # Name Section
    if [[ -n "$program_name" && -n "$description" ]]; then
        man_page+=".SH NAME\n"
        man_page+="$program_name - $description\n"
    fi

    # Synopsis Section
    if [[ -n "$program_name" ]]; then
        man_page+=".SH SYNOPSIS\n"
        man_page+=".B $program_name\n"

        # Check if input files are needed
        read -p "Do you want to include input files in the synopsis? (y/n): " include_input
        if [[ $include_input =~ ^[Yy]$ ]]; then
            man_page+="[input_file] "
        fi

        # Check if output files are needed
        read -p "Do you want to include output files in the synopsis? (y/n): " include_output
        if [[ $include_output =~ ^[Yy]$ ]]; then
            man_page+="[output_file] "
        fi

        man_page+="\n"
    fi

    # Description Section
    if [[ -n "$description" ]]; then
        man_page+=".SH DESCRIPTION\n"
        man_page+="$description\n"
    fi

    # Exit Status Section
    if [[ -n "$exit_status" ]]; then
        man_page+=".SH EXIT STATUS\n"
        man_page+="$exit_status\n"
    fi

    # Options Section
    if [[ ${#options[@]} -gt 0 ]]; then
        man_page+=".SH OPTIONS\n"
        for option in "${options[@]}"; do
            IFS='|' read -r flag desc type default <<< "$option"
            man_page+="\n.B $flag\n$desc\n"
            [[ -n "$type" ]] && man_page+="Type: $type\n"
            [[ -n "$default" ]] && man_page+="Default: $default\n"
        done
    fi

    # Examples Section
    if [[ ${#examples[@]} -gt 0 ]]; then
        man_page+=".SH EXAMPLES\n"
        for example in "${examples[@]}"; do
            IFS='|' read -r cmd output notes <<< "$example"
            man_page+=".RS\n.B $program_name $cmd\n"
            [[ -n "$output" ]] && man_page+="Expected output: $output\n"
            [[ -n "$notes" ]] && man_page+="Notes: $notes\n"
            man_page+=".RE\n"
        done
    fi

    # Files Section
    if [[ ${#files[@]} -gt 0 ]]; then
        man_page+=".SH FILES\n"
        for file in "${files[@]}"; do
            man_page+=".B $file\nThis file is used by the program.\n"
        done
    else
        man_page+=".SH FILES\nNo specific files are used by this program.\n"
    fi

    # Functionality Notes Section
    if [[ -n "$functionality_notes" ]]; then
        man_page+=".SH FUNCTIONALITY NOTES\n"
        man_page+="$functionality_notes\n"
    fi

    # Custom See Also Section
    if [[ ${#see_also[@]} -gt 0 ]]; then
        man_page+=".SH SEE ALSO\n"
        for entry in "${see_also[@]}"; do
            man_page+=".B $entry\n"
        done
    fi

    echo -e "$man_page"
}

# Function to gather user input with y/n prompts for section inclusion
get_user_input() {
    local prompt="$1"
    local input
    read -p "$prompt" input
    echo "$input"
}

# Function to verify if groff is installed
check_groff_installed() {
    if ! command -v groff &> /dev/null; then
        echo "Error: 'groff' is not installed. Please install it to generate the man page."
        exit 1
    fi
}

# Function to gather options with y/n prompts
gather_options() {
    options=()
    read -p "Do you want to include options in the man page? (y/n): " include_options
    if [[ $include_options =~ ^[Yy]$ ]]; then
        while true; do
            option_flag=$(get_user_input "Enter an option flag (or 'done' to finish): ")
            if [[ $option_flag == "done" ]]; then
                break
            fi
            option_description=$(get_user_input "Enter the option description: ")
            option_type=$(get_user_input "Enter the parameter type (press Enter to skip): ")
            option_default=$(get_user_input "Enter the default value (press Enter to skip): ")
            options+=("$option_flag|$option_description|$option_type|$option_default")
        done
    fi
}

# Function to gather examples with y/n prompts
gather_examples() {
    examples=()
    read -p "Do you want to include examples in the man page? (y/n): " include_examples
    if [[ $include_examples =~ ^[Yy]$ ]]; then
        while true; do
            example_cmd=$(get_user_input "Enter an example command (or 'done' to finish): ")
            if [[ $example_cmd == "done" ]]; then
                break
            fi
            expected_output=$(get_user_input "Enter expected output (press Enter to skip): ")
            notes=$(get_user_input "Enter notes for the example (press Enter to skip): ")
            examples+=("$example_cmd|$expected_output|$notes")
        done
    fi
}

# Function to gather files
gather_files() {
    files=()
    read -p "Do you want to include files in the man page? (y/n): " include_files
    if [[ $include_files =~ ^[Yy]$ ]]; then
        while true; do
            file=$(get_user_input "Enter a file used by the program (or 'done' to finish): ")
            if [[ $file == "done" ]]; then
                break
            fi
            files+=("$file")
        done
    fi
}

# Function to gather functionality notes
gather_functionality_notes() {
    read -p "Do you want to include functionality notes? (y/n): " include_functionality_notes
    if [[ $include_functionality_notes =~ ^[Yy]$ ]]; then
        functionality_notes=$(get_user_input "Enter any functionality notes: ")
    fi
}

# Function to gather see also references
gather_see_also() {
    see_also=()
    read -p "Do you want to include 'see also' references? (y/n): " include_see_also
    if [[ $include_see_also =~ ^[Yy]$ ]]; then
        while true; do
            reference=$(get_user_input "Enter a related command or reference (or 'done' to finish): ")
            if [[ $reference == "done" ]]; then
                break
            fi
            see_also+=("$reference")
        done
    fi
}

# Main script
main() {
    # Check if groff is installed
    check_groff_installed

    # Gather mandatory inputs
    program_name=$(get_user_input "Enter the program name: ")
    description=$(get_user_input "Enter a short description: ")
    version=$(get_user_input "Enter the version number: ")
    date=$(date +%Y-%m-%d)
    
    # Ask for optional sections
    exit_status=$(get_user_input "Enter the exit status description (success and error codes): ")

    gather_options
    gather_examples
    gather_files
    gather_functionality_notes
    gather_see_also

    # Create man page content
    man_page_content=$(create_man_page "$program_name" "$description" "$version" "$date" "$exit_status" "${options[@]}")

    # Save to a .1 file
    man_page_filename="${program_name}.1"
    echo -e "$man_page_content" > "$man_page_filename" || {
        echo "Error: Could not write to '$man_page_filename'."
        exit 1
    }

    # Run groff to format the man page into .txt
    output_file="${program_name}.txt"
    groff -Tascii -man "$man_page_filename" > "$output_file" || {
        echo "Error: Failed to generate formatted output from man page."
        exit 1
    }

    echo "Man page for '$program_name' generated as '$man_page_filename'."
    echo "Formatted output created: '$output_file'."
}

# Invoke the main function
main
