*** Settings ***
Documentation  Unit Testing Edvora
Library  String
Library  REST  https://brc.api.vweb.app/create

*** Variables ***
# Accepted Values based on schema
${json_full}         { "first_name": "John", "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
# First name as Integer
${json_first_name}         { "first_name": 123, "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
# Last Name as Integer
${json_last_name}         { "first_name": "John", "last_name": 456, "username": "John@doe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
# alphanumerical Characters as username
${json_username_alpha}         { "first_name": "John", "last_name": "Doe", "username": "johndoe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
# Numerical Number as username
${json_username_num}         { "first_name": "John", "last_name": "Doe", "username": "12344", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
# Age in Strings
${json_age}         { "first_name": "John", "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17091990", "age": "wasd", "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
#Dob in alphanumerical
${json_dob}         { "first_name": "John", "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17th September 1980", "age": 19, "email": "john.doe@unknown.com", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
#Invalid email
${json_email}         { "first_name": "John", "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.co233m", "married": false, "attributes": [ { "title": "unknown", "description": "API test" }] }
#Marital status in strings
${json_married}         { "first_name": "John", "last_name": "Doe", "username": "John@doe1", "date_of_birth": "17091990", "age": 19, "email": "john.doe@unknown.com", "married": "not", "attributes": [ { "title": "unknown", "description": "API test" }] }

*** Test Cases ***
Check whether First name accepts Integer
    [Documentation]   Test to check whether First Name accepts Integer as a data type.Expected Behaviour: Integer should not be accepted and user should not be created.
    
    [tags]  Unit
    POST        /                    ${json_first_name}
    Integer     response status           422
    [Teardown]  Output  response body     ${OUTPUTDIR}/first_name_integer.json

Check whether Last name accepts Integer
    [Documentation]   Test to check whether Last Name accepts Integer data type.Expected Behaviour: Integer should not be accepted and user should not be created.
    [tags]  Unit
    POST        /                    ${json_last_name}
    Integer     response status           422
    [Teardown]  Output  response body     ${OUTPUTDIR}/last_name_integer.json

Check whether First name accepts Strings
    [Documentation]   Test to check whether First Name accepts Strings data type.Expected Behaviour: Stings should be accepted and user should be created.
    [tags]  Unit
    POST        /                    ${json_full}
    Integer     response status           200
    [Teardown]  Output  response body     ${OUTPUTDIR}/first_name_string.json

Check whether Last name accepts String
    [Documentation]   Test to check whether Last Name accepts String data type.Expected Behaviour: Given String should be accepted and user should be created.
    [tags]  Unit
    POST        /                    ${json_full}
    Integer     response status           200
    [Teardown]  Output  response body     ${OUTPUTDIR}/last_name_string.json

Check if username accepts one UpperCase letter,one symbol & one number & between 8-15 Characters
    [Documentation]    Expected Behaviour: The test should pass and data should be submitted successfully with response code 200
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/username.json

Check if username does not accept alphanumerical or just number as a value.
    [Documentation]    Expected Behaviour: The test should pass but data should not be submitted and a response code 422("username must satisfy one Uppercase letter, one lowercase letter, One Numberic letter, One special symbol, length should be atleast 8 and less then 15")
    [tags]    Unit
    POST    /    ${json_username_alpha}
    POST    /    ${json_username_num}
    Integer    response status    422
    [Teardown]  Output  response body     ${OUTPUTDIR}/username_negative.json

Check if age accepts Integer as a value.
    [Documentation]    Expected Behaviour: The test should pass with 200(with the message "user created successfully") as a response code
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/age_positive.json

Check if age does not accept String as a value.
    [Documentation]    Expected Behaviour: A response code of 422 with the message ("value is not a valid integer")
    [tags]    Unit
    POST    /    ${json_age}
    Integer    response status    422
    [Teardown]  Output  response body     ${OUTPUTDIR}/age_negative.json

Check if date of birth accepts Integer as a value.
    [Documentation]    Expected Behaviour: The test should pass with 200(with the message "user created successfully") as a response code
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/dob_positive.json


Check if dob does not accept alphanumerical Characters as a value.
    [Documentation]    Expected Behaviour: A response code of 422 with the message ("value is not a valid integer")
    [tags]    Unit
    POST    /    ${json_dob}
    Integer    response status    422
    [Teardown]  Output  response body     ${OUTPUTDIR}/dob_negative.json

Check if a valid email address is accepted in the email field
    [Documentation]    Expected Behaviour: The test should pass with 200(with the message "user created successfully") as a response code
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/email_positive.json

Check if an invalid email address format is not accepted in the email field
    [Documentation]    Expected Behaviour: A response code of 422 with the message ("Email is not valid")
    [tags]    Unit
    POST    /    ${json_email}
    Integer    response status    422
    [Teardown]  Output  response body     ${OUTPUTDIR}/email_negative.json

Check if married field accepts boolean
    [Documentation]    Expected Behaviour: The test should pass with 200(with the message "user created successfully") as a response code
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/married_positive.json

Check if married field does not accept any other values
    [Documentation]    Expected Behaviour: A response code of 422 with the message ("value could not be parsed to a boolean")
    [tags]    Unit
    POST    /    ${json_married}
    Integer    response status    422
    [Teardown]  Output  response body     ${OUTPUTDIR}/married_negative.json

Check if attributes value are passed
    [Documentation]    Expected Behaviour: The test should pass with 200(with the message "user created successfully") as a response code
    [tags]    Unit
    POST    /    ${json_full}
    Integer    response status    200
    [Teardown]  Output  response body     ${OUTPUTDIR}/attributes_positive.json