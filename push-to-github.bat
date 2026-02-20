@echo off
REM After creating the repository on GitHub, run this script
REM Replace YOUR_USERNAME with your actual GitHub username

set /p USERNAME="Enter your GitHub username: "

echo Setting up remote...
git remote add origin https://github.com/%USERNAME%/golden-cicd-python.git

echo Pushing to GitHub...
git push -u origin main

echo.
echo Done! Check your repository at:
echo https://github.com/%USERNAME%/golden-cicd-python
echo.
echo View the CI/CD pipeline at:
echo https://github.com/%USERNAME%/golden-cicd-python/actions

pause
