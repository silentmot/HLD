# Add GitHub MCP Server Configuration
# Source: User request to add GitHub MCP server with environment variable access

$mcpPath = "$env:USERPROFILE\.cursor\mcp.json"

if (-not (Test-Path $mcpPath)) {
    Write-Error "MCP configuration file not found at: $mcpPath"
    exit 1
}

Write-Host "Reading MCP configuration from: $mcpPath" -ForegroundColor Cyan

# Read current configuration
$content = Get-Content $mcpPath -Raw
$json = $content | ConvertFrom-Json

# Check if GitHub server already exists
if ($json.mcpServers.PSObject.Properties.Name -contains "github") {
    Write-Host "GitHub MCP server already exists. Updating configuration..." -ForegroundColor Yellow
    $json.mcpServers.github = @{
        command = "npx"
        args = @(
            "-y",
            "@modelcontextprotocol/server-github"
        )
        type = "stdio"
        env = @{
            GITHUB_PERSONAL_ACCESS_TOKEN = "`${env:GITHUB_PERSONAL_ACCESS_TOKEN}"
        }
    }
} else {
    Write-Host "Adding GitHub MCP server configuration..." -ForegroundColor Green
    # Add GitHub MCP server configuration
    $githubConfig = @{
        command = "npx"
        args = @(
            "-y",
            "@modelcontextprotocol/server-github"
        )
        type = "stdio"
        env = @{
            GITHUB_PERSONAL_ACCESS_TOKEN = "`${env:GITHUB_PERSONAL_ACCESS_TOKEN}"
        }
    }

    # Add to mcpServers object
    $json.mcpServers | Add-Member -MemberType NoteProperty -Name "github" -Value $githubConfig -Force
}

# Convert back to JSON with proper formatting
$updatedJson = $json | ConvertTo-Json -Depth 10

# Write back to file
$updatedJson | Set-Content $mcpPath -Encoding UTF8

Write-Host "`nGitHub MCP server configuration added successfully!" -ForegroundColor Green
Write-Host "`nTo use the GitHub MCP server, set the environment variable:" -ForegroundColor Cyan
Write-Host "  `$env:GITHUB_PERSONAL_ACCESS_TOKEN = 'your_token_here'" -ForegroundColor Yellow
Write-Host "`nOr add it to your PowerShell profile for persistence." -ForegroundColor Cyan
