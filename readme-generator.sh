#!/bin/bash

# Function to prompt for input with a default value
prompt_input() {
    local prompt="$1"
    local default="$2"
    read -r -p "$prompt [$default]: " input
    echo "${input:-$default}"
}

# Function to ask if the user wants to include a section
prompt_include() {
    local prompt="$1"
    read -r -p "$prompt (y/n)? " input
    if [[ "$input" =~ ^[Yy]$ ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Main script
echo "Welcome to the GitHub README Generator!"

# Project Title
title=$(prompt_input "Project Title" "Your Project Title")

# Sections to include
include_description=$(prompt_include "Include Description")
include_installation=$(prompt_include "Include Installation Instructions")
include_usage=$(prompt_include "Include Usage Information")
include_contribution=$(prompt_include "Include Support and Contributions")
include_license=$(prompt_include "Include License")

# Gather input for each section
description=""
installation=""
usage=""
contribution=""
license=""

[[ "$include_description" == "true" ]] && description=$(prompt_input "Description" "Enter a brief description of your project")
[[ "$include_installation" == "true" ]] && installation=$(prompt_input "Installation Instructions" "To install this project, clone the repository and run the following command: npm install")
[[ "$include_usage" == "true" ]] && usage=$(prompt_input "Usage Information" "To use this project, execute the following command: node index.js")
[[ "$include_contribution" == "true" ]] && contribution=$(prompt_input "Support and Contributions" "For any issues or feature requests, please feel free to open an issue or submit a pull request in the repository where this project is maintained.")
[[ "$include_license" == "true" ]] && license=$(prompt_input "License" "MIT")

# Generate README content
readme_content="# $title\n\n"

if [[ "$include_description" == "true" ]]; then
    readme_content+="## Description\n$description\n\n"
fi
if [[ "$include_installation" == "true" ]]; then
    readme_content+="## Installation\n$installation\n\n"
fi
if [[ "$include_usage" == "true" ]]; then
    readme_content+="## Usage\n$usage\n\n"
fi
if [[ "$include_contribution" == "true" ]]; then
    readme_content+="## Support and Contributions\n$contribution\n\n"
fi
if [[ "$include_license" == "true" ]]; then
    license_choice=$(prompt_input "Select a License" "MIT")
    readme_content+="## License\n$license_choice\n"
fi

# Output README content to README.md file
echo -e "$readme_content" > README.md
echo "README.md has been generated!"
