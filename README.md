# Create Research Folders

A lightweight Windows utility that automatically creates an organized folder structure for research projects.

**Start every research project with an organized workspace—without manually creating folders every time.**

## Features

- **Simple GUI:** Create folders through a graphical interface.
- **Custom Project Names:** Choose a name for your research project.
- **Flexible Location:** Select where your project folder will be created.
- **Automatic Organization:** Create predefined subfolders in seconds.
- **Existing Folder Support:** Add missing subfolders to an existing project directory.
- **Quick Access:** Automatically open the project folder in Windows Explorer.

## Default Folder Structure

The script creates the following structure:

```text
Research Project/
├── 00_Archive/
├── 01_Codes/
├── 02_Data/
└── 03_Output/
```

## Requirements

- Windows operating system
- Windows PowerShell

No additional software installation is required on a standard Windows setup.

## Installation and Usage

### Option 1: Download the Latest Release (Recommended)

1. Visit the [Releases](../../releases) page.
2. Download `Create_Research_Folders.bat` from the latest release.
3. Save the file to your computer.
4. Double-click the `.bat` file to launch the utility.
5. Select your preferred project location.
6. Enter your project name and create the folder structure.

### Option 2: Download the Repository

1. Click the **Code** button on the repository page.
2. Select **Download ZIP**.
3. Extract the downloaded ZIP file.
4. Run `Create_Research_Folders.bat`.
5. Follow the on-screen instructions.

**Security note:** Review the script before running it, especially if you downloaded it from an unfamiliar source. Windows may display a security warning for downloaded scripts.

## Customization

You can customize the folder structure by editing the `$SubFolders` list in the PowerShell section of the batch file.

For example:

```powershell
$SubFolders = @(
    '00_Archive',
    '01_Codes',
    '02_Data',
    '03_Output',
    '04_Documents'
)
```

Save your changes before running the script.

## Use Cases

This utility may be useful for:

- Academic research projects
- Research assistant workflows
- Quantitative and qualitative studies
- Data analysis projects
- Organizing project files consistently across studies

## Version

**Current release:** v1.0.0

See the [Releases](../../releases) page for available versions and updates.

## Contributing

Suggestions, bug reports, and feature requests are welcome. Feel free to open an issue in this repository.

## License

See the `LICENSE` file for the terms under which this project may be used, modified, and distributed.

---

Developed by **Arman Mahmud**.
