# MkDocs Development Server Launcher
# Source: mkdocs.yml configuration

Write-Host "Starting MkDocs development server..." -ForegroundColor Cyan

# GTK libraries path for PDF export
# Source: User's GTK installation at C:\msys64\mingw64\bin
$env:PATH = "C:\msys64\mingw64\bin;$env:PATH"

# Activate virtual environment
& .\venv\Scripts\Activate.ps1

# Start server
Write-Host "`nServer will be available at: http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

mkdocs serve
