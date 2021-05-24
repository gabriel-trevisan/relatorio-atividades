#include "totvs.ch"
#include "protheus.ch"
#include "parmtype.ch"

/*/{Protheus.doc} Firebase
Classe para fazer comunicação com a API Firebase do Realtime Database em ADVPL
@type class
@version  12.1.27
@author gabriel-trevisan
@since 22/05/2021
/*/
class FIREBASE
	data cBaseUrl
    data cApiKey
    data cIdToken

	method new(cBaseUrl, cApiKey)
	method get()
    method login()
endclass

/*/{Protheus.doc} Firebase::new
Construtor da classe
@type method
@version  12.1.27
@author gabriel-trevisan
@since 22/05/2021
@param cBaseUrl, character, Base url do projeto em Firebase
@param cApiKey, character, Api Key do projeto Firebase
/*/
method new(cBaseUrl, cApiKey) class Firebase
    ::cBaseUrl := cBaseUrl
	::cApiKey := cApiKey
return

/*/{Protheus.doc} Firebase::login
Methodo de login no Authentication Firebase no modo anônimo
@type method
@version 12.1.27
@author gabriel-trevisan
@since 22/05/2021
/*/
method login() class Firebase
    local oRestClient := FWRest():New("https://identitytoolkit.googleapis.com")
    local aHeaderStr := {}
    local cPath := "/v1/accounts:signUp?key="+::cApiKey
    local cJson := '{"returnSecureToken": true}'
    local oObj := JsonObject():new()
    
    aadd(aHeaderStr,"Content-Type: application/json; charset=utf-8")

    oRestClient:setPath(cPath)

    oRestClient:SetPostParams(cJson)

	If oRestClient:post(aHeaderStr)
        oObj:fromJSON(oRestClient:GetResult())
        ::cIdToken := oObj['idToken']
		return .T.
	Else
		return(oRestClient:GetLastError())
	Endif

return

/*/{Protheus.doc} Firebase::get
Methodo get para fazer as requisições
@type method
@version 12.1.27
@author gabriel-trevisan
@since 22/05/2021
@param cEndPoint, character, endpoint
/*/
method get(cEndPoint) class Firebase

    Local oRestClient := FWRest():New(::cBaseUrl)
    local aHeaderStr := {}
    local cPath := cEndPoint+"?auth="+::cIdToken
    local oObj := JsonObject():new()

    aadd(aHeaderStr,"Content-Type: application/json; charset=utf-8")

    oRestClient:setPath(cPath)
	
	If oRestClient:get(aHeaderStr)
        oObj:fromJSON(oRestClient:GetResult())
		return oObj
	Else
		return(oRestClient:GetLastError())
	Endif

return
