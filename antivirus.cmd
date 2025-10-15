@echo off
set DIRECTORY="%ProgramFiles%\83t460"
set DATADIR=%LOCALAPPDATA%\INT\83t460
set CONFIGURATION=%DATADIR%\config.json
set FILE=%1
set LOG="%DATADIR%\antivir.log"
set DEBUG=1

if exist "%ProgramFiles%\DrWeb\dwscanner.exe" ( set SCANNER="%ProgramFiles%\DrWeb\dwscanner.exe" ) else ( set SCANNER=notantivir )

echo start %0 %* >%LOG%
call :scan %FILE%

if "%RESULT%" == "0" (
    echo no
    echo Ok! >>%LOG%
    echo %DATE% %TIME% end %0 %* >>%LOG%
    exit /b %RESULT%
)

echo yes
echo %DATE% %TIME% end %0 %* >>%LOG%
exit /b %RESULT%


:scan %FILE%
    set RESULT=
    echo. >>%LOG%
    echo.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ >>%LOG%
    echo.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ >>%LOG%
    echo.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ >>%LOG%
    echo.%DATE% %TIME% start %0 %* >>%LOG%
    %SCANNER% /aa- /ac+ /ar+ /dr- /go /ha+ /ln+ /ma+ /ok- /qna+ /quit /rep+ /sls+ /sps+ /aad:r /aar:r /acn:r /adl:r /aht:r /aic:r /ain:r /ajk:r /aml:r /arw:r /asu:r /rp:%LOG% /ra:%LOG% %1
    echo %ERRORLEVEL% >>%LOG%
    for /f "tokens=2 delims= " %%i in ('type %LOG%^|find /i "Total"^|find /i "infected"') do if not "%%i" == "" set RESULT=%%i else set RESULT=0
    echo.%RESULT%
    if not "%RESULT%" == "0" echo Alarm! Found virus in %1 >>%LOG%
    exit /b %RESULT%
