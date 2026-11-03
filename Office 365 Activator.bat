@echo off
setlocal EnableExtensions
title Microsoft Office Activation Tool

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo  ===================================================
    echo         ADMINISTRATOR PRIVILEGES REQUIRED
    echo  ===================================================
    echo.
    echo  Please right-click this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

cls
color 0B

echo.
echo  ===================================================
echo          Microsoft Office Activation Tool
echo  ===================================================
echo.
echo  This tool will activate your Microsoft Office installation
echo  using a KMS volume licensing server.
echo.
echo  [*] Checking Office installation...

:: Find Office installation path
set "OFFICE_PATH="
if exist "%ProgramFiles%\Microsoft Office\root\Office16\ospp.vbs" (
    set "OFFICE_PATH=%ProgramFiles%\Microsoft Office\root\Office16"
)
if not defined OFFICE_PATH (
    if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\ospp.vbs" (
        set "OFFICE_PATH=%ProgramFiles(x86)%\Microsoft Office\root\Office16"
    )
)
if not defined OFFICE_PATH (
    if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" (
        set "OFFICE_PATH=%ProgramFiles%\Microsoft Office\Office16"
    )
)
if not defined OFFICE_PATH (
    if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" (
        set "OFFICE_PATH=%ProgramFiles(x86)%\Microsoft Office\Office16"
    )
)

if not defined OFFICE_PATH (
    color 0C
    echo.
    echo  [!] ERROR: Microsoft Office installation not found.
    echo      Please make sure Office is properly installed.
    echo.
    pause
    exit /b 1
)

cd /d "%OFFICE_PATH%"
echo  [OK] Office installation found at: "%OFFICE_PATH%"
echo.

:: Detect and install Volume License files
set "LIC_PATH="
if exist "..\Licenses16" (
    set "LIC_PATH=..\Licenses16"
)
if not defined LIC_PATH (
    if exist "..\root\Licenses16" (
        set "LIC_PATH=..\root\Licenses16"
    )
)

if defined LIC_PATH (
    echo  [*] Installing KMS Volume License packages...
    for /f "tokens=*" %%x in ('dir /b "%LIC_PATH%\ProPlus2021VL_KMS*.xrm-ms" 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"%LIC_PATH%\%%x" >nul
    )
    for /f "tokens=*" %%x in ('dir /b "%LIC_PATH%\proplusvl_kms*.xrm-ms" 2^>nul') do (
        cscript //nologo ospp.vbs /inslic:"%LIC_PATH%\%%x" >nul
    )
    echo  [OK] License files installed.
) else (
    echo  [!] License directory not found; attempting direct activation...
)

echo.
echo  [*] Configuring KMS client settings and key...
cscript //nologo ospp.vbs /setprt:1688 >nul
cscript //nologo ospp.vbs /unpkey:6F7TH >nul 2>&1
cscript //nologo ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH >nul
cscript //nologo ospp.vbs /unpkey:BTDRB >nul 2>&1
cscript //nologo ospp.vbs /unpkey:KHGM9 >nul 2>&1
cscript //nologo ospp.vbs /unpkey:CPQVG >nul 2>&1
echo  [OK] KMS client configured.

echo.
echo  [*] Attempting KMS activation...
echo      Connecting to KMS servers, please wait...
echo.

set "ACTIVATED=0"
for %%S in (kms8.msguides.com kms9.msguides.com kms.loli.best kms.digiboy.ir kms.moeclub.org kms.ddns.net e8.us.to) do (
    echo      Trying KMS server: %%S ...
    cscript //nologo ospp.vbs /sethst:%%S >nul
    cscript //nologo ospp.vbs /act | findstr /i "successful" >nul 2>&1
    if not errorlevel 1 (
        set "ACTIVATED=1"
        goto :ACTIVATION_SUCCESS
    )
    echo      Server %%S failed or busy. Trying next...
)

if %ACTIVATED%==0 goto :ACTIVATION_FAILED

:ACTIVATION_SUCCESS
color 0A
echo.
echo  ===================================================
echo            OFFICE ACTIVATED SUCCESSFULLY!
echo  ===================================================
echo.
echo  Your Microsoft Office is now fully activated.
echo.
echo  Press any key to exit...
pause >nul
exit /b 0

:ACTIVATION_FAILED
color 0E
echo.
echo  ===================================================
echo                  ACTIVATION FAILED
echo  ===================================================
echo.
echo  All KMS servers are currently busy or unavailable.
echo  Please check your internet connection and firewall on port 1688.
echo.
echo  Press any key to exit...
pause >nul
exit /b 1
