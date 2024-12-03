import numpy as np


def test_time_projection_valid_input(time_projection) -> None:
    """
    Test that the TimeProjection class calculates the correct time array
    when a valid non-negative duration is provided.

    Parameters:
    - time_projection: An instance of the TimeProjection class.

    Expected Outcome:
    - The exit code should be 0, indicating success.
    - The resulting time array should match the expected range [0, duration].
    """
    result = time_projection.calculate(10)
    assert result["exit_code"] == 0
    assert np.array_equal(result["result"], np.arange(0, 11))


def test_time_projection_negative_input(time_projection) -> None:
    """
    Test that the TimeProjection class returns an error when a negative
    duration is provided.

    Parameters:
    - time_projection: An instance of the TimeProjection class.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should indicate that the duration must be non-negative.
    """
    result = time_projection.calculate(-1)
    assert result["exit_code"] == 1
    assert "Duration must be non-negative." in result["error"]
