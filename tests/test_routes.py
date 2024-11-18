import sys
import json
import pytest

sys.path.append("./app/src")

from app.src.routes import app

@pytest.fixture
def client():
    """Fixture to create a test client."""
    with app.test_client() as client:
        yield client


def test_home_route(client) -> None:
    """Test the main route to ensure it loads the form page correctly."""
    response = client.get('/')
    assert response.status_code == 200  # Check for successful response
    assert b'<form' in response.data  # Verify form is present in the HTML

def test_submit_route(client) -> None:
    """Test the /submit route to ensure it accepts POST and returns JSON."""
    # Mock form data for the POST request
    mock_form_data = {"sex": "men",
                      "age": 33,
                      "weight": 196,
                      "height": 71,
                      "units": "imperial",
                      "weeks": 4,
                      "weight_loss_rate": 2,
                      "energy_deficit": 1000}
    response = client.post('/submit', data=json.dumps(mock_form_data),
                           content_type='application/json')

    assert response.status_code == 200  # Check for successful response
    assert response.is_json  # Confirm response is JSON
    response_data = response.get_json()
    assert response_data["status"] == "Success!"  # Validate message in JSON

def test_clear_route(client) -> None:
    """Test the /clear route to ensure it clears out buffer data."""
    # Mock form data for the POST request
    response = client.post('/clear')
    assert response.status_code == 200  # Check for successful response
    assert response.is_json  # Confirm response is JSON
    response_data = response.get_json()
    assert response_data["status"] == "Success!"  # Validate message in JSON
    assert response_data["data_out"] == []