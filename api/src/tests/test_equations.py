import numpy as np


# === Unit Tests: Equations ===


def test_equations_valid(equations_helper):
    """
    Test Equations helper with valid inputs.
    """
    projection = np.array([0, 1, 2])
    result = equations_helper.mifflinstjeor_rmr(
        sex="male",
        units="si",
        age=30,
        weight=70,
        height=1.75,
        weight_loss_rate=0.5,
        time_projection=projection,
    )
    assert result["exit_code"] == 0
    assert "sedentary" in result["result"]
    assert isinstance(result["result"]["sedentary"], list)


def test_equations_invalid(equations_helper):
    """
    Test Equations helper with invalid inputs.
    """
    projection = np.array([0, 1, 2])
    result = equations_helper.mifflinstjeor_rmr(
        sex="unknown",
        units="si",
        age=30,
        weight=70,
        height=1.75,
        weight_loss_rate=0.5,
        time_projection=projection,
    )
    assert result["exit_code"] == 1
    assert "Invalid combination" in result["error"]
