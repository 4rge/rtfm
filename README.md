# Unified README & R.T.F.M. Generator

## Overview
The Unified README & R.T.F.M. Generator is a web-based tool designed to help developers create both README files and man pages for their projects efficiently. It features an easy-to-use interface, allowing users to input required fields, generate markdown content, and export the results in various formats.

## Features
- **Dual Functionality**: Toggle between README generation and man page (R.T.F.M.) generation with a single button.
- **Customizable Fields**: Easily input project details such as title, description, installation instructions, usage information, and more.
- **Content Preview**: View generated markdown or man page content in real-time.
- **Export Options**: Copy the generated content to your clipboard or download it as a `.md` file or man page.
- **Responsive Design**: Optimized for use on various devices with a flexible layout.

## Getting Started
To use the generator:
1. Open the HTML file in a web browser.
2. Enter the relevant information for your project's README or man page.
3. Use the toggle button to switch between the README and R.T.F.M. sections.
4. Fill in the fields and check or uncheck options for content inclusion.
5. Generate the corresponding document and use the buttons to copy or download the content.

## Usage Instructions
### README Generator
- **Project Title**: Enter the title of your project.
- **Description**: Briefly describe what your project does.
- **Installation Instructions**: Provide steps for installing the project.
- **Usage Information**: Describe how to use the project.
- **Support and Contributions**: Include information on how others can contribute or seek support.
- **License**: Select the appropriate license for your project.

### R.T.F.M. Generator
- **Program Name**: Specify the name of your program.
- **Description**: Short description of what the program does.
- **Version**: Enter the version number of the program.
- **Exit Status**: Describe the program's exit statuses.
- **Options**: Detail the command-line options available for the program.
- **Date**: Automatically populated with the current date when the page loads.

## Example
In the README section, you can input the following:
- **Project Title**: My Awesome Project
- **Description**: This project aims to solve a major problem in a unique way.
- **Installation Instructions**: Clone the repository and run `npm install`.
- **Usage Information**: Run the command `node index.js` to start.
- **Support and Contributions**: Feel free to open an issue or submit a pull request.
- **License**: Choose MIT from the dropdown.

And obtain the resultant markdown in the preview area, which can then be exported.

## Development Notes
- The generator is created with HTML, CSS, and JavaScript.
- You may modify the `style.css` file for additional styling.
- Ensure you have a suitable environment to run this HTML file in a browser.

## Command-Line and Text User Interface Versions
The functionalities of both sides of the webpage have been reimplemented in Bash and Python scripts for broader usage:
- **Bash Scripts**: For Unix-compliant devices, scripts are available as `rtfm.sh` and `readme-generator.sh`.
- **Python Scripts**: For non-Unix devices, functionality is provided through `rtfm.py` and `readme-generator.py`.

These scripts allow you to generate README files and man pages directly from the command line or a text user interface, ensuring compatibility across various operating systems.

## Contributions
- Contributions are welcome! Please submit issues or pull requests for improvements or feature additions.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Live Demo
You can try out the generator by opening the provided HTML file in your web browser. Enjoy creating your documentation with ease!
