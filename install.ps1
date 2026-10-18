$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$repo = "ariel-cr/yunque-releases"
$asset = "yunque-windows-x86_64.exe"
$dir = if ($env:YUNQUE_INSTALL_DIR) { $env:YUNQUE_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "Yunque" }
$dir = [System.IO.Path]::GetFullPath($dir)
$target = Join-Path $dir "yunque.exe"

Write-Host "Instalando Yunque..."
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$version = $env:YUNQUE_VERSION
if ([string]::IsNullOrEmpty($version) -or $version -eq "latest") {
    $url = "https://github.com/$repo/releases/latest/download/$asset"
} else {
    $url = "https://github.com/$repo/releases/download/$version/$asset"
}
Invoke-WebRequest -Uri $url -OutFile $target -UseBasicParsing

$binaryVersion = & $target --version
if ($LASTEXITCODE -ne 0) { throw "El binario no se pudo ejecutar." }
$installOutput = & $target install-agents --binary $target 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "No se pudieron registrar todos los subagentes. El binario está en $target.`n$($installOutput -join "`n")"
}
$report = ($installOutput -join "`n") | ConvertFrom-Json

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathAdded = @($userPath -split ';') -notcontains $dir
if ($pathAdded) {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$dir", "User")
}
$banner = @'
 __   ___   _ _   _  ___  _   _ _____
 \ \ / / | | | \ | |/ _ \| | | | ____|
  \ V /| | | |  \| | | | | | | |  _|
   | | | |_| | |\  | |_| | |_| | |___
   |_|  \___/|_| \_|\__\_\\___/|_____|
'@
Write-Host ""
if ($env:NO_COLOR) { Write-Host $banner } else { Write-Host $banner -ForegroundColor DarkYellow }
Write-Host ""
Write-Host "Yunque has been installed."
Write-Host "Versión: $($binaryVersion -replace '^yunque ', '')"
Write-Host "Ubicación: $target"
if (@($report.hosts.PSObject.Properties).Count -eq 0) {
    Write-Host "No se detectaron anfitriones. Ejecuta yunque install-agents cuando instales uno."
} else {
    Write-Host "Reinicia tu agente y abre tu proyecto Godot."
}
if ($pathAdded) { Write-Host "La ruta se añadió a PATH. Abre una terminal nueva." }
