*** Settings ***
Library  Collections
Library  RequestsLibrary
Library  String

*** Test Cases ***
Auth & Get PS List in Develop
    [Tags]  Auth & Get PS list
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.v@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now getting PS list...
    Create Session  feature4-2  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${params}=    Create Dictionary
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    ${resp2}=     Get Request   feature4-2  /api/v1/payment-systems   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200

Get PS List of Sub-Merchant
    [Tags]  Get PS List of Sub-Merchant
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.v@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now getting PS list of Sub-Merchant...

    Create Session  feature4-2  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    # log to console    ${resp_json["access_token"]}
    ${resp2}=     Get Request    feature4-2    api/v1/merchants/15/payment-systems   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200

Set PS List for Sub-Merchant
    [Tags]  Get PS List of Sub-Merchant
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.v@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now getting PS list of Sub-Merchant...

    Create Session  feature4-2  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    ${params}=    Create Dictionary   
    # log to console    ${resp_json["access_token"]}
    ${resp2}=     Post Request    feature4-2    api/v1/merchants/15/payment-systems   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200
