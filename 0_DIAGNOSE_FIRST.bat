@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Diagnose First
color 0B
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs" mkdir "%R%logs" 2>nul
set "LOG=%R%logs\nova_diag.txt"
echo NOVA AI Diagnostic > "%LOG%"
echo Date: %DATE% Time: %TIME% >> "%LOG%"
echo Root: %R% >> "%LOG%"
echo.
echo  ============================================================
echo   NOVA AI - Step 0: Diagnose (Qwen2.5-7B)
echo   Results saved to logs\nova_diag.txt
echo  ============================================================
echo.
echo  [1] Windows
ver
ver >> "%LOG%"
echo.
echo  [2] Engine
if exist "%R%engine\llama-server.exe" (
    echo  PASS: llama-server.exe found
    echo PASS: llama-server.exe >> "%LOG%"
    "%R%engine\llama-server.exe" --version
    "%R%engine\llama-server.exe" --version >> "%LOG%" 2>&1
    if not errorlevel 1 (echo  PASS: CPU compatible & echo PASS: CPU >> "%LOG%") else (echo  FAIL: CPU incompatible - try avx version & echo FAIL: CPU >> "%LOG%")
) else (
    echo  FAIL: llama-server.exe NOT in engine\
    echo FAIL: no llama-server >> "%LOG%"
    dir "%R%engine\" /b 2>nul
    dir "%R%engine\" /b >> "%LOG%" 2>&1
)
echo.
echo  [3] Qwen2.5-7B Model
set "MFOUND=0"
for %%F in ("%R%model\*.gguf") do (
    set "FN=%%~nxF"
    echo !FN! | findstr /i "qwen" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (echo  PASS: %%~nxF & echo PASS model: %%~nxF >> "%LOG%" & set "MFOUND=1")
)
if "!MFOUND!"=="0" (echo  FAIL: No Qwen model in model\ folder & echo FAIL: no model >> "%LOG%")
echo.
echo  [4] Port 8080
netstat -aon 2>nul | findstr ":8080 " >nul
if not errorlevel 1 (echo  WARN: Port 8080 in use & echo WARN: port in use >> "%LOG%") else (echo  PASS: Port 8080 free & echo PASS: port free >> "%LOG%")
echo.
echo  [5] Frontend
if exist "%R%frontend\index.html" (echo  PASS: index.html found & echo PASS: index.html >> "%LOG%") else (echo  FAIL: index.html missing & echo FAIL: no index.html >> "%LOG%")
if exist "%R%frontend\chart-studio.html" (echo  PASS: chart-studio.html found & echo PASS: chart-studio.html >> "%LOG%") else (echo  WARN: chart-studio.html missing & echo WARN: no chart-studio >> "%LOG%")
echo.
echo  [6] curl
where curl >nul 2>&1
if not errorlevel 1 (echo  PASS: curl found & echo PASS: curl >> "%LOG%") else (echo  WARN: curl not found & echo WARN: no curl >> "%LOG%")
echo.
echo Diagnostic complete: %DATE% %TIME% >> "%LOG%"
echo  ============================================================
echo   Complete. Opening log in Notepad...
echo  ============================================================
timeout /t 2 /nobreak >nul
notepad "%LOG%"
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
