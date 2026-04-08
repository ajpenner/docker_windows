#!/usr/bin/env bash
set -Eeuo pipefail

: "${VM_ENV_VARS:=}"
: "${VM_ENV_DIR:=/data/.dockur-env}"

[[ -z "$VM_ENV_VARS" ]] && return 0

mkdir -p "$VM_ENV_DIR"

json_file="$VM_ENV_DIR/env.json"
ps1_file="$VM_ENV_DIR/import-env.ps1"

printf '{\n' > "$json_file"

first=1
IFS=',' read -r -a names <<< "$VM_ENV_VARS"

for raw_name in "${names[@]}"; do
  name="$(echo "$raw_name" | xargs)"
  [[ -z "$name" ]] && continue

  if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    warn "Skipping invalid env var name: $name"
    continue
  fi

  value="${!name-}"

  esc_value=$(
    printf '%s' "$value" | \
      sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e ':a;N;$!ba;s/\n/\\n/g'
  )

  if [[ $first -eq 0 ]]; then
    printf ',\n' >> "$json_file"
  fi
  first=0

  printf '  "%s": "%s"' "$name" "$esc_value" >> "$json_file"
done

printf '\n}\n' >> "$json_file"

cat > "$ps1_file" <<'EOF'
$envFile = "C:\Shared\.dockur-env\env.json"
if (-not (Test-Path $envFile)) {
    $envFile = "C:\Data\.dockur-env\env.json"
}
if (-not (Test-Path $envFile)) {
    exit 0
}

$data = Get-Content $envFile -Raw | ConvertFrom-Json
$data.PSObject.Properties | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_.Name, [string]$_.Value, "User")
}
EOF

chmod 0644 "$json_file" "$ps1_file"
