**🇮🇹 [Italiano](README.md) | 🇬🇧 [English](README.en.md)**

---

# Download Organizer

Organizzatore automatico della cartella Download per **Linux**, **macOS** e **Windows**.

Lo script gira in background ogni 3 ore e ordina i file scaricati in sottocartelle organizzate per tipo, senza bisogno di intervento manuale.

---

## Come funziona

Ogni 3 ore lo script esegue automaticamente queste operazioni:

1. **Prende i nuovi file** dalla cartella Download e li mette in `001__Recenti/Oggi/`
2. **Dopo 1 giorno**, li sposta in `001__Recenti/Questa-Settimana/`
3. **Dopo 7 giorni**, li smista nella cartella giusta in base al tipo (PDF, immagini, video, ecc.)
4. **Dopo 30 giorni**, elimina i file sconosciuti rimasti in `008__Temporaneo/`

In pratica: hai **7 giorni** per trovare i file recenti nella cartella `001__Recenti/`, poi vengono archiviati automaticamente nella categoria corretta.

---

## Struttura delle cartelle

Dopo l'installazione, la cartella Download viene organizzata così:

```
Download/
├── 001__Recenti/
│   ├── Oggi/                    ← file scaricati nelle ultime 24 ore
│   └── Questa-Settimana/        ← file da 1 a 7 giorni
│
├── 002__Dati/
│   ├── CSV/                     ← .csv, .tsv
│   ├── Excel/                   ← .xlsx, .xls, .ods
│   ├── JSON/                    ← .jsonl, .ndjson
│   ├── Database/                ← .sql, .db, .sqlite
│   ├── Parquet/                 ← .parquet, .feather, .arrow
│   └── Altri-Formati/           ← .xml, .avro, .hdf5
│
├── 003__Documenti/
│   ├── PDF/                     ← .pdf
│   ├── Word/                    ← .doc, .docx, .odt
│   ├── Presentazioni/           ← .ppt, .pptx, .odp, .key
│   ├── Testo/                   ← .txt, .md
│   └── Ebook/                   ← .epub, .mobi
│
├── 004__Media/
│   ├── Immagini/                ← .jpg, .png, .gif, .svg, .webp, .heic
│   ├── Video/                   ← .mp4, .avi, .mkv, .mov
│   ├── Audio/                   ← .mp3, .wav, .flac, .ogg
│   └── Diagrammi/               ← .drawio, .puml
│
├── 005__Sviluppo/
│   ├── Codice/                  ← .py, .js, .ts, .java, .cpp, .swift
│   ├── Notebooks/               ← .ipynb
│   ├── Config/                  ← .json, .yaml, .toml, .env
│   ├── Repository/              ← .zip/.tar.gz con nomi tipo "v1.0", "main"
│   └── Package/                 ← .whl, .jar, .deb, .rpm
│
├── 006__Software/
│   ├── Installatori/            ← formati specifici per ogni OS (vedi sotto)
│   ├── Archivi/                 ← .zip, .rar, .7z, .tar.gz
│   ├── Docker/                  ← Dockerfile, docker-compose.yml
│   └── Scripts/                 ← .sh, .bat, .ps1
│
├── 007__Lavoro/
│   ├── Fatture/                 ← file con "fattura" o "invoice" nel nome
│   ├── Contratti/               ← file con "contratto" o "contract" nel nome
│   ├── Preventivi/              ← file con "preventivo" o "quote" nel nome
│   └── Altri-Documenti/
│
└── 008__Temporaneo/             ← file con estensione sconosciuta
                                    (eliminati automaticamente dopo 30 giorni)
```

Le cartelle sono numerate (`001__`, `002__`, ecc.) per apparire sempre nello stesso ordine nel file manager.

---

## Caratteristiche principali

- **Supporto multi-lingua**: i nomi delle cartelle, i messaggi e le keyword di riconoscimento si adattano alla lingua scelta durante l'installazione (Italiano, English, Español, Français, Deutsch, Português)
- **Nessun file viene sovrascritto**: se esiste già un file con lo stesso nome, viene aggiunto un suffisso numerico (`documento_1.pdf`, `documento_2.pdf`, ecc.)
- **I download in corso non vengono toccati**: i file `.part`, `.crdownload` e `.download` vengono ignorati
- **Documenti di lavoro riconosciuti automaticamente**: fatture, contratti e preventivi vengono identificati dal nome del file e smistati in `007__Lavoro/` (le keyword cambiano in base alla lingua scelta)
- **Modalità test (DRY RUN)**: è possibile vedere cosa farebbe lo script senza spostare nulla
- **Log dettagliato**: ogni operazione viene registrata in un file di log per consultazione
- **Migrazione cartelle**: se cambi lingua reinstallando, le cartelle esistenti vengono rinominate automaticamente

---

## Installazione

### Scegli la versione per il tuo sistema operativo

Ogni cartella contiene gli script e una guida passo passo pensata per utenti non tecnici.

