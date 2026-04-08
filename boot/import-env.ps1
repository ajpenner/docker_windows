$envFile = "\\host.lan\Data\.dockur-env\env.json"
if (-not (Test-Path $envFile)) {
    exit 0
}

$data = Get-Content $envFile -Raw | ConvertFrom-Json
$data.PSObject.Properties | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_.Name, [string]$_.Value, "User")
}

# Ensure variables are available on first shell
$data.PSObject.Properties | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_.Name, [string]$_.Value, "User")
    Set-Item -Path "Env:$($_.Name)" -Value ([string]$_.Value)
}
