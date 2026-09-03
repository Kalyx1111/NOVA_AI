@echo off
setlocal EnableDelayedExpansion
title NOVA AI - System Check
color 0B
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs" mkdir "%R%logs" 2>nul
echo.
echo  ============================================================
echo   NOVA AI - System Check (Qwen2.5-7B)
echo  ============================================================
echo.
set "P=0" & set "F=0"
echo  [Folders]
for %%D in (engine model frontend logs chat_history) do (
    if exist "%R%%%D\" (echo    PASS %%D\ & set /a P+=1) else (mkdir "%R%%%D" 2>nul & echo    FIXED %%D\)
)
echo.
echo  [Engine - llama-server.exe]
if exist "%R%engine\llama-server.exe" (
    echo    PASS llama-server.exe found
    set /a P+=1
    "%R%engine\llama-server.exe" --version >nul 2>&1
    if not errorlevel 1 (echo    PASS CPU compatible & set /a P+=1) else (echo    FAIL CPU incompatible - try avx version & set /a F+=1)
) else (
    echo    FAIL llama-server.exe NOT found
    echo    Get: https://github.com/ggml-org/llama.cpp/releases/latest
    echo    Download: llama-[version]-bin-win-avx2-x64.zip
    echo    Extract ALL files into: %R%engine\
    set /a F+=1
)
echo.
echo  [Qwen2.5-7B Model]
set "MFOUND=0"
for %%F in ("%R%model\*.gguf") do (
    set "FN=%%~nxF"
    echo !FN! | findstr /i "qwen" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (echo    PASS %%~nxF & set /a P+=1 & set "MFOUND=1")
)
if "!MFOUND!"=="0" (
    echo    FAIL No Qwen2.5-7B .gguf in model\ folder
    echo    Get Qwen2.5-7B-Instruct-Q4_K_M.gguf:
    echo    https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF
    echo    /resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf
    set /a F+=1
)
echo.
echo  [Frontend]
if exist "%R%frontend\index.html" (echo    PASS index.html found & set /a P+=1) else (echo    FAIL index.html missing & set /a F+=1)
if exist "%R%frontend\chart-studio.html" (echo    PASS chart-studio.html found & set /a P+=1) else (echo    WARN chart-studio.html missing - Chart Studio button will not work)
echo.
echo  ============================================================
echo   PASS=!P!   FAIL=!F!
echo  ============================================================
echo.
if !F! EQU 0 (color 0A & echo   All good. Run 3_START.bat to launch.) else (color 0C & echo   !F! issue(s). Fix above then run 1_CHECK.bat again.)
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
