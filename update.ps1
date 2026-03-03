$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$urls = @(
    "https://iplists.firehol.org/files/cybercrime.ipset",
    "https://iplists.firehol.org/files/et_compromised.ipset",
    "https://iplists.firehol.org/files/firehol_level2.netset",
    "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/ips/tif.txt",
    "https://www.spamhaus.org/drop/drop.txt",
    "http://lists.blocklist.de/lists/sip.txt",
    "http://lists.blocklist.de/lists/ftp.txt"
)

$tempFolder = "temp_lists"
$combinedFile = "combined_blocklist.txt"
$combinedTemp = "combined_new.tmp"

if (Test-Path $tempFolder) { Remove-Item -Recurse -Force $tempFolder }
New-Item -ItemType Directory -Path $tempFolder | Out-Null

foreach ($url in $urls) {
    try {
        $dest = Join-Path $tempFolder (Split-Path $url -Leaf)
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    }
    catch {
        continue
    }
}

$ipRegex = '^\d{1,3}(\.\d{1,3}){3}(/\d{1,2})?$'
$data = Get-Content "$tempFolder\*" | Where-Object { $_ -match $ipRegex } | Sort-Object -Unique

$timestamp = "# Last updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm') (UTC)"
$finalOutput = $timestamp + "`n" + ($data -join "`n")
[System.IO.File]::WriteAllText("$(Get-Location)\$combinedTemp", $finalOutput)

$hasChanged = $true
if (Test-Path $combinedFile) {
    $oldHash = (Get-FileHash $combinedFile -Algorithm SHA256).Hash
    $newHash = (Get-FileHash $combinedTemp -Algorithm SHA256).Hash
    if ($oldHash -eq $newHash) { $hasChanged = $false }
}

if ($hasChanged) {
    Move-Item -Path $combinedTemp -Destination $combinedFile -Force
    Write-Host "::notice::Blocklist updated."
} else {
    if (Test-Path $combinedTemp) { Remove-Item $combinedTemp }
    Write-Host "::notice::No changes found."
}

if (Test-Path $tempFolder) { Remove-Item -Recurse -Force $tempFolder }
