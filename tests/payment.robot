*** Settings ***
Library  Collections
Library  RequestsLibrary
Library  String

*** Test Cases ***
Create Payment
    [Tags]  Create Payment
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.v@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now creating payment...
    # Create Session  develop  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${params}=    Create Dictionary   payment_system=111  amount=9.8  currency=USD
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    ${resp2}=     Post Request   develop  /api/v1/payments   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200


Get Payment List
    [Tags]  Get Payment List
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.v@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now getting Payment list...
    # Create Session  feature4-2  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${params}=    Create Dictionary
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    ${resp2}=     Get Request   develop  /api/v1/payments   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200
