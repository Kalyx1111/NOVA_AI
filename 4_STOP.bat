@echo off
setlocal EnableDelayedExpansion
title NOVA AI - Stop
color 0E
set "R=%~dp0"
echo.
echo  ============================================================
echo   NOVA AI - Stop
echo  ============================================================
echo.
taskkill /F /FI "WINDOWTITLE eq NOVA-Engine*" >nul 2>&1
for /f "tokens=5" %%P in ('netstat -aon 2^>nul ^| findstr ":8080 "') do (
    if not "%%P"=="0" if not "%%P"=="" taskkill /F /PID %%P >nul 2>&1
)
echo  Server stopped.
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
