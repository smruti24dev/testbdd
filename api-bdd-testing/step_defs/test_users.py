"""
Step definitions for the user API tests.
"""

import pytest
import requests
from faker import Faker
from pytest_bdd import scenario, given, when, then, parsers

# Constants
API_BASE_URL = "https://reqres.in/api"

# Scenarios
@scenario('../features/users.feature', 'Retrieve a single user successfully')
def test_get_single_user():
    """Scenario: Retrieve a single user successfully."""
    pass

@scenario('../features/users.feature', 'User not found')
def test_user_not_found():
    """Scenario: User not found."""
    pass

@scenario('../features/users.feature', 'Create a new user')
def test_create_new_user():
    """Scenario: Create a new user."""
    pass

# Fixtures
@pytest.fixture
def api_response():
    """A fixture to store the API response."""
    return {}

@pytest.fixture
def new_user_data():
    """A fixture to generate and store new user data."""
    faker = Faker()
    return {
        "name": faker.name(),
        "job": faker.job()
    }

# Step Definitions

@given("the user API is available")
def api_is_available():
    """A step to check if the API is available. Can be a simple pass-through."""
    pass

@given("I have the data for a new user")
def i_have_new_user_data(new_user_data):
    """A step that relies on the new_user_data fixture."""
    assert "name" in new_user_data
    assert "job" in new_user_data

@when(parsers.parse('I request the user with ID "{user_id}"'))
def get_user_by_id(api_response, user_id):
    """Make a GET request to retrieve a user by their ID."""
    response = requests.get(f"{API_BASE_URL}/users/{user_id}")
    api_response["json"] = response.json() if response.status_code in [200, 201] else {}
    api_response["status_code"] = response.status_code

@when("I send a POST request to create the user")
def create_user(api_response, new_user_data):
    """Make a POST request to create a new user."""
    response = requests.post(f"{API_BASE_URL}/users", json=new_user_data)
    api_response["json"] = response.json()
    api_response["status_code"] = response.status_code

@then(parsers.parse('the response status code should be {status_code:d}'))
def check_status_code(api_response, status_code):
    """Check if the response status code matches the expected code."""
    assert api_response["status_code"] == status_code

@then("the response should contain the user's data")
def check_user_data(api_response):
    """Check if the response body contains the user's data."""
    assert "data" in api_response["json"]
    assert "id" in api_response["json"]["data"]

@then(parsers.parse('the user\'s email should be "{email}"'))
def check_user_email(api_response, email):
    """Check if the user's email in the response matches the expected email."""
    assert api_response["json"]["data"]["email"] == email

@then("the response should contain the created user's data")
def check_created_user_data(api_response, new_user_data):
    """Check if the response contains the data sent for user creation."""
    response_json = api_response["json"]
    assert response_json["name"] == new_user_data["name"]
    assert response_json["job"] == new_user_data["job"]
    assert "id" in response_json
    assert "createdAt" in response_json
