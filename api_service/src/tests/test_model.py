def test_rmr_model_valid_input(bmr_model, valid_input_data) -> None:
    """
    Test the RMRModel class with valid input data, ensuring correct RMR
    calculation.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 0, indicating success.
    - The output should include the calculated RMR values as a list.
    """
    result = bmr_model.process(valid_input_data)
    assert result["exit_code"] == 0
    assert "input" in result
    assert "output" in result
    assert "rmr" in result["output"]


def test_rmr_model_missing_keys(bmr_model, valid_input_data) -> None:
    """
    Test the RMRModel class with missing required input keys, ensuring an error
    is returned.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify the missing required keys.
    """
    invalid_data = valid_input_data.copy()
    del invalid_data["age"]
    result = bmr_model.process(invalid_data)
    assert result["exit_code"] == 1
    assert "Missing required keys" in result["error"]


def test_rmr_model_invalid_age(bmr_model, invalid_age_data) -> None:
    """
    Test the RMRModel class with an invalid 'age' value, ensuring an error is
    returned.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - invalid_age_data: A dictionary with an invalid 'age' value.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify the invalid age value.
    """
    result = bmr_model.process(invalid_age_data)
    assert result["exit_code"] == 1
    assert "Invalid age" in result["error"]


def test_rmr_model_invalid_weight(bmr_model, valid_input_data) -> None:
    """
    Test the RMRModel class with an invalid 'weight' value, ensuring an error
    is returned.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify the invalid weight value.
    """
    invalid_data = valid_input_data.copy()
    invalid_data["weight"] = -10
    result = bmr_model.process(invalid_data)
    assert result["exit_code"] == 1
    assert "Invalid weight" in result["error"]


def test_rmr_model_invalid_height(bmr_model, valid_input_data) -> None:
    """
    Test the RMRModel class with an invalid 'height' value, ensuring an error
    is returned.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify the invalid height value.
    """
    invalid_data = valid_input_data.copy()
    invalid_data["height"] = 0
    result = bmr_model.process(invalid_data)
    assert result["exit_code"] == 1
    assert "Invalid height" in result["error"]


def test_rmr_model_negative_duration(bmr_model, valid_input_data) -> None:
    """
    Test the RMRModel class with a negative duration value, ensuring an error
    is returned.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 1, indicating an error.
    - The error message should specify the invalid duration value.
    """
    invalid_data = valid_input_data.copy()
    invalid_data["duration"] = -5
    result = bmr_model.process(invalid_data)
    assert result["exit_code"] == 1
    assert "Invalid duration" in result["error"]


def test_rmr_model_integration(bmr_model, valid_input_data) -> None:
    """
    Full integration test for the RMRModel class, ensuring end-to-end
    functionality.

    Parameters:
    - bmr_model: An instance of the RMRModel class.
    - valid_input_data: A dictionary containing valid input data.

    Expected Outcome:
    - The exit code should be 0, indicating success.
    - The output should include a list of RMR values with the correct length.
    """
    result = bmr_model.process(valid_input_data)
    assert result["exit_code"] == 0
    assert "input" in result
    assert "output" in result
    assert isinstance(result["output"]["rmr"], list)
    assert len(result["output"]["rmr"]) == valid_input_data["duration"] + 1
