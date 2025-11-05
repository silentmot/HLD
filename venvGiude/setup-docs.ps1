# MkDocs Documentation Setup Script
# Source: requirements.txt, mkdocs.yml (lines 142-173 of Qu1.md)

Write-Host "Setting up Python environment for MkDocs..." -ForegroundColor Cyan

# Create virtual environment
Write-Host "`nCreating Python virtual environment..." -ForegroundColor Yellow
python -m venv venv

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Upgrade pip
Write-Host "`nUpgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install requirements
Write-Host "`nInstalling MkDocs and plugins..." -ForegroundColor Yellow
pip install -r requirements.txt

# Create docs directory structure
Write-Host "`nCreating documentation directory structure..." -ForegroundColor Yellow
$directories = @(
    "docs",
    "docs\hld",
    "docs\hld\diagrams",
    "docs\api",
    "docs\assets"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Green
    }
}

# Create placeholder README
if (-not (Test-Path "docs\README.md")) {
    @"
# Documentation Home

Welcome to the system documentation portal.

## Sections

- [High-Level Design (HLD)](hld/README.md)
- API Documentation
"@ | Out-File -FilePath "docs\README.md" -Encoding utf8
    Write-Host "  Created: docs\README.md" -ForegroundColor Green
}

if (-not (Test-Path "docs\hld\README.md")) {
    @"
# High-Level Design

This section contains the comprehensive system architecture documentation.

## Contents

Navigate through the sections using the sidebar.
"@ | Out-File -FilePath "docs\hld\README.md" -Encoding utf8
    Write-Host "  Created: docs\hld\README.md" -ForegroundColor Green
}

Write-Host "`n✅ Setup complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Start development server: mkdocs serve" -ForegroundColor White
Write-Host "  2. Build static site: mkdocs build" -ForegroundColor White
Write-Host "  3. Deploy to GitHub Pages: mkdocs gh-deploy" -ForegroundColor White
Write-Host "`nDocumentation will be available at: http://127.0.0.1:8000" -ForegroundColor Yellow
