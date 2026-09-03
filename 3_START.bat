@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Running (Keep Open)
color 0A
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs"         mkdir "%R%logs"         2>nul
if not exist "%R%model"        mkdir "%R%model"        2>nul
if not exist "%R%engine"       mkdir "%R%engine"       2>nul
if not exist "%R%frontend"     mkdir "%R%frontend"     2>nul
if not exist "%R%chat_history" mkdir "%R%chat_history" 2>nul
set "LOG=%R%logs\nova_start.txt"
echo NOVA AI Start: %DATE% %TIME% > "%LOG%"
echo Root: %R% >> "%LOG%"
echo.
echo  ============================================================
echo   NOVA AI - Offline AI Office Assistant (Qwen2.5-7B)
echo   Log: logs\nova_start.txt
echo  ============================================================
echo.
echo  [1/5] Checking engine...
if not exist "%R%engine\llama-server.exe" goto :NOENG
"%R%engine\llama-server.exe" --version >> "%LOG%" 2>&1
if errorlevel 1 goto :BADCPU
echo  Engine OK
echo Engine OK >> "%LOG%"
echo.
echo  [DLL Check]
for %%D in (MSVCP140.dll VCRUNTIME140.dll VCRUNTIME140_1.dll MSVCP140_CODECVT_IDS.dll VCOMP140.dll) do (
    if not exist "%R%engine\%%D" (
        if exist "%SystemRoot%\System32\%%D" (
            copy "%SystemRoot%\System32\%%D" "%R%engine\%%D" >nul 2>&1
            echo  Copied %%D
        )
    )
)
echo  DLL check done.
echo.
echo  [2/5] Finding Qwen2.5-7B model...
set "MF=" & set "MN="
REM Search specifically for Qwen model, prefer Q4_K_M quantization
for %%F in ("%R%model\*.gguf") do (
    set "FN=%%~nxF"
    echo !FN! | findstr /i "qwen" >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo !FN! | findstr /i "Q4_K_M" >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            set "MF=%%~fF" & set "MN=%%~nxF"
        ) else (
            if not defined MF set "MF=%%~fF" & set "MN=%%~nxF"
        )
    )
)
if not defined MF goto :NOMDL
echo  Model: !MN!
echo Model: !MF! >> "%LOG%"
echo.
echo  [3/5] CPU threads...
set "T=4"
for /f "skip=1 tokens=1" %%X in ('wmic cpu get NumberOfLogicalProcessors 2^>nul') do (
    set "V=%%X" & set "V=!V: =!"
    if not "!V!"=="" if not "!V!"=="NumberOfLogicalProcessors" if not "!V!"=="0" (
        set "T=!V!" & goto :TDONE
    )
)
:TDONE
echo  Threads: !T!
echo Threads: !T! >> "%LOG%"
echo.
echo  [4/5] Starting server on port 8080...
echo [4] Starting server >> "%LOG%"
taskkill /F /FI "WINDOWTITLE eq NOVA-Engine*" >nul 2>&1
for /f "tokens=5" %%P in ('netstat -aon 2^>nul ^| findstr ":8080 "') do (
    if not "%%P"=="0" if not "%%P"=="" taskkill /F /PID %%P >nul 2>&1
)
timeout /t 2 /nobreak >nul
set "CTX=4096"
set "BATCH=512"
start "NOVA-Engine" /MIN "%R%engine\llama-server.exe" --model "!MF!" --host 127.0.0.1 --port 8080 --ctx-size !CTX! --threads !T! --batch-size !BATCH! --path "%R%frontend" --log-disable
echo  Server launched. Waiting for model to load into RAM...
echo  (Qwen2.5-7B typically takes 60-90 seconds)
echo Server launched >> "%LOG%"
set "N=0" & set "UP=0"
:WAIT
timeout /t 3 /nobreak >nul
set /a N+=1
tasklist 2>nul | findstr /i "llama-server" >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    color 0C
    echo.
    echo  ERROR: llama-server.exe crashed during model loading.
    echo.
    echo  Likely causes:
    echo    1. Not enough free RAM - Qwen2.5-7B needs ~5GB free
    echo    2. Model file is corrupt - re-download it
    echo    3. Missing DLLs - run 5_FIX.bat
    echo.
    echo  Close other programs to free RAM, then run 3_START.bat again.
    echo.
    echo SERVER_CRASHED >> "%LOG%"
    goto :DONE
)
curl -s --max-time 2 http://127.0.0.1:8080/health >nul 2>&1
if !ERRORLEVEL! EQU 0 (set "UP=1" & goto :WAIT_DONE)
echo  Waiting... check !N!/40
if !N! GEQ 40 goto :WAIT_DONE
goto :WAIT
:WAIT_DONE
if "!UP!"=="1" (
    echo.
    echo  Server READY. Model loaded successfully.
    echo Server ready >> "%LOG%"
) else (
    echo.
    echo  Server did not respond in 120 seconds.
    echo  Check RAM - close other programs and retry.
    echo Server timeout >> "%LOG%"
)
echo.
echo  [5/5] Opening browser...
if not exist "%R%frontend\index.html" (
    color 0C
    echo  ERROR: frontend\index.html missing.
    goto :DONE
)
start "" http://127.0.0.1:8080
echo  Browser opened: http://127.0.0.1:8080
echo Browser opened >> "%LOG%"
echo.
title NOVA AI - Running (Keep Open)
color 0A
echo  ============================================================
echo   NOVA AI IS RUNNING
echo  ============================================================
echo.
echo   Model  : !MN!
echo   URL    : http://127.0.0.1:8080
echo   Log    : %R%logs\nova_start.txt
echo.
echo   GREEN dot = ready     RED dot = still loading (60-90s)
echo.
echo   KEEP THIS WINDOW OPEN while using NOVA AI.
echo   To stop: run 4_STOP.bat
echo  ============================================================
echo RUNNING >> "%LOG%"
set "FL=0"
:MONITOR
timeout /t 30 /nobreak >nul
curl -s --max-time 5 http://127.0.0.1:8080/health >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    set /a FL+=1
    echo  [%TIME%] Health check !FL!/5 failed
    if !FL! GEQ 5 (
        echo  Auto-restarting server...
        taskkill /F /FI "WINDOWTITLE eq NOVA-Engine*" >nul 2>&1
        timeout /t 2 /nobreak >nul
        start "NOVA-Engine" /MIN "%R%engine\llama-server.exe" --model "!MF!" --host 127.0.0.1 --port 8080 --ctx-size !CTX! --threads !T! --batch-size !BATCH! --path "%R%frontend" --log-disable
        set "FL=0" & color 0A & echo  Restarted.
        echo Restarted >> "%LOG%"
    )
) else (
    if !FL! GTR 0 (echo  [%TIME%] Back online. & set "FL=0")
)
goto :MONITOR
:NOENG
color 0C
echo.
echo  FAIL: llama-server.exe NOT in engine\
echo  1. https://github.com/ggml-org/llama.cpp/releases/latest
echo  2. Download: llama-[version]-bin-win-avx2-x64.zip
echo  3. Extract ALL files into: %R%engine\
echo FAIL: no engine >> "%LOG%"
goto :DONE
:BADCPU
color 0C
echo.
echo  FAIL: llama-server.exe crashes on this CPU.
echo  Try: llama-[version]-bin-win-avx-x64.zip
echo FAIL: CPU >> "%LOG%"
goto :DONE
:NOMDL
color 0C
echo.
echo  FAIL: No Qwen2.5-7B .gguf model found in model\ folder.
echo.
echo  Download Qwen2.5-7B-Instruct-Q4_K_M.gguf (4.7GB):
echo  https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF
echo  /resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf
echo.
echo  Copy downloaded .gguf into: %R%model\
echo FAIL: no model >> "%LOG%"
goto :DONE
:DONE
echo.
echo  ============================================================
echo   Run 5_FIX.bat to auto-repair common issues.
echo   Log: %R%logs\nova_start.txt
echo  ============================================================
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
