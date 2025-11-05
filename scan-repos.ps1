# GitHub Repository Scanner
# Uses GitHub MCP to fetch repository details and generate RepoIndex.md

$repos = @(
    @{name="art"; desc=$null; private=$false; branch="master"},
    @{name="at"; desc=$null; private=$true; branch="main"},
    @{name="cargo"; desc=$null; private=$false; branch="master"},
    @{name="capstone"; desc="Front-end Development Capstone Exercise: Setting up the repository"; private=$false; branch="master"},
    @{name="codex"; desc=$null; private=$true; branch="master"},
    @{name="DeskOps"; desc=$null; private=$true; branch="master"},
    @{name="desk-ops"; desc=$null; private=$false; branch="main"},
    @{name="domain"; desc=$null; private=$true; branch="main"},
    @{name="docs"; desc=$null; private=$false; branch="main"},
    @{name="excel"; desc=$null; private=$false; branch="master"},
    @{name="gatex"; desc="GateX - Modern Laravel 12 waste management system"; private=$true; branch="main"},
    @{name="glassmorphic-analyti"; desc=$null; private=$true; branch="main"},
    @{name="HLD"; desc=$null; private=$true; branch="main"},
    @{name="new-trip"; desc=$null; private=$true; branch="master"},
    @{name="next-ops"; desc=$null; private=$false; branch="master"},
    @{name="ops"; desc=$null; private=$false; branch="master"},
    @{name="org"; desc=$null; private=$true; branch="master"},
    @{name="silentmot"; desc="Daily.Dev README"; private=$false; branch="main"},
    @{name="silentmot.github.io"; desc="Github Pages"; private=$false; branch="main"},
    @{name="ssc"; desc="Self Hosted"; private=$true; branch="main"},
    @{name="ssc-presentation"; desc=$null; private=$false; branch="main"},
    @{name="swms-admin"; desc=$null; private=$true; branch="master"},
    @{name="swms-clean"; desc=$null; private=$true; branch="main"},
    @{name="swms-cportal"; desc=$null; private=$true; branch="master"},
    @{name="swms-turbo"; desc=$null; private=$true; branch="master"},
    @{name="templeto"; desc="Template repository for full stack app monorepo"; private=$true; branch="main"},
    @{name="web"; desc=$null; private=$false; branch="main"},
    @{name="wms"; desc=$null; private=$true; branch="main"},
    @{name="ws-ops"; desc="comprehensive facility management system designed specifically for Construction & Demolition (C&D) recycling operations"; private=$false; branch="master"},
    @{name="fulls"; desc="Full-Stack Admin Dashboard"; private=$false; branch="master"}
)

Write-Host "Repository data prepared. Generating RepoIndex.md..." -ForegroundColor Cyan
