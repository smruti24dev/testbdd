#!/bin/bash

# This script sets up the entire project structure for the API BDD testing project.
# It creates all directories and files with the correct content.

set -e # Exit immediately if a command exits with a non-zero status.

PROJECT_DIR="api-bdd-testing"

echo "Creating project directory: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR/features"
mkdir -p "$PROJECT_DIR/step_defs"

cd "$PROJECT_DIR"

echo "Creating requirements.txt..."
cat <<'EOF' > requirements.txt
pytest
pytest-bdd
requests
Faker
pytest-html
EOF

echo "Creating pytest.ini..."
cat <<'EOF' > pytest.ini
[pytest]
bdd_features_base_dir = features/
python_files = step_defs/*.py
addopts = --html=report.html --self-contained-html
EOF

echo "Creating features/users.feature..."
cat <<'EOF' > features/users.feature
Feature: User Management API
  As a consumer of the User API
  I want to be able to create, retrieve, and manage users
  So that I can integrate user functionality into my application.

  Scenario: Retrieve a single user successfully
    Given the user API is available
    When I request the user with ID "2"
    Then the response status code should be 200
    And the response should contain the user's data
    And the user's email should be "janet.weaver@reqres.in"

  Scenario: User not found
    Given the user API is available
    When I request the user with ID "23"
    Then the response status code should be 404

  Scenario: Create a new user
    Given the user API is available
    And I have the data for a new user
    When I send a POST request to create the user
    Then the response status code should be 201
    And the response should contain the created user's data
EOF

echo "Creating step_defs/test_users.py..."
cat <<'EOF' > step_defs/test_users.py
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
EOF

echo "Creating .gitignore..."
cat <<'EOF' > .gitignore
__pycache__/
*.pyc
.pytest_cache/
venv/
*.egg-info/
.pytest_cache/
venv/
*.egg-info/
*.html
EOF

echo "Creating README.md..."
cat <<'EOF' > README.md
# REST API BDD Testing with Pytest and Pytest-BDD

This project demonstrates how to write BDD-style tests for a REST API using Python, `pytest`, and `pytest-bdd`.

## 🚀 Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd api-bdd-testing
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3.  **Install the dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

## ▶️ Running the Tests

To run all the tests, simply execute `pytest` from the root of the project directory:

```bash
pytest -v
```
EOF

echo ""
echo "✅ Project setup complete in the '$PROJECT_DIR' directory!"
echo ""
echo "To run the tests, execute the following commands:"
echo "cd $PROJECT_DIR"
echo "python -m venv venv"
echo "source venv/bin/activate"
echo "pip install -r requirements.txt"
echo "pytest -v"


