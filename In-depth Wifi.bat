@echo off
title Camerons Wifi Menu
chcp 65001 >nul
:menu
cls
echo [34m    ██╗███╗   ██╗      ██████╗ ███████╗██████╗ ████████╗██╗  ██╗    ██╗    ██╗██╗███████╗██╗[0m
echo [34m    ██║████╗  ██║      ██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██║  ██║    ██║    ██║██║██╔════╝██║[0m
echo [94m    ██║██╔██╗ ██║█████╗██║  ██║█████╗  ██████╔╝   ██║   ███████║    ██║ █╗ ██║██║█████╗  ██║[0m
echo [94m    ██║██║╚██╗██║╚════╝██║  ██║██╔══╝  ██╔═══╝    ██║   ██╔══██║    ██║███╗██║██║██╔══╝  ██║[0m
echo [96m    ██║██║ ╚████║      ██████╔╝███████╗██║        ██║   ██║  ██║    ╚███╔███╔╝██║██║     ██║[0m
echo [96m    ╚═╝╚═╝  ╚═══╝      ╚═════╝ ╚══════╝╚═╝        ╚═╝   ╚═╝  ╚═╝     ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝[0m

echo [34m    ==========================================
echo [96m    Welcome to the Wi-Fi and Network Scanner Menu
echo [34m    ==========================================
echo [96m    1. Basic Wi-Fi Connection Status Checker
echo [94m    2. List All Wi-Fi Networks in Range
echo [96m    3. Ping Scan for Active Devices on Your Wi-Fi Network
echo [94m    4. Export Wi-Fi Network Passwords
echo [96m    5. Network Speed Test via Command Line (Requires speedtest-cli)
echo [94m    6. List All Devices Connected to Your Wi-Fi Network (with IP and Hostname)
echo [96m    7. Check Wi-Fi Signal Strength
echo [94m    8. Batch File to View and Disconnect from Wi-Fi Networks
echo [96m    9. Show All Available Wi-Fi Networks with Signal Strength
echo [94m    10. Find the MAC Address of Your Router
echo [96m    11. Wi-Fi Channel Scanner
echo [94m    12. Wi-Fi Signal Quality and Network Usage Monitor
echo [96m    13. Monitor Network Traffic Usage
echo [94m    14. Show All Active Network Connections
echo [96m    15. Wi-Fi Password Recovery (on Your Own Computer)
echo [94m    16. Credits
echo [95m    17. Exit
echo [34m    ==========================================
set /p choice="Please choose an option (1-16): "

if "%choice%"=="1" goto wifi_status
if "%choice%"=="2" goto list_wifi
if "%choice%"=="3" goto ping_scan
if "%choice%"=="4" goto export_passwords
if "%choice%"=="5" goto speed_test
if "%choice%"=="6" goto list_devices
if "%choice%"=="7" goto wifi_signal
if "%choice%"=="8" goto disconnect_wifi
if "%choice%"=="9" goto wifi_strength
if "%choice%"=="10" goto find_mac
if "%choice%"=="11" goto wifi_channel
if "%choice%"=="12" goto signal_quality
if "%choice%"=="13" goto network_usage
if "%choice%"=="14" goto active_connections
if "%choice%"=="15" goto wifi_password_recovery
if "%choice%"=="16" goto credits
if "%choice%"=="17" exit

:wifi_status
cls
for /f "tokens=2 delims=:" %%i in ('netsh wlan show interfaces ^| findstr /C:"SSID"') do set SSID=%%i
if defined SSID (
    echo Connected to Wi-Fi: %SSID%
) else (
    echo No Wi-Fi connection found.
)
pause
goto menu

:list_wifi
cls
echo Scanning for available Wi-Fi networks...
netsh wlan show networks
pause
goto menu

:ping_scan
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

:export_passwords
cls
echo Exporting saved Wi-Fi passwords...
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles') do (
    set SSID=%%i
    netsh wlan show profile name=!SSID! key=clear | findstr /C:"Key Content" >> WiFiPasswords.txt
)
echo Saved Wi-Fi passwords exported to WiFiPasswords.txt
pause
goto menu

:speed_test
cls
echo Please install "speedtest-cli" via pip (Python required) for this to work.
speedtest-cli
pause
goto menu

:list_devices
cls
setlocal enabledelayedexpansion
set "network=192.168.1"
echo Scanning network for devices...
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

:wifi_signal
cls
netsh wlan show interfaces | findstr /C:"Signal"
pause
goto menu

:disconnect_wifi
cls
echo Available saved networks:
netsh wlan show profiles
echo.
set /p "network=Enter the name of the network you want to disconnect from: "
netsh wlan disconnect name="%network%"
echo Disconnected from %network%.
pause
goto menu

:wifi_strength
cls
netsh wlan show networks mode=bssid | findstr "Channel"
pause
goto menu

:find_mac
cls
for /f "tokens=3" %%i in ('ipconfig ^| findstr "Default Gateway"') do set gateway=%%i
echo Default Gateway IP: %gateway%
arp -a %gateway%
pause
goto menu

:wifi_channel
cls
netsh wlan show networks mode=bssid | findstr "Channel"
pause
goto menu

:signal_quality
cls
:loop
cls
netsh wlan show interfaces | findstr /C:"Signal"
timeout /t 5 > nul
goto loop
goto menu

:network_usage
cls
netstat -e -s
pause
goto menu

:active_connections
cls
netstat -a
pause
goto menu

:wifi_password_recovery
cls
echo Enter the Wi-Fi name to recover the password:
set /p "wifi=Wi-Fi Name: "
netsh wlan show profile name="%wifi%" key=clear | findstr /C:"Key Content"
pause
goto menu

:Credits
color 0a
cls

echo ===================================================
echo              Credits for Cameron's Network Nexus
echo ===================================================
echo.
echo   🛠 Script Created By: Cameron
echo   🌍 Network-related functions based on various tools
echo   ⚡ Powered by Batch scripting and Windows utilities
echo.
echo   🚀 Special Thanks To:
echo   - The developers of Windows command-line tools (netsh, ping, netstat, etc.)
echo   - The open-source community for their continuous innovation
echo   - You, for using and exploring the power of your network!
echo.
echo   💡 Inspired by the idea of making network management easy, fun, and powerful.
echo ===================================================
echo.
echo   ✨ "Connect. Control. Conquer." ✨
echo ===================================================

pause
goto menu