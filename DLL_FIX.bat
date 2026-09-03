@echo off
setlocal EnableDelayedExpansion
title NOVA AI - DLL Fix
color 0B
set "R=%~dp0"
cd /d "%R%"
if not exist "%R%logs" mkdir "%R%logs" 2>nul
echo.
echo  ============================================================
echo   NOVA AI - DLL Fix
echo   Fixes: MSVCP140, VCRUNTIME140, VCOMP140 missing errors
echo  ============================================================
echo.

set "FIXED=0"
set "MISSING=0"

echo  [1] Copying DLLs from Windows System32...
for %%D in (MSVCP140.dll MSVCP140_CODECVT_IDS.dll VCRUNTIME140.dll VCRUNTIME140_1.dll VCOMP140.dll) do (
    if exist "%R%engine\%%D" (
        echo    OK  %%D already in engine\
    ) else (
        if exist "%SystemRoot%\System32\%%D" (
            copy "%SystemRoot%\System32\%%D" "%R%engine\%%D" >nul 2>&1
            echo    FIXED  Copied %%D
            set /a FIXED+=1
        ) else (
            echo    MISSING  %%D not in System32
            set /a MISSING+=1
        )
    )
)
echo.

if "!MISSING!" GTR "0" (
    echo  [2] Some DLLs not in System32. Trying vc_redist...
    if exist "%R%engine\vc_redist.x64.exe" (
        echo  Installing vc_redist.x64.exe silently...
        "%R%engine\vc_redist.x64.exe" /install /quiet /norestart
        echo  Done. Run 3_START.bat now.
    ) else (
        color 0C
        echo.
        echo  ============================================================
        echo   MANUAL FIX NEEDED:
        echo.
        echo   This PC is missing Visual C++ Runtime DLLs.
        echo   Two options:
        echo.
        echo   OPTION A (easier - no internet needed):
        echo   On a working Windows PC, copy these 5 files from:
        echo   C:\Windows\System32\
        echo   into this folder: %R%engine\
        echo.
        echo     MSVCP140.dll
        echo     MSVCP140_CODECVT_IDS.dll
        echo     VCRUNTIME140.dll
        echo     VCRUNTIME140_1.dll
        echo     VCOMP140.dll
        echo.
        echo   OPTION B (needs internet on another PC):
        echo   Download vc_redist.x64.exe from:
        echo   https://aka.ms/vs/17/release/vc_redist.x64.exe
        echo   Copy into: %R%engine\
        echo   Then run this DLL_FIX.bat again.
        echo  ============================================================
        color 0A
    )
) else (
    echo  [2] All DLLs resolved. OK
)
echo.

echo  [3] Current DLL status in engine\:
for %%D in (MSVCP140.dll MSVCP140_CODECVT_IDS.dll VCRUNTIME140.dll VCRUNTIME140_1.dll VCOMP140.dll) do (
    if exist "%R%engine\%%D" (echo    PASS  %%D) else (echo    FAIL  %%D)
)
echo.

echo  ============================================================
echo   Fixed: !FIXED!   Still missing: !MISSING!
echo  ============================================================
echo.
if "!MISSING!"=="0" (
    color 0A
    echo   All DLLs OK. Run 3_START.bat to launch NOVA AI.
) else (
    color 0C
    echo   Read OPTION A or OPTION B above to fix remaining DLLs.
)
echo.
echo  ============================================================
echo   Press any key to close.
echo  ============================================================
pause >nul
endlocal