| Sistema operativo | Cartella | Script principale | Guida |
|-------------------|----------|-------------------|-------|
| **Linux** (Ubuntu, Fedora, Debian, Mint, ecc.) | [`linux/`](linux/) | `organize_downloads.sh` (bash) | [`linux/README.md`](linux/README.md) |
| **macOS** (10.15 Catalina o successivo) | [`macOS/`](macOS/) | `organize_downloads.sh` (bash) | [`macOS/README.md`](macOS/README.md) |
| **Windows** (10 e 11) | [`windows/`](windows/) | `Organize-Downloads.ps1` (PowerShell) | [`windows/README.md`](windows/README.md) |

### Procedura rapida

1. **Scarica** i file della cartella corrispondente al tuo sistema operativo
2. **Apri la guida** (`README.md`) dentro quella cartella e segui le istruzioni passo passo
3. **Lancia lo script di installazione** (`install.sh` su Linux/macOS, `Install-Windows.ps1` su Windows)
4. **Scegli la lingua** quando richiesto (Italiano, English, Español, Français, Deutsch, Português)
5. **Conferma** l'attivazione automatica quando richiesto

L'installazione richiede pochi minuti. Dopo, lo script gira da solo in background senza bisogno di ulteriori interventi.

### Lingue supportate

| Codice | Lingua | Esempio cartella |
|--------|--------|-----------------|
| `it` | Italiano (default) | `001__Recenti/Oggi` |
| `en` | English | `001__Recent/Today` |
| `es` | Español | `001__Recientes/Hoy` |
| `fr` | Français | `001__Recents/Aujourd-hui` |
| `de` | Deutsch | `001__Neueste/Heute` |
| `pt` | Português | `001__Recentes/Hoje` |

Per cambiare lingua dopo l'installazione, basta rieseguire lo script di installazione e scegliere una nuova lingua. Le cartelle esistenti vengono rinominate automaticamente.

---

## Differenze tra le versioni

Le tre versioni sono funzionalmente identiche: stessa struttura di cartelle, stessa logica di categorizzazione, stesso comportamento. Le differenze riguardano solo l'adattamento al sistema operativo.

### Linux

- **Linguaggio**: Bash
- **Automazione**: cron job (`crontab`)
- **Installatori riconosciuti**: `.appimage`, `.deb`, `.snap`, `.flatpak`
- **Percorso predefinito**: `$HOME/Download` (da modificare se la cartella ha un nome diverso, ad esempio `Scaricati` o `Downloads`)

### macOS

- **Linguaggio**: Bash (compatibile con bash 3.2+)
- **Automazione**: cron job (`crontab`)
- **Installatori riconosciuti**: `.dmg`, `.pkg`, `.app`
- **Percorso predefinito**: `$HOME/Downloads`
- **Nota importante**: è necessario concedere l'**Accesso completo al disco** a `cron` nelle Impostazioni di Sistema, altrimenti lo script non potrà accedere alla cartella Download quando gira in automatico. La guida spiega come fare.

### Windows

- **Linguaggio**: PowerShell
- **Automazione**: Utilità di pianificazione (Task Scheduler)
- **Installatori riconosciuti**: `.exe`, `.msi`, `.appx`, `.msix`
- **Percorso predefinito**: `$env:USERPROFILE\Downloads`
- **Nota**: potrebbe essere necessario abilitare l'esecuzione degli script PowerShell. La guida spiega come fare.

---

## Domande frequenti

**I file vengono cancellati?**
No. I file vengono solo spostati in sottocartelle. L'unica eccezione è la cartella `008__Temporaneo/`: i file con estensione sconosciuta che restano lì per oltre 30 giorni vengono eliminati.

**Posso spostare i file manualmente tra le cartelle?**
Sì, puoi spostare file come preferisci. Lo script non tocca i file che sono già dentro le sottocartelle.

**Lo script rallenta il computer?**
No. Gira per pochi secondi ogni 3 ore e non consuma risorse.

**Posso cambiare la frequenza di esecuzione?**
Sì. Ogni guida specifica spiega come modificare l'intervallo (ogni ora, ogni 6 ore, una volta al giorno, ecc.).

**Posso usarlo su più sistemi operativi contemporaneamente?**
Sì. Ogni versione è indipendente e può essere installata separatamente su ciascun computer.

---

## Contenuto del repository

```
download_organizer/
├── README.md                        ← questa guida generale (italiano)
├── README.en.md                     ← questa guida generale (inglese)
├── .gitignore
├── linux/
│   ├── organize_downloads.sh        ← script principale (bash)
│   ├── install.sh                   ← installazione automatica
│   ├── lang/                        ← file di lingua (it, en, es, fr, de, pt)
│   ├── README.md                    ← guida passo passo per Linux (italiano)
│   └── README.en.md                 ← guida passo passo per Linux (inglese)
├── macOS/
│   ├── organize_downloads.sh        ← script principale (bash)
│   ├── install.sh                   ← installazione automatica
│   ├── lang/                        ← file di lingua (it, en, es, fr, de, pt)
│   ├── README.md                    ← guida passo passo per macOS (italiano)
│   └── README.en.md                 ← guida passo passo per macOS (inglese)
└── windows/
    ├── Organize-Downloads.ps1       ← script principale (PowerShell)
    ├── Install-Windows.ps1          ← installazione automatica
    ├── lang/                        ← file di lingua (it, en, es, fr, de, pt)
    ├── README.md                    ← guida passo passo per Windows (italiano)
    └── README.en.md                 ← guida passo passo per Windows (inglese)
```