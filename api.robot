*** Settings ***
Documentation         Curso Robot Do Zero to Hero
...
...                   Exemplo de automação de apis utilizando
...                   somente um arquivo

Library               Collections
Library               RequestsLibrary

*** Variables ***
${URL}                    https://my-json-server.typicode.com/yuryalencar/fake-api
${GET_EMPLOYEE_ID}        1
${DELETE_EMPLOYEE_ID}     2

*** Test Cases ***
Teste na Requisição GET para Empregados (StatusCode)
  GET                 ${URL}/employees     expected_status=200

Teste na Requisição GET para o Empregado Yury
  ${response}=        GET                 ${URL}/employees/${GET_EMPLOYEE_ID}            expected_status=200

  Should Be Equal As Strings              ${GET_EMPLOYEE_ID}                  ${response.json()}[id]
  Should Be Equal As Strings              Yury Alencar                        ${response.json()}[name]
  Should Be Equal As Strings              Automation & QA Tech Lead           ${response.json()}[job]
  Should Be Equal As Strings              07091238095                         ${response.json()}[document]

Teste na Requisição DELETE para o Empregado Gustavo (Status Code)
  DELETE              ${URL}/employees/${DELETE_EMPLOYEE_ID}      expected_status=200

Teste na Requisição DELETE para o Empregado Gustavo (Verificando 404 no GET)
  DELETE              ${URL}/employees/${DELETE_EMPLOYEE_ID}      expected_status=200
  GET                 ${URL}/employees/${DELETE_EMPLOYEE_ID}      expected_status=404

Teste na Requisição DELETE para o Empregado Gustavo (Verificando no GET da listagem)
  DELETE              ${URL}/employees/${DELETE_EMPLOYEE_ID}      expected_status=200
  ${response}=        GET                                         ${URL}/employees

  ${id_number}=       Convert To Integer    ${DELETE_EMPLOYEE_ID}
  &{employee_dict}=   Create Dictionary     id=${id_number}       name=Gustavo Satheler   job=Full Cycle Lead     document=20874135095

  List Should Not Contain Value             ${response.json()}    ${employee_dict}

Teste na Requisição POST para o Empregado João (StatusCode)
  &{new_employee}=    Create Dictionary     name=João da Silva        job=Automation Tester   document=73889385087
  POST                ${URL}/employees      json=${new_employee}      expected_status=201

Teste na Requisição POST para o Empregado João (Com id novo)
  &{new_employee}=    Create Dictionary     id=200                    name=João da Silva        job=Automation Tester   document=73889385087
  POST                ${URL}/employees      json=${new_employee}      expected_status=201


Teste na Requisição POST para o Empregado João (Com id existente)
  &{new_employee}=    Create Dictionary     id=${GET_EMPLOYEE_ID}     name=João da Silva        job=Automation Tester   document=73889385087
  POST                ${URL}/employees      json=${new_employee}      expected_status=400

Teste na Requisição PUT para o Empregado Yury (StatusCode)
  &{updated_employee}=    Create Dictionary                       name=Yury Alencar Lima      job=Automation   document=73889385087
  PUT                     ${URL}/employees/${GET_EMPLOYEE_ID}     json=${updated_employee}    expected_status=200

Teste na Requisição PUT para o Empregado Yury (Id outro empregado)
  &{updated_employee}=    Create Dictionary                       id=${DELETE_EMPLOYEE_ID}    name=Yury Alencar Lima      job=Automation   document=73889385087
  PUT                     ${URL}/employees/${GET_EMPLOYEE_ID}     json=${updated_employee}    expected_status=400

Teste na Requisição PUT para o Empregado Yury (Id do próprio empregado)
  &{updated_employee}=    Create Dictionary                       id=${GET_EMPLOYEE_ID}       name=Yury Alencar Lima      job=Automation   document=73889385087
  PUT                     ${URL}/employees/${GET_EMPLOYEE_ID}     json=${updated_employee}    expected_status=200

Teste na Requisição PUT para o Empregado Yury (Id novo)
  &{updated_employee}=    Create Dictionary                       id=2000                     name=Yury Alencar Lima      job=Automation   document=73889385087
  PUT                     ${URL}/employees/${GET_EMPLOYEE_ID}     json=${updated_employee}    expected_status=200

Teste na Requisição PATCH para o Empregado Yury (Nome - StatusCode)
  &{attribute}=           Create Dictionary                       name=Yury Alencar PATCH
  PATCH                   ${URL}/employees/${GET_EMPLOYEE_ID}     json=${attribute}           expected_status=200

Teste na Requisição PATCH para o Empregado Yury (job - StatusCode)
  &{attribute}=           Create Dictionary                       job=Automation PATCH
  PATCH                   ${URL}/employees/${GET_EMPLOYEE_ID}     json=${attribute}           expected_status=200

Teste na Requisição PATCH para o Empregado Yury (document - StatusCode)
  &{attribute}=           Create Dictionary                       document=73889385087
  PATCH                   ${URL}/employees/${GET_EMPLOYEE_ID}     json=${attribute}           expected_status=200

Teste na Requisição PATCH para o Empregado Yury (id - StatusCode)
  &{attribute}=           Create Dictionary                       id=500
  PATCH                   ${URL}/employees/${GET_EMPLOYEE_ID}     json=${attribute}           expected_status=200
