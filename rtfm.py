#!/usr/bin/env python3

import curses
import subprocess
import os

def create_man_page(program_name, description, options, examples):
    # Define the man page structure
    man_page_content = f"""
.TH {program_name.upper()} 1 "Date" "Version" "{program_name} manual"
.SH NAME
{program_name} - {description}
.SH SYNOPSIS
.B {program_name}
[options]
.SH DESCRIPTION
{description}
.SH OPTIONS
"""

    # Add options to the man page
    for option in options:
        man_page_content += f"\n.B {option['flag']}\n{option['description']}\n"

    man_page_content += ".SH EXAMPLES\n"

    # Add examples to the man page
    for example in examples:
        man_page_content += f"\n.B {example}\n"

    return man_page_content.strip()

def save_man_page(file_name, content):
    with open(file_name, 'w') as man_file:
        man_file.write(content)

def run_troff(man_page_file):
    # Specify the output txt file name
    output_file = f"{man_page_file.replace('.1', '')}.txt"  # Name for the formatted output
    try:
        # Redirect the output of troff to the specified .txt file
        with open(output_file, 'w') as outfile:
            subprocess.run(['groff', '-Tascii', '-man', man_page_file], stdout=outfile, check=True)
        return output_file  # Return the formatted output file name
    except subprocess.CalledProcessError as e:
        print(f"Error while running troff: {e}")
        return None

def get_user_input(win, prompt):
    curses.echo()  # Enable echoing of characters to the screen
    win.addstr(prompt)
    input_str = win.getstr().decode('utf-8')  # Decode bytes to get a string
    return input_str.strip()

def tui(win):
    curses.curs_set(1)  # Make cursor visible

    # Get program name
    program_name = get_user_input(win, "Enter the program name: ")

    # Get description
    description = get_user_input(win, "Enter a short description: ")

    # Get options
    options = []
    while True:
        option_flag = get_user_input(win, "Enter an option flag (or 'done' to finish): ")
        if option_flag.lower() == 'done':
            break
        option_description = get_user_input(win, "Enter the option description: ")
        options.append({'flag': option_flag, 'description': option_description})

    # Get examples
    examples = []
    while True:
        example = get_user_input(win, "Enter an example command (or 'done' to finish): ")
        if example.lower() == 'done':
            break
        examples.append(example)

    # Create man page
    man_page_content = create_man_page(program_name, description, options, examples)

    # Save to a file (e.g., my_program.1)
    man_page_filename = f"{program_name}.1"
    save_man_page(man_page_filename, man_page_content)

    # Run troff on the generated man page
    formatted_output_file = run_troff(man_page_filename)

    if formatted_output_file:
        win.addstr(f"\nMan page for '{program_name}' generated as '{man_page_filename}'.\n")
        win.addstr(f"Formatted output created: '{formatted_output_file}'.\n")
    else:
        win.addstr("Failed to generate formatted output.\n")

    win.addstr("Press any key to exit...")
    win.getch()  # Wait for user input

def main():
    curses.wrapper(tui)

if __name__ == "__main__":
    main()
