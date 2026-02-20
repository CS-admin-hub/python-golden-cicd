# 🧪 Testing Guide

## ⚠️ Fix Python First

Your Python installation has issues. Before testing, fix it:

### Option 1: Reinstall Python
1. Download Python 3.11 from: https://www.python.org/downloads/
2. During installation, check "Add Python to PATH"
3. Restart your terminal

### Option 2: Use Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Install dependencies
pip install -r requirements.txt
```

## 🧪 Test Locally (After Python is Fixed)

### Step 1: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 2: Run Tests
```bash
pytest tests/ -v
```

Expected output:
```
tests/test_main.py::test_root_endpoint PASSED
tests/test_main.py::test_health_endpoint PASSED
```

### Step 3: Run Application
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

### Step 4: Test Endpoints

Open another terminal and run:

```bash
# Test root endpoint
curl http://localhost:8000/

# Expected: {"message":"Welcome to Golden CI/CD API","environment":"local"}

# Test health endpoint
curl http://localhost:8000/health

# Expected: {"status":"OK","environment":"local"}
```

Or open in browser:
- http://localhost:8000/
- http://localhost:8000/health
- http://localhost:8000/docs (FastAPI auto-generated docs)

## 🐳 Test with Docker (Recommended - No Python Issues)

If Python is broken, use Docker instead:

### Step 1: Build Image
```bash
docker build -t golden-cicd-python .
```

### Step 2: Run Container
```bash
docker run -d --name test-app -p 8000:8000 -e APP_ENV=local golden-cicd-python
```

### Step 3: Test Endpoints
```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

### Step 4: Check Logs
```bash
docker logs test-app
```

### Step 5: Stop Container
```bash
docker stop test-app
docker rm test-app
```

## 🚀 Test on GitHub (Easiest - No Local Setup Needed)

1. Create repository on GitHub: https://github.com/new
2. Push code (see instructions below)
3. Go to Actions tab
4. Watch the pipeline run all tests automatically

The GitHub Actions runner will:
- ✅ Install Python 3.11
- ✅ Install dependencies
- ✅ Run pytest
- ✅ Build Docker image
- ✅ Run container
- ✅ Test health endpoint
- ✅ Save Docker image

## 📊 What Gets Tested

### Unit Tests (pytest)
- `/` endpoint returns 200 with correct JSON
- `/health` endpoint returns 200 with status "OK"

### Integration Tests (CI/CD)
- Docker image builds successfully
- Container starts and runs
- Health endpoint accessible from outside container
- Application responds correctly

### Environment Tests
- `APP_ENV` variable works correctly
- Default value is "local"
- Can be overridden via environment variable

## ✅ Success Criteria

All tests pass when:
- ✅ `pytest tests/ -v` shows 2 passed
- ✅ `curl http://localhost:8000/health` returns `{"status":"OK"}`
- ✅ Docker container runs without errors
- ✅ GitHub Actions pipeline shows green checkmarks

## 🐛 Troubleshooting

### Python Issues
```bash
# Check Python version
python --version  # Should be 3.11+

# Check pip
python -m pip --version

# Reinstall pip
python -m ensurepip --upgrade
```

### Port Already in Use
```bash
# Windows - Find process on port 8000
netstat -ano | findstr :8000

# Kill process (replace PID)
taskkill /PID <PID> /F
```

### Docker Issues
```bash
# Check Docker is running
docker --version

# Remove all containers
docker rm -f $(docker ps -aq)

# Clean up images
docker system prune -a
```

### Tests Fail
```bash
# Run with verbose output
pytest tests/ -v --tb=short

# Run specific test
pytest tests/test_main.py::test_health_endpoint -v
```

## 📝 Manual Testing Checklist

- [ ] Python dependencies install without errors
- [ ] Tests pass with pytest
- [ ] Application starts with uvicorn
- [ ] Root endpoint (/) returns correct JSON
- [ ] Health endpoint (/health) returns status OK
- [ ] Docker image builds successfully
- [ ] Docker container runs and responds
- [ ] Environment variable APP_ENV works
- [ ] GitHub Actions pipeline passes

## 🎯 Next Steps After Testing

Once local tests pass:
1. Push to GitHub
2. Verify CI/CD pipeline passes
3. Download Docker image artifact
4. (Optional) Deploy to EC2
