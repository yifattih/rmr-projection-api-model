# === Unit Tests: Fixtures ===


def test_coefficients_fixture(coefficients_fixture):
    """
    Test the correctness of MIFFLINSTJEOR coefficients.

    Parameters
    ----------
    coefficients_fixture : dict
        The fixture providing coefficients for testing.

    Raises
    ------
    AssertionError
        If the coefficients do not match the expected values.
    """
    assert coefficients_fixture["male"]["si"]["weight"] == 10.0
    assert coefficients_fixture["female"]["imperial"]["bias"] == -161


def test_activity_factors_fixture(activity_factors_fixture):
    """
    Test the correctness of MIFFLINSTJEOR activity factors.

    Parameters
    ----------
    activity_factors_fixture : dict
        The fixture providing activity factors for testing.

    Raises
    ------
    AssertionError
        If the activity factors do not match the expected values.
    """
    assert activity_factors_fixture["male"]["active"] == 1.25
    assert activity_factors_fixture["female"]["sedentary"] == 1.00
