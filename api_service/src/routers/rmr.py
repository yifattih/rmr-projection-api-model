from fastapi import APIRouter, HTTPException
from ..models.model import RMRModel
from ..schemas import RMRInput, RMROutput

router = APIRouter(prefix="/rmr", tags=["RMR Calculator"])
rmr_model = RMRModel()

@router.post("/", response_model=RMROutput)
async def calculate_rmr(input_data: RMRInput):
    """
    Endpoint to calculate RMR over a time projection using Mifflin-St. Jeor equations.
    """
    result = rmr_model.process(input_data.dict())
    
    if result["exit_code"] != 0:
        raise HTTPException(status_code=400, detail=result["error"])
    
    return {
        "input": result["input"],
        "output": result["output"]
    }
