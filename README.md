# High-Level Design Documentation

Documentation repository for system architecture and technical specifications.

## ✅ Setup Complete - Ready to Use

**PDF export enabled with GTK libraries configured.**

👉 **[START HERE - Quick Start Guide](START-HERE.md)** 👈

---

## Quick Start

### Setup Environment

```powershell
# Run the setup script
.\setup-docs.ps1
```

Or manually:

```powershell
# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
```

### Development

**Quick Start:**

```powershell
# Easy way - run the server script
.\docs-server.ps1
```

**Manual:**

```powershell
# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Serve documentation locally with live reload
mkdocs serve

# Build static site
mkdocs build

# Deploy to GitHub Pages
mkdocs gh-deploy
```

The development server will be available at: `http://127.0.0.1:8000`

### PDF Export (Optional)

PDF export requires GTK libraries on Windows:

**Enable PDF Export:**

1. Run diagnostic: `.\enable-gtk-pdf.ps1`
2. Follow instructions in `GTK-SETUP-WINDOWS.md`
3. Uncomment PATH line in `docs-server.ps1`

**Alternatives:** See `PDF-GENERATION.md` for browser print, GitHub Actions, Docker, etc.

## Documentation Structure

```lua
docs/
├── hld/              # High-Level Design documents
│   ├── diagrams/     # Mermaid and draw.io sources
│   └── *.md          # Architecture documentation
├── api/              # OpenAPI specifications
└── assets/           # Images and exports
```

## Features

- **Material Theme**: Modern, responsive design
- **Mermaid Diagrams**: Embedded diagram rendering
- **PDF Export**: Generate complete documentation as PDF
- **Search**: Built-in documentation search
- **Navigation**: Auto-generated from file structure

## Technology Stack

- MkDocs 1.5.3
- Material for MkDocs 9.5.3
- Mermaid2 Plugin for diagrams
- PDF Export Plugin

## Requirements

- Python 3.8+
- pip

## License

[Your License Here]
