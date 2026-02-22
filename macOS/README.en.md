**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer for macOS

Automatic organizer for the Downloads folder on macOS.
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
│   ├── Presentations/             ← .ppt, .pptx, .odp, .key
│   ├── Text/                      ← .txt, .md
│   └── Ebook/                     ← .epub, .mobi
│
├── 004__Media/
│   ├── Images/                    ← .jpg, .png, .gif, .svg, .webp, .heic
│   ├── Video/                     ← .mp4, .avi, .mkv, .mov
│   ├── Audio/                     ← .mp3, .wav, .flac, .ogg
│   └── Diagrams/                  ← .drawio, .puml
│
├── 005__Development/
│   ├── Code/                      ← .py, .js, .ts, .swift, .java, .cpp
│   ├── Notebooks/                 ← .ipynb
│   ├── Config/                    ← .json, .yaml, .toml, .env
│   ├── Repository/                ← .zip/.tar.gz with names like "v1.0", "main"
│   └── Package/                   ← .whl, .gem, .jar
│
├── 006__Software/
│   ├── Installers/                ← .dmg, .pkg, .app
│   ├── Archives/                  ← .zip, .rar, .7z, .tar.gz
│   ├── Docker/                    ← Dockerfile, docker-compose.yml
│   └── Scripts/                   ← .sh, .zsh, .command
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

Folders are numbered (`001__`, `002__`, etc.) to always appear in the same order in Finder.

---

## Step-by-step installation guide

### Requirements

- A Mac running macOS 10.15 Catalina or later
- Know how to open the Terminal (explained in Step 3)

### Step 1: Find the name of your Downloads folder

On macOS the folder is almost always called `Downloads` and is located at:

```
/Users/YOURNAME/Downloads
```

To verify, open Finder and look in the sidebar: the "Downloads" folder corresponds to the `Downloads` folder in the system.

If you changed your Mac language to Italian, the folder may appear as "Download" in Finder, but its real name in the system remains `Downloads`.

**In most cases you don't need to change anything**: the default path `Downloads` is already correct.

### Step 2: Download the files

Copy the two files (`organize_downloads.sh` and `install.sh`) to a folder of your choice.

If you received them as a `.zip` archive, double-click to extract.

### Step 3: Open the Terminal

1. Open **Finder**
2. Go to **Applications** > **Utilities**
3. Double-click **Terminal**

Or, quick method:
1. Press `Cmd + Space` (opens Spotlight)
2. Type `Terminal` and press Enter

A window with text will open. This is the terminal.

### Step 4: Run the installation

1. In the Terminal window, navigate to the folder where you put the files. Type the correct path and press Enter.

   For example, if you put the files in Downloads:

   ```bash
   cd ~/Downloads
   ```

   Or, if you put them in a specific folder:

   ```bash
   cd ~/Documents/download_organizer/macOS
   ```

2. Make the files executable:

   ```bash
   chmod +x organize_downloads.sh install.sh
   ```

3. Run the installation:

   ```bash
   ./install.sh
   ```

   **If an error appears** like "Operation not permitted", see the "macOS permissions" section below.

4. **Choose the language**: the script will ask which language you want for folder names.
   Options are: Italiano, English, Español, Français, Deutsch, Português.
   Press the corresponding number and then Enter. If you don't choose, it defaults to Italiano.

5. The script will automatically:
   - Copy the program to the `~/.local/bin/` folder
   - Copy language files to `~/.local/share/download_organizer/lang/`
   - Add the folder to PATH (if needed)
   - If it detects existing folders in another language, it asks if you want to rename them
   - Run a first test
   - Ask you: **"Do you want me to configure the cron job automatically?"**

6. **Answer `y`** and press Enter to activate automatic execution every 3 hours.

If everything went well, you'll see: `Installation completed!`

### Step 5: Configure macOS permissions (important!)

macOS has a security system that may prevent the script from accessing the Downloads folder when running automatically. To fix this:

1. Open **System Settings** (the gear icon)
2. Go to **Privacy & Security** > **Full Disk Access**
3. Click the lock at the bottom left and enter your password
4. Click the **+** button to add a program
5. Press `Cmd + Shift + G` and type `/usr/sbin/cron`, then press Enter
6. Select `cron` and click "Open"
7. Make sure the checkbox next to `cron` is enabled

This allows the cron system (which runs the script every 3 hours) to access the Downloads folder.

### Step 6: Verify everything works

Open the Terminal and type:

```bash
crontab -l
```

You should see a line similar to this:

```
0 */3 * * * /Users/YOURNAME/.local/bin/organize_downloads.sh >> /Users/YOURNAME/.download_organizer.log 2>&1
```

(Instead of `YOURNAME` you'll see your username.)

Then open the Downloads folder in Finder: you should see the new numbered subfolders (`001__Recent`, `002__Data`, etc.).

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

1. Open the Terminal and type:
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

1. Open the Terminal and type:
   ```bash
   crontab -e
   ```
2. A text editor will open. Find the line containing `organize_downloads.sh`
3. Add the `#` symbol at the beginning of the line (no spaces before):
   ```
   #0 */3 * * * /Users/YOURNAME/.local/bin/organize_downloads.sh >> ...
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

### "Operation not permitted" error

macOS blocks access to the Downloads folder for security reasons. Follow Step 5 of the installation to grant Full Disk Access to `cron`.

If the error appears when you manually run the script from the Terminal:
1. Go to **System Settings** > **Privacy & Security** > **Full Disk Access**
2. Add **Terminal** (Terminal.app) to the list

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

3. Verify that `cron` has Full Disk Access (Step 5).

### Files are not being moved

1. Check the log to understand what's happening:
   ```bash
   tail -n 50 ~/.download_organizer.log
   ```

2. Verify that the path in the script is correct:
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

**Does the script slow down the Mac?**
No. It runs for a few seconds every 3 hours and doesn't consume resources.

**Does it work if the Mac is asleep or off?**
No. The script only runs when the Mac is on and not asleep. When you wake it, it will activate at the next scheduled time (every 3 hours: at 0, 3, 6, 9, 12, 15, 18, 21).

**Can I change the frequency?**
Yes. Open `crontab -e` and modify the line. Some examples:
- Every hour: `0 * * * *`
- Every 6 hours: `0 */6 * * *`
- Once a day at midnight: `0 0 * * *`

**Are in-progress downloads touched?**
No. Files with `.part`, `.crdownload` or `.download` extension (incomplete downloads) are ignored.

**Do I need to keep the Terminal open?**
No. The cron job runs in the background independently of the Terminal. Once configured, you can close the Terminal.

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
