# Enable GTK Libraries for PDF Export
# Source: WeasyPrint GTK requirements

Write-Host "GTK Library Configuration for MkDocs PDF Export" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

# Check common GTK installation locations
$gtkLocations = @(
    "C:\msys64\mingw64\bin",
    "C:\msys64\ucrt64\bin",
    "C:\msys32\mingw32\bin",
    "C:\GTK\bin",
    "C:\Program Files\GTK\bin",
    "C:\Program Files (x86)\GTK\bin"
)

Write-Host "Searching for GTK libraries..." -ForegroundColor Yellow

$foundPath = $null
foreach ($location in $gtkLocations) {
    if (Test-Path "$location\libgobject-2.0-0.dll") {
        Write-Host "✅ Found GTK at: $location" -ForegroundColor Green
        $foundPath = $location
        break
    }
}

if (-not $foundPath) {
    Write-Host "`n❌ GTK libraries not found in standard locations.`n" -ForegroundColor Red

    Write-Host "Where did you install GTK? Common options:`n" -ForegroundColor Yellow
    Write-Host "1. MSYS2 (recommended)" -ForegroundColor White
    Write-Host "   Install: https://www.msys2.org/" -ForegroundColor Gray
    Write-Host "   Then run: pacman -S mingw-w64-x86_64-gtk3`n" -ForegroundColor Gray

    Write-Host "2. GTK for Windows" -ForegroundColor White
    Write-Host "   Download: https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer`n" -ForegroundColor Gray

    Write-Host "3. vcpkg" -ForegroundColor White
    Write-Host "   Run: vcpkg install gtk`n" -ForegroundColor Gray

    $customPath = Read-Host "Enter the full path to your GTK bin directory (or press Enter to skip)"

    if ($customPath -and (Test-Path "$customPath\libgobject-2.0-0.dll")) {
        $foundPath = $customPath
        Write-Host "✅ GTK found at custom location: $foundPath" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  Cannot proceed without GTK libraries." -ForegroundColor Yellow
        Write-Host "   PDF export will remain disabled.`n" -ForegroundColor Yellow
        exit 1
    }
}

# Add to PATH for current session
Write-Host "`nAdding GTK to PATH for current session..." -ForegroundColor Yellow
$env:PATH = "$foundPath;$env:PATH"

# Test WeasyPrint
Write-Host "Testing WeasyPrint with GTK..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

python -c "import weasyprint; print('✅ WeasyPrint can load GTK libraries')" 2>&1 | Out-Host
$testResult = $LASTEXITCODE

if ($testResult -eq 0) {
    Write-Host "`n✅ SUCCESS! PDF export is now functional.`n" -ForegroundColor Green

    Write-Host "To make this permanent, add GTK to your system PATH:" -ForegroundColor Cyan
    Write-Host "1. Search 'Environment Variables' in Windows" -ForegroundColor White
    Write-Host "2. Edit 'Path' variable" -ForegroundColor White
    Write-Host "3. Add: $foundPath`n" -ForegroundColor White

    Write-Host "Or add to this project's launch script:" -ForegroundColor Cyan
    Write-Host "`$env:PATH = `"$foundPath;`$env:PATH`"`n" -ForegroundColor White

    Write-Host "Now you can:" -ForegroundColor Green
    Write-Host "  mkdocs serve    # Development server with PDF export" -ForegroundColor White
    Write-Host "  mkdocs build    # Generates site + PDF in site/ directory" -ForegroundColor White

} else {
    Write-Host "`n❌ WeasyPrint still cannot load GTK libraries.`n" -ForegroundColor Red
    Write-Host "This might indicate:" -ForegroundColor Yellow
    Write-Host "  - Missing dependencies (cairo, pango, gdk-pixbuf)" -ForegroundColor White
    Write-Host "  - Incompatible architecture (32-bit vs 64-bit Python/GTK mismatch)" -ForegroundColor White
    Write-Host "  - Incomplete GTK installation`n" -ForegroundColor White

    Write-Host "Python architecture: " -NoNewline -ForegroundColor Cyan
    python -c "import struct; print(f'{struct.calcsize(`"P`")*8}-bit')"

    Write-Host "`nRecommended: Install MSYS2 and GTK3:" -ForegroundColor Yellow
    Write-Host "  1. Download MSYS2 from https://www.msys2.org/" -ForegroundColor White
    Write-Host "  2. Run: pacman -S mingw-w64-x86_64-gtk3" -ForegroundColor White
    Write-Host "  3. Add C:\msys64\mingw64\bin to PATH" -ForegroundColor White
    Write-Host "  4. Run this script again`n" -ForegroundColor White
}
