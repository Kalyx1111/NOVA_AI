@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Full Diagnostics
color 0B
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs" mkdir "%R%logs" 2>nul
set "LOG=%R%logs\nova_fulldiag.txt"
echo FULLDIAG: %DATE% %TIME% > "%LOG%"
echo.
echo  ============================================================
echo   NOVA AI - Full Diagnostics (Qwen2.5-7B)
echo   Saves to logs\nova_fulldiag.txt
echo  ============================================================
echo.
set "P=0" & set "F=0"
echo  [1] Folders
for %%D in (engine model frontend logs chat_history) do (
    if exist "%R%%%D\" (echo    PASS %%D\ & set /a P+=1) else (echo    FAIL %%D\ & set /a F+=1)
)
echo.
echo  [2] BAT files
for %%B in (0_DIAGNOSE_FIRST.bat 1_CHECK.bat 2_SETUP.bat 3_START.bat 4_STOP.bat 5_FIX.bat 6_DIAGNOSE.bat) do (
    if exist "%R%%%B" (echo    PASS %%B & set /a P+=1) else (echo    FAIL %%B & set /a F+=1)
)
echo.
echo  [3] Frontend
if exist "%R%frontend\index.html" (echo    PASS index.html & set /a P+=1) else (echo    FAIL index.html missing & set /a F+=1)
if exist "%R%frontend\chart-studio.html" (echo    PASS chart-studio.html & set /a P+=1) else (echo    WARN chart-studio.html missing)
echo.
echo  [4] Engine
if exist "%R%engine\llama-server.exe" (
    echo    PASS llama-server.exe
    set /a P+=1
    "%R%engine\llama-server.exe" --version >> "%LOG%" 2>&1
    if not errorlevel 1 (echo    PASS CPU compatible & set /a P+=1) else (echo    FAIL CPU incompatible & set /a F+=1)
) else (echo    FAIL llama-server.exe missing & set /a F+=1)
echo.
echo  [5] Qwen2.5-7B Model
set "MFOUND=0"
for %%F in ("%R%model\*.gguf") do (
    set "FN=%%~nxF"
    echo !FN! | findstr /i "qwen" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (echo    PASS %%~nxF & set /a P+=1 & set "MFOUND=1")
)
if "!MFOUND!"=="0" (echo    FAIL No Qwen model found & set /a F+=1)
echo.
echo  [6] Server status
curl -s --max-time 4 http://127.0.0.1:8080/health >nul 2>&1
if not errorlevel 1 (
    echo    PASS Server on port 8080
    for /f "tokens=*" %%R2 in ('curl -s --max-time 4 http://127.0.0.1:8080/health 2^>nul') do echo    INFO %%R2
    set /a P+=1
) else echo    INFO Server not running - start with 3_START.bat
echo.
echo PASS=!P! FAIL=!F! >> "%LOG%"
echo  ============================================================
echo   PASS=!P!   FAIL=!F!
echo  ============================================================
echo.
if !F! EQU 0 (color 0A & echo   All good. Run 3_START.bat.) else (color 0C & echo   !F! failure(s). Run 5_FIX.bat.)
echo.
set /p VL=   Open log? (Y/N): 
if /i "!VL!"=="Y" notepad "%LOG%"
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
