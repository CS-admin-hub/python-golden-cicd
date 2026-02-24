# How to Test - Step by Step

##  Your Repository is Live!

**URL:** https://github.com/NinadD26/golden-cicd-python

**CI/CD Status:**  ALL TESTS PASSED

---

##  3 Ways to Test (Choose One)

###  METHOD 1: Automated Test Script (Easiest)

Just double-click or run:

**Windows:**
```bash
test-local.bat
```

**Linux/Mac:**
```bash
chmod +x test-local.sh
./test-local.sh
```

This will automatically:
1. Build Docker image
2. Start container
3. Test both endpoints
4. Show you the results
5. Keep running until you press Enter

---

###  METHOD 2: Manual Docker Testing

```bash
# Step 1: Build the image
docker build -t golden-cicd-python .

# Step 2: Run the container
docker run -d --name my-test-app -p 8000:8000 -e APP_ENV=local golden-cicd-python

# Step 3: Wait a few seconds
# (Windows: timeout /t 5)
# (Linux/Mac: sleep 5)

# Step 4: Test the endpoints
curl http://localhost:8000/
curl http://localhost:8000/health

# Step 5: Open in browser
# Go to: http://localhost:8000
# Go to: http://localhost:8000/docs (Interactive API docs!)

# Step 6: View logs
docker logs my-test-app

# Step 7: Stop when done
docker stop my-test-app
docker rm my-test-app
```

---

###  METHOD 3: Just View on GitHub (No Local Setup)

The tests already ran successfully on GitHub!

1. **View Pipeline Results:**
   https://github.com/NinadD26/golden-cicd-python/actions/runs/22211412895

2. **See What Passed:**
   -  Python tests (pytest)
   -  Docker build
   -  Container health check
   -  API endpoint verification

3. **Download Docker Image:**
   - Go to the Actions run above
   - Scroll to "Artifacts" section
   - Download "docker-image" (61.8 MB)
   - Extract and run:
   ```bash
   gunzip docker-image.tar.gz
   docker load < docker-image.tar
   docker run -d -p 8000:8000 golden-cicd-python:latest
   ```

---

##  What You Should See

### When Testing Root Endpoint (/)
```json
{
  "message": "Welcome to Golden CI/CD API",
  "environment": "local"
}
```

### When Testing Health Endpoint (/health)
```json
{
  "status": "OK",
  "environment": "local"
}
```

### In Browser (http://localhost:8000/docs)
You'll see an interactive API documentation page (Swagger UI) where you can:
- See all available endpoints
- Test them directly in the browser
- View request/response schemas

---

##  Troubleshooting

### Docker Not Installed?
Download from: https://www.docker.com/products/docker-desktop

### Port 8000 Already in Use?
```bash
# Windows - Find what's using port 8000
netstat -ano | findstr :8000

# Kill the process (replace PID with actual number)
taskkill /PID <PID> /F

# Or use a different port
docker run -d -p 8080:8000 golden-cicd-python
# Then test: http://localhost:8080
```

### Container Won't Start?
```bash
# Check logs
docker logs my-test-app

# Remove old containers
docker rm -f $(docker ps -aq)

# Try again
docker run -d --name my-test-app -p 8000:8000 golden-cicd-python
```

### Curl Not Found?
**Windows:** Use PowerShell instead:
```powershell
Invoke-WebRequest http://localhost:8000/ | Select-Object -Expand Content
Invoke-WebRequest http://localhost:8000/health | Select-Object -Expand Content
```

**Or just open in browser:**
- http://localhost:8000/
- http://localhost:8000/health

---

##  Success Checklist

Test is successful when you see:

- [ ] Docker image builds without errors
- [ ] Container starts and runs
- [ ] Root endpoint returns welcome message
- [ ] Health endpoint returns status OK
- [ ] Both endpoints return valid JSON
- [ ] Browser shows API documentation at /docs

---

##  Quick Test Commands

**One-liner to test everything:**

```bash
docker build -t golden-cicd-python . && docker run -d --name test -p 8000:8000 golden-cicd-python && sleep 5 && curl http://localhost:8000/health && docker stop test && docker rm test
```

**Expected output:**
```
[Docker build output...]
[Container ID]
{"status":"OK","environment":"local"}
test
test
```

If you see `{"status":"OK"...}` then everything works! 

---

##  View Full Results

Check these files for detailed information:

- **DASHBOARD.md** - Visual dashboard with all metrics
- **TEST-RESULTS.md** - Complete test results from CI/CD
- **README.md** - Full documentation
- **TESTING.md** - Comprehensive testing guide

---

##  What's Next?

After confirming tests pass locally:

1.  **Celebrate!** Everything works!

2.  **Enable AWS EC2 Deployment:**
   - Add GitHub Secrets (EC2_HOST, EC2_USER, EC2_SSH_KEY)
   - Uncomment EC2 job in `.github/workflows/ci-cd.yml`
   - Push changes
   - Watch it deploy automatically!

3.  **Customize the Application:**
   - Add more endpoints in `app/main.py`
   - Add tests in `tests/test_main.py`
   - Push to GitHub
   - CI/CD runs automatically!

4.  **Monitor in Production:**
   - Use the `/health` endpoint for monitoring
   - Set up alerts
   - Add logging

---

##  Pro Tips

1. **Use the test scripts** - They handle everything automatically
2. **Check /docs endpoint** - Interactive API testing in browser
3. **View GitHub Actions** - See tests run in real-time
4. **Download artifacts** - Pre-built Docker images ready to use
5. **Read DASHBOARD.md** - Quick overview of everything

---

##  Need Help?

1. Check **TESTING.md** for detailed troubleshooting
2. View **GitHub Actions logs** for CI/CD issues
3. Check **Docker logs** for container issues
4. Review **README.md** for architecture details

---

**Remember:** The CI/CD pipeline already tested everything successfully on GitHub. Local testing is optional but recommended to see it work on your machine!

**Status:**  READY TO TEST

---


