from pydantic import BaseModel, Field
from typing import Dict, List


class RMRInput(BaseModel):
    sex: str = Field(
        description="The sex of the individual ('male' or 'female')."
    )
    units: str = Field(
        description="The units system ('si' or 'imperial').")
    age: int = Field(
        gt=19,
        le=150,
        description="Age of the individual in years (20 to 150).",
    )
    weight: float = Field(
        gt=0, description="Weight in kilograms (SI) or pounds (imperial)."
    )
    height: float = Field(
        gt=0, description="Height in meters (SI) or inches (imperial)."
    )
    weight_loss_rate: float = Field(
        ge=0, description="Rate of weight loss per time unit."
    )
    duration: int = Field(
        ge=0, description="Duration for the time projection (>= 0)."
    )


class RMROutput(BaseModel):
    input: Dict[str, str | int | float]
    output: Dict[str, Dict[str, List[float]] | List[int]]
