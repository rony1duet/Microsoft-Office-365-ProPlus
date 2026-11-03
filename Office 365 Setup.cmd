@ECHO OFF
setlocal EnableExtensions
TITLE Microsoft Office 365 ProPlus - Online/Offline Installer
PushD "%~dp0"
Set "Version=3.2.6"
CHCP 1252 1>NUL
Set "BatchDir=%~dp0"
If [%BatchDir:~-1%]==[\] Set "BatchDir=%BatchDir:~0,-1%"

:: Check for administrator privileges
FLTMC >NUL 2>&1 || (
    ECHO.
    ECHO Requesting administrator privileges . . .
    PowerShell -nop -c "Start-Process -FilePath cmd -ArgumentList '/c', '\"\"%~f0\"\"' -Verb RunAs" >NUL 2>&1 && EXIT /b 0
    ECHO This script requires administrator privileges.
    PAUSE
    EXIT /b 1
)

:: Enable ANSI terminal colors
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "cGreen=%ESC%[92m"
set "cYellow=%ESC%[93m"
set "cCyan=%ESC%[96m"
set "cGray=%ESC%[90m"
set "cReset=%ESC%[0m"

Set "on=(YES)"
Set "off=(NO) "
Set "opt1=%on%"
Set "opt2=%on%"
Set "opt3=%on%"
Set "opt4=%on%"
Set "opt5=%on%"
Set "opt6=%on%"
Set "opt7=%on%"
Set "opt8=%on%"
Set "opt9=%on%"
Set "optP=%on%"
Set "optT=%on%"
Set "optD=%on%"
If "%Processor_Architecture%"=="x86" Set "optB=32-bit"
If "%Processor_Architecture%"=="AMD64" Set "optB=64-bit"
If "%Processor_Architecture%"=="ARM64" Set "optB=64-bit"
Set "optO=%off%"
Set "optS=%on%"

:MENU
CLS
WHERE /q /r ".\Office\Data" "stream.*.x-none.dat" 2>NUL && (Set "OFiles=%on%") || (Set "OFiles=%off%")
If "%optO%,%OFiles%"=="%on%,%on%" Set "OMessage=Delete Offline Files"
If "%optS%,%OFiles%"=="%on%,%on%" Set "SMessage=Offline Installation"
If "%optO%,%OFiles%"=="%off%,%off%" Set "OMessage=Download Offline Files (x86 and x64 = 6.40 GB)"
If "%optS%,%OFiles%"=="%off%,%off%" Set "SMessage=Online Installation"
If "%optO%,%OFiles%"=="%on%,%off%" Set "OMessage=Download Offline Files (x86 and x64 = 6.40 GB)"
If "%optS%,%OFiles%"=="%on%,%off%" Set "SMessage=Online Installation"
If "%optO%,%OFiles%"=="%off%,%on%" Set "OMessage=Delete Offline Files"
If "%optS%,%OFiles%"=="%off%,%on%" Set "SMessage=Offline Installation"
If "%optB%"=="64-bit" Set "BMessage=Here you can switch between a 32-bit or 64-bit installation"
If "%optB%"=="32-bit" Set "BMessage=Here you can switch between a 32-bit or 64-bit installation"
If "%optB%,%Processor_Architecture%"=="64-bit,x86" Set "optB=32-bit" & Set "BMessage=A 64-bit Application cannot be installed on a 32-bit Windows"

set "c1=%cGray%" & if "%opt1%"=="%on%" set "c1=%cGreen%"
set "c2=%cGray%" & if "%opt2%"=="%on%" set "c2=%cGreen%"
set "c3=%cGray%" & if "%opt3%"=="%on%" set "c3=%cGreen%"
set "c4=%cGray%" & if "%opt4%"=="%on%" set "c4=%cGreen%"
set "c5=%cGray%" & if "%opt5%"=="%on%" set "c5=%cGreen%"
set "c6=%cGray%" & if "%opt6%"=="%on%" set "c6=%cGreen%"
set "c7=%cGray%" & if "%opt7%"=="%on%" set "c7=%cGreen%"
set "c8=%cGray%" & if "%opt8%"=="%on%" set "c8=%cGreen%"
set "c9=%cGray%" & if "%opt9%"=="%on%" set "c9=%cGreen%"
set "cP=%cGray%" & if "%optP%"=="%on%" set "cP=%cGreen%"
set "cT=%cGray%" & if "%optT%"=="%on%" set "cT=%cGreen%"
set "cD=%cGray%" & if "%optD%"=="%on%" set "cD=%cGreen%"
set "cO=%cGray%" & if "%optO%"=="%on%" set "cO=%cCyan%"
set "cS=%cGray%" & if "%optS%"=="%on%" set "cS=%cCyan%"

