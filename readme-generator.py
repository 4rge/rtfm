import curses

def prompt_input(stdscr, prompt, default=""):
    curses.echo()  # Enable echoing of typed characters
    stdscr.addstr(prompt + f" [{default}]: ")
    input_str = stdscr.getstr().decode('utf-8').strip()
    return input_str if input_str else default

def prompt_include(stdscr, prompt):
    stdscr.addstr(f"{prompt} (y/n)? ")
    while True:
        input_str = stdscr.getstr().decode('utf-8').strip().lower()
        if input_str in ['y', 'n']:
            return input_str == 'y'

def main(stdscr):
    curses.curs_set(1)  # Show cursor
    stdscr.clear()

    stdscr.addstr("Welcome to the GitHub README Generator!\n\n")

    # Project Title
    title = prompt_input(stdscr, "Project Title", "Your Project Title")

    # Sections to include
    include_description = prompt_include(stdscr, "Include Description")
    include_installation = prompt_include(stdscr, "Include Installation Instructions")
    include_usage = prompt_include(stdscr, "Include Usage Information")
    include_contribution = prompt_include(stdscr, "Include Support and Contributions")
    include_license = prompt_include(stdscr, "Include License")

    # Gather input for each section
    description = ""
    installation = ""
    usage = ""
    contribution = ""
    license_info = ""

    if include_description:
        description = prompt_input(stdscr, "Description", "Enter a brief description of your project")

    if include_installation:
        installation = prompt_input(stdscr, "Installation Instructions", "To install this project, clone the repository and run: npm install")

    if include_usage:
        usage = prompt_input(stdscr, "Usage Information", "To use this project, run: node index.js")

    if include_contribution:
        contribution = prompt_input(stdscr, "Support and Contributions", "For issues or feature requests, open an issue or submit a PR.")

    if include_license:
        license_info = prompt_input(stdscr, "License", "MIT")

    # Generate README content
    readme_content = f"# {title}\n\n"

    if include_description:
        readme_content += f"## Description\n{description}\n\n"
    if include_installation:
        readme_content += f"## Installation\n{installation}\n\n"
    if include_usage:
        readme_content += f"## Usage\n{usage}\n\n"
    if include_contribution:
        readme_content += f"## Support and Contributions\n{contribution}\n\n"
    if include_license:
        readme_content += f"## License\n{license_info}\n"

    # Write the README content to README.md file
    with open("README.md", "w") as f:
        f.write(readme_content)

    stdscr.clear()
    stdscr.addstr("README.md has been generated!\n")
    stdscr.addstr("Press any key to exit.")
    stdscr.refresh()
    
    stdscr.getch()  # Wait for user to press a key

if __name__ == "__main__":
    curses.wrapper(main)
