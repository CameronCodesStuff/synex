@echo off
title Network Scanning Tools
cls
color 0a

:menu
cls
echo ===================== Network Scanning Menu =====================
echo 1. IP Address Scanner (Ping Sweep)
echo 2. Port Scanner
echo 3. Wi-Fi Network Scanner
echo 4. Active Device Scanner on Local Network
echo 5. Network Speed Test (Requires speedtest-cli)
echo 6. Wi-Fi Signal Strength
echo 7. List Active Network Connections
echo 8. Scan for Devices with Hostnames
echo 9. Wi-Fi Password Exporter
echo 10. Wi-Fi Channel Scanner
echo 11. MAC Address Scanner (Router MAC)
echo 12. Network Usage Monitor
echo 13. Network Interface Configuration
echo 14. Ping Test to Specific IP
echo 15. Network Bandwidth Usage
echo 16. Check for Listening Ports
echo 17. Show All Devices Connected to Your Wi-Fi Network
echo 18. Get Current IP Configuration
echo 19. Exit
echo =================================================================
set /p choice="Please choose an option (1-19): "

if "%choice%"=="1" goto ip_scanner
if "%choice%"=="2" goto port_scanner
if "%choice%"=="3" goto wifi_scanner
if "%choice%"=="4" goto active_device_scanner
if "%choice%"=="5" goto speed_test
if "%choice%"=="6" goto wifi_signal
if "%choice%"=="7" goto active_connections
if "%choice%"=="8" goto device_with_hostname
if "%choice%"=="9" goto wifi_password_exporter
if "%choice%"=="10" goto wifi_channel_scanner
if "%choice%"=="11" goto mac_address_scanner
if "%choice%"=="12" goto network_usage_monitor
if "%choice%"=="13" goto network_interface
if "%choice%"=="14" goto ping_test
if "%choice%"=="15" goto bandwidth_usage
if "%choice%"=="16" goto listening_ports
if "%choice%"=="17" goto devices_connected_wifi
if "%choice%"=="18" goto ip_configuration
if "%choice%"=="19" exit

:ip_scanner
cls
setlocal enabledelayedexpansion
set "network=192.168.1"
echo Scanning IP range 192.168.1.1 to 192.168.1.254...
for /l %%i in (1,1,254) do (
    set "ip=%network%.%%i"
    ping -n 1 -w 500 !ip! > nul
    if !errorlevel! equ 0 (
        echo Active device found at !ip!
    )
)
pause
goto menu

:port_scanner
cls
echo Enter the IP address to scan for open ports:
set /p ip="IP: "
echo Scanning open ports on %ip%...
for /l %%i in (1,1,65535) do (
    echo Testing port %%i...
    telnet %ip% %%i > nul
    if not errorlevel 1 (
        echo Port %%i is open on %ip%
    )
)
pause
goto menu

:wifi_scanner
cls
echo Scanning for available Wi-Fi networks...
netsh wlan show networks
pause
goto menu

:active_device_scanner
cls
setlocal enabledelayedexpansion
set "network=192.168.1"
echo Scanning network for active devices...
for /l %%i in (1,1,254) do (
    set "ip=%network%.%%i"
    ping -n 1 -w 500 !ip! > nul
    if !errorlevel! equ 0 (
        echo Active device found at !ip!
    )
)
pause
goto menu

:speed_test
cls
echo Please install "speedtest-cli" via pip (Python required) for this to work.
speedtest-cli
pause
goto menu

:wifi_signal
cls
netsh wlan show interfaces | findstr /C:"Signal"
pause
goto menu

:active_connections
cls
netstat -a
pause
goto menu

:device_with_hostname
cls
setlocal enabledelayedexpansion
set "network=192.168.1"
echo Scanning network for devices with hostnames...
for /l %%i in (1,1,254) do (
    set "ip=%network%.%%i"
    ping -n 1 -w 1000 !ip! > nul
    if !errorlevel! equ 0 (
        echo Device found at !ip!
        nslookup !ip! | findstr /C:"Name" >> devices_list.txt
    )
)
echo Scan complete. Devices listed in devices_list.txt
pause
goto menu

:wifi_password_exporter
cls
echo Exporting saved Wi-Fi passwords...
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles') do (
    set SSID=%%i
    netsh wlan show profile name=!SSID! key=clear | findstr /C:"Key Content" >> WiFiPasswords.txt
)
echo Saved Wi-Fi passwords exported to WiFiPasswords.txt
pause
goto menu

:wifi_channel_scanner
cls
netsh wlan show networks mode=bssid | findstr "Channel"
pause
goto menu

:mac_address_scanner
cls
for /f "tokens=3" %%i in ('ipconfig ^| findstr "Default Gateway"') do set gateway=%%i
echo Default Gateway IP: %gateway%
arp -a %gateway%
pause
goto menu

:network_usage_monitor
cls
netstat -e -s
pause
goto menu

:network_interface
cls
ipconfig /all
pause
goto menu

:ping_test
cls
echo Pinging 8.8.8.8 (Google DNS) to test latency...
ping 8.8.8.8
pause
goto menu

:bandwidth_usage
cls
netstat -e
pause
goto menu

:listening_ports
cls
netstat -an | findstr "LISTEN"
pause
goto menu

:devices_connected_wifi
cls
setlocal enabledelayedexpansion
set "network=192.168.1"
echo Scanning for connected devices...
for /l %%i in (1,1,254) do (
    set "ip=%network%.%%i"
    ping -n 1 -w 1000 !ip! > nul
    if !errorlevel! equ 0 (
        echo Device found at !ip!
    )
)
pause
goto menu

:ip_configuration
cls
ipconfig
pause
goto menu