ECHO ===========================================================================
ECHO      Microsoft Office 365 Professional Plus - Online/Offline Installer v%Version%
ECHO ===========================================================================
ECHO.
ECHO  [1] %c1%%opt1%%cReset% Microsoft Office Word.
ECHO  [2] %c2%%opt2%%cReset% Microsoft Office Excel.
ECHO  [3] %c3%%opt3%%cReset% Microsoft Office PowerPoint.
ECHO  [4] %c4%%opt4%%cReset% Microsoft Office Outlook.
ECHO  [5] %c5%%opt5%%cReset% Microsoft Office OneNote.
ECHO  [6] %c6%%opt6%%cReset% Microsoft Office Publisher.
ECHO  [7] %c7%%opt7%%cReset% Microsoft Office Access.
ECHO  [8] %c8%%opt8%%cReset% Microsoft Office Visio.
ECHO  [9] %c9%%opt9%%cReset% Microsoft Office Project.
ECHO  [P] %cP%%optP%%cReset% Microsoft Office Proofing Tools.
ECHO  [T] %cT%%optT%%cReset% Microsoft Teams.
ECHO  [D] %cD%%optD%%cReset% Microsoft OneDrive.
ECHO  --- Office will match its language with your Windows system language.
ECHO  [B] %cYellow%(%optB%)%cReset% %BMessage%.
ECHO  [O] %cO%%optO%%cReset% %OMessage%.
ECHO  [S] %cS%%optS%%cReset% %SMessage%.
ECHO.
CHOICE /c 123456789PTDBOSXZ /n /t 300 /d X /m "--> Toggle your option(s) and toggle [Z] to Start: "

If ERRORLEVEL 17 GoTo CONTINUE
If ERRORLEVEL 16 EXIT /b 0
If ERRORLEVEL 15 (If "%optS%"=="%on%" (Set "optS=%off%" & Set "optO=%on%") Else (Set "optS=%on%" & Set "optO=%off%")) & GoTo MENU
If ERRORLEVEL 14 (If "%optO%"=="%on%" (Set "optO=%off%" & Set "optS=%on%") Else (Set "optO=%on%" & Set "optS=%off%")) & GoTo MENU
If ERRORLEVEL 13 (If "%optB%"=="64-bit" (Set "optB=32-bit") Else (Set "optB=64-bit")) & GoTo MENU
If ERRORLEVEL 12 (If "%optD%"=="%on%" (Set "optD=%off%") Else (Set "optD=%on%")) & GoTo MENU
If ERRORLEVEL 11 (If "%optT%"=="%on%" (Set "optT=%off%") Else (Set "optT=%on%")) & GoTo MENU
If ERRORLEVEL 10 (If "%optP%"=="%on%" (Set "optP=%off%") Else (Set "optP=%on%")) & GoTo MENU
If ERRORLEVEL 9 (If "%opt9%"=="%on%" (Set "opt9=%off%") Else (Set "opt9=%on%")) & GoTo MENU
If ERRORLEVEL 8 (If "%opt8%"=="%on%" (Set "opt8=%off%") Else (Set "opt8=%on%")) & GoTo MENU
If ERRORLEVEL 7 (If "%opt7%"=="%on%" (Set "opt7=%off%") Else (Set "opt7=%on%")) & GoTo MENU
If ERRORLEVEL 6 (If "%opt6%"=="%on%" (Set "opt6=%off%") Else (Set "opt6=%on%")) & GoTo MENU
If ERRORLEVEL 5 (If "%opt5%"=="%on%" (Set "opt5=%off%") Else (Set "opt5=%on%")) & GoTo MENU
If ERRORLEVEL 4 (If "%opt4%"=="%on%" (Set "opt4=%off%") Else (Set "opt4=%on%")) & GoTo MENU
If ERRORLEVEL 3 (If "%opt3%"=="%on%" (Set "opt3=%off%") Else (Set "opt3=%on%")) & GoTo MENU
If ERRORLEVEL 2 (If "%opt2%"=="%on%" (Set "opt2=%off%") Else (Set "opt2=%on%")) & GoTo MENU
If ERRORLEVEL 1 (If "%opt1%"=="%on%" (Set "opt1=%off%") Else (Set "opt1=%on%")) & GoTo MENU

:CONTINUE
ECHO.
ECHO ---------------------------------------------------------------------------
If "%optO%,%OFiles%"=="%on%,%off%" GoTo DO_DOWNLOAD
If "%optO%,%OFiles%"=="%on%,%on%" GoTo DO_DELETE
Echo %opt1% %opt2% %opt3% %opt4% %opt5% %opt6% %opt7% %opt8% %opt9% %optP% %optT% %optD% | FindStr /l /i "%on%" >nul 2>&1 && GoTo DO_INSTALL
ECHO.
ECHO No options were selected.
PAUSE
GoTo MENU

:CONFIG
Set "OCS=.\Office 365 Setup Config.xml"
                                     >"%OCS%" ECHO ^<Configuration^>
If "%optO%,%OFiles%"=="%on%,%off%"  >>"%OCS%" ECHO   ^<Add OfficeClientEdition="%CPU%" Channel="Current"^>
If "%optS%,%OFiles%"=="%on%,%off%"  >>"%OCS%" ECHO   ^<Add OfficeClientEdition="%CPU%" Channel="Current" MigrateArch="TRUE"^>
If "%optS%,%OFiles%"=="%on%,%on%"   >>"%OCS%" ECHO   ^<Add OfficeClientEdition="%CPU%" Channel="Current" MigrateArch="TRUE" SourcePath="%BatchDir%"^>
                                    >>"%OCS%" ECHO     ^<Product ID="O365ProPlusRetail"^>
                                    >>"%OCS%" ECHO       ^<Language ID="MatchOS" Fallback="en-US" /^>
If "%opt1%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Word" /^>
If "%opt2%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Excel" /^>
If "%opt3%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="PowerPoint" /^>
If "%opt4%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Outlook" /^>
If "%opt5%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="OneNote" /^>
If "%opt6%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Publisher" /^>
If "%opt7%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Access" /^>
If "%optT%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="Teams" /^>
If "%optD%"=="%off%"                >>"%OCS%" ECHO       ^<ExcludeApp ID="OneDrive" /^>
                                    >>"%OCS%" ECHO       ^<ExcludeApp ID="Lync" /^>
                                    >>"%OCS%" ECHO       ^<ExcludeApp ID="Groove" /^>
                                    >>"%OCS%" ECHO       ^<ExcludeApp ID="Bing" /^>
                                    >>"%OCS%" ECHO     ^</Product^>
If "%opt8%"=="%on%"                 >>"%OCS%" ECHO     ^<Product ID="VisioProRetail"^>
If "%opt8%"=="%on%"                 >>"%OCS%" ECHO       ^<Language ID="MatchOS" Fallback="en-US" /^>
If "%opt8%"=="%on%"                 >>"%OCS%" ECHO       ^<ExcludeApp ID="Bing" /^>
If "%opt8%"=="%on%"                 >>"%OCS%" ECHO     ^</Product^>
If "%opt9%"=="%on%"                 >>"%OCS%" ECHO     ^<Product ID="ProjectProRetail"^>
If "%opt9%"=="%on%"                 >>"%OCS%" ECHO       ^<Language ID="MatchOS" Fallback="en-US" /^>
If "%opt9%"=="%on%"                 >>"%OCS%" ECHO       ^<ExcludeApp ID="Bing" /^>
If "%opt9%"=="%on%"                 >>"%OCS%" ECHO     ^</Product^>
If "%optP%"=="%on%"                 >>"%OCS%" ECHO     ^<Product ID="ProofingTools"^>
If "%optP%"=="%on%"                 >>"%OCS%" ECHO       ^<Language ID="MatchOS" Fallback="en-US" /^>
If "%optP%"=="%on%"                 >>"%OCS%" ECHO       ^<ExcludeApp ID="Bing" /^>
If "%optP%"=="%on%"                 >>"%OCS%" ECHO     ^</Product^>
                                    >>"%OCS%" ECHO     ^<Product ID="LanguagePack"^>
                                    >>"%OCS%" ECHO       ^<Language ID="MatchInstalled" /^>
                                    >>"%OCS%" ECHO       ^<ExcludeApp ID="Bing" /^>
                                    >>"%OCS%" ECHO     ^</Product^>
                                    >>"%OCS%" ECHO   ^</Add^>
If "%optS%"=="%on%"                 >>"%OCS%" ECHO   ^<Updates Enabled="TRUE" /^>
If "%optS%"=="%on%"                 >>"%OCS%" ECHO   ^<Display Level="Full" AcceptEULA="TRUE" /^>
If "%optS%"=="%on%"                 >>"%OCS%" ECHO   ^<Property Name="ForceAppShutdown" Value="TRUE" /^>
If "%optS%"=="%on%"                 >>"%OCS%" ECHO   ^<AppSettings^>
If "%optS%,%opt1%"=="%on%,%on%"     >>"%OCS%" ECHO     ^<User Key="Software\Microsoft\Office\16.0\Word\Options" Name="defaultformat" Value="" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" /^>
If "%optS%,%opt2%"=="%on%,%on%"     >>"%OCS%" ECHO     ^<User Key="Software\Microsoft\Office\16.0\Excel\Options" Name="defaultformat" Value="51" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" /^>
If "%optS%,%opt3%"=="%on%,%on%"     >>"%OCS%" ECHO     ^<User Key="Software\Microsoft\Office\16.0\PowerPoint\Options" Name="defaultformat" Value="27" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" /^>
If "%optS%"=="%on%"                 >>"%OCS%" ECHO   ^</AppSettings^>
                                    >>"%OCS%" ECHO ^</Configuration^>
GoTo :EOF

:DO_DOWNLOAD
ECHO.
ECHO INFO: This can take a few minutes, depending on your Internet Speed.
ECHO.
Set "CPU=32" & CALL :CONFIG
ECHO.
ECHO Downloading Microsoft Office 365 ProPlus %CPU%-bit (Size ~3.08 GB) . . .
ping -n 3 localhost 1>NUL
START "" /WAIT /B ".\setup.exe" /download ".\Office 365 Setup Config.xml"
ECHO.
Set "CPU=64" & CALL :CONFIG
ECHO.
ECHO Downloading Microsoft Office 365 ProPlus %CPU%-bit (Size ~3.32 GB) . . .
ping -n 3 localhost 1>NUL
START "" /WAIT /B ".\setup.exe" /download ".\Office 365 Setup Config.xml"
GoTo END

:DO_INSTALL
ECHO.
If "%optB%"=="64-bit" Set "CPU=64"
If "%optB%"=="32-bit" Set "CPU=32"
CALL :CONFIG
ECHO.
ECHO Installing Microsoft Office 365 ProPlus %CPU%-bit . . .
ping -n 3 localhost 1>NUL
START "" /WAIT /B ".\setup.exe" /configure ".\Office 365 Setup Config.xml"

ECHO.
ECHO Disabling Microsoft Office 365 Telemetry . . .
ping -n 3 localhost 1>NUL
REG ADD "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "00000001" /f 1>NUL
GoTo END

:DO_DELETE
ECHO.
ECHO Deleting Microsoft Office 365 ProPlus Installation Files . . .
ping -n 3 localhost 1>NUL
RmDir /s /q ".\Office" 2>NUL
ECHO.
ECHO ---------------------------------[Finished]--------------------------------
ping -n 3 localhost 1>NUL
Set "optO=%off%"
Set "optS=%on%"
GoTo MENU

:END
ECHO.
ECHO --------------------------------[Completed]--------------------------------
ECHO.
DEL /f ".\Office 365 Setup Config.xml" 2>NUL
PAUSE
EXIT /b 0
