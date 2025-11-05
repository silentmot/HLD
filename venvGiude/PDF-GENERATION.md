# PDF Generation Alternatives
<!-- markdownlint-disable MD029 -->
The `mkdocs-pdf-export-plugin` requires GTK libraries not available on Windows by default.

## Alternative Methods

### Method 1: Browser Print (Easiest)

1. Start the development server:

```powershell
.\docs-server.ps1
```

2. Open `http://127.0.0.1:8000` in Chrome/Edge

3. Use browser print:
   - Press `Ctrl+P`
   - Destination: "Save as PDF"
   - Layout: Portrait
   - Enable: "Background graphics"
   - Save

### Method 2: GitHub Actions (Recommended for Production)

Create `.github/workflows/docs-publish.yml`:

```yaml
name: Publish Documentation

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v4
        with:
          python-version: 3.x

      - run: pip install -r requirements.txt

      - name: Enable PDF export in Linux
        run: |
          # Uncomment PDF plugin in mkdocs.yml
          sed -i 's/# - pdf-export:/- pdf-export:/' mkdocs.yml
          sed -i 's/#     combined: true/    combined: true/' mkdocs.yml
          sed -i 's/#     combined_output_path:/    combined_output_path:/' mkdocs.yml

      - run: mkdocs gh-deploy --force
```

### Method 3: Docker (Cross-Platform)

Create `Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /docs

RUN apt-get update && apt-get install -y \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]
```

Run with:

```powershell
docker build -t hld-docs .
docker run -p 8000:8000 -v ${PWD}:/docs hld-docs
```

### Method 4: wkhtmltopdf (Windows Compatible)

1. Download from: <https://wkhtmltopdf.org/downloads.html>

2. Build site and convert:

```powershell
mkdocs build
wkhtmltopdf --enable-local-file-access site/index.html HLD.pdf
```

### Method 5: Pandoc (Advanced)

1. Install Pandoc: <https://pandoc.org/installing.html>

2. Convert markdown to PDF:

```powershell
pandoc docs/**/*.md -o HLD.pdf --pdf-engine=xelatex
```

## Recommendation

For **local development**: Use Method 1 (Browser Print)
For **CI/CD deployment**: Use Method 2 (GitHub Actions with Linux runner)
For **high-quality PDFs**: Use Method 3 (Docker) or Method 5 (Pandoc)
