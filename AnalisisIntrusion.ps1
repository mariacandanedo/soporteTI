Write-Host "===  Analisis rapido de seguridad del sistema ===" -ForegroundColor Cyan 

# Usuario actual
$user = whoami
Write-Host "`nUsuario actual:" $user -ForegroundColor Green

# Últimos eventos de inicio de sesión
Write-Host "Ultimos eventos de autenticacion:" -ForegroundColor Yellow
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624,4625} -MaxEvents 10 |
Select-Object TimeCreated, Id, Message | Format-Table -AutoSize

# Intentos fallidos recientes
$failed = (Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 50).Count
if ($failed -gt 5) {
    Write-Host "`n Se detectaron" $failed "intentos fallidos recientes" -ForegroundColor Red 
} else {
    Write-Host "`n No hay intentos de inicio de sesion fallidos recientes." -ForegroundColor Green 
}

# Conexiones activas
Write-Host "`nConexiones de red activas:" -ForegroundColor Yellow
Get-NetTCPConnection -State Established | Select LocalAddress,RemoteAddress,RemotePort,OwningProcess | Format-Table -AutoSize

Write-Host "`nRevisión completa " -ForegroundColor Cyan