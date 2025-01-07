"""
Activity Factor Coefficients Module
----------
Activity factor coefficients for the equations defined below.

MIFFLINSTJEOR
----------
For the Mifflin-St. Jeor equations:
        For male:
                SI units system:
                        RMR = 10*weight + 6.25*height - 5*age + 5
                        RMR = RMR * Activity Factor

                        weight in kilograms | height in meters | age in years

                Imperial units system:
                        RMR = 4.536*weight + 15.875*height − 5*age + 5
                        RMR = RMR * Activity Factor

                        weight in pounds | height in inches | age in years

        For female:
                SI units system:
                        RMR = 10*weight + 6.25*height - 5*age - 161
                        RMR = RMR * Activity Factor

                        weight in kilograms | height in meters | age in years


                Imperial units system:
                        RMR = 4.536*weight + 15.875*height − 5*age − 161
                        RMR = RMR * Activity Factor

                        weight in pounds | height in inches | age in years

Returns:
----------
MIFFLINSTJEOR : dict
        Dictionary containing activity factor constants by sex and
        activity level.
"""

MIFFLINSTJEOR_ACTIVITYFACTOR = {
    "male": {
        "sedentary": 1.00,
        "low_active": 1.11,
        "active": 1.25,
        "very_active": 1.48,
    },
    "female": {
        "sedentary": 1.00,
        "low_active": 1.12,
        "active": 1.27,
        "very_active": 1.45,
    },
}
