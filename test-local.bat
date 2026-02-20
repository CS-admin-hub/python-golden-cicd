@echo off
echo ========================================
echo   Testing golden-cicd-python Locally
echo ========================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo [1/5] Building Docker image...
docker build -t golden-cicd-python . || goto :error

echo.
echo [2/5] Starting container...
docker run -d --name golden-test -p 8000:8000 -e APP_ENV=local golden-cicd-python || goto :error

echo.
echo [3/5] Waiting for application to start...
timeout /t 5 /nobreak >nul

echo.
echo [4/5] Testing endpoints...
echo.

echo Testing root endpoint (/)...
curl -s http://localhost:8000/ || goto :error
echo.
echo.

echo Testing health endpoint (/health)...
curl -s http://localhost:8000/health || goto :error
echo.
echo.

echo [5/5] Viewing container logs...
docker logs golden-test
echo.

echo ========================================
echo   ALL TESTS PASSED!
echo ========================================
echo.
echo Application is running at: http://localhost:8000
echo API Documentation: http://localhost:8000/docs
echo.
echo Press any key to stop the container...
pause >nul

:cleanup
echo.
echo Stopping and removing container...
docker stop golden-test >nul 2>&1
docker rm golden-test >nul 2>&1
echo Done!
exit /b 0

:error
echo.
echo ========================================
echo   ERROR: Test failed!
echo ========================================
echo.
goto :cleanup
