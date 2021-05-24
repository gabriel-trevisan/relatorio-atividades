#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} GATRATV001
Função para impressão do relatório das atividades com status aberto
@type function
@version 12.1.27
@author gabriel-trevisan
@since 24/05/2021
/*/
User Function GATRATV001()
    Local oAtivis := atividades() //Busca atividades no Firebase
    Private oReport  := Nil

    oReport := TReport():New("GATRATV001","Impressão das atividades com status aberto.",,{|oReport| print(oReport, oAtivis)},"Impressão das atividades com status aberto.")
    oReport:SetLandscape(.T.)

    oReport:PrintDialog()	

Return Nil

/*/{Protheus.doc} print
Função para impressão do relatório
@type function
@version 12.1.27
@author gabriel-trevisan
@since 24/05/2021
@param oReport, object, instancia da Classe TReport
@param oAtivis, object, instancia da Classe Firebase
/*/
Static Function print(oReport, oAtivis)
    Local ni
    Local oSecCab
    Local aIdAtivs := oAtivis:getNames()
    Local cStatus := ""
    Local cTipoAtiv := "" 

    for ni := 1 to len(aIdAtivs)

        if(oAtivis[&("aIdAtivs")[ni]]["status"] == "1")

            oSecCab := TRSection():New( oReport , "Atividades")

            oSecCab:init(.T.)

            oTrCellCli := TRCell():New( oSecCab, "CLIENTE")
            oTrCellLoj := TRCell():New( oSecCab, "LOJA")
            oTrCellNCI := TRCell():New( oSecCab, "NOME CLIENTE")
            oTrCellNCI:SetSize(20, .T.)
            oTrCellDta := TRCell():New( oSecCab, "DATA")
            oTrCellDta:SetSize(10, .T.)
            oTrCellDes := TRCell():New( oSecCab, "DESCRIÇÃO")
            oTrCellDes:SetSize(30, .T.)
            oTrCellRes := TRCell():New( oSecCab, "RESPONSÁVEL")
            oTrCellSta := TRCell():New( oSecCab, "STATUS")
            oTrCellTip := TRCell():New( oSecCab, "TIPO ATIVIDADE")
            oTrCellTip:SetSize(20, .T.)

            oTrCellCli:SetBlock({ || oAtivis[&("aIdAtivs")[ni]]["cliente"] })
            oTrCellLoj:SetBlock({ || oAtivis[&("aIdAtivs")[ni]]["loja"] })
            oTrCellNCI:SetBlock({ || oAtivis[&("aIdAtivs")[ni]]["nome_cliente"] })
            oTrCellDta:SetBlock({ || oAtivis[&("aIdAtivs")[ni]]["data"] })
            oTrCellDes:SetBlock({ || oAtivis[&("aIdAtivs")[ni]]["descricao"] })
            oTrCellRes:SetBlock({ || DecodeUTF8(oAtivis[&("aIdAtivs")[ni]]["nome_responsavel"]) })
            cStatus := iif(oAtivis[&("aIdAtivs")[ni]]["status"] == "1", "Aberto", "Fechado")
            oTrCellSta:SetBlock({ || cStatus })
            cTipoAtiv := iif(oAtivis[&("aIdAtivs")[ni]]["tipo_de_atividade"] == "1", "Visita", "Contato por Telefone")
            oTrCellTip:SetBlock({ || cTipoAtiv })

            oSecCab:PrintLine()

            oSecCab:Finish()

        endif

    next ni

Return Nil

/*/{Protheus.doc} atividades
Busca as atividades no Firebase
@type function
@version 12.1.27 
@author gabriel-trevisan
@since 24/05/2021
/*/
static function atividades()

	Local oFire := Firebase():New(/*cBaseUrl*/, /*cApiKey*/)
    Local oResult

	if oFire:login()
	    oResult := oFire:get("/atividades.json")
        return oResult
    endif

Return Nil
