# 🚀 Golden CI/CD Python

Production-ready FastAPI application with automated CI/CD pipeline, Docker containerization, and future AWS EC2 deployment support.

## 📋 Architecture

```
golden-cicd-python/
├── app/
│   ├── __init__.py
│   └── main.py              # FastAPI application
├── tests/
│   ├── __init__.py
│   └── test_main.py         # Pytest test suite
├── scripts/
│   └── deploy.sh            # Deployment script (local + EC2 ready)
├── .github/
│   └── workflows/
│       └── ci-cd.yml        # GitHub Actions pipeline
├── Dockerfile               # Multi-stage Docker build
├── requirements.txt         # Python dependencies
├── .env.example            # Environment variables template
└── README.md
```

## 🔄 CI/CD Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         PUSH TO MAIN                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 1: Checkout Code                                          │
│  ✓ Clone repository                                             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 2: Setup Python 3.11                                      │
│  ✓ Install Python environment                                   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 3: Install Dependencies                                   │
│  ✓ pip install -r requirements.txt                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 4: Run Tests (pytest)                                     │
│  ✓ Test / endpoint (200 OK)                                     │
│  ✓ Test /health endpoint (status: OK)                           │
│  ❌ FAIL → Pipeline stops here                                  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 5: Build Docker Image                                     │
│  ✓ docker build -t golden-cicd-python:latest .                  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 6: Run Container & Verify                                 │
│  ✓ docker run -d -p 8000:8000 golden-cicd-python                │
│  ✓ curl http://localhost:8000/health                            │
│  ✓ Stop container after validation                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  STEP 7: Save Docker Image (Simulated Deployment)               │
│  ✓ docker save | gzip > golden-cicd-python.tar.gz               │
│  ✓ Upload as GitHub artifact                                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  ✅ PIPELINE COMPLETE                                           │
│  Ready for EC2 deployment when configured                       │
└─────────────────────────────────────────────────────────────────┘
```

## 🏃 Run Locally

### Prerequisites
- Python 3.11+
- pip

### Steps

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/golden-cicd-python.git
cd golden-cicd-python
```

2. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set environment variables:
```bash
cp .env.example .env
export APP_ENV=local  # On Windows: set APP_ENV=local
```

5. Run the application:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

6. Test endpoints:
```bash
curl http://localhost:8000/
curl http://localhost:8000/health
```

7. Run tests:
```bash
pytest tests/ -v
```

## 🐳 Run with Docker

### Build and run:
```bash
docker build -t golden-cicd-python .
docker run -d --name golden-app -p 8000:8000 -e APP_ENV=local golden-cicd-python
```

### Verify:
```bash
curl http://localhost:8000/health
```

### Stop:
```bash
docker stop golden-app
docker rm golden-app
```

### Using deployment script:
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

## ☁️ Enable EC2 Deployment (Future)

Currently, the pipeline validates Docker containers locally. To enable AWS EC2 deployment:

### 1. Prepare EC2 Instance

```bash
# SSH into your EC2 instance
ssh -i your-key.pem ec2-user@your-ec2-ip

# Install Docker
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
```

### 2. Add GitHub Secrets

Go to: `Settings → Secrets and variables → Actions → New repository secret`

Add these secrets:
- `EC2_HOST`: Your EC2 public IP or hostname
- `EC2_USER`: SSH username (usually `ec2-user` or `ubuntu`)
- `EC2_SSH_KEY`: Private SSH key content (entire .pem file)

### 3. Enable EC2 Deployment Job

In `.github/workflows/ci-cd.yml`, uncomment the `deploy-to-ec2` job (lines marked with comments).

### 4. Update Security Group

Ensure your EC2 security group allows:
- Port 22 (SSH) from GitHub Actions IPs
- Port 8000 (Application) from your desired sources

### 5. Test Deployment

```bash
git add .
git commit -m "Enable EC2 deployment"
git push origin main
```

The pipeline will now:
1. Run tests
2. Build Docker image
3. Deploy to EC2
4. Verify health endpoint on EC2

## 🔐 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_ENV` | `local` | Environment name (local/ci/production) |
| `PORT` | `8000` | Application port |

## 📊 API Endpoints

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/` | GET | Root endpoint | `{"message": "...", "environment": "..."}` |
| `/health` | GET | Health check | `{"status": "OK", "environment": "..."}` |

## 🧪 Testing

```bash
# Run all tests
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=app --cov-report=html
```

## 📦 Docker Image Details

- Base: `python:3.11-slim`
- Size: ~150MB (optimized)
- Port: 8000
- Runtime: uvicorn with auto-reload disabled

## 🔧 Troubleshooting

### Pipeline fails at test step
```bash
# Run tests locally to debug
pytest tests/ -v
```

### Docker container won't start
```bash
# Check logs
docker logs golden-app

# Verify port availability
netstat -an | grep 8000
```

### EC2 deployment fails
```bash
# Verify SSH access
ssh -i your-key.pem ec2-user@your-ec2-ip

# Check Docker on EC2
docker ps
docker logs golden-cicd-app
```

## 📝 License

MIT

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

---

Built with ❤️ using FastAPI, Docker, and GitHub Actions
