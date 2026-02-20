# import os
# from fastapi import FastAPI

# app = FastAPI(title="Golden CI/CD Python API")

# APP_ENV = os.getenv("APP_ENV", "local")


# @app.get("/")
# async def root():
#     return {"message": "Welcome to Golden CI/CD API", "environment": APP_ENV}


# @app.get("/health")
# async def health():
#     return {"status": "OK", "environment": APP_ENV}

# from fastapi import FastAPI

# app = FastAPI()

# # Existing routes here...


# @app.get("/greet")
# def greet(name: str = "World"):
#     return {
#         "message": f"Hello {name}"
#     }

import os
from fastapi import FastAPI

APP_ENV = os.getenv("APP_ENV", "local")

app = FastAPI(title="Golden CI/CD Python API")


@app.get("/")
async def root():
    return {
        "message": "Welcome to Golden CI/CD API",
        "environment": APP_ENV
    }


@app.get("/health")
async def health():
    return {
        "status": "OK",
        "environment": APP_ENV
    }


@app.get("/greet")
def greet(name: str = "World"):
    return {
        "message": f"Hello {name}",
        "environment": APP_ENV
    }
