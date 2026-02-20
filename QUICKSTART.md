# ⚡ Quick Start Guide

## 📋 What You Have

A production-ready FastAPI application with:
- ✅ FastAPI with health endpoint
- ✅ Pytest test suite
- ✅ Docker containerization
- ✅ GitHub Actions CI/CD pipeline
- ✅ EC2 deployment ready (commented)
- ✅ Clean project structure

## 🚀 Push to GitHub (3 Steps)

### Step 1: Create Repository on GitHub
Visit: https://github.com/new
- Name: `golden-cicd-python`
- Public repository
- Don't initialize with anything

### Step 2: Push Your Code
```bash
git remote add origin https://github.com/YOUR_USERNAME/golden-cicd-python.git
git push -u origin main
```

### Step 3: Watch Pipeline Run
Go to: `https://github.com/YOUR_USERNAME/golden-cicd-python/actions`

## 🧪 Test Locally First

```bash
# Install and test
pip install -r requirements.txt
pytest tests/ -v

# Run app
uvicorn app.main:app --reload

# Test endpoints (in another terminal)
curl http://localhost:8000/
curl http://localhost:8000/health
```

## 🐳 Test with Docker

```bash
# Build and run
docker build -t golden-cicd-python .
docker run -d --name test-app -p 8000:8000 golden-cicd-python

# Test
curl http://localhost:8000/health

# Cleanup
docker stop test-app && docker rm test-app
```

## 📊 CI/CD Pipeline Flow

```
Push to main → Tests → Build Docker → Run Container → Verify Health → Save Image
```

If tests fail, pipeline stops immediately.

## ☁️ Enable AWS EC2 Later

When ready:
1. Add GitHub Secrets: `EC2_HOST`, `EC2_USER`, `EC2_SSH_KEY`
2. Uncomment EC2 job in `.github/workflows/ci-cd.yml`
3. Push changes

See README.md for detailed AWS setup.

## 📁 Project Structure

```
golden-cicd-python/
├── app/main.py              # FastAPI app
├── tests/test_main.py       # Tests
├── Dockerfile               # Container config
├── .github/workflows/       # CI/CD pipeline
├── scripts/deploy.sh        # Deployment script
└── requirements.txt         # Dependencies
```

## 🔧 Key Files

- `app/main.py` - Main application with / and /health endpoints
- `tests/test_main.py` - Test suite (must pass for CI to succeed)
- `.github/workflows/ci-cd.yml` - CI/CD pipeline configuration
- `scripts/deploy.sh` - Idempotent deployment script
- `Dockerfile` - Optimized Python 3.11 slim image

## 🎯 Environment Variables

- `APP_ENV` - Environment name (default: local)
- `PORT` - Application port (default: 8000)

## ✅ Success Criteria

Your pipeline passes when:
- ✅ All pytest tests pass
- ✅ Docker image builds successfully
- ✅ Container starts and runs
- ✅ Health endpoint returns 200 OK
- ✅ Docker image saved as artifact

## 🆘 Troubleshooting

**Tests fail locally?**
```bash
pytest tests/ -v --tb=short
```

**Docker build fails?**
```bash
docker build -t golden-cicd-python . --no-cache
```

**Pipeline fails on GitHub?**
Check the Actions tab for detailed logs.

---

Need help? Check README.md for comprehensive documentation.
