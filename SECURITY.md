**🇬🇧 [English](SECURITY.md) | 🇮🇹 [Italiano](SECURITY.it.md) | 📄 [License](LICENSE.md)**

---

# Security Policy

## Overview

Download Organizer is designed with security and privacy as core principles. The scripts run entirely locally on your machine, with no external connections, data collection, or cloud services.

---

## Security Features

### 1. Local-Only Execution

- **No network connections**: Scripts never connect to the internet or external services
- **No data transmission**: Your files and metadata never leave your computer
- **No telemetry**: No usage statistics or analytics are collected
- **No external dependencies**: Scripts use only built-in system commands

### 2. File Safety

- **No file deletion** (except temporary folder after 30 days)
- **Duplicate protection**: Files with the same name get a numeric suffix instead of being overwritten
- **In-progress downloads ignored**: `.part`, `.crdownload`, and `.download` files are never touched
- **Read-only operations**: Scripts only read file metadata (name, extension, modification date)
- **No file content inspection**: Scripts never open or read the content of your files

### 3. Permission Model

#### Linux
- Scripts run with **user-level permissions** only
- No `sudo` or root access required
- Cron job runs under your user account
- Scripts cannot access files outside your home directory without explicit permission

#### macOS
- Scripts run with **user-level permissions** only
- No administrator privileges required
- Requires **Full Disk Access** for cron (standard macOS security requirement)
- This permission is explicitly requested during installation and can be revoked at any time

#### Windows
- Scripts run with **current user permissions** only
- No administrator rights required
- Task Scheduler runs under your user account
- PowerShell execution policy may need adjustment (documented in installation guide)

### 4. Code Transparency

- **Open source**: All code is publicly available for inspection
- **No obfuscation**: Scripts are written in plain text with comments
- **No compiled binaries**: Everything runs as interpreted scripts
- **Auditable**: You can review every line before installation

### 5. Installation Safety

- **Manual installation**: You control every step of the process
- **No automatic downloads**: You download files directly from GitHub
- **No installer executables**: Installation uses shell scripts (Linux/macOS) or PowerShell scripts (Windows)
- **Dry run mode**: Test the script behavior without moving files (`DRY_RUN=true`)

### 6. Logging and Monitoring

- **Detailed logs**: Every operation is recorded in `~/.download_organizer.log`
- **Transparent operations**: You can see exactly what the script does
- **No sensitive data in logs**: Logs contain only file names and timestamps
- **Local log storage**: Logs never leave your machine

### 7. Folder Migration Safety

- **Automatic renaming**: When changing language, existing folders are renamed (not deleted)
- **No data loss**: Files remain in place during folder migration
- **Reversible**: You can change language multiple times without losing files

---

## What the Scripts Do NOT Do

- ❌ Access the internet or external services
- ❌ Collect or transmit personal data
- ❌ Modify file contents
- ❌ Access files outside the Downloads folder
- ❌ Require administrator/root privileges
- ❌ Install additional software or dependencies
- ❌ Create backdoors or persistent processes (only scheduled tasks)
- ❌ Access system files or configurations (except cron/Task Scheduler for automation)

---

## Potential Risks and Mitigations

### Risk: Accidental File Movement

**Scenario**: A file might be moved to an unexpected category

**Mitigation**:
- Use dry run mode first (`DRY_RUN=true` in scripts)
- Check the log file to see what was moved
- Files are never deleted (except from temporary folder after 30 days)
- You can manually move files back at any time

### Risk: Temporary Folder Auto-Deletion

**Scenario**: Unknown file types in `008__Temporary/` are deleted after 30 days

**Mitigation**:
- 30-day grace period to review and move important files
- Warning messages in logs before deletion
- Only affects files with unrecognized extensions
- You can disable auto-deletion by modifying the script

### Risk: Script Modification

**Scenario**: Someone could modify the scripts to add malicious code

**Mitigation**:
- Download only from official GitHub repository
- Verify file integrity by reviewing code before running
- Scripts are simple enough to audit manually
- No automatic updates (you control when to update)

### Risk: Permission Escalation

**Scenario**: Scripts could be modified to request elevated privileges

**Mitigation**:
- Scripts explicitly do not require root/admin access
- Installation guides warn against running with elevated privileges
- Cron/Task Scheduler runs under user account only

---

## Best Practices

### Before Installation

1. **Review the code**: Read through the scripts to understand what they do
2. **Test in dry run mode**: Set `DRY_RUN=true` to see operations without moving files
3. **Backup important files**: Make a backup of your Downloads folder before first run
4. **Check permissions**: Ensure scripts will run with user-level permissions only

### After Installation

1. **Monitor the log file**: Check `~/.download_organizer.log` periodically
2. **Review organized files**: Verify files are categorized correctly
3. **Check temporary folder**: Review `008__Temporary/` before the 30-day deletion
4. **Keep scripts updated**: Check GitHub for security updates (no automatic updates)

### Uninstallation

If you want to remove the organizer:

**Linux/macOS**:
```bash
# Remove cron job
crontab -l | grep -v "organize_downloads.sh" | crontab -

# Remove scripts (optional)
rm -rf ~/.local/share/download_organizer

# Remove log file (optional)
rm ~/.download_organizer.log
```

**Windows**:
```powershell
# Remove scheduled task
Unregister-ScheduledTask -TaskName "OrganizeDownloads" -Confirm:$false

# Remove scripts (optional)
Remove-Item -Recurse -Force "$env:USERPROFILE\Scripts\download_organizer"

# Remove log file (optional)
Remove-Item "$env:USERPROFILE\.download_organizer.log"
```

---

## Reporting Security Issues

If you discover a security vulnerability, please report it responsibly:

1. **Do not** open a public GitHub issue
2. Contact the maintainer privately (see repository for contact information)
3. Provide detailed information about the vulnerability
4. Allow reasonable time for a fix before public disclosure

---

## Security Checklist

Before running the scripts, verify:

- [ ] Downloaded from official GitHub repository
- [ ] Reviewed the script code
- [ ] Tested in dry run mode
- [ ] No `sudo` or administrator privileges required
- [ ] Scripts only access Downloads folder
- [ ] No network connections in the code
- [ ] Log file location is in your home directory
- [ ] Cron/Task Scheduler runs under your user account

---

## Updates and Maintenance

- **No automatic updates**: You control when to update
- **Check GitHub**: Visit the repository for new versions
- **Review changelogs**: Read what changed before updating
- **Security patches**: Critical security fixes will be clearly marked

---

## Privacy Statement

Download Organizer:
- Does not collect any personal information
- Does not transmit any data over the network
- Does not use cookies, trackers, or analytics
- Does not require registration or accounts
- Operates entirely offline on your local machine

Your files, file names, and usage patterns remain completely private and never leave your computer.

---

## License

This project is released under the MIT License. See [LICENSE.md](LICENSE.md) for details.

---

**Last Updated**: 2024-01-09
