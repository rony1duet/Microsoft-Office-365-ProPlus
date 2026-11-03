@echo off
chcp 65001 > nul
title Microsoft Office Activation Tool

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo.
    echo  ╔═══════════════════════════════════════════════╗
    echo  ║       ADMINISTRATOR PRIVILEGES REQUIRED       ║
    echo  ╚═══════════════════════════════════════════════╝
    echo.
    echo  Please right-click this file and select "Run as administrator"
    echo.
    pause
    exit
)

cls
color 0B

echo.
echo  ╔═══════════════════════════════════════════════╗
echo  ║        Microsoft Office Activation Tool       ║
echo  ╚═══════════════════════════════════════════════╝
echo.
echo  This tool will activate your Microsoft Office installation
echo  using a KMS server.
echo.
echo  [*] Checking Office installation...

:: Find Office installation path
set "OfficeFound=0"
if exist "%ProgramFiles%\Microsoft Office\root\Office16\ospp.vbs" (
    cd /d "%ProgramFiles%\Microsoft Office\root\Office16"
    set "OfficeFound=1"
) else if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\ospp.vbs" (
    cd /d "%ProgramFiles(x86)%\Microsoft Office\root\Office16"
    set "OfficeFound=1"
) else if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" (
    cd /d "%ProgramFiles%\Microsoft Office\Office16"
    set "OfficeFound=1"
) else if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" (
    cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
    set "OfficeFound=1"
)

if %OfficeFound%==0 (
    color 0C
    echo.
    echo  [!] ERROR: Microsoft Office installation not found.
    echo      Please make sure Office is properly installed.
    echo.
    pause
    exit
)

echo  [✓] Office installation found!
echo.
echo  [*] Installing license files...

:: Install license files
if exist "..\root\Licenses16\" (
    for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
    )
    for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
    )
) else if exist "..\Licenses16\" (
    for /f %%x in ('dir /b ..\Licenses16\ProPlus2021VL_KMS*.xrm-ms 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"..\Licenses16\%%x" >nul
    )
    for /f %%x in ('dir /b ..\Licenses16\proplusvl_kms*.xrm-ms 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"..\Licenses16\%%x" >nul
    )
)

echo  [✓] License files installed
echo.
echo  [*] Configuring KMS client...

:: Configure KMS
cscript //nologo ospp.vbs /setprt:1688 >nul
cscript //nologo ospp.vbs /unpkey:6F7TH >nul 2>&1
cscript //nologo ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH >nul

:: Remove previous keys if they exist
cscript //nologo ospp.vbs /unpkey:BTDRB >nul 2>&1
cscript //nologo ospp.vbs /unpkey:KHGM9 >nul 2>&1
cscript //nologo ospp.vbs /unpkey:CPQVG >nul 2>&1

echo  [✓] KMS client configured
echo.
echo  [*] Attempting to activate Office...
echo      Connecting to KMS servers, please wait...
echo.

:: KMS Server List Loop
set server=1
set attempts=0
:skms
set /a attempts+=1
if %server%==1 set KMS=23.226.136.46
if %server%==2 set KMS=107.175.77.7
if %server%==3 set KMS=kms7.devomman.com
if %server%==4 set KMS=e8.us.to
if %server%==5 set KMS=kms7.MSGuides.com
if %server%==6 goto busyError

:: Set host
echo     Trying KMS server %server% of 5...
cscript //nologo ospp.vbs /sethst:%KMS% >nul

:: Try Activation
cscript //nologo ospp.vbs /act | find /i "successful" && (
    color 0A
    echo.
    echo  ╔═══════════════════════════════════════════════╗
    echo  ║       OFFICE ACTIVATED SUCCESSFULLY!          ║
    echo  ╚═══════════════════════════════════════════════╝
    echo.
    echo  Your Microsoft Office is now fully activated.
    echo.
    echo  Press any key to exit...
    pause >nul
    exit
) || (
    echo     Server %server% failed. Trying next server...
    set /a server+=1
    if %attempts% LSS 15 (
        timeout /t 2 >nul
        goto skms
    ) else (
        goto busyError
    )
)

:busyError
color 0E
echo.
echo  ╔═══════════════════════════════════════════════╗
echo  ║              ACTIVATION FAILED                ║
echo  ╚═══════════════════════════════════════════════╝
echo.
echo  All KMS servers are currently busy or unavailable.
echo  Please try again later or check your internet connection.
echo.
echo  Press any key to exit...
pause >nul
exit