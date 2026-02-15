# ===============================
# Auto-Update Firewall Blocklist
# Optimized for GitHub Actions
# ===============================

# Force TLS 1.2 for HTTPS downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# -------------------------------
# List of upstream blocklists
# -------------------------------
$urls = @(
    "https://iplists.firehol.org/files/cybercrime.ipset",
    "https://iplists.firehol.org/files/et_compromised.ipset",
    "https://iplists.firehol.org/files/firehol_level2.netset",
    "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/ips/tif.txt",
    "https://www.spamhaus.org/drop/drop.txt",
    "http://lists.blocklist.de/lists/sip.txt",
    "http://lists.blocklist.de/lists/ftp.txt"
)

# Temporary folder for downloads
$tempFolder = "temp_lists"

# -------------------------------
# Clean old temp folder
# -------------------------------
Remove-Item -Recurse -Force $tempFolder -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $tempFolder | Out-Null

# -------------------------------
# Download all lists
# -------------------------------
foreach ($url in $urls) {
    try {
        $file = Join-Path $tempFolder (Split-Path $url -Leaf)
        Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
        Write-Host "Downloaded: $url"
    }
    catch {
        Write-Host "Failed to download $url"
    }
}

# -------------------------------
# Combine, clean, remove duplicates
# -------------------------------
$combinedTemp = "combined_blocklist_new.txt"
$combinedFile = "combined_blocklist.txt"

Get-Content "$tempFolder\*" |
Where-Object {$_ -notmatch '^(#|;|$)'} |  # Remove comments/empty lines
Sort-Object -Unique |
Set-Content $combinedTemp

# -------------------------------
# Check if file has changed
# -------------------------------
$hasChanges = -Not (Test-Path $combinedFile) -or
    -Not (Compare-Object (Get-Content $combinedFile) (Get-Content $combinedTemp))

if ($hasChanges) {
    # Overwrite tracked file with new blocklist
    $timestamp = "# Last updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    Set-Content -Path $combinedFile -Value $timestamp
    Add-Content -Path $combinedFile -Value (Get-Content $combinedTemp)

    Write-Host '::notice::Blocklist updated successfully at ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
} else {
    Write-Host '::notice::No changes detected at ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
}

# -------------------------------
# Cleanup temp folder
# -------------------------------
Remove-Item -Recurse -Force $tempFolder
