
Function Get-MyPublicIP {
(Invoke-WebRequest -Uri ifconfig.me).RawContent -match "\b(?:\d{1,3}\.){3}\d{1,3}\b" | Out-Null
$matches | select -ExpandProperty Values
}
