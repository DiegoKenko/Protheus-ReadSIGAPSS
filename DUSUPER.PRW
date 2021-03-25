#INCLUDE 'PROTHEUS.CH'


//-------------------------------------------------------------------
/*/{Protheus.doc} DUSUPER
@type     User Function
     Detalhas os acessos do usuario, ou , detalhas os usuarios que tem acesso.
@author   Diego Andrade
@since
@version  12.1.25
@param    ,
@return
@table
@obs
@history
/*/
//-------------------------------------------------------------------
User Function DUSUPER()

     Local nZ
     Local nY
     Local oFont      := TFont():New('Courier new',,16)
     Local oFont2     := TFont():New('Courier new',,18)
     Local oFontCheck := TFont():New('Courier new',,16,,.T.)
     Local oFontBtn   := TFont():New("Courier new",,18,,.T.,,,,,.F.,.F.)
     Local oFontBtn2  := TFont():New("Courier new",,14,,.T.,,,,,.F.,.F.)
     Local oFontRet  := TFont():New("Courier new",,10,,.T.,,,,,.F.,.F.)
     Private cTitulo  := ''
     Private oDlg
     Private cRetG := ''
     Private cRetE := ''
     Private aRetorno := {}
     Private aUser    := AllUsers()
     Private cUser    := Space(06)
     Private cMod  := Space(02)
     Private cMenu    := Space(20)
     Private cRetCam    := ''
     Private lAltData := .F.

     DEFINE DIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME FROM 0,0 TO 600,900 PIXEL
     // Cria os painéis que conterão os containers
     oPanelG := TPanel():New(01,01,"",oDlg,,,,,,40,300)
     oPanelE := TPanel():New(01,01,"",oDlg,,,,,,40,300)
     oPanel3 := TPanel():New(10,310,"",oDlg,,,,,,200,500)
     TSay():New(01,01,{||'  Usuario: '},oPanel3,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,70,10,,,,,,.T.)
     TGet():New(01,70, { | u | If( PCount() == 0, cUser, cUser := u ) },oPanel3,030, 10, "@! 999999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,{|| cMenu := Space(16),cMod := Space(02),lAltData := .F. },.F.,.F. ,,"cUser",,,,.F. )
     TSay():New(20,01,{||'  Menu: '},oPanel3,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,70,20,,,,,,.T.)
     TGet():New(20,70, { | u | If( PCount() == 0, cMenu, cMenu := u ) },oPanel3,050, 10, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,{|| cUser := Space(06),cMod := Space(02),lAltData := .F. },.F.,.F. ,,"cMenu",,,,.F. )
     TSay():New(40,01,{||'  Modulo: '},oPanel3,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,70,20,,,,,,.T.)
     TGet():New(40,70, { | u | If( PCount() == 0, cMod, cMod := u ) },oPanel3,020, 10, "@! 99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,{|| cMenu := Space(16),cUser := Space(06),lAltData := .F. },.F.,.F. ,,"cMod",,,,.F. )
     oTButton4 := TButton():New(70,01, "Mostra alteração da data base",oPanel3,{|| lAltData := .T.,cUser := Space(06),cMod := Space(02),cMenu := Space(16),Processa()},120,15,,oFontBtn2,.F.,.T.,.F.,,.F.,,,.F.)
     oTButton4:SetColor(CLR_GRAY)
     oTButton1 := TButton():New(200,10, "BUSCAR",oPanel3,{|| Processa()},120,15,,oFontBtn,.F.,.T.,.F.,,.F.,,,.F.)
     oTButton1:SetColor(CLR_GRAY)
     oTButton2 := TButton():New(220,20,"EXPORTAR",oPanel3,{|| Exportar()},100,15,,oFontBtn,.F.,.T.,.F.,,.F.,,,.F.)
     oTButton2:SetColor(CLR_GRAY)
     TSay():New(240,01,{||cRetCam},oPanel3,,oFontRet,,,,.T.,CLR_BLACK,CLR_WHITE,300,5000)
     oTButton3 := TButton():New(250,30, "FECHAR",oPanel3,{|| oDlg:End()},80,15,,oFontBtn,.F.,.T.,.F.,,.F.,,,.F.)
     oTButton3:SetColor(CLR_GRAY)
     oTb := TToolBox():New(01,01,oDlg,300,280)
     oTb:bChangeGrp := {|x| }
     oTb:AddGroup( oPanelG, 'Geral',nil )
     oTb:AddGroup( oPanelE, 'Específico',nil )
     oScrG := TScrollBox():New(oPanelG,01,01,245,300,.T.)
     oScrE := TScrollBox():New(oPanelE,01,01,245,300,.T.)
     oSayMainG := TSay():New(01,01,{||cRetG},oScrG,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,300,5000)
     oSayMainG:SetTextAlign( 0, 0 )
     oSayMainG:lWordWrap := .F.
     oSayMainE := TSay():New(01,01,{||cRetE},oScrE,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,300,5000)
     oSayMainE:SetTextAlign( 0, 0 )
     oSayMainE:lWordWrap := .F.

     ACTIVATE DIALOG oDlg CENTERED

return

static function Processa()

     cRetE := ''
     cRetG := ''

     IF !Empty(cMenu) // Informou o menus
          cMenu := AllTrim(cMenu)
          cTitulo := 'Acessos no menu ' + cMenu + '.xnu'
          cRetE := LerXnu(cMenu)
          For nZ := 1 to Len(aUser)
               IF !UsuBloq(aUser[nZ])
                    For nY:= 1 to Len(aUser[nZ][3])
                         IF (AllTrim(cMenu) + '.XNU') $ Upper(aUser[nZ][3][nY])
                              IF SubStr(aUser[nZ][3][nY],3,1) == '5'
                                   cRetG += Chr(10) + aUser[nZ][1][1] + ' - ' + aUser[nZ][1][2] + ' - '+ SubStr(aUser[nZ][3][nY],12)
                              ENDIF
                         EndIf
                    Next nY
               ENDIF
          Next nZ
     ElseIF !Empty(cMod) // Informou o modulo
          cTitulo := 'Acessos no módulo ' + cMod
          For nZ := 1 to Len(aUser)
               IF !UsuBloq(aUser[nZ])
                    For nY:= 1 to Len(aUser[nZ][3])
                         IF AllTrim(cMod) == SubStr(aUser[nZ][3][nY],1,2)
                              IF SubStr(aUser[nZ][3][nY],3,1) == '5'
                                   cRetG += Chr(10) + aUser[nZ][1][1] + ' - ' + aUser[nZ][1][2] + ' - '+ SubStr(aUser[nZ][3][nY],12)
                              ENDIF
                         EndIf
                    Next nY
               ENDIF
          Next nZ
     ElseIf !Empty(cUser) // Informou o usuario
          IF PswSeek(cUser)
               aInfo   := PswRet(1)
               aPer    := PswRet(2)
               aMenus  := PswRet(3)
               cTitulo := 'Menus do usuário ' + cUser + ' - ' + aInfo[1][2]
               cRetG += Chr(10) + aInfo[1][1] + ' - ' + aInfo[1][2] + ' - ' + IIF(aInfo[1][17],'Bloqueado','Ativo')
               For nX := 1 to Len(aMenus[1])
                    IF SubStr(aMenus[1][nX],3,1) == '5'
                         cRetG += Chr(10) + SubStr(aMenus[1][nX],1,2) + ' - '  + SubStr(aMenus[1][nX],12)
                    ENDIF
               Next
               cRetE += Chr(10) + ' Nome:            '  + aInfo[1][4]
               cRetE += Chr(10) + ' E-mail:          '  + aInfo[1][14]
               cRetE += Chr(10) + ' Retroceder data: '  + cvaltochar(aInfo[1][23][2])
               cRetE += Chr(10) + ' Avançar data:    '  + cvaltochar(aInfo[1][23][3])
          ELSE
               cRetG := ''
               cRetG := ''
          ENDIF
     ElseIF lAltData // Retroceder e avançar data base
          cTitulo := 'Permissões para alteração da database '
          For nY:= 1 to Len(aUser)
               IF aUser[nY][1][23][1] .AND. !(aUser[nY][1][17]) //
                    cRetG += Chr(10) + aUser[nY][1][1] + ' - ' + aUser[nY][1][2]
                    cRetG += Chr(10) + Chr(13) + Chr(13) + 'Retroceder: ' + cValToChar(aUser[nY][1][23][2])
                    cRetG += Chr(10) + Chr(13) + Chr(13) + 'Avançar:    ' + cValToChar(aUser[nY][1][23][3])
               ENDIF
          Next
     ELSE
          Return
     ENDIF

     IF Empty(cRetG)
          cRetG := "......... sem informações."
     ENDIF
     IF Empty(cRetE)
          cRetE := "......... sem informações."
     ENDIF

     oDlg:Refresh()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} UsuBloq
@type     User Function
     Verifica se o usuario esta bloqueado
@author   Diego Andrade
@since    21/12/20
@version  12.1.25
@param    aUsu,array que contém as informacoes do usuarios.
@return
@table
@obs
          aUsu[1][17] = .T. = BLOQUEADO
@history
/*/
//-------------------------------------------------------------------
static function UsuBloq(aUsu)

     Local lRet := aUsu[1][17]

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuAtv
@type     User Function
     Verifica se o menu esta ativo
@author   Diego Andrade
@since    21/12/20
@version  12.1.25
@param    aUsu,array que contém as informacoes do usuarios.
          cMenu, codigo do modulo, com dois digitos. Ex.: 02 = compras
@return
@table
@obs
          //5 = permitido
          //X = bloqueado
@history
/*/
//-------------------------------------------------------------------
static function MenuAtv(aUsu,cMenu)

     Local cInfo    := ''
     Local cRet     := ''

     For nX:= 1 to Len(aUsu[3])
          cInfo := aUsu[3][cValToChar(nX)]
          IF SubStr(cInfo,1,2) == cMenu
               IF SubStr(cInfo,3,1) == '5'
                    cRet := SubStr(cInfo,12)
               EndIf
          EndIf
     Next

return cRet

static function LerXnu(cMenu)

     Local cConteudo := ''
     Local aConteudo := {}
     Local aRet      := {}
     Local cRet      := ''
     Local nPosIni   := 0
     Local nPosFim   := 0
     Local cStrMen   := ''
     Local cAccess   := ''

     nHandle := fopen('\SYSTEM\' + cMenu + '.XNU')
     FRead( nHandle, cConteudo,10000000)

     cConteudo := StrTran(cConteudo,">","")
     cConteudo := StrTran(cConteudo,"/","")
     cConteudo := StrTran(cConteudo,"&","")
     cConteudo := StrTran(cConteudo,'"',"")
     cConteudo := StrTran(cConteudo,'Disable',"desativado")
     cConteudo := StrTran(cConteudo,'Enable',"ativado")

     aConteudo := StrTokArr(cConteudo,'<')

     For nX:= 1 to Len(aConteudo)
          aConteudo[nX] := AllTrim(aConteudo[nX])
          DO CASE
               CASE Contem(aConteudo[nX],'Title lang=pt')
                    IF Contem(aConteudo[nX - 1],'Menu Status')
                         cRet += Chr(10) + Chr(10) + Chr(10) + Chr(09) + Chr(09) + Chr(09) + Upper(SubStr(aConteudo[nX],Len('Title lang=pt')+ 1))
                    ELSE
                         cRet += Chr(10) + Chr(10) + Chr(10) + Chr(09) + Upper(SubStr(aConteudo[nX],Len('Title lang=pt')+ 1))
                    ENDIF
                    IF At('desativado',aConteudo[nX - 1]) > 0
                         cRet += Chr(10) + Chr(09) + Chr(09) + Chr(09) + Chr(09) + Chr(09) + 'Desativado'
                    ENDIF

               CASE Contem(aConteudo[nX],'Function')
                    IF LEN(aConteudo[nX]) > 14
                         cRet += Chr(09) + Chr(09) + Chr(09) + Chr(09) + Chr(09) + '(' + SubStr(aConteudo[nX],Len('Function')+ 1,8) + ')'
                    ENDIF
               CASE Contem(aConteudo[nX],'Access')
                    cAccess := SubStr(aConteudo[nX],Len('access') + 1,5)
                    cRet += Chr(10) + Chr(10)
                    If SubStr(cAccess,1,1) == 'x'
                         cRet += Chr(09) + 'Busca'
                    ELSE
                         cRet += Chr(09) + Space(5)
                    ENDIF
                    If SubStr(cAccess,2,1) == 'x'
                         cRet += Chr(09) + 'Visualização'
                    ELSE
                         cRet += Chr(09) + Space(12)
                    ENDIF
                    If SubStr(cAccess,3,1) == 'x'
                         cRet += Chr(09) + 'Adição'
                    ELSE
                         cRet += Chr(09) + Space(6)
                    ENDIF
                    If SubStr(cAccess,4,1) == 'x'
                         cRet += Chr(09) + 'Edição'
                    ELSE
                         cRet += Chr(09) + Space(6)
                    ENDIF
                    If SubStr(cAccess,5,1) == 'x'
                         cRet += Chr(09) + 'Exclusão'
                    ELSE
                         cRet += Chr(09) + Space(8)
                    ENDIF
          END
     Next

return cRet

static function Corta(cString,cBusca)

     Local cRet := ''

     cRet := SubStr(cString,At(cBusca,cString),Len(cBusca))

return cRet

static function Contem(cString,cBusca)
     Local lRet := .F.

     IF At(cBusca,cString) > 0
          lRet := .T.
     EndIf

return lRet

static function Exportar()

     IF MemoWrite( "\\10.2.0.5\totvs 12\Microsiga\protheus_data\generico\especifico.txt",cRetE ) .AND.;
               MemoWrite( "\\10.2.0.5\totvs 12\Microsiga\protheus_data\generico\geral.txt",cRetG )
          cRetCam := '\\10.2.0.5\totvs 12\Microsiga\protheus_data\generico\'
     ENDIF

return