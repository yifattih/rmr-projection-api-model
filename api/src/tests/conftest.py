import pytest
from ..models.coefficients import MIFFLINSTJEOR
from ..models.activity_factor import MIFFLINSTJEOR_ACTIVITYFACTOR
from ..models.time_projection import TimeProjection
from ..models.equations import Equations
from ..models.model import RMRModel

# === Fixtures ===


@pytest.fixture
def coefficients_fixture():
    """
    Fixture providing MIFFLINSTJEOR coefficients for testing.

    Returns
    -------
    dict
        A dictionary containing coefficients for the Mifflin-St Jeor equations.
    """
    return MIFFLINSTJEOR


@pytest.fixture
def activity_factors_fixture():
    """
    Fixture providing activity factors for testing.

    Returns
    -------
    dict
        A dictionary containing activity factors based on activity levels.
    """
    return MIFFLINSTJEOR_ACTIVITYFACTOR


@pytest.fixture
def time_projection_helper():
    """
    Fixture providing an instance of the TimeProjection helper class.

    Returns
    -------
    TimeProjection
        An instance of the TimeProjection helper.
    """
    return TimeProjection()


@pytest.fixture
def equations_helper():
    """
    Fixture providing an instance of the Equations helper class.

    Returns
    -------
    Equations
        An instance of the Equations helper.
    """
    return Equations()


@pytest.fixture
def rmr_model():
    """
    Fixture providing an instance of the RMRModel class.

    Returns
    -------
    RMRModel
        An instance of the RMRModel class.
    """
    return RMRModel()


@pytest.fixture
def valid_input_data():
    """
    Fixture providing valid input data for RMRModel.

    Returns
    -------
    dict
        Valid input data with all required fields.
    """
    return {
        "sex": "male",
        "units": "si",
        "age": 30,
        "weight": 70.0,
        "height": 1.75,
        "weight_loss_rate": 0.5,
        "duration": 10,
    }


@pytest.fixture
def edge_case_input_data():
    """
    Fixture providing edge case input data for RMRModel.

    Returns
    -------
    dict
        Input data containing edge case values for testing.
    """
    return {
        "sex": "female",
        "units": "imperial",
        "age": 20,
        "weight": 1.0,
        "height": 1.0,
        "weight_loss_rate": 0.0,
        "duration": 0,
    }
