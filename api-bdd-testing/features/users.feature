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
