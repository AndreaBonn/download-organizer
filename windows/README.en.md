**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer for Windows

Automatic organizer for the Downloads folder on Windows systems.
The script runs in the background every 3 hours and sorts downloaded files into organized subfolders by type, with no manual intervention needed.

---

## What it does

Every time the script runs (every 3 hours), it performs these operations:

1. **Takes new files** from the Downloads folder and puts them in `001__Recent\Today\`
2. **Moves files older than 1 day** from `Today\` to `This-Week\`
3. **After 7 days**, automatically sorts them into the right folder based on type (PDF, images, video, etc.)
4. **Deletes unknown files** left in `008__Temporary\` for over 30 days

In practice: you have 7 days to find recent files in `001__Recent\`, then they are automatically archived.

### Folder structure

After installation, your Downloads folder will look like this:

```
Downloads\
├── 001__Recent\
│   ├── Today\                     ← files downloaded in the last 24 hours
│   └── This-Week\                 ← files from 1 to 7 days old
│
├── 002__Data\
│   ├── CSV\                       ← .csv, .tsv
│   ├── Excel\                     ← .xlsx, .xls, .ods
│   ├── JSON\                      ← .jsonl, .ndjson
│   ├── Database\                  ← .sql, .db, .sqlite, .mdb, .accdb
│   ├── Parquet\                   ← .parquet, .feather, .arrow
│   └── Other-Formats\             ← .xml, .avro, .hdf5
│
├── 003__Documents\
│   ├── PDF\                       ← .pdf
│   ├── Word\                      ← .doc, .docx, .odt
│   ├── Presentations\             ← .ppt, .pptx, .odp
│   ├── Text\                      ← .txt, .md
│   └── Ebook\                     ← .epub, .mobi
│
├── 004__Media\
│   ├── Images\                    ← .jpg, .png, .gif, .svg, .webp
│   ├── Video\                     ← .mp4, .avi, .mkv, .mov
│   ├── Audio\                     ← .mp3, .wav, .flac, .ogg
│   └── Diagrams\                  ← .drawio, .puml
│
├── 005__Development\
│   ├── Code\                      ← .py, .js, .ts, .java, .cpp
│   ├── Notebooks\                 ← .ipynb
│   ├── Config\                    ← .json, .yaml, .toml, .env
│   ├── Repository\                ← .zip/.tar.gz with names like "v1.0", "main"
│   └── Package\                   ← .whl, .jar, .nupkg
│
├── 006__Software\
│   ├── Installers\                ← .exe, .msi, .appx, .msix
│   ├── Archives\                  ← .zip, .rar, .7z, .tar.gz
│   ├── Docker\                    ← Dockerfile, docker-compose.yml
│   └── Scripts\                   ← .bat, .ps1, .cmd, .vbs
│
├── 007__Work\
│   ├── Invoices\                  ← files with "invoice" or "receipt" in the name
│   ├── Contracts\                 ← files with "contract" or "agreement" in the name
│   ├── Quotes\                    ← files with "quote" or "estimate" in the name
│   └── Other-Documents\
│
└── 008__Temporary\                ← files with unknown extension
                                      (automatically deleted after 30 days)
