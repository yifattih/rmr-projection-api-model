# === Integration Tests ===


def test_rmr_model_valid(rmr_model, valid_input_data):
    """
    Test RMRModel with valid inputs.

    Parameters
    ----------
    rmr_model : RMRModel
        The fixture providing the RMRModel instance.
    valid_input_data : dict
        The fixture providing valid input data for testing.

    Raises
    ------
    AssertionError
        If the exit code or output structure is incorrect.
    """
    result = rmr_model.process(valid_input_data)
    assert result["exit_code"] == 0
    assert "output" in result
    assert "sedentary" in result["output"]["rmr"]


def test_rmr_model_edge_case(rmr_model, edge_case_input_data):
    """
    Test RMRModel with edge case inputs.

    Parameters
    ----------
    rmr_model : RMRModel
        The fixture providing the RMRModel instance.
    edge_case_input_data : dict
        The fixture providing edge case input data for testing.

    Raises
    ------
    AssertionError
        If the exit code or output length is incorrect.
    """
    result = rmr_model.process(edge_case_input_data)
    assert result["exit_code"] == 0
    assert "output" in result
    assert len(result["output"]["rmr"]["sedentary"]) == 1


def test_rmr_model_invalid_values(rmr_model):
    """
    Test RMRModel with invalid input values.

    Parameters
    ----------
    rmr_model : RMRModel
        The fixture providing the RMRModel instance.

    Raises
    ------
    AssertionError
        If the exit code or error message is incorrect.
    """
    input_data = {
        "sex": "male",
        "units": "si",
        "age": 200,  # Invalid age
        "weight": -1,  # Invalid weight
        "height": -1,  # Invalid height
        "weight_loss_rate": -1,  # Invalid weight loss rate
        "duration": -1,  # Invalid duration
    }
    result = rmr_model.process(input_data)
    assert result["exit_code"] == 1
    assert "Invalid age" in result["error"]
