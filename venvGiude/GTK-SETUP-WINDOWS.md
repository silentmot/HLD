# GTK Setup for PDF Export on Windows

PDF export requires GTK libraries. Here's how to configure them.

---

## Quick Diagnosis

Run this script to check your GTK installation:

```powershell
.\enable-gtk-pdf.ps1
```

This will:
- Search for GTK in common locations
- Test if WeasyPrint can load libraries
- Provide specific instructions for your system

---

## Option 1: MSYS2 (Recommended)

### Install MSYS2 + GTK

1. **Download MSYS2:**
   - https://www.msys2.org/
   - Install to `C:\msys64` (default)

2. **Install GTK3:**
```bash
# Open MSYS2 UCRT64 terminal
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gtk3
```

3. **Add to PATH:**

**Temporary (current session):**
```powershell
$env:PATH = "C:\msys64\ucrt64\bin;$env:PATH"
```

**Permanent (system-wide):**
- Windows Search → "Environment Variables"
- Edit "Path" → Add: `C:\msys64\ucrt64\bin`

4. **Verify:**
```powershell
.\enable-gtk-pdf.ps1
```

---

## Option 2: GTK for Windows Installer

1. **Download:**
   - https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer
   - Install latest version

2. **Installer adds GTK to PATH automatically**

3. **Restart PowerShell and verify:**
```powershell
.\enable-gtk-pdf.ps1
```

---

## Option 3: vcpkg

```powershell
# Install vcpkg
git clone https://github.com/microsoft/vcpkg
.\vcpkg\bootstrap-vcpkg.bat

# Install GTK
.\vcpkg\vcpkg install gtk:x64-windows

# Add to PATH
$env:PATH = ".\vcpkg\installed\x64-windows\bin;$env:PATH"
```

---

## Configure MkDocs Project

Once GTK is in PATH, update `docs-server.ps1`:

```powershell
# Uncomment and set your GTK path:
$env:PATH = "C:\msys64\ucrt64\bin;$env:PATH"
```

Or add to your PowerShell profile for all sessions:
```powershell
# Edit: $PROFILE
$env:PATH = "C:\msys64\ucrt64\bin;$env:PATH"
```

---

## Verify Installation

### Test GTK Libraries:
```powershell
# Check if DLL exists
Test-Path "C:\msys64\ucrt64\bin\libgobject-2.0-0.dll"
```

### Test WeasyPrint:
```powershell
.\venv\Scripts\Activate.ps1
python -c "import weasyprint; print('Success!')"
```

### Test MkDocs PDF Export:
```powershell
mkdocs build
# Look for: HLD-documentation.pdf in site/ directory
```

---

## Troubleshooting

### Error: "cannot load library 'libgobject-2.0-0'"

**Cause:** GTK not in PATH or wrong architecture

**Solutions:**
1. Verify GTK location: `where.exe libgobject-2.0-0.dll`
2. Check Python architecture matches GTK (both 64-bit or both 32-bit):
   ```powershell
   python -c "import struct; print(f'{struct.calcsize('P')*8}-bit')"
   ```
3. Restart PowerShell after PATH changes
4. Use full MSYS2 path: `C:\msys64\ucrt64\bin` (not `mingw64`)

### Error: Missing dependencies (cairo, pango, etc.)

**Solution:** Install complete GTK stack:
```bash
# MSYS2
pacman -S mingw-w64-ucrt-x86_64-gtk3 \
          mingw-w64-ucrt-x86_64-cairo \
          mingw-w64-ucrt-x86_64-pango \
          mingw-w64-ucrt-x86_64-gdk-pixbuf2
```

### 32-bit vs 64-bit Mismatch

**Check Python:**
```powershell
python -c "import sys; print(sys.maxsize > 2**32)"
# True = 64-bit, False = 32-bit
```

**Install matching GTK:**
- 64-bit Python → `mingw-w64-ucrt-x86_64-gtk3`
- 32-bit Python → `mingw-w64-i686-gtk3`

---

## Alternative: Disable PDF Export

If GTK setup is problematic, disable PDF export in `mkdocs.yml`:

```yaml
plugins:
  - search
  - mermaid2
  # - pdf-export:
  #     combined: true
```

Use alternatives from `PDF-GENERATION.md`:
- Browser print to PDF
- GitHub Actions (Linux runner)
- Docker container
- wkhtmltopdf

---

## Where Are GTK Libraries?

The script searches these locations:

```
C:\msys64\ucrt64\bin         # MSYS2 UCRT64 (preferred)
C:\msys64\mingw64\bin        # MSYS2 MinGW64
C:\msys64\mingw32\bin        # MSYS2 32-bit
C:\GTK\bin                   # Custom GTK install
C:\Program Files\GTK\bin     # GTK for Windows
```

If yours is elsewhere, run:
```powershell
Get-ChildItem -Path "C:\" -Recurse -Filter "libgobject-2.0-0.dll" -ErrorAction SilentlyContinue
```

---

## Recommended Setup Summary

**For most users:**

1. Install MSYS2: https://www.msys2.org/
2. Run: `pacman -S mingw-w64-ucrt-x86_64-gtk3`
3. Add to PATH: `C:\msys64\ucrt64\bin`
4. Edit `docs-server.ps1`: Add PATH line
5. Test: `.\enable-gtk-pdf.ps1`
6. Start server: `.\docs-server.ps1`

**Build with PDF:**
```powershell
mkdocs build
# Output: site/HLD-documentation.pdf
```

---

## Need More Help?

- MSYS2 Docs: https://www.msys2.org/docs/
- WeasyPrint Install: https://doc.courtbouillon.org/weasyprint/stable/first_steps.html
- Run diagnostic: `.\enable-gtk-pdf.ps1`
- See: `TROUBLESHOOTING.md`
