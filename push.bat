@echo off
cd /d "%~dp0"

git add .

git diff --cached --quiet
if %errorlevel%==0 (
    echo No changes to commit.
    pause
    exit /b
)

git commit -m "Auto update %date% %time%"
git push

echo.
echo GitHub push complete!
pause