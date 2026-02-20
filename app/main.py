import os
from fastapi import FastAPI

app = FastAPI(title="Golden CI/CD Python API")

APP_ENV = os.getenv("APP_ENV", "local")


@app.get("/")
async def root():
    return {"message": "Welcome to Golden CI/CD API", "environment": APP_ENV}


@app.get("/health")
async def health():
    return {"status": "OK", "environment": APP_ENV}
