# 🚀 Quick Start Guide - Documentation Tooling

## Prerequisites

- Python 3.11+
- Node.js 18+
- Git

## 1️⃣ Initial Setup (5 minutes)

```bash
# Clone repository
cd d:\GitHub\HLD

# Install Python dependencies
pip install -r requirements.txt

# Install Node.js dependencies for Redocly
npm install -g @redocly/cli

# Verify installations
mkdocs --version
redocly --version
```

## 2️⃣ Configure OpenAI Assistant (2 minutes)

Edit `docs/overrides/partials/footer.html`:

```javascript
apiKey: 'YOUR_ACTUAL_OPENAI_API_KEY',  // Replace this line
```

## 3️⃣ Enable GitHub Pages (1 minute)

1. Go to Repository Settings → Pages
2. Source: "GitHub Actions"
3. Save

## 4️⃣ Update Team Names (2 minutes)

Edit `.github/CODEOWNERS` and replace placeholder teams:

```
@architects → @your-org/architects
@device-team → @your-org/device-team
# etc.
```

## 5️⃣ Test Locally (2 minutes)

```bash
# Start local server
mkdocs serve

# Visit http://localhost:8000

# In another terminal, validate APIs
redocly lint
```

## 6️⃣ Make Your First Change (5 minutes)

1. Create a branch:

   ```bash
   git checkout -b docs/test-update
   ```

2. Edit any file in `docs/hld/`

3. Test locally:

   ```bash
   mkdocs build --strict
   redocly lint
   ```

4. Commit and push:

   ```bash
   git add .
   git commit -m "docs: test documentation update"
   git push origin docs/test-update
   ```

5. Create PR - automated checks will run!

## 7️⃣ Deploy to Production (automatic)

Once PR is approved and merged to `main`:

- GitHub Actions automatically deploys
- Documentation live at: `https://silentmot.github.io/HLD/`
- Check deployment status in Actions tab

## ✅ Verification Checklist

After setup, verify:

- [ ] `mkdocs serve` runs without errors
- [ ] `redocly lint` passes all checks
- [ ] OpenAI widget appears in footer
- [ ] GitHub Pages is enabled
- [ ] CODEOWNERS teams are correct
- [ ] First PR creates automated checks

## 🆘 Troubleshooting

### MkDocs fails to start

```bash
pip install --upgrade mkdocs mkdocs-material
```

### Redocly not found

```bash
npm install -g @redocly/cli
```

### GitHub Actions fail

- Check workflow logs in Actions tab
- Verify `requirements.txt` dependencies
- Ensure OpenAPI specs are valid

### OpenAI widget not showing

- Check browser console for errors
- Verify API key is set correctly
- Ensure `custom_dir` is set in `mkdocs.yml`

## 📚 Next Steps

- Read `TOOLING-SETUP.md` for detailed documentation
- Review `IMPLEMENTATION-SUMMARY.md` for what was implemented
- Check `.github/PULL_REQUEST_TEMPLATE.md` for PR guidelines
- See `updates.md` for GZANSP protocol rules

## 🎯 Total Setup Time: ~20 minutes

You're ready to start contributing to the documentation! 🎉
