Feature:
    Como desarrollador de APIsrequiero consultar la información de prueba para identificar las respuestas de un API de Ejemplo
 
    Scenario: Negocio un consumer key y secret key de la app de prueba
        Given I have basic authentication credentials `apigeeUsername` and `apigeePassword`        
        When I GET `apigeeHost`/v1/organizations/`apigeeOrg`/developers/`apigeeDeveloper`/apps/`apigeeApp`
        Then response code should be 200
        And response body should be valid json
        And I store the value of body path $.credentials[0].consumerKey as globalConsumerKey in global scope
        And I store the value of body path $.credentials[0].consumerSecret as globalConsumerSecret in global scope

    Scenario: Negocia un access token con el Authorization server
        Given I set form parameters to
        | parameter | value |
        | grant_type | client_credentials |
        And I have basic authentication credentials `globalConsumerKey` and `globalConsumerSecret`
        When I POST to `apigeeDomain`/`apigeeOauthEndpoint`
        Then response code should be 200
        And response body should be valid json
        And I store the value of body path $.access_token as access token

    Scenario Outline: Verificar que obtenga la información relacionada desde una transaccion GET en /busquedas
        
        Given I set bearer token
        When I GET `apigeeDomain`/ejemplo/`deploymentSuffix`/busquedas?idEstado=<idEstado>
        
        Then response code should be 200
        And response body should be valid json
        And response body path $.codigo should be <codigo>
        And response body path $.mensaje should be <mensaje>
        And response body path $.folio should be <folio>
        And response body path $.estado.descripcion should be <descripcion>
        And response body path $.estado.descripcionCorta should be <descripcionCorta>
        Examples:
        |idEstado|codigo|mensaje|folio|descripcion|descripcionCorta|
        |6|0|Operacion Exitosa.|^\d{16,20}$|Aguascalientes|AGUAS|

    Scenario Outline: Verificar que al introducir argumentos no validos indique como resultado una entrada incorrecta desde una transaccion GET en /busquedas
        
        Given I set bearer token
        When I GET `apigeeDomain`/ejemplo/`deploymentSuffix`/busquedas?idEstado=<idEstado>
        
        Then response code should be 400
        And response body should be valid json
        And response body path $.codigo should be <codigo>
        And response body path $.mensaje should be <mensaje>
        And response body path $.folio should be <folio>
        And response body path $.detalles[0] should be <detalle1>
        Examples:
        |idEstado|codigo|mensaje|folio|detalle1|
        |X|^400\.area-api\.\d{4}$|Parametros no validos por favor valide su informacion.|^\d{16,20}$|identificador no valido|
    
    Scenario Outline: Verificar que al introducir argumentos validos pero inexistentes no se obtenga informacion relacionada desde una transaccion GET en /busquedas
        
        Given I set bearer token
        When I GET `apigeeDomain`/ejemplo/`deploymentSuffix`/busquedas?idEstado=<idEstado>
        
        Then response code should be 404
        And response body should be valid json
        And response body path $.codigo should be <codigo>
        And response body path $.mensaje should be <mensaje>
        And response body path $.folio should be <folio>
        And response body path $.detalles[0] should be <detalle1>
        Examples:
        |idEstado|codigo|mensaje|folio|detalle1|
        |33|^404\.area-api\.\d{4}$|Recurso no encontrado.|^\d{16,20}$|identificador no encontrado|
    
    Scenario Outline: Verificar la disponibilidad del backend services desde una transaccion GET en /busquedas
        
        Given I set bearer token
        When I GET `apigeeDomain`/ejemplo/`deploymentSuffix`/busquedas?idEstado=<idEstado>
        
        Then response code should be 500
        And response body should be valid json
        And response body path $.codigo should be <codigo>
        And response body path $.mensaje should be <mensaje>
        And response body path $.folio should be <folio>
        And response body path $.detalles[0] should be <detalle1>
        Examples:
        |idEstado|codigo|mensaje|folio|detalle1|
        |2|^500\.area-api\.\d{4}$|Error interno en servidor.|^\d{16,20}$|timeout|