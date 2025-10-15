:: -*- coding: cp1251 -*-
@echo off
REM start asodi client

set prgdir=%~dp0
set fname=%~n0
set prgname="%prgdir%%fname%.exe"
set PORT=""
set WEBPort=""
set CONF=""
set SERVER=""
set LOG=""
set DATADIR="%LOCALAPPDATA%\INT\83t460"
setlocal ENABLEDELAYEDEXPANSION

:: узнаем уровень пользователя 
chcp 1251 >nul 2>&1
set n=0
for /f "tokens=*" %%i in ('sysapicmd -u') do (
	set sys[!n!]=%%i
	set /a n=n+1
)
set CURRENTLEVEL=%sys[6]:~15%

IF "%CURRENTLEVEL%"=="совершенно секретно" (
    set lev=3
) ELSE (
IF "%CURRENTLEVEL%"=="секретно" (
    set lev=2
) ELSE IF "%CURRENTLEVEL:~0,3%"=="для" (
    set lev=1
) ELSE IF "%CURRENTLEVEL:~0,3%"=="дсп" (
    set lev=1
) ELSE (
IF "%CURRENTLEVEL%"=="несекретно" (
    set lev=0
) ELSE echo "ошибка"
))
chcp 866 >nul 2>&1

:: определяем параметры команды
:getopts
    if /i "%1" == "-p" set PORT=%2 & shift
    if /i "%1" == "-c" set CONF=%2 & shift
    if /i "%1" == "-l" set LOG=%2 & shift
    if /i "%1" == "-w" set WEBPort=%2 & shift
    if /i "%1" == "-s" SERVER=%2 & shift
    if /i "%1" == "-m" set MAC=%2 & shift
    if /i "%1" == "-h" goto usage
    shift
    if not "%1" == "" goto getopts

:: Определяем наличие необхоимых файлов и переменных
if not CONF == "" if exist %DATADIR%\%CONF% set CONF=%DATADIR%\%CONF%
if exist %CONF% for /f "eol=# tokens=1,2 delims==" %%x in ('type "%CONF%"') do set %%x=%%y
if not MAC == "" set WEBPort=%MAC%
if %SERVER% == "" set PORT=""
if %PORT% == "" set WEBPort=""
if %LOG% == "" set LOG=%DATADIR%\83tclient.%lev%.log
if not %LOG% == "" for /f %%l in ("%LOG%") do if %%~dpl == "." set LOG=%DATADIR%\%LOG%

pushd %prgdir%
sysapicmd.exe -s 0 %LOG% >nul 2>&1
call :chmac -s 0 %DATADIR%
for /f %%c in ('dir /b "%CONF%"') do for /f "delims=" %%f in ('2^>nul dir /s /b %DATADIR% ^| findstr /v /c:"%%~nxc"') do >>%LOG% 2>&1 rd /s /q "%%f" >>%LOG% 2>&1 & >>%LOG% 2>&1 del /q "%%f"
echo. >> %LOG%
echo. %DATE% %TIME% start %prgname% %SERVER% %PORT% %WEBPort% >> %LOG%
:: Запуск программы
%prgname% %SERVER% %PORT% %WEBPort% 2>&1 >> %LOG%
echo. %DATE% %TIME% end %prgname% %SERVER% %PORT% %WEBPort% >> %LOG%
echo. >> %LOG%
call :chmac -s 0 %DATADIR%
for /f %%c in ('dir /b "%CONF%"') do for /f "delims=" %%f in ('2^>nul dir /s /b %DATADIR% ^| findstr /v /c:"%%~nxc" /c:"antivir.log" /c:"83tclient.%lev%.log"') do >>%LOG% 2>&1 rd /s /q "%%f" >>%LOG% 2>&1 & >>%LOG% 2>&1 del /q "%%f"
popd

endlocal

exit /b ERRORLEVEL

:usage
    echo."Usage: %prgname% [-c conf_file] [-p port] [-s host] [-w web_port] [-l file_log] [-h]" >&2
    echo."if use conf_file then" >&2
    echo."file conf_file must contain:" >&2
    echo."    PORT=port" >&2
    echo."    SERVER=host" >&2
    echo."    WEBPort=web_port" >&2
    echo."    LOG=file_log" >&2
    exit /b 1

:chmac
    chcp 1251 >nul 2>&1
    sysapicmd.exe -s %1 %2 all >>%LOG% 2>&1
    sysapicmd.exe -s %1 %2 * >>%LOG% 2>&1
    sysapicmd.exe -s %1 %2 >>%LOG% 2>&1
    chcp 866 >nul 2>&1
    exit /b 
