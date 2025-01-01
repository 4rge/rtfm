## Webpage:

A simple web application that enables users to generate manual (man) pages for command-line programs. This tool allows you to create customized man pages by inputting program details, options, and examples, and provides the ability to download the generated man page.

## Features

- Input fields for program name and description.
- Dynamic addition of option flags and their descriptions.
- Dynamic addition of example commands.
- Generation of the formatted man page output.
- Command for converting the generated man page for use.
- Download option for the generated man page in `.1` format.

## Usage

1. Open the Man Page Generator in your web browser.
2. Enter the **Program Name** and a brief **Description** of the program.
3. Click the **Add Option** button to input command-line options. For each option, provide:
   - An option flag (e.g., `-h`)
   - A description of what the option does.
4. Click the **Add Example** button to input example commands that demonstrate usage of the program.
5. Click the **Generate Man Page** button to see the formatted man page based on the provided inputs.
6. The command to convert the generated man page will be displayed along with the option to download it.
7. Click the **Download Man Page** button to save the man page to your device.


# Bash or Python Script:

A command-line application in Python/Bash that facilitates the creation of manual (man) pages for various command-line programs. This program allows users to input details such as the program name, description, options, and examples. It then generates a formatted man page and provides an option to view it.

## Features

- Interactive command-line interface using the `curses` library for an enhanced user experience (python) or without tui (bash).
- Easily input program details, options, and examples.
- Automatically generates a man page in the conventional format.
- Uses `groff` to produce a formatted output for the man page.

## Prerequisites

Before running this application, ensure you have the following installed:

- Python 3 if using TUI version
- `groff` command-line tool for formatting man pages

# Usage
Launch the program:
Follow the prompts in the terminal to:
Enter the program name.
Provide a short description of the program.
Add option flags and their corresponding descriptions (type done to finish).
Add example commands (type done to finish).
The generated man page will be saved in a file named <program_name>.1.
The formatted output will also be created in a .txt file.
To exit the application, press any key after the man page generation is complete.

## License

This script is open-source. You are free to modify and use it under the terms of your choice, provided proper attribution is given.

## Support and Contributions

For any issues or feature requests, please feel free to open an issue or submit a pull request in the repository where this project is maintained.

## Disclaimer

This script is provided as-is. Please ensure that the generated man pages are accurate and formatted correctly before using them in a production environment.