```

Folders are numbered (`001__`, `002__`, etc.) to always appear in the same order in File Explorer.

---

## Step-by-step installation guide

### Requirements

- A computer running Windows 10 or Windows 11
- Know how to open PowerShell (explained in Step 3)

### Step 1: Find the name of your Downloads folder

On Windows the folder is almost always called `Downloads` and is located at:

```
C:\Users\YOURNAME\Downloads
```

To verify:
1. Open File Explorer (the yellow folder icon in the taskbar)
2. In the left sidebar look for "Downloads"
3. Right-click the folder > Properties > check the "Location" field

**Write down the exact name** because you'll need it in Step 2.

### Step 2: Edit the Downloads folder path (if needed)

The default path in the script is `Downloads`. If your folder has a different name, you need to change it.

1. Right-click `Organize-Downloads.ps1` > "Open with" > "Notepad" (or another text editor)

2. Look for this line near the beginning of the file (line 11):

   ```
   $DownloadDir = "$env:USERPROFILE\Downloads"
   ```

3. If your folder has a different name, change only the part after the last `\`. Example:

   - If it's called **Download** (without the s):
     ```
     $DownloadDir = "$env:USERPROFILE\Download"
     ```

4. Save the file and close the editor.

If your folder is called `Downloads` (as on most Windows PCs), **you don't need to change anything** and can go directly to Step 3.

### Step 3: Open PowerShell as Administrator

This step is needed to configure automatic execution.

**On Windows 11:**
1. Right-click the Start button (the Windows icon at the bottom left)
2. Select "Terminal (Admin)" or "Windows PowerShell (Admin)"
3. If a window appears asking "Do you want to allow this app to make changes?", click "Yes"

**On Windows 10:**
1. Type "PowerShell" in the search bar at the bottom
2. Right-click "Windows PowerShell"
3. Select "Run as administrator"
4. If a window appears asking "Do you want to allow this app to make changes?", click "Yes"

A blue/black window with text will open. This is the PowerShell terminal.

### Step 4: Run the installation

1. In the PowerShell window, navigate to the folder where you put the files. Type the correct path and press Enter.

   For example, if you put the files in Downloads:
   ```powershell
   cd $env:USERPROFILE\Downloads
   ```

   Or, if you put them in a specific folder:
   ```powershell
   cd C:\Users\YOURNAME\Documents\download_organizer\windows
   ```

2. Run the installation:

   ```powershell
   .\Install-Windows.ps1
   ```

   **If an error appears** like "script execution is disabled", type this command first and retry:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Choose the language**: the script will ask which language you want for folder names.
   Options are: Italiano, English, Español, Français, Deutsch, Português.
   Press the corresponding number and then Enter. If you don't choose, it defaults to Italiano.

4. The script will automatically:
   - Copy the program to the `C:\Users\YOURNAME\Scripts\` folder
   - Copy language files to `C:\Users\YOURNAME\Scripts\lang\`
   - If it detects existing folders in another language, it asks if you want to rename them
   - Run a first test
   - Ask you: **"Do you want to configure automatic execution every 3 hours?"**

5. **Answer `y`** and press Enter to activate automatic execution.

If everything went well, you'll see: `Installation completed!`

### Step 5: Verify everything works

1. In the PowerShell window, type:

   ```powershell
   Get-ScheduledTask -TaskName "OrganizeDownloads"
   ```

   You should see a line with `State: Ready`.

2. Open your Downloads folder in File Explorer: you should see the new numbered subfolders (`001__Recent`, `002__Data`, etc.).

**Done!** From this moment the script will run automatically every 3 hours. You don't need to do anything else.

---

## How to use it after installation

### Normal use

You don't need to do anything! The script works on its own in the background. Keep downloading files as you always do: they'll be organized automatically.

Newly downloaded files are always found in: `001__Recent\Today\`

### Run the script manually

If you want to organize files right away without waiting 3 hours, you have three ways:

**Method 1 - Double click** (the simplest):
Go to `C:\Users\YOURNAME\Scripts\` and double-click `Organize-Downloads.bat`

**Method 2 - From PowerShell:**
```powershell
& "$env:USERPROFILE\Scripts\Organize-Downloads.ps1"
```

**Method 3 - From Task Scheduler:**
```powershell
Start-ScheduledTask -TaskName "OrganizeDownloads"
```

### Do a test without moving anything

If you want to see what the script would do without touching files:

1. Open the installed file with Notepad:
   - Go to `C:\Users\YOURNAME\Scripts\`
   - Right-click `Organize-Downloads.ps1` > "Open with" > "Notepad"
2. Find the line `$DryRun = $false` and change it to `$DryRun = $true`
3. Save and close
4. Run the script: you'll see what it would move, without moving anything
5. **Remember to change back to `$DryRun = $false`** when you're done testing

### See what the script has done

Open PowerShell and type:

```powershell
Get-Content "$env:USERPROFILE\.download_organizer.log" -Tail 50
```

This shows the last 50 lines of the log, where all moved files are listed.

---

## Deactivation and removal

### Temporarily disable

If you want to pause the script without removing it:

1. Open PowerShell as Administrator (see Step 3)
2. Type:
   ```powershell
   Disable-ScheduledTask -TaskName "OrganizeDownloads"
   ```

The script won't run until you reactivate it.

### Reactivate

```powershell
Enable-ScheduledTask -TaskName "OrganizeDownloads"
```

### Remove completely

1. Remove the automatic task (from PowerShell as Administrator):
   ```powershell
   Unregister-ScheduledTask -TaskName "OrganizeDownloads" -Confirm:$false
   ```

2. Delete the scripts folder:
   - Go to `C:\Users\YOURNAME\Scripts\` and delete the files `Organize-Downloads.ps1` and `Organize-Downloads.bat`

3. (Optional) Delete the log file:
   - Go to `C:\Users\YOURNAME\` and delete the file `.download_organizer.log`

The folders created in the Downloads folder remain: you can reorganize them as you prefer.

---

## Troubleshooting

### "Script execution is disabled" error

This is a Windows security block. To fix it, open PowerShell as Administrator and type:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then retry the installation.

### The script doesn't start automatically

1. Verify that the task exists:
   ```powershell
   Get-ScheduledTask -TaskName "OrganizeDownloads"
   ```
   If it doesn't exist, repeat Step 4 of the installation.

2. Verify that the state is "Ready" and not "Disabled".

3. Check the Task Scheduler logs:
   - Open "Event Viewer" (search in the Windows search bar)
   - Go to: Windows Logs > Microsoft > Windows > TaskScheduler > Operational

### Files are not being moved

1. Check the log to understand what's happening:
   ```powershell
   Get-Content "$env:USERPROFILE\.download_organizer.log" -Tail 50
   ```

2. Verify that the path in the script is correct:
   - Open `C:\Users\YOURNAME\Scripts\Organize-Downloads.ps1`
   - Check the `$DownloadDir =` line and make sure it matches the real path of your folder

3. If a file is open in a program, it can't be moved. It will be moved at the next execution (within 3 hours).

### Duplicate files

If you download a file with the same name as one that already exists, the script adds a sequential number:
- `document.pdf` (already exists) -> the new one becomes `document_1.pdf`

No file is ever overwritten.

---

## Frequently asked questions

**Are files deleted?**
No. Files are only moved into subfolders. The only exception is the `008__Temporary\` folder: files with unknown extensions that remain there for over 30 days are deleted.

**Can I manually move files between folders?**
Yes, you can move files as you like. The script doesn't touch files that are already inside the subfolders.

**Does the script slow down the computer?**
No. It runs for a few seconds every 3 hours and doesn't consume resources.

**Does it work if the computer is off or asleep?**
No. The script only runs when the computer is on. When you turn it back on, if an execution was skipped, it will be started automatically.

**Can I change the frequency?**
Yes. Open PowerShell as Administrator and type one of these commands:
- Every hour:
  ```powershell
  $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
  Set-ScheduledTask -TaskName "OrganizeDownloads" -Trigger $trigger
  ```
- Every 6 hours:
  ```powershell
  $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 6)
  Set-ScheduledTask -TaskName "OrganizeDownloads" -Trigger $trigger
  ```

**Are in-progress downloads touched?**
No. Files with `.tmp`, `.crdownload` or `.part` extension (incomplete downloads) are ignored.

**How do I change language after installation?**
Re-run `.\Install-Windows.ps1` from the original folder and choose a new language. The script detects existing folders in the previous language and asks if you want to rename them automatically.

---

## Folder contents

| File | Description |
|------|-------------|
| `Organize-Downloads.ps1` | The main script that organizes files |
| `Install-Windows.ps1` | The installation script (run once only) |
| `lang\it.ps1` ... `lang\pt.ps1` | Language files (6 languages supported) |
| `README.md` | This guide (Italian) |
| `README.en.md` | This guide (English) |
