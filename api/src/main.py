from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
from .routers import rmr


app = FastAPI(
    title="Resting Metabolic Rate (RMR) API",
    description=(
        "A RESTful API for calculating RMR using Mifflin-St. Jeor"
        + " equations."
    ),
    version="1.0.0",
)

# Instrumentation to expose metrics endpoint for Prometheus
Instrumentator().instrument(app).expose(app)


@app.get("/", tags=["Root"])
async def root():
    return {
        "message": (
            "Welcome to the RMR API. Use /docs for the API" + " documentation."
        )
    }

# Include the RMR routes
app.include_router(rmr.router)
