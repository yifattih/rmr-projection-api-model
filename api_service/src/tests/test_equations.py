import numpy as np


def test_equations_valid_input(equations, time_projection) -> None:
    """
    Test the Mifflin-St Jeor equation with valid input parameters, ensuring
    correct RMR calculation.

    Parameters:
    - equations: An instance of the Equations class.
    - time_projection: An instance of the TimeProjection class to generate time
    data.

    Expected Outcome:
    - The exit code should be 0, indicating success.
    - The result should be a numpy array of RMR values of the expected length.
    """
    time_data = time_projection.calculate(10)
    result = equations.mifflinstjeor_rmr(
        sex="male",
        units="si",
        age=30,
        weight=70,
        height=1.75,
        weight_loss_rate=0.5,
        time_projection=time_data["result"],
    )
    assert result["exit_code"] == 0
    assert isinstance(result["result"], np.ndarray)
    assert len(result["result"]) == 11


def test_equations_invalid_sex(equations, time_projection) -> None:
    """
    Test the Mifflin-St Jeor equation with an invalid 'sex' parameter.

    Parameters:
    - equations: An instance of the Equations class.
    - time_projection: An instance of the TimeProjection class to generate time
    data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify an invalid combination of sex or units.
    """
    time_data = time_projection.calculate(10)
    result = equations.mifflinstjeor_rmr(
        sex="unknown",
        units="si",
        age=30,
        weight=70,
        height=1.75,
        weight_loss_rate=0.5,
        time_projection=time_data["result"],
    )
    assert result["exit_code"] == 1
    assert "Invalid combination of sex or units" in result["error"]


def test_equations_invalid_units(equations, time_projection) -> None:
    """
    Test the Mifflin-St Jeor equation with an invalid 'units' parameter.

    Parameters:
    - equations: An instance of the Equations class.
    - time_projection: An instance of the TimeProjection class to generate time
    data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify an invalid combination of sex or units.
    """
    time_data = time_projection.calculate(10)
    result = equations.mifflinstjeor_rmr(
        sex="male",
        units="unknown",
        age=30,
        weight=70,
        height=1.75,
        weight_loss_rate=0.5,
        time_projection=time_data["result"],
    )
    assert result["exit_code"] == 1
    assert "Invalid combination of sex or units" in result["error"]
