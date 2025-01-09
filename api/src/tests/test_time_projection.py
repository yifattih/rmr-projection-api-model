import numpy as np


# === Unit Tests: Time Projection ===


def test_time_projection_valid(time_projection_helper):
    """
    Test TimeProjection with valid input.

    Parameters
    ----------
    time_projection_helper : TimeProjection
        The fixture providing the TimeProjection helper instance.

    Raises
    ------
    AssertionError
        If the result array or exit code is incorrect.
    """
    result = time_projection_helper.calculate(5)
    assert result["exit_code"] == 0
    assert np.array_equal(result["result"], np.array([0, 1, 2, 3, 4, 5]))


def test_time_projection_invalid(time_projection_helper):
    """
    Test TimeProjection with invalid input.

    Parameters
    ----------
    time_projection_helper : TimeProjection
        The fixture providing the TimeProjection helper instance.

    Raises
    ------
    AssertionError
        If the exit code or error message is incorrect.
    """
    result = time_projection_helper.calculate(-1)
    assert result["exit_code"] == 1
    assert "non-negative" in result["error"]
