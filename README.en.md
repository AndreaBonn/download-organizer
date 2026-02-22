**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer

Automatic Download folder organizer for **Linux**, **macOS** and **Windows**.

The script runs in the background every 3 hours and sorts downloaded files into organized subfolders by type, with no manual intervention needed.

---

## How it works

Every 3 hours the script automatically performs these operations:

1. **Takes new files** from the Download folder and puts them in `001__Recent/Today/`
2. **After 1 day**, moves them to `001__Recent/This-Week/`
3. **After 7 days**, sorts them into the right folder based on type (PDF, images, video, etc.)
4. **After 30 days**, deletes unknown files left in `008__Temporary/`

In practice: you have **7 days** to find recent files in `001__Recent/`, then they are automatically archived into the correct category.

---

## Folder structure

After installation, the Download folder is organized like this:

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
│   ├── Code/                      ← .py, .js, .ts, .java, .cpp, .swift
│   ├── Notebooks/                 ← .ipynb
│   ├── Config/                    ← .json, .yaml, .toml, .env
│   ├── Repository/                ← .zip/.tar.gz with names like "v1.0", "main"
│   └── Package/                   ← .whl, .jar, .deb, .rpm
│
├── 006__Software/
│   ├── Installers/                ← OS-specific formats (see below)
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

## Key features

- **Multi-language support**: folder names, messages and recognition keywords adapt to the language chosen during installation (Italiano, English, Español, Français, Deutsch, Português)
- **No files are overwritten**: if a file with the same name already exists, a numeric suffix is added (`document_1.pdf`, `document_2.pdf`, etc.)
- **In-progress downloads are not touched**: `.part`, `.crdownload` and `.download` files are ignored
- **Work documents recognized automatically**: invoices, contracts and quotes are identified by filename and sorted into `007__Work/` (keywords change based on the chosen language)
- **Test mode (DRY RUN)**: you can see what the script would do without moving anything
- **Detailed log**: every operation is recorded in a log file for reference
- **Folder migration**: if you change language by reinstalling, existing folders are automatically renamed

---

## Installation

### Choose the version for your operating system

Each folder contains the scripts and a step-by-step guide designed for non-technical users.

| Operating system | Folder | Main script | Guide |
|-----------------|--------|-------------|-------|
| **Linux** (Ubuntu, Fedora, Debian, Mint, etc.) | [`linux/`](linux/) | `organize_downloads.sh` (bash) | [`linux/README.en.md`](linux/README.en.md) |
| **macOS** (10.15 Catalina or later) | [`macOS/`](macOS/) | `organize_downloads.sh` (bash) | [`macOS/README.en.md`](macOS/README.en.md) |
| **Windows** (10 and 11) | [`windows/`](windows/) | `Organize-Downloads.ps1` (PowerShell) | [`windows/README.en.md`](windows/README.en.md) |

### Quick procedure

1. **Download** the files from the folder corresponding to your operating system
2. **Open the guide** (`README.en.md`) inside that folder and follow the step-by-step instructions
3. **Run the installation script** (`install.sh` on Linux/macOS, `Install-Windows.ps1` on Windows)
4. **Choose the language** when prompted (Italiano, English, Español, Français, Deutsch, Português)
5. **Confirm** automatic activation when prompted

Installation takes a few minutes. Afterwards, the script runs on its own in the background with no further action needed.

### Supported languages

| Code | Language | Folder example |
|------|----------|---------------|
| `it` | Italiano (default) | `001__Recenti/Oggi` |
| `en` | English | `001__Recent/Today` |
| `es` | Español | `001__Recientes/Hoy` |
| `fr` | Français | `001__Recents/Aujourd-hui` |
| `de` | Deutsch | `001__Neueste/Heute` |
| `pt` | Português | `001__Recentes/Hoje` |

To change language after installation, simply re-run the installation script and choose a new language. Existing folders are automatically renamed.

---

## Differences between versions

The three versions are functionally identical: same folder structure, same categorization logic, same behavior. The differences only concern OS-specific adaptation.

### Linux

- **Language**: Bash
- **Automation**: cron job (`crontab`)
- **Recognized installers**: `.appimage`, `.deb`, `.snap`, `.flatpak`
- **Default path**: `$HOME/Download` (change if your folder has a different name, e.g. `Scaricati` or `Downloads`)

### macOS

- **Language**: Bash (compatible with bash 3.2+)
- **Automation**: cron job (`crontab`)
- **Recognized installers**: `.dmg`, `.pkg`, `.app`
- **Default path**: `$HOME/Downloads`
- **Important note**: you need to grant **Full Disk Access** to `cron` in System Settings, otherwise the script won't be able to access the Download folder when running automatically. The guide explains how.

### Windows

- **Language**: PowerShell
- **Automation**: Task Scheduler
- **Recognized installers**: `.exe`, `.msi`, `.appx`, `.msix`
- **Default path**: `$env:USERPROFILE\Downloads`
- **Note**: you may need to enable PowerShell script execution. The guide explains how.

---

## Frequently asked questions

**Are files deleted?**
No. Files are only moved into subfolders. The only exception is the `008__Temporary/` folder: files with unknown extensions that remain there for over 30 days are deleted.

**Can I manually move files between folders?**
Yes, you can move files as you like. The script doesn't touch files that are already inside the subfolders.

**Does the script slow down the computer?**
No. It runs for a few seconds every 3 hours and doesn't consume resources.

**Can I change the execution frequency?**
Yes. Each specific guide explains how to modify the interval (every hour, every 6 hours, once a day, etc.).

**Can I use it on multiple operating systems at the same time?**
Yes. Each version is independent and can be installed separately on each computer.

---

## Repository contents

```
download_organizer/
├── README.md                        ← general guide (Italian)
├── README.en.md                     ← general guide (English)
├── .gitignore
├── linux/
│   ├── organize_downloads.sh        ← main script (bash)
│   ├── install.sh                   ← automatic installation
│   ├── lang/                        ← language files (it, en, es, fr, de, pt)
│   ├── README.md                    ← step-by-step guide for Linux (Italian)
│   └── README.en.md                 ← step-by-step guide for Linux (English)
├── macOS/
│   ├── organize_downloads.sh        ← main script (bash)
│   ├── install.sh                   ← automatic installation
│   ├── lang/                        ← language files (it, en, es, fr, de, pt)
│   ├── README.md                    ← step-by-step guide for macOS (Italian)
│   └── README.en.md                 ← step-by-step guide for macOS (English)
└── windows/
    ├── Organize-Downloads.ps1       ← main script (PowerShell)
    ├── Install-Windows.ps1          ← automatic installation
    ├── lang/                        ← language files (it, en, es, fr, de, pt)
    ├── README.md                    ← step-by-step guide for Windows (Italian)
    └── README.en.md                 ← step-by-step guide for Windows (English)
```
