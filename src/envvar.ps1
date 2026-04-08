$envFile = "C:\Shared\.dockur-env\env.json"
if (-not (Test-Path $envFile)) {
    $envFile = "C:\Data\.dockur-env\env.json"
}
if (Test-Path $envFile) {
    $data = Get-Content $envFile -Raw | ConvertFrom-Json
    $data.PSObject.Properties | ForEach-Object {
        [System.Environment]::SetEnvironmentVariable($_.Name, [string]$_.Value, "User")
    }
}
