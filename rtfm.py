import curses
import subprocess
from datetime import date

def create_man_page(program_name, description, version, date_str, exit_status, options):
    man_page = f".TH {program_name.upper()} 1 \"{date_str}\" \"{version}\" \"{program_name} manual\"\n"
    
    if program_name and description:
        man_page += f".SH NAME\n{program_name} - {description}\n"
    if program_name:
        man_page += f".SH SYNOPSIS\n.B {program_name}\n"

    return man_page

def get_user_input(win, prompt, allow_empty=True):
    """Function to get user input for a prompt."""
    win.addstr(prompt)
    curses.echo()  # Enable echoing user input
    user_input = win.getstr().decode('utf-8').strip()  # Get user input
    curses.noecho()  # Disable echoing
    return user_input if allow_empty or user_input else get_user_input(win, prompt, allow_empty)

def gather_section(win, section_name):
    """Gather a section of options from the user."""
    win.addstr(f"Include {section_name} in the man page? (y/n): ")
    include = win.getch()
    if chr(include).lower() == 'y':
        entries = []
        while True:
            entry = get_user_input(win, f"Enter a {section_name} (or 'done' to finish): ")
            if entry.lower() == 'done':
                break
            entries.append(entry)
        return entries
    return []

def check_groff_installed():
    """Check if groff is installed on the system."""
    if subprocess.run(['which', 'groff'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
        raise RuntimeError("Error: 'groff' not installed. Install it to generate the man page.")

def main(stdscr):
    """Main function for the program."""
    curses.curs_set(0)  # Hide the cursor
    stdscr.clear()
    
    check_groff_installed()

    program_name = get_user_input(stdscr, "Enter the program name: ")
    description = get_user_input(stdscr, "Enter a short description: ")
    version = get_user_input(stdscr, "Enter the version number: ")
    date_str = date.today().strftime("%Y-%m-%d")
    exit_status = get_user_input(stdscr, "Enter the exit status description: ")

    # Gather sections from the user
    options = gather_section(stdscr, "options")
    examples = gather_section(stdscr, "examples")
    files = gather_section(stdscr, "files")
    functionality_notes = get_user_input(stdscr, "Include functionality notes? (y/n): ", False)
    if functionality_notes.lower() == 'y':
        functionality_notes = get_user_input(stdscr, "Enter any functionality notes: ")
    else:
        functionality_notes = ""

    see_also = gather_section(stdscr, "see also")

    # Create the man page content
    man_page_content = create_man_page(program_name, description, version, date_str, exit_status, options)
    
    # Save the man page content to a file
    man_page_filename = f"{program_name}.1"
    with open(man_page_filename, 'w') as f:
        f.write(man_page_content)

    # Generate the formatted output using groff
    output_file = f"{program_name}.txt"
    subprocess.run(['groff', '-Tascii', '-man', man_page_filename], stdout=open(output_file, 'w'))

    stdscr.clear()
    stdscr.addstr(f"Man page for '{program_name}' generated as '{man_page_filename}'.\n")
    stdscr.addstr(f"Formatted output created: '{output_file}'.\n")
    stdscr.addstr("Press any key to exit...")
    stdscr.refresh()
    stdscr.getch()

if __name__ == "__main__":
    curses.wrapper(main)
