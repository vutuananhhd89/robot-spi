*** Settings ***
Library  Collections
Library  RequestsLibrary
Library  String

*** Test Cases ***
Develop - Auth merchant & Get PS List
    [Tags]  Develop - Auth merchant
    Create Session  develop  http://develop.spiderpipe.s3.stuffio.com
    &{params}=    Create Dictionary   email=adam.sm2@paymentwall.com    password=admin123
    ${resp}=      Post Request    develop   /api/v1/auth    params=${params}
    Should be Equal as Strings    ${resp.status_code}   200
    ${resp_json}=     evaluate    json.loads('''${resp.content}''')   json
    log   Auth ok now getting PS list...
    Create Session  feature4-2  http://feature-sp-4-2.spiderpipe.s3.stuffio.com
    ${params}=    Create Dictionary
    ${headers}=   Create Dictionary   Authorization=bearer ${resp_json["access_token"]}
    ${resp2}=     Get Request   feature4-2  /api/v1/payment-systems   headers=${headers}
    Should be Equal as Strings    ${resp2.status_code}   200
