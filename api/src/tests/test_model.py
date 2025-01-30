# === Integration Tests ===


def test_rmr_model_valid(rmr_model, valid_input_data):
    """
    Test RMRModel with valid inputs.
    """
    result = rmr_model.process(valid_input_data)
    assert result["exit_code"] == 0
    assert "output" in result
    assert "sedentary" in result["output"]["rmr"]


def test_rmr_model_edge_case(rmr_model, edge_case_input_data):
    """
    Test RMRModel with edge case inputs.
    """
    result = rmr_model.process(edge_case_input_data)
    assert result["exit_code"] == 0
    assert "output" in result
    assert len(result["output"]["rmr"]["sedentary"]) == 1


def test_rmr_model_invalid_values(rmr_model):
    """
    Test RMRModel with invalid input values.
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
