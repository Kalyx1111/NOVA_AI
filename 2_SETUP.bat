@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Setup Guide
color 0B
set "R=%~dp0"
cd /d "%R%"
echo.
echo  ============================================================
echo   NOVA AI - Setup Guide (Qwen2.5-7B)
echo  ============================================================
echo.
echo  STEP A: Get llama-server.exe
echo  1. https://github.com/ggml-org/llama.cpp/releases/latest
echo  2. Download: llama-[version]-bin-win-avx2-x64.zip
echo  3. Extract ALL files into: %R%engine\
echo  4. Run 1_CHECK.bat to verify CPU compatibility
echo     (If fail: try avx version instead of avx2)
echo.
echo  STEP B: Get Qwen2.5-7B Model
echo  Qwen2.5-7B-Instruct-Q4_K_M.gguf (4.7GB, for 8-16GB RAM):
echo  https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF
echo  /resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf
echo.
echo  Copy the .gguf file into: %R%model\
echo.
echo  CURRENT STATUS:
if exist "%R%engine\llama-server.exe" (echo  Engine: FOUND) else (echo  Engine: MISSING)
set "MC=0"
for %%F in ("%R%model\*.gguf") do (
    set "FN=%%~nxF"
    echo !FN! | findstr /i "qwen" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (echo  Model: %%~nxF FOUND & set /a MC+=1)
)
if "!MC!"=="0" echo  Model: MISSING - download Qwen2.5-7B from link above
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
