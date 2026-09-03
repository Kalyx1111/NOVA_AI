@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Fix Errors
color 0B
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs" mkdir "%R%logs" 2>nul
echo.
echo  ============================================================
echo   NOVA AI - Fix Errors
echo  ============================================================
echo.
set "FX=0"
echo  [1] Folders
for %%D in (engine model frontend logs chat_history) do (
    if not exist "%R%%%D\" mkdir "%R%%%D" 2>nul & echo    Created %%D\ & set /a FX+=1
)
echo    OK
echo.
echo  [2] Clear port 8080
taskkill /F /FI "WINDOWTITLE eq NOVA-Engine*" >nul 2>&1
set "KC=0"
for /f "tokens=5" %%P in ('netstat -aon 2^>nul ^| findstr ":8080 "') do (
    if not "%%P"=="0" if not "%%P"=="" (taskkill /F /PID %%P >nul 2>&1 & echo    Cleared PID %%P & set "KC=1" & set /a FX+=1)
)
if "!KC!"=="0" echo    Port 8080 free - OK
echo.
echo  [3] Unblock engine files
if exist "%R%engine\" (
    for %%F in ("%R%engine\*.exe" "%R%engine\*.dll") do (
        powershell -Command "Unblock-File -Path '%%~fF' -EA SilentlyContinue" >nul 2>&1
    )
    echo    Done
    set /a FX+=1
)
echo.
echo  [4] Windows Defender exclusion
powershell -Command "Add-MpPreference -ExclusionPath '%R%' -EA SilentlyContinue" >nul 2>&1
if not errorlevel 1 (echo    Exclusion added & set /a FX+=1) else (
    powershell -Command "Start-Process powershell -Arg 'Add-MpPreference -ExclusionPath ''%R%''' -Verb RunAs -Wait -WindowStyle Hidden" >nul 2>&1
    echo    Attempted via elevation
)
echo.
echo  [5] DLL check
for %%D in (MSVCP140.dll VCRUNTIME140.dll VCRUNTIME140_1.dll MSVCP140_CODECVT_IDS.dll VCOMP140.dll) do (
    if not exist "%R%engine\%%D" (
        if exist "%SystemRoot%\System32\%%D" (
            copy "%SystemRoot%\System32\%%D" "%R%engine\%%D" >nul 2>&1
            echo    Copied %%D
            set /a FX+=1
        )
    )
)
echo    Done
echo.
echo  ============================================================
echo   Fixes applied: !FX!
echo  ============================================================
echo.
set /p YN=   Start NOVA AI now? (Y/N): 
if /i "!YN!"=="Y" (endlocal & call "%R%3_START.bat") else (
    echo.
    echo  ============================================================
    echo   Press any key to close.
    echo  ============================================================
    pause >nul
    endlocal
)
