@echo off
setlocal EnableExtensions

title Qwen2.5-7B-Instruct-Q4_K_M Downloader

echo.
echo ============================================================
echo       QWEN 2.5 7B INSTRUCT Q4_K_M DOWNLOADER
echo ============================================================
echo.

REM ============================================================
REM IMPORTANT:
REM %~dp0 = THE FOLDER WHERE THIS BAT FILE IS LOCATED
REM No username, drive or fixed path is required.
REM ============================================================

cd /d "%~dp0"

set "MODEL_NAME=Qwen2.5-7B-Instruct-Q4_K_M.gguf"

set "MODEL_URL=https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF/resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf?download=true"

echo Download location:
echo %~dp0
echo.
echo Model:
echo %MODEL_NAME%
echo.
echo Size:
echo Approximately 4.68 GB
echo.
echo Source:
echo Hugging Face - bartowski
echo.
echo ============================================================
echo.

REM ============================================================
REM CHECK FOR CURL
REM ============================================================

where curl >nul 2>&1

if errorlevel 1 (
    echo.
    echo [ERROR] CURL was not found on this computer.
    echo.
    echo Windows 10 and Windows 11 normally include CURL.
    echo.
    pause
    exit /b 1
)

REM ============================================================
REM CHECK IF MODEL ALREADY EXISTS
REM ============================================================

if exist "%MODEL_NAME%" (
    echo.
    echo [INFO] Model already exists in this folder:
    echo.
    echo %~dp0%MODEL_NAME%
    echo.
    echo The download will not be started again.
    echo.
    echo ============================================================
    echo.
    pause
    exit /b 0
)

REM ============================================================
REM START DOWNLOAD
REM ============================================================

echo.
echo ============================================================
echo                  STARTING DOWNLOAD
echo ============================================================
echo.
echo ONE single GGUF file will be downloaded.
echo.
echo No second Qwen file is required.
echo No merging is required.
echo.
echo If the download is interrupted, run this BAT again.
echo CURL will attempt to resume the partial download.
echo.
echo Please keep this window open during the download.
echo.
echo ============================================================
echo.

curl -L -C - --fail --progress-bar ^
-o "%MODEL_NAME%" ^
"%MODEL_URL%"

REM ============================================================
REM CHECK DOWNLOAD RESULT
REM ============================================================

if errorlevel 1 (
    echo.
    echo ============================================================
    echo          DOWNLOAD FAILED OR WAS INTERRUPTED
    echo ============================================================
    echo.
    echo The partial file has been kept.
    echo.
    echo Location:
    echo %~dp0%MODEL_NAME%
    echo.
    echo Double-click this BAT again to retry/resume.
    echo.
    pause
    exit /b 1
)

REM ============================================================
REM SUCCESS
REM ============================================================

echo.
echo ============================================================
echo             DOWNLOAD COMPLETED SUCCESSFULLY
echo ============================================================
echo.
echo Model:
echo %MODEL_NAME%
echo.
echo Saved in the SAME FOLDER as this BAT file:
echo.
echo %~dp0
echo.
echo Full file path:
echo %~dp0%MODEL_NAME%
echo.
echo ============================================================
echo.
echo Qwen2.5-7B-Instruct-Q4_K_M.gguf is ready.
echo.
echo ============================================================
echo.

pause
exit /b 0