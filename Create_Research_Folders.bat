<# : ---------------- Batch part: launches the PowerShell part below ----------------
@echo off
setlocal
title Create Project Folders
powershell -NoProfile -ExecutionPolicy Bypass -STA -Command "iex ([IO.File]::ReadAllText('%~f0'))"
endlocal
goto :EOF
: ---------------- PowerShell part (everything below) ---------------- #>

# ==============================================================================
#  Create_Project_Folders.bat
#  Author : Arman Mahmud (ARCED Foundation)
#  Purpose: Pop-up asks for a location and a folder name, then creates
#           <Location>\<Name>\ with the standard project subfolders.
#  Edit the list below to change the subfolders.
# ==============================================================================

$SubFolders = @('01_Codes', '02_Data', '03_Output', '04_Submission')

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

function Show-Msg($text, $icon = 'Information', $buttons = 'OK') {
    [System.Windows.Forms.MessageBox]::Show($text, 'Create Project Folders', $buttons, $icon)
}

function New-ProjectStructure($root) {
    # Create top level folders
    foreach ($sf in $SubFolders) {
        $sfPath = Join-Path $root $sf
        New-Item -ItemType Directory -Path $sfPath -Force -ErrorAction Stop | Out-Null
        
        # Each of 01_Codes, 02_Data, 03_Output gets 00_Archive
        New-Item -ItemType Directory -Path (Join-Path $sfPath '00_Archive') -Force -ErrorAction Stop | Out-Null
    }
    
    # 02_Data specific subfolders
    $dataPath = Join-Path $root '02_Data'
    New-Item -ItemType Directory -Path (Join-Path $dataPath '01_Raw') -Force -ErrorAction Stop | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $dataPath '02_Clean') -Force -ErrorAction Stop | Out-Null
    
    # 03_Output specific subfolders
    $outputPath = Join-Path $root '03_Output'
    New-Item -ItemType Directory -Path (Join-Path $outputPath '01_Table') -Force -ErrorAction Stop | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $outputPath '02_Figures') -Force -ErrorAction Stop | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $outputPath '03_Raw_Research') -Force -ErrorAction Stop | Out-Null
}

# ---------------- Build the pop-up form ----------------
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = 'Create Project Folder'
$form.ClientSize      = New-Object System.Drawing.Size(500, 150)
$form.StartPosition   = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox     = $false
$form.MinimizeBox     = $false
$form.TopMost         = $true
$form.Font            = New-Object System.Drawing.Font('Segoe UI', 9)

$lblLoc          = New-Object System.Windows.Forms.Label
$lblLoc.Text     = 'Location:'
$lblLoc.Location = New-Object System.Drawing.Point(15, 22)
$lblLoc.AutoSize = $true

$txtLoc          = New-Object System.Windows.Forms.TextBox
$txtLoc.Location = New-Object System.Drawing.Point(100, 18)
$txtLoc.Width    = 290
$txtLoc.Text     = [Environment]::GetFolderPath('MyDocuments')

$btnBrowse          = New-Object System.Windows.Forms.Button
$btnBrowse.Text     = 'Browse...'
$btnBrowse.Location = New-Object System.Drawing.Point(400, 16)
$btnBrowse.Width    = 85

$lblName          = New-Object System.Windows.Forms.Label
$lblName.Text     = 'Folder name:'
$lblName.Location = New-Object System.Drawing.Point(15, 62)
$lblName.AutoSize = $true

$txtName          = New-Object System.Windows.Forms.TextBox
$txtName.Location = New-Object System.Drawing.Point(100, 58)
$txtName.Width    = 385

$btnOK              = New-Object System.Windows.Forms.Button
$btnOK.Text         = 'Create'
$btnOK.Location     = New-Object System.Drawing.Point(310, 105)
$btnOK.Width        = 85
$btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK

$btnCancel              = New-Object System.Windows.Forms.Button
$btnCancel.Text         = 'Cancel'
$btnCancel.Location     = New-Object System.Drawing.Point(400, 105)
$btnCancel.Width        = 85
$btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$form.Controls.AddRange(@($lblLoc, $txtLoc, $btnBrowse, $lblName, $txtName, $btnOK, $btnCancel))
$form.AcceptButton = $btnOK
$form.CancelButton = $btnCancel
$form.Add_Shown({ $txtName.Focus() })

# Browse button -> folder picker
$btnBrowse.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description         = 'Select where the project folder should be created'
    $fbd.ShowNewFolderButton = $true
    if (Test-Path -LiteralPath $txtLoc.Text) { $fbd.SelectedPath = $txtLoc.Text }
    if ($fbd.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtLoc.Text = $fbd.SelectedPath
    }
})

# ---------------- Show form, validate, create ----------------
$invalid = [IO.Path]::GetInvalidFileNameChars()

while ($true) {
    if ($form.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { exit }

    $location = $txtLoc.Text.Trim().Trim('"')
    $name     = $txtName.Text.Trim()

    if (-not $location -or -not (Test-Path -LiteralPath $location -PathType Container)) {
        Show-Msg "The location does not exist:`n$location" 'Warning' | Out-Null; continue
    }
    if (-not $name) {
        Show-Msg 'Please enter a folder name.' 'Warning' | Out-Null; continue
    }
    if ($name.IndexOfAny($invalid) -ge 0 -or $name.EndsWith('.')) {
        Show-Msg "The folder name contains characters Windows doesn't allow:`n\ / : * ? `" < > |" 'Warning' | Out-Null; continue
    }

    $target = Join-Path $location $name

    if (Test-Path -LiteralPath $target) {
        $ans = Show-Msg "'$name' already exists here.`n`nAdd any missing subfolders to it?" 'Question' 'YesNo'
        if ($ans -ne [System.Windows.Forms.DialogResult]::Yes) { continue }
    }
    break
}

try {
    New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
    New-ProjectStructure $target
} catch {
    Show-Msg "Could not create the folders:`n$($_.Exception.Message)" 'Error' | Out-Null
    exit 1
}

$structure = @(
    "01_Codes/",
    "   └── 00_Archive/",
    "02_Data/",
    "   ├── 00_Archive/",
    "   ├── 01_Raw/",
    "   └── 02_Clean/",
    "03_Output/",
    "   ├── 00_Archive/",
    "   ├── 01_Table/",
    "   ├── 02_Figures/",
    "   └── 03_Raw_Research/",
    "04_Submission/",
    "   └── 00_Archive/"
)
Show-Msg ("Created:`n$target`n`n" + ($structure -join "`n")) | Out-Null
Start-Process explorer.exe -ArgumentList "`"$target`""
