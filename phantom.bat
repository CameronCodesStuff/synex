@echo off
chcp 65001 >nul
color 0D
goto menu

:menu
cls
echo.
echo.
echo         ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗████████╗ ██████╗ ███╗   ███╗
echo         ██╔══██╗██║  ██║██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗████╗ ████║
echo         ██████╔╝███████║███████║██╔██╗ ██║   ██║   ██║   ██║██╔████╔██║
echo         ██╔═══╝ ██╔══██║██╔══██║██║╚██╗██║   ██║   ██║   ██║██║╚██╔╝██║
echo         ██║     ██║  ██║██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║ ╚═╝ ██║
echo         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
echo.
echo.
echo 1. Geolocation
echo 2. DOS (Rapid IP Pinger)
echo 3. Port Scan
echo 4. Traceroute
echo 5. Exit
echo.
set /p choice=Choose an option (1-5): 

if "%choice%"=="1" goto geolocation
if "%choice%"=="2" goto dos
if "%choice%"=="3" goto portscan
if "%choice%"=="4" goto traceroute
if "%choice%"=="5" goto end

goto menu

:geolocation
cls
echo Geolocation Lookup
echo.
set /p ip=Enter the IP address to lookup: 

:: Fetch geolocation data using PowerShell
powershell -Command "Invoke-RestMethod -Uri 'https://ipinfo.io/%ip%/json' | ConvertTo-Json"
echo.
pause
goto menu

:dos
cls
echo Rapid IP Pinger
echo.
set /p ip=Enter the IP address to ping: 
set /p count=Enter the number of pings: 

:: Perform rapid pings without delay
for /L %%i in (1,1,%count%) do (
    echo Pinging %ip% - Attempt %%i
    ping -n 1 %ip% | findstr /i "Reply"
)

echo.
pause
goto menu

:portscan
cls
echo Port Scanner
echo.
set /p ip=Enter the IP address to scan: 
set /p ports=Enter the ports to scan (e.g., 80,443,21): 

:: Perform port scan using PowerShell
powershell -Command "
$ip = '%ip%'
$ports = '%ports%' -split ','
foreach ($port in $ports) {
    $tcp = Test-NetConnection -ComputerName $ip -Port $port
    if ($tcp.TcpTestSucceeded) {
        Write-Output \"Port $port is open\"
    } else {
        Write-Output \"Port $port is closed\"
    }
}"
echo.
pause
goto menu

:traceroute
cls
echo Traceroute
echo.
set /p ip=Enter the IP address to trace: 

:: Perform traceroute using tracert
tracert %ip%
echo.
pause
goto menu

:end
exit