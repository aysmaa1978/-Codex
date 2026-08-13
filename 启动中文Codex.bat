@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"

set "APP=E:\Downloads\Codex-Windows-x64"

if not exist "%APP%\app\resources\app.asar" (
  echo [ERROR] app.asar not found: %APP%\app\resources\app.asar
  pause
  exit /b 1
)

where python >nul 2>nul
if %errorlevel%==0 (
  set "PY=python"
) else (
  set "PY=py"
)

echo [1/2] Applying zh-CN patch to app.asar ...
"%PY%" "%~dp0codex_zhcn_patcher.py" --app "%APP%"
if errorlevel 1 (
  echo.
  echo [FAILED] Patch did not complete. Please send the error above to Codex.
  pause
  exit /b 1
)

echo [2/2] Starting Codex zh-CN ...
echo.
echo NOTE: If the official Codex is still running, close it first,
echo       otherwise both instances may conflict on the same data files.
timeout /t 3 /nobreak >nul
if not exist "%APP%\userData" mkdir "%APP%\userData"
set "CODEX_ELECTRON_USER_DATA_PATH=%APP%\userData"
start "" "%APP%\app\ChatGPT.exe" --lang=zh-CN

echo.
echo Done. If the official Codex is still running, close it first,
echo otherwise both instances may conflict on the same data files.
endlocal
