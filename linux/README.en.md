**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer for Linux

Automatic organizer for the Downloads (or Scaricati) folder on Linux systems.
The script runs in the background every 3 hours and sorts downloaded files into organized subfolders by type, with no manual intervention needed.

---

## What it does

Every time the script runs (every 3 hours), it performs these operations:

1. **Takes new files** from the Downloads folder and puts them in `001__Recent/Today/`
2. **Moves files older than 1 day** from `Today/` to `This-Week/`
3. **After 7 days**, automatically sorts them into the right folder based on type (PDF, images, video, etc.)
4. **Deletes unknown files** left in `008__Temporary/` for over 30 days

In practice: you have 7 days to find recent files in `001__Recent/`, then they are automatically archived.

### Folder structure

After installation, your Downloads folder will look like this:

```
Downloads/
├── 001__Recent/
│   ├── Today/                     ← files downloaded in the last 24 hours
│   └── This-Week/                 ← files from 1 to 7 days old
│
├── 002__Data/
│   ├── CSV/                       ← .csv, .tsv
│   ├── Excel/                     ← .xlsx, .xls, .ods
│   ├── JSON/                      ← .jsonl, .ndjson
│   ├── Database/                  ← .sql, .db, .sqlite
│   ├── Parquet/                   ← .parquet, .feather, .arrow
│   └── Other-Formats/             ← .xml, .avro, .hdf5
│
├── 003__Documents/
│   ├── PDF/                       ← .pdf
│   ├── Word/                      ← .doc, .docx, .odt
│   ├── Presentations/             ← .ppt, .pptx, .odp
│   ├── Text/                      ← .txt, .md
│   └── Ebook/                     ← .epub, .mobi
│
├── 004__Media/
│   ├── Images/                    ← .jpg, .png, .gif, .svg, .webp
│   ├── Video/                     ← .mp4, .avi, .mkv, .mov
│   ├── Audio/                     ← .mp3, .wav, .flac, .ogg
│   └── Diagrams/                  ← .drawio, .puml
│
├── 005__Development/
│   ├── Code/                      ← .py, .js, .ts, .java, .cpp
│   ├── Notebooks/                 ← .ipynb
│   ├── Config/                    ← .json, .yaml, .toml, .env
│   ├── Repository/                ← .zip/.tar.gz with names like "v1.0", "main"
│   └── Package/                   ← .whl, .deb, .rpm, .jar
│
├── 006__Software/
│   ├── Installers/                ← .appimage, .deb, .snap, .flatpak
│   ├── Archives/                  ← .zip, .rar, .7z, .tar.gz
│   ├── Docker/                    ← Dockerfile, docker-compose.yml
│   └── Scripts/                   ← .sh, .bat, .ps1
│
├── 007__Work/
│   ├── Invoices/                  ← files with "invoice" or "receipt" in the name
│   ├── Contracts/                 ← files with "contract" or "agreement" in the name
│   ├── Quotes/                    ← files with "quote" or "estimate" in the name
│   └── Other-Documents/
│
└── 008__Temporary/                ← files with unknown extension
                                      (automatically deleted after 30 days)
```

Folders are numbered (`001__`, `002__`, etc.) to always appear in the same order in the file manager.

---

## Step-by-step installation guide

### Requirements

- A computer running Linux (Ubuntu, Fedora, Debian, Mint, etc.)
- Know how to open the Terminal (found among applications, or open with `Ctrl+Alt+T`)

### Step 1: Find the name of your Downloads folder

The folder where downloaded files go has different names depending on the system language:

- **Italian**: `Scaricati`
- **English**: `Downloads`
- **Other languages**: it may have a different name

To find out yours, open the Terminal and type:

```bash
ls ~/
```

Press Enter. You'll see a list of folders. Look for the one you use for downloads (e.g. `Scaricati`, `Downloads`, `Download`).

**Write down the exact name** because you'll need it in Step 3.

### Step 2: Download the files

Copy the two files (`organize_downloads.sh` and `install.sh`) to a folder of your choice.

If you received them as a `.zip` archive, extract them first.

### Step 3: Edit the Downloads folder path

This is the only step that requires a manual edit.

1. Open the file `organize_downloads.sh` with a text editor (the system Text Editor works fine: right-click the file > "Open with Text Editor")

2. Look for this line near the beginning of the file (line 12):

   ```
   DOWNLOAD_DIR="$HOME/Download"
   ```

3. Replace `Download` with the name of **your** downloads folder. Examples:

   - If your folder is called **Scaricati**:
     ```
     DOWNLOAD_DIR="$HOME/Scaricati"
     ```
   - If it's called **Downloads**:
     ```
     DOWNLOAD_DIR="$HOME/Downloads"
     ```

4. Save the file and close the editor.

**Caution**: respect uppercase and lowercase. `Scaricati` and `scaricati` are two different things for Linux.

### Step 4: Run the installation

1. Open the Terminal (`Ctrl+Alt+T`)

2. Navigate to the folder where you put the files. For example, if you put them in `Downloads`:

   ```bash
   cd ~/Downloads
   ```

   Or, if you put them in a specific folder:

   ```bash
   cd ~/Documents/download_organizer/linux
   ```

3. Make the files executable:

   ```bash
   chmod +x organize_downloads.sh install.sh
   ```

4. Run the installation:

   ```bash
   ./install.sh
   ```

5. **Choose the language**: the script will ask which language you want for folder names.
   Options are: Italiano, English, Español, Français, Deutsch, Português.
   Press the corresponding number and then Enter. If you don't choose, it defaults to Italiano.

6. The script will automatically:
   - Copy the program to the correct system folder (`~/.local/bin/`)
   - Copy language files to `~/.local/share/download_organizer/lang/`
   - If it detects existing folders in another language, it asks if you want to rename them
   - Run a first test
   - Ask you: **"Do you want me to configure the cron job automatically?"**

7. **Answer `y`** (and press Enter) to activate automatic execution every 3 hours.

If everything went well, you'll see the message: `Installation completed!`

### Step 5: Verify everything works

Open the Terminal and type:

```bash
crontab -l
```

You should see a line similar to this:

```
0 */3 * * * /home/YOURNAME/.local/bin/organize_downloads.sh >> /home/YOURNAME/.download_organizer.log 2>&1
```

(Instead of `YOURNAME` you'll see your username.)

Then open your Downloads folder: you should see the new numbered subfolders (`001__Recent`, `002__Data`, etc.).

**Done!** From this moment the script will run automatically every 3 hours. You don't need to do anything else.

---

## How to use it after installation

### Normal use

You don't need to do anything! The script works on its own in the background. Keep downloading files as you always do: they'll be organized automatically.

Newly downloaded files are always found in: `001__Recent/Today/`

### Run the script manually

If you want to organize files right away without waiting 3 hours:

```bash
~/.local/bin/organize_downloads.sh
```

### Do a test without moving anything

If you want to see what the script would do without touching files:

1. Open the installed script file:
   ```bash
   nano ~/.local/bin/organize_downloads.sh
   ```
2. Find the line `DRY_RUN=false` and change it to `DRY_RUN=true`
3. Save (`Ctrl+O`, then `Enter`, then `Ctrl+X` to exit)
4. Run the script: you'll see what it would move, without moving anything
5. **Remember to change back to `DRY_RUN=false`** when you're done testing

### See what the script has done

To check the operations log:

```bash
tail -n 50 ~/.download_organizer.log
```

This shows the last 50 lines of the log, where all moved files are listed.

---

## Deactivation and removal

### Temporarily disable

If you want to pause the script without removing it:

1. Open the terminal and type:
   ```bash
   crontab -e
   ```
2. A text editor will open. Find the line containing `organize_downloads.sh`
3. Add the `#` symbol at the beginning of the line (no spaces before):
   ```
   #0 */3 * * * /home/YOURNAME/.local/bin/organize_downloads.sh >> ...
   ```
4. Save and close. The script won't run until you remove the `#`.

### Reactivate

Same procedure: open `crontab -e`, remove the `#` from the line, save and close.

### Remove completely

1. Remove the cron job:
   ```bash
   crontab -e
   ```
   Delete the line with `organize_downloads.sh`, save and close.

2. Delete the installed script:
   ```bash
   rm ~/.local/bin/organize_downloads.sh
   ```

3. (Optional) Delete the log file:
   ```bash
   rm ~/.download_organizer.log
   ```

The folders created in the Downloads folder remain: you can reorganize them as you prefer.

---

## Troubleshooting

### The script doesn't start automatically

1. Verify that the cron job is active:
   ```bash
   crontab -l
   ```
   If you don't see any line with `organize_downloads.sh`, repeat Step 4 of the installation.

2. Verify file permissions:
   ```bash
   ls -la ~/.local/bin/organize_downloads.sh
   ```
   It should show `rwx` (executable). If it doesn't, run:
   ```bash
   chmod +x ~/.local/bin/organize_downloads.sh
   ```

### Files are not being moved

1. Check the log to understand what's happening:
   ```bash
   tail -n 50 ~/.download_organizer.log
   ```

2. Verify that the folder name in the script is correct:
   ```bash
   head -15 ~/.local/bin/organize_downloads.sh
   ```
   Check the `DOWNLOAD_DIR=` line and make sure it matches the real name of your folder.

### Duplicate files

If you download a file with the same name as one that already exists, the script adds a sequential number:
- `document.pdf` (already exists) -> the new one becomes `document_1.pdf`

No file is ever overwritten.

---

## Frequently asked questions

**Are files deleted?**
No. Files are only moved into subfolders. The only exception is the `008__Temporary/` folder: files with unknown extensions that remain there for over 30 days are deleted.

**Can I manually move files between folders?**
Yes, you can move files as you like. The script doesn't touch files that are already inside the subfolders.

**Does the script slow down the computer?**
No. It runs for a few seconds every 3 hours and doesn't consume resources.

**Does it work if the computer is off?**
No. The script only runs when the computer is on. When you turn it back on, it will activate at the next scheduled time (every 3 hours: at 0, 3, 6, 9, 12, 15, 18, 21).

**Can I change the frequency?**
Yes. Open `crontab -e` and modify the line. Some examples:
- Every hour: `0 * * * *`
- Every 6 hours: `0 */6 * * *`
- Once a day at midnight: `0 0 * * *`

**Are in-progress downloads touched?**
No. Files with `.part` or `.crdownload` extension (incomplete downloads) are ignored.

**How do I change language after installation?**
Re-run `./install.sh` from the original folder and choose a new language. The script detects existing folders in the previous language and asks if you want to rename them automatically.

---

## Folder contents

| File | Description |
|------|-------------|
| `organize_downloads.sh` | The main script that organizes files |
| `install.sh` | The installation script (run once only) |
| `lang/it.sh` ... `lang/pt.sh` | Language files (6 languages supported) |
| `README.md` | This guide (Italian) |
| `README.en.md` | This guide (English) |
