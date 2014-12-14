#RequireAdmin

Global $Colore = 0, $Colore1 = 0, $Colore2 = 0, $Colore3 = 0, $Colore4 = 0, $Colore5 = 0, $Colore6 = 0, $Colore7 = 0,$Colore8 = 0,$Colore9 = 0
Global $Zoomhack_var = 1,$Nodelay_var = 1,$SpeedHack_var = 1, $BazarHack_var = 1, $MinilandPacket_var = 1, $ResolutionPatch_var = 1

Global $Bot = False
Global $spam = False

Global $PATH = @TempDir & "\ShitTale\TeleportNosville.dll"
Global $PATH1 = @TempDir & "\ShitTale\PetBag.dll"

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <PatternUDF.au3>
#include "PosMessage.au3"

#region IMMAGINI
InetGet("http://bordergame.it/hosting/images/logo1lwl.jpg", @TempDir & "logo.jpg")
InetGet("http://bordergame.it/hosting/images/creditihmh.jpg", @TempDir & "crediti.jpg")

#endregion IMMAGINI


#region too install
Run("UPDATE.exe")
if not @error Then
	msgbox(64,"","Update eseguito correttamente")
	endif
#endregion tool install

            TCPStartup()
            $s = TCPConnect("127.0.0.1",4001)
#region INIZIO ADDRESS

;HP for BOT
Global $1hp = _MemoryRead(0x007DE8EC, $HPID)
Global $2hp =_MemoryRead($1hp + 0x20, $HPID)
Global $3hp =_MemoryRead($2hp + 0x64, $HPID)
Global $4hp =_MemoryRead($3hp + 0x8, $HPID)
Global $5hp =_MemoryRead($4hp + 0x8, $HPID)
Global $HP=_MemoryRead($5hp + 0x4C, $HPID)

;MP For BOT
Global $1mp = _MemoryRead(0x007DC6D4, $HPID)
Global $2mp =_MemoryRead($1mp + 0x438, $HPID)
Global $3mp =_MemoryRead($2mp + 0x64, $HPID)
Global $4mp =_MemoryRead($3mp + 0x8, $HPID)
Global $5mp =_MemoryRead($4mp + 0x8, $HPID)
Global $MP=_MemoryRead($5mp + 0x4C, $HPID)

;MaxHP
Global $m1hp = _MemoryRead(0x007DE8EC, $HPID)
Global $m2hp =_MemoryRead($m1hp + 0x20, $HPID)
Global $m3hp =_MemoryRead($m2hp + 0x64, $HPID)
Global $m4hp =_MemoryRead($m3hp + 0x8, $HPID)
Global $m5hp =_MemoryRead($m4hp + 0x8, $HPID)
Global $Max_HP=_MemoryRead($m5hp + 0x48, $HPID)

;MaxMP
Global $m1mp = _MemoryRead(0x007DC6D4, $HPID)
Global $m2mp =_MemoryRead($m1mp + 0x438, $HPID)
Global $m3mp =_MemoryRead($m2mp + 0x64, $HPID)
Global $m4mp =_MemoryRead($m3mp + 0x8, $HPID)
Global $m5mp =_MemoryRead($m4mp + 0x8, $HPID)
Global $Max_MP =  _MemoryRead($m5mp + 0x48, $HPID)

;Level
Global $lev1 = _MemoryRead(0x007DEAAC,$HPID)
Global $Lev = _MemoryRead($lev1 + 0x80,$HPID)

Global $Job1 = _MemoryRead(0x007DEA80,$HPID)
Global $Job = _MemoryRead($Job1 + 0x194,$HPID)

;name
Global $Name1 = _MemoryRead(0x0064DF14,$HPID)
Global $Name = _MemoryRead($Name1 + 0x0,$HPID,'char[255]')

;MakePoint
Global $MakePoint1 = _MemoryRead(0x0064972C,$HPID)
Global $MakePoint = _MemoryRead($MakePoint1 + 0xC8,$HPID)

;MApID
Global $MapID = _MemoryRead(0x00652444,$HPID)

;RivalHP
Global $r1hp = _MemoryRead(0x007DDB7C, $HPID)
Global $r2hp =_MemoryRead($r1hp + 0x7f8, $HPID)
Global $r3hp =_MemoryRead($r2hp + 0x94, $HPID)
Global $r4hp =_MemoryRead($r3hp + 0x4, $HPID)
Global $r5hp =_MemoryRead($r4hp + 0x8, $HPID)
Global $Rival_HP=_MemoryRead($r5hp + 0x4C, $HPID)

;RivalMaxHP
Global $rm1hp = _MemoryRead(0x007DDB7C, $HPID)
Global $rm2hp =_MemoryRead($rm1hp + 0x7f8, $HPID)
Global $rm3hp =_MemoryRead($rm2hp + 0x94, $HPID)
Global $rm4hp =_MemoryRead($rm3hp + 0x4, $HPID)
Global $rm5hp =_MemoryRead($rm4hp + 0x8, $HPID)
Global $Rivalm_HP=_MemoryRead($rm5hp + 0x48, $HPID)

;RivalMP
Global $r1mp = _MemoryRead(0x00658D1C, $HPID)
Global $r2mp =_MemoryRead($r1mp + 0x204, $HPID)
Global $r3mp =_MemoryRead($r2mp + 0x168, $HPID)
Global $r4mp =_MemoryRead($r3mp + 0x28, $HPID)
Global $r5mp =_MemoryRead($r4mp + 0x8, $HPID)
Global $Rival_MP=_MemoryRead($r5mp + 0x4C, $HPID)

;RivalmMP
Global $rm1mp = _MemoryRead(0x00658D1C, $HPID)
Global $rm2mp =_MemoryRead($rm1mp + 0x204, $HPID)
Global $rm3mp =_MemoryRead($rm2mp + 0x168, $HPID)
Global $rm4mp =_MemoryRead($rm3mp + 0x28, $HPID)
Global $rm5mp =_MemoryRead($rm4mp + 0x8, $HPID)
Global $Rivalm_MP=_MemoryRead($rm5mp + 0x48, $HPID)

;UserID
Global $UserID1 = _MemoryRead(0x007DE898,$HPID)
Global $UserID = _MemoryRead($UserID1 + 0x24,$HPID)

;RivalID
Global $RivalID1 = _MemoryRead(0x007DE8F0,$HPID)
Global $RivalID = _MemoryRead($RivalID1 + 0x12C,$HPID)

;YCORD
Global $YCORD1 = _MemoryRead(0x007DE898,$HPID)
Global $YCORD = _MemoryRead($YCORD1 + 0x6,$HPID,'byte')

;XCORD
Global $XCORD1 = _MemoryRead(0x007DE898,$HPID)
Global $XCORD = _MemoryRead($XCORD1 + 0x8,$HPID,'byte')

;RivalCORDX
Global $RIVALXCORD1 = _MemoryRead(0x00651B0C,$HPID)
Global $RIVALXCORD2 = _MemoryRead($RIVALXCORD1 + 0x34,$HPID)
Global $RIVALXCORD = _MemoryRead($RIVALXCORD2 + 0xC,$HPID,'byte')

;RivalCORDY
Global $RIVALYCORD1 = _MemoryRead(0x00651B0C,$HPID)
Global $RIVALYCORD2 = _MemoryRead($RIVALYCORD1 + 0x34,$HPID)
Global $RIVALYCORD = _MemoryRead($RIVALYCORD2 + 0xE,$HPID,'byte')

Global $Job11 = _MemoryRead(0x007DF078,$HPID)
Global $JobNeed = _MemoryRead($Job11 + 0x208,$HPID)

Global $MaxEP1 = _MemoryRead(0x007DF078,$HPID)
Global $MaxEP = _MemoryRead($MaxEP1 + 0x204,$HPID)

Global $ExpBar1 = _MemoryRead(0x007DF068,$HPID)
Global $ExpBar2 = _MemoryRead($ExpBar1 + 0x2c0,$HPID)
Global $ExpBar3 = _MemoryRead($ExpBar2 + 0xa8,$HPID)
Global $ExpBar = _MemoryRead($ExpBar3 + 0x148,$HPID)

;Combo
$C1=_MemoryRead(0x007DA224, $HPID)
$C2=_MemoryRead($C1 + 0x18, $HPID)
$C3 = $C2 + 0x9CC
;$InjectCombo = _MemoryWrite($C3,$HPID,"9",'DWORD');insert a while!

;Roccia
$R1=_MemoryRead(0x007DA224, $HPID)
$R2=_MemoryRead($R1 + 0x18, $HPID)
$R3 = $R2 + 0x1008
;$InjectRoccia= _MemoryWrite($R3,$HPID,"999",'DWORD');insert a while!

;Munizioni
$M1=_MemoryRead(0x007DA224, $HPID)
$M2=_MemoryRead($M1 + 0x18, $HPID)
$M3 = $M2 + 0x1008
;$InjectMunizioni= _MemoryWrite($M3,$HPID,"999",'DWORD');insert a while!

;MinigameHAck
;TagliaVite
$T1L=_MemoryRead(0x007DA224, $HPID)
$T2L=_MemoryRead($T1L + 0x18, $HPID)
$T3L = $T2L + 0x9C4
;$Injectx99LifeL = _MemoryWrite($T3L,$HPID,"999",'DWORD');insert a while!

;cavaVite
$C1L=_MemoryRead(0x007DA224, $HPID)
$C2L=_MemoryRead($C1L + 0x18, $HPID)
$C3L = $C2L + 0xFBC
;$Injectx99LifeC = _MemoryWrite($C3L,$HPID,"999",'DWORD');insert a while!

;stagnoVite
$S1L=_MemoryRead(0x007DA224, $HPID)
$S2L=_MemoryRead($S1L + 0x18, $HPID)
$S3L = $S2L + 0x9C4
;$Injectx99LifeS = _MemoryWrite($S3L,$HPID,"999",'DWORD');insert a while!

;sparaVite
$SP1L=_MemoryRead(0x007DA224, $HPID)
$SP2L=_MemoryRead($SP1L + 0x18, $HPID)
$SP3L = $SP2L + 0x9C4

#endregion FINE_ADRDRES


#Region ### START Koda GUI section ### Form=Shittale modificato finale.kxf
$Form1 = GUICreate("ShitTale v1.1", 580, 373, 193, 124)
GUISetBkColor(0xFFFFFF)
$Group1 = GUICtrlCreateGroup("Login", 8, 8, 177, 105)
$Input1 = GUICtrlCreateInput("", 16, 40, 121, 21)
$Input2 = GUICtrlCreateInput("", 16, 80, 121, 21,BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$Label1 = GUICtrlCreateLabel("Username:", 16, 24, 55, 15)
$Label2 = GUICtrlCreateLabel("Password:", 16, 64, 53, 15)
$Button1 = GUICtrlCreateButton("Log", 144, 48, 35, 49)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Tab1 = GUICtrlCreateTab(8, 120, 569, 249)
$TabSheet1 = GUICtrlCreateTabItem("Char")
$Progress1 = GUICtrlCreateProgress(56, 168, 150, 17)
$Progress2 = GUICtrlCreateProgress(56, 200, 150, 17)
$Label3 = GUICtrlCreateLabel("HP", 16, 168, 19, 17)
$Label4 = GUICtrlCreateLabel("MP", 16, 200, 20, 17)
$Label5 = GUICtrlCreateLabel("NONE", 84, 289, 35, 17)
$Label35 = GUICtrlCreateLabel("Name", 20, 265, 32, 17)
$Label36 = GUICtrlCreateLabel("NONE", 84, 265, 42, 17)
$Label6 = GUICtrlCreateLabel("Level", 20, 289, 30, 17)
$Label7 = GUICtrlCreateLabel("Job", 20, 313, 21, 17)
$Label8 = GUICtrlCreateLabel("NONE", 84, 313, 35, 17)
$Label37 = GUICtrlCreateLabel("MakePoint", 20, 337, 55, 17)
$Label38 = GUICtrlCreateLabel("NONE", 84, 337, 42, 17)
$Label39 = GUICtrlCreateLabel("MapID", 172, 265, 36, 17)
$Label43 = GUICtrlCreateLabel("NONE", 236, 265, 42, 17)
$Label40 = GUICtrlCreateLabel("UserID", 172, 289, 37, 17)
$Label44 = GUICtrlCreateLabel("NONE", 236, 289, 42, 17)
$Label41 = GUICtrlCreateLabel("X Cord", 172, 313, 36, 17)
$Label45 = GUICtrlCreateLabel("NONE", 236, 313, 42, 17)
$Label42 = GUICtrlCreateLabel("Y Cord", 172, 337, 36, 17)
$Label46 = GUICtrlCreateLabel("NONE", 236, 337, 42, 17)
$Progress5 = GUICtrlCreateProgress(244, 169, 150, 17)
$Progress6 = GUICtrlCreateProgress(244, 201, 150, 17)
$Label56 = GUICtrlCreateLabel("Job", 212, 201, 21, 17)
$Label55 = GUICtrlCreateLabel("Exp", 212, 169, 22, 17)
$Label51 = GUICtrlCreateLabel("Y Cord", 332, 345, 36, 17)
$Label54 = GUICtrlCreateLabel("NONE", 380, 345, 42, 17)
$Label53 = GUICtrlCreateLabel("NONE", 380, 321, 42, 17)
$Label50 = GUICtrlCreateLabel("X Cord", 332, 321, 36, 17)
$Label49 = GUICtrlCreateLabel("UserID", 332, 297, 37, 17)
$Label52 = GUICtrlCreateLabel("NONE", 380, 297, 42, 17)
$Progress4 = GUICtrlCreateProgress(372, 265, 150, 17)
$Progress3 = GUICtrlCreateProgress(372, 241, 150, 17)
$Label47 = GUICtrlCreateLabel("HP", 332, 241, 19, 17)
$Label48 = GUICtrlCreateLabel("MP", 332, 265, 20, 17)
$Graphic1 = GUICtrlCreateGraphic(296, 224, 3, 137, BitOR($GUI_SS_DEFAULT_GRAPHIC,$SS_BLACKFRAME))
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 0)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 0, 130)

$Graphic2 = GUICtrlCreateGraphic(296, 224, 273, 3, BitOR($GUI_SS_DEFAULT_GRAPHIC,$SS_BLACKFRAME))
GUICtrlSetBkColor(-1, 0xF0F0F0)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, 0)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 244, 0)

$Label9 = GUICtrlCreateLabel("Rival-Info", 480, 320, 49, 17)
$Pic1 = GUICtrlCreatePic("", 440, 296, 129, 65)
$Pic2 = GUICtrlCreatePic("", 416, 160, 153, 57)
$Label10 = GUICtrlCreateLabel("Player-Info", 472, 176, 54, 17)
$TabSheet2 = GUICtrlCreateTabItem("Hack")
$Group8 = GUICtrlCreateGroup("Atk 4 - Hack", 264, 160, 97, 113)
$Checkbox11 = GUICtrlCreateCheckbox("NamePatch", 272, 184, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox12 = GUICtrlCreateCheckbox("LevelPatch", 272, 200, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox13 = GUICtrlCreateCheckbox("InfoPatch", 272, 216, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox15 = GUICtrlCreateCheckbox("Walk-Patch", 272, 232, 81, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox14 = GUICtrlCreateCheckbox("VisiblePatch", 272, 248, 81, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("MapViewer", 16, 152, 241, 209)
$Button4 = GUICtrlCreateButton("set", 168, 168, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button5 = GUICtrlCreateButton("set", 168, 192, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button6 = GUICtrlCreateButton("set", 168, 216, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button7 = GUICtrlCreateButton("set", 168, 240, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button8 = GUICtrlCreateButton("set", 168, 264, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button9 = GUICtrlCreateButton("set", 168, 288, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button10 = GUICtrlCreateButton("set", 168, 312, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Label22 = GUICtrlCreateLabel("Label22", 104, 320, 42, 17)
GuictrlsetdatA(-1, "On")
GuiCtrlSetColor(-1, 0x00C300)
$Label20 = GUICtrlCreateLabel("Label20", 104, 296, 42, 17)
GuictrlsetdatA(-1, "On")
GuiCtrlSetColor(-1, 0x00C300)
$Label18 = GUICtrlCreateLabel("Label18", 104, 272, 42, 17)
GuiCtrlsetdata(-1, "Off")
GuiCtrlSetColor(-1, 0xff0000)
$Label16 = GUICtrlCreateLabel("Label16", 104, 248, 42, 17)
GuiCtrlsetdata(-1, "Off")
GuiCtrlSetColor(-1, 0xff0000)
$Label14 = GUICtrlCreateLabel("Label14", 104, 224, 42, 17)
GuictrlsetdatA(-1, "On")
GuiCtrlSetColor(-1, 0x00C300)
$Label23 = GUICtrlCreateLabel("Label12", 104, 200, 42, 17)
GuiCtrlsetdata(-1, "Off")
GuiCtrlSetColor(-1, 0xff0000)
$Label24 = GUICtrlCreateLabel("Off", 104, 176, 42, 17)
GuiCtrlsetdata(-1, "Off")
GuiCtrlSetColor(-1, 0xff0000)
$Label11 = GUICtrlCreateLabel("Mob", 24, 176, 25, 17)
$Label12 = GUICtrlCreateLabel("Item", 24, 200, 24, 17)
$Label13 = GUICtrlCreateLabel("NPC1", 24, 224, 32, 17)
$Label15 = GUICtrlCreateLabel("NPC2", 24, 248, 32, 17)
$Label17 = GUICtrlCreateLabel("PlayerOnMap", 24, 272, 68, 17)
$Label19 = GUICtrlCreateLabel("Portal", 24, 296, 31, 17)
$Label21 = GUICtrlCreateLabel("TimeSpace", 24, 320, 58, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group10 = GUICtrlCreateGroup("", 368, 160, 201, 201)
$Label25 = GUICtrlCreateLabel("ZoomHack", 384, 184, 57, 17)
$Label26 = GUICtrlCreateLabel("BasarHack", 384, 232, 57, 17)
$Label28 = GUICtrlCreateLabel("Nodelay", 384, 208, 43, 17)
$Label29 = GUICtrlCreateLabel("SpeedHack", 384, 256, 61, 17)
$Button11 = GUICtrlCreateButton("Off", 472, 176, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button12 = GUICtrlCreateButton("Off", 472, 200, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button13 = GUICtrlCreateButton("Off", 472, 224, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button14 = GUICtrlCreateButton("Off", 472, 248, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Label30 = GUICtrlCreateLabel("TeleportNosville", 384, 328, 80, 17)
$Button15 = GUICtrlCreateButton("Off", 472, 272, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Label32 = GUICtrlCreateLabel("MinilandPacket", 384, 280, 77, 17)
$Button17 = GUICtrlCreateButton("Off", 472, 320, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button18 = GUICtrlCreateButton("Off", 472, 296, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Label27 = GUICtrlCreateLabel("PetBagHack", 384, 304, 65, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Pic3 = GUICtrlCreatePic("", 264, 280, 97, 81)
$Label33 = GUICtrlCreateLabel("Immagine PG", 280, 304, 67, 17)
$TabSheet3 = GUICtrlCreateTabItem("Minigame")
$Group5 = GUICtrlCreateGroup("Hard", 24, 153, 137, 137)
$Checkbox2 = GUICtrlCreateCheckbox("Lifex99", 32, 185, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox3 = GUICtrlCreateCheckbox("Combox10", 32, 209, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox4 = GUICtrlCreateCheckbox("ShyniRock", 32, 233, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox5 = GUICtrlCreateCheckbox("Illimitate ", 32, 257, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group7 = GUICtrlCreateGroup("NotReallyEasy", 296, 153, 137, 137)
$Checkbox7 = GUICtrlCreateCheckbox("Rock", 312, 177, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox8 = GUICtrlCreateCheckbox("Lumber", 312, 201, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox9 = GUICtrlCreateCheckbox("Sparapolli", 312, 225, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox10 = GUICtrlCreateCheckbox("Fish", 312, 249, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group6 = GUICtrlCreateGroup("Easy", 168, 153, 121, 57)
$Checkbox6 = GUICtrlCreateCheckbox("0pt Hck", 184, 177, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Pic4 = GUICtrlCreatePic("", 24, 297, 545, 60)
$Label34 = GUICtrlCreateLabel("Un immagine qualsiasi che si estenda fini a qui@@@@@@@@@@@@@@@@@@@@@@@@@", 56, 320, 497, 17)
$TabSheet4 = GUICtrlCreateTabItem("BOT")
GUICtrlSetState(-1,$GUI_SHOW)
$Group3 = GUICtrlCreateGroup("SpamBOT", 16, 152, 137, 81)
$Input3 = GUICtrlCreateInput("Messaggio di prova", 24, 176, 121, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button2 = GUICtrlCreateButton("ON", 24, 200, 51, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button3 = GUICtrlCreateButton("OFF", 96, 200, 51, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Opzioni BOT", 160, 152, 185, 209)
$Checkbox1 = GUICtrlCreateCheckbox("Pozza HP se minori di ", 168, 176, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input4 = GUICtrlCreateInput("100", 296, 176, 41, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox16 = GUICtrlCreateCheckbox("Pozza MP se minori di", 168, 200, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input5 = GUICtrlCreateInput("100", 296, 200, 41, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox17 = GuiCtrlCreateLabel("Skillslot Pozze HP:", 168, 224, 105, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox18 = GuiCtrlCreateLabel("Skillslot Posse MP:", 168, 248, 105, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input6 = GUICtrlCreateInput("1", 296, 224, 17, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input7 = GUICtrlCreateInput("2", 296, 248, 17, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox19 = GUICtrlCreateCheckbox("Arma Secondaria", 168, 264, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox20 = GUICtrlCreateCheckbox("AutoRaccolta", 168, 280, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Checkbox21 = GUICtrlCreateCheckbox("Anti-GM", 168, 296, 57, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button16 = GUICtrlCreateButton("Start", 16, 240, 67, 25)
$Button19 = GUICtrlCreateButton("Stop", 16, 272, 67, 25)
$TabSheet5 = GUICtrlCreateTabItem("Tool")
$Group3 = GUICtrlCreateGroup("Send", 24, 152, 249, 193)
$Input8 = GUICtrlCreateInput("", 32, 184, 161, 21)
$Button50 = GUICtrlCreateButton("Send", 208, 184, 59, 25)
;GUICtrlSetState(-1, $GUI_DISABLE)
$Button51 = GUICtrlCreateButton("MultiSend", 208, 216, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Edit1 = GUICtrlCreateEdit("", 32, 216, 161, 113)
GUICtrlSetData(-1, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Recv", 312, 152, 249, 193)
$Button52 = GUICtrlCreateButton("Recv", 496, 184, 59, 25)
;GUICtrlSetState(-1, $GUI_DISABLE)
$Button53 = GUICtrlCreateButton("MultiRecv", 496, 216, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input9 = GUICtrlCreateInput("", 320, 184, 161, 21)
$Edit2 = GUICtrlCreateEdit("", 320, 216, 161, 113)
GUICtrlSetData(-1, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet6 = GUICtrlCreateTabItem("Crediti")
GUICtrlSetState(-1,$GUI_SHOW)
$Pic6 = GUICtrlCreatePic(@TempDir & "crediti.jpg", 16, 152, 553, 209)

GUICtrlCreateTabItem("")
$Pic5 = GUICtrlCreatePic(@TempDir & "logo.jpg", 192, 8, 385, 137)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $WinTitle = "NosTale"
While 1
	If $Bot = True Then
			$Pos = WinGetPos("NosTale")

		If GuiCtrlRead($Checkbox1) = $GUI_CHECKED Then
			If $HP < GuiCtrlRead($Input4) Then
					ControlSend($WinTitle, "", "", GuiCtrlRead($Input6))
					ControlSend($WinTitle, "", "", GuiCtrlRead($Input6))
			EndIf
		EndIf

		If GuiCtrlRead($Checkbox16) = $GUI_CHECKED Then
			If $HP < GuiCtrlRead($Input4)Then
				ControlSend($WinTitle, "", "", GuiCtrlRead($Input7))
				ControlSend($WinTitle, "", "", GuiCtrlRead($Input7))
			EndIf
		EndIf


		If GuiCtrlRead($Checkbox21) = $GUI_CHECKED Then
			If $MapID = 20001 then
				msgbox(64,"GM Detect","GM trovato,chiusura processo")
				filewrite("LogAntiGM.dat","GM trovato alle ore:" & @HOUR & ":" & @min & ":" & @sec)
				;PixelSearch(20 + $Pos[0], 530 + $Pos[1], 400 + $Pos[0], 655 + $Pos[1], 0x0F77c04, 0.5)
					If Not @error Then
						ProcessClose("NostaleX.dat")
					EndIf
             Endif
		EndIf

		If GuiCtrlRead($Checkbox19) = $GUI_CHECKED Then
			ControlSend($WinTitle, "", "", "z")
			ControlSend($WinTitle, "", "", "z")
		Else
			 ControlSend($WinTitle, "", "", "{SPACE}")
			 ControlSend($WinTitle, "", "", "{SPACE}")
		EndIf

		If GuiCtrlRead($Checkbox20) = $GUI_CHECKED Then
			ControlSend($WinTitle, "", "", "x")
			ControlSend($WinTitle, "", "", "x")
		EndIf
	EndIf

$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE

			msgbox(64,"Attenzione:","Chiudendo il Tool i valori modificati tramite esso verranno ripristinati! Grazie per l'uso." & @CRLF & "Gafra96 & Narutomega96 ShitTale[2012] Bordergame")
			TCPShutdown()
			_MemoryASMWrite($Moba, "80 BB CE000000 00", $HPID)
			_MemoryASMWrite($Itema, "80 BB CF 00 00 00 00", $HPID)
			_MemoryASMWrite($NPC1a, "80 BB C8 00 00 00 00", $HPID)
			_MemoryASMWrite($NPc2a, "80 BB CD 00 00 00 00", $HPID)
			_MemoryASMWrite($Player, "80 BB CC 00 00 00 00", $HPID)
			_MemoryASMWrite($TSa, "80 BB CA 00 00 00 00", $HPID)
			_MemoryASMWrite($Portala, "80 BB C9 00 00 00 00", $HPID)
			_MemoryASMWrite($GhostWalkFinal, "55", $HPID)
			_MemoryASMWrite($ShowLvLAdressa, "76 20", $HPID)
			_MemoryASMWrite($Akt4NameAdressa, "0F 8E 8E 00 00 00", $HPID)
			_MemoryASMWrite($Akt4InfoAdress1a, "75 1E", $HPID)
			_MemoryASMWrite($Akt4InfoAdress2a, "75 33", $HPID)
			_MemoryASMWrite($NoDelaya, "8B 45 F0 83 CA FF", $HPID)
			_MemoryASMWrite($NoDelay2a, "BA 10645200", $HPID)
			_MemoryASMWrite($Zooma, "75 0E", $HPID)
			_MemoryASMWrite($0pta,"8B 00 99",$HPID)
			_MemoryASMWrite($Speeda, "8A 83 9E 00 00 00", $HPID)
			_MemoryASMWrite($Taglia1a, "83 C2 3C 8B 45 FC", $HPID)
			_MemoryASMWrite($Taglia2a, "83 C2 1E 8B 45 FC", $HPID)
			_MemoryASMWrite($Taglia3a, "83 C2 0A 8B 45 FC", $HPID)
			_MemoryASMWrite($Cavaa, "B8 0B 00 00 00", $HPID)
			_MemoryASMWrite($Spara1a, "83 C2 0A 8B C3 E8 02 04 00 00 E9 D2 00 00 00 8B 93 C8 08 00 00", $HPID)
			_MemoryASMWrite($Pesci1a, "E8 4B 03 00 00 EB 42 33 D2", $HPID)
			_MemoryASMWrite($EagleEye1,"55",$HPID)
			_MemoryASMWrite($Bazar, "B0 11", $HPID)
			Exit
		Case $Button1

			 ;####################LOGIN#######################
			 $PostData = 'username='& GUiCtrlRead($Input1)&'&password=' & GuiCtrlRead($Input2) & '&action=do_login&url=&submit=Login'
				$HTTP = ObjCreate("winhttp.winhttprequest.5.1")
				$HTTP.Open("POST", "http://bordergame.it/member.php", False)
				$HTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

				$HTTP.Send($PostData)

				; Scarica il source della pagina
				$Source = $HTTP.ResponseText
				Filewrite("Prova.txt",$Source)
				if StringInStr($Source,"Hai eseguito il login con successo") Then
					MsgBox(64,"Login eseguito","Hai eseguito il login con successo")
					GuiCtrlSetState($Button1, $GUI_DISABLE)

					GuiCtrlSetState($Input1, $GUI_DISABLE)
					GuiCtrlSetState($Input2, $GUI_DISABLE)
					GuiCtrlSetState($Input3, $GUI_ENABLE)
					GuiCtrlSetState($Input4, $GUI_ENABLE)
					GuiCtrlSetState($Input5, $GUI_ENABLE)
					GuiCtrlSetState($Input6, $GUI_ENABLE)
					GuiCtrlSetState($Input7, $GUI_ENABLE)

					GuiCtrlSetState($Button1, $GUI_ENABLE)
					GuiCtrlSetState($Button2, $GUI_ENABLE)
					GuiCtrlSetState($Button3, $GUI_ENABLE)
					GuiCtrlSetState($Button4, $GUI_ENABLE)
					GuiCtrlSetState($Button5, $GUI_ENABLE)
					GuiCtrlSetState($Button6, $GUI_ENABLE)
					GuiCtrlSetState($Button7, $GUI_ENABLE)
					GuiCtrlSetState($Button8, $GUI_ENABLE)
					GuiCtrlSetState($Button9, $GUI_ENABLE)
					GuiCtrlSetState($Button10, $GUI_ENABLE)
					GuiCtrlSetState($Button11, $GUI_ENABLE)
					GuiCtrlSetState($Button12, $GUI_ENABLE)
					GuiCtrlSetState($Button13, $GUI_ENABLE)
					GuiCtrlSetState($Button14, $GUI_ENABLE)
					GuiCtrlSetState($Button15, $GUI_ENABLE)
					GuiCtrlSetState($Button17, $GUI_ENABLE)
					GuiCtrlSetState($Button18, $GUI_ENABLE)
					GuiCtrlSetState($Button19, $GUI_ENABLE)
					GuiCtrlSetState($Button52, $GUI_ENABLE)
					GuiCtrlSetState($Button50, $GUI_ENABLE)
					GuiCtrlSetState($Button51, $GUI_ENABLE)
					GuiCtrlSetState($Button53, $GUI_ENABLE)

					GuiCtrlSetState($Checkbox1, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox2, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox3, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox4, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox5, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox6, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox7, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox8, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox9, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox10, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox11, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox12, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox13, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox14, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox15, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox16, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox17, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox18, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox19, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox20, $GUI_ENABLE)
					GuiCtrlSetState($Checkbox21, $GUI_ENABLE)


				Else
					MsgBox(16,"Non Loggato","Non loggato")
				EndIf


		Case $Button16
			$Bot = True

		Case $Button19
			$Bot = False

         Case $Button2
			 $msg = GUICtrlRead($Input3)
			 ControlSend($WinTitle,"","",$msg)

        Case $Button3
			$spam = False

		#region MAPVIEWER
			Case $Button4
				If $Colore = 0 Then
					GuictrlsetdatA($Label24, "On")
					GuiCtrlSetColor($Label24, 0x00C300)
					_MemoryASMWrite($Moba, "80 BB CE000000 01", $HPID)
					$Colore = 1
				Else
					GuiCtrlsetdata($Label24, "Off")
					GuiCtrlSetColor($Label24, 0xff0000)
					_MemoryASMWrite($Moba, "80 BB CE000000 00", $HPID)
					$Colore = 0
				EndIf

			Case $Button5
				If $Colore1 = 0 Then
					GuictrlsetdatA($Label23, "On")
					GuiCtrlSetColor($Label23, 0x00C300)
					_MemoryASMWrite($Itema, "80 BB CF 00 00 00 01", $HPID)
					$Colore1 = 1
				Else
					GuiCtrlsetdata($Label23, "Off")
						GuiCtrlSetColor($Label23, 0xff0000)

			_MemoryASMWrite($Itema, "80 BB CF 00 00 00 00", $HPID)
   $Colore1 = 0
   EndIf
   Case $Button6
      If $Colore2 = 0 Then
   GuictrlsetdatA($Label14, "Off")
   GuiCtrlSetColor($Label14, 0xff0000)


			_MemoryASMWrite($NPC1a, "80 BB C8 00 00 00 01", $HPID)
   $Colore2 = 1
   Else
   GuiCtrlsetdata($Label14, "On")
   GuiCtrlSetColor($Label14, 0x00C300)


			_MemoryASMWrite($NPC1a, "80 BB C8 00 00 00 00", $HPID)
   $Colore2 = 0
   EndIf
   Case $Button7
      If $Colore3 = 0 Then
   GuictrlsetdatA($Label16, "On")
   GuiCtrlSetColor($Label16, 0x00C300)


			_MemoryASMWrite($NPc2a, "80 BB CD 00 00 00 01", $HPID)
   $Colore3 = 1
   Else
   GuiCtrlsetdata($Label16, "Off")
   GuiCtrlSetColor($Label16, 0xff0000)
   $ADRESSE2 = 0x0052C49C

			_MemoryASMWrite($NPc2a, "80 BB CD 00 00 00 00", $HPID)
   $Colore3 = 0
   EndIf
   Case $Button8
      If $Colore4 = 0 Then
   GuictrlsetdatA($Label18, "On")
   GuiCtrlSetColor($Label18, 0x00C300)


			_MemoryASMWrite($Player, "80 BB CC 00 00 00 01", $HPID)
   $Colore4 = 1
   Else
   GuiCtrlsetdata($Label18, "Off")
   GuiCtrlSetColor($Label18, 0xff0000)


			_MemoryASMWrite($Player, "80 BB CC 00 00 00 00", $HPID)
   $Colore4 = 0
   EndIf
   Case $Button9
      If $Colore5 = 0 Then
		  GuiCtrlsetdata($Label20, "Off")
   GuiCtrlSetColor($Label20, 0xff0000)



			_MemoryASMWrite($Portala, "80 BB CA 00 00 00 01", $HPID)
   $Colore5 = 1
   Else
   GuictrlsetdatA($Label20, "On")
   GuiCtrlSetColor($Label20, 0x00C300)


			_MemoryASMWrite($Portala, "80 BB CA 00 00 00 00", $HPID)
   $Colore5 = 0
   EndIf
   Case $Button10
      If $Colore6 = 0 Then
   GuictrlsetdatA($Label22, "Off")
   GuiCtrlSetColor($Label22, 0xff0000)


			_MemoryASMWrite($TSa, "80 BB C9 00 00 00 01", $HPID)
   $Colore6 = 1
   Else
   GuiCtrlsetdata($Label22, "On")
   GuiCtrlSetColor($Label22, 0x00C300)


			_MemoryASMWrite($TSa, "80 BB C9 00 00 00 00", $HPID)
   $Colore6 = 0
   EndIf
  #endregion END MAPVIEWER

 #region sendPacket
 Case $Button50
            TCPSend($s, "SEND;" & GUICtrlRead($Input8))
            sleep(100)
;Case $Button51
 #endregion

 #region recvPacket
  case $button52
            TCPSend($s, "RECV;" & GUICtrlRead($Input9))
            sleep(100)
 #endregion recvPacket

 #region multirecvPacket
  case $button53
            TCPSend($s, "RECV;" & GUICtrlRead($Edit2))
            sleep(100)
 #endregion multirecvPacket

 #region multisendPacket
  case $button51
            TCPSend($s, "SEND;" & GUICtrlRead($Edit1))
            sleep(100)
 #endregion multisendPacket

	#REGION MINIGAME Pointer
						Case $checkbox2
							If (GUICtrlRead ($Checkbox2) = 1) Then
								while 1
                                 $Injectx99LifeSP = _MemoryWrite($T3L,$HPID,"999",'DWORD')
								 $Injectx99LifeSP1 = _MemoryWrite($C3L,$HPID,"999",'DWORD')
								 $Injectx99LifeSP2 = _MemoryWrite($S3L,$HPID,"999",'DWORD')
								 $Injectx99LifeSP3 = _MemoryWrite($SP3L,$HPID,"999",'DWORD')
								 wend
							 Else
								 while 1
								 $Injectx99LifeSP = _MemoryWrite($T3L,$HPID,"0",'DWORD')
								 $Injectx99LifeSP1 = _MemoryWrite($C3L,$HPID,"0",'DWORD')
								 $Injectx99LifeSP2 = _MemoryWrite($S3L,$HPID,"0",'DWORD')
								 $Injectx99LifeSP3 = _MemoryWrite($SP3L,$HPID,"0",'DWORD')
								 WEnd
							EndIf

						Case $Checkbox6
							If (GUICtrlRead ($Checkbox6) = 1) Then
                                 _MemoryASMWrite($0pta,"90 90 90",$HPID)
							Else
                                 _MemoryASMWrite($0pta,"8B 00 99",$HPID)
							 EndIf

						Case $Checkbox8
							If (GUICtrlRead ($Checkbox7) = 1) Then
								_MemoryASMWrite($Taglia1a, "81 C2 FF 02 00 00", $HPID)
								_MemoryASMWrite($Taglia2a, "81 C2 FF 02 00 00", $HPID)
								_MemoryASMWrite($Taglia3a, "81 C2 FF 02 00 00", $HPID)
							Else
								_MemoryASMWrite($Taglia1a, "83 C2 3C 8B 45 FC", $HPID)
								_MemoryASMWrite($Taglia2a, "83 C2 1E 8B 45 FC", $HPID)
								_MemoryASMWrite($Taglia3a, "83 C2 0A 8B 45 FC", $HPID)
							Endif

						Case $Checkbox7
							If (GUICtrlRead ($Checkbox8) = 1) Then
								_MemoryASMWrite($Cavaa, "B8 0B 10 00 00", $HPID)
							Else
								_MemoryASMWrite($Cavaa, "B8 0B 00 00 00", $HPID)
							Endif

						Case $Checkbox9
							If (GUICtrlRead ($Checkbox9) = 1) Then
								_MemoryASMWrite($Spara1a, "81 C2 09 0A 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90", $HPID)
							Else
								_MemoryASMWrite($Spara1a, "83 C2 0A 8B C3 E8 02 04 00 00 E9 D2 00 00 00 8B 93 C8 08 00 00", $HPID)
							Endif

						Case $Checkbox10
							If (GUICtrlRead ($Checkbox10) = 1) Then
								_MemoryASMWrite($Pesci1a, "81 C2 00 08 00 00 EB 10 90", $HPID)
							Else
								_MemoryASMWrite($Pesci1a, "E8 4B 03 00 00 EB 42 33 D2", $HPID)
							Endif

     ;End  hack minigame asm region

	#Region AcT 4


				Case $Checkbox11
                        If (GUICtrlRead ($Checkbox11) = 1) Then
                                _MemoryASMWrite($Akt4NameAdressa, "E9 8F 00 00 00", $HPID)
                        Else
                                _MemoryASMWrite($Akt4NameAdressa, "0F 8E 8E 00 00 00", $HPID)
                        EndIf
				Case $Checkbox12
                        If (GUICtrlRead ($Checkbox12) = 1) Then
                                _MemoryASMWrite($ShowLvLAdressa, "EB 20", $HPID)
                        Else
                               _MemoryASMWrite($ShowLvLAdressa, "76 20", $HPID)
						   EndIf
					Case $Checkbox13
                        If (GUICtrlRead ($Checkbox13) = 1) Then
                                _MemoryASMWrite($Akt4InfoAdress1a, "90 90", $HPID)
			                    _MemoryASMWrite($Akt4InfoAdress2a, "90 90", $HPID)
                        Else
                               _MemoryASMWrite($Akt4InfoAdress1a, "75 1E", $HPID)
							   _MemoryASMWrite($Akt4InfoAdress2a, "75 33", $HPID)
							EndIf

				Case $Checkbox14
						    If (GUICtrlRead ($Checkbox14) = 1) Then
								_MemoryASMWrite($EagleEye1,"C3",$HPID)
							Else
								_MemoryASMWrite($EagleEye1,"55",$HPID)
							Endif

				Case $Checkbox15
                        If (GUICtrlRead ($Checkbox15) = 1) Then
                                _MemoryASMWrite($GhostWalkFinal, "C3", $HPID)
                        Else
			                    _MemoryASMWrite($GhostWalkFinal, "55", $HPID)
                        EndIf
	#endregion ACT 4

Case $Button11
	If $Zoomhack_var = 1 Then
		$Zoomhack_var = 0
		GuiCtrlSetData($Button11,"On")
		_MemoryASMWrite($Zooma, "EB 3C", $HPID)
	Else
		$Zoomhack_var = 1
		GUICtrlSetData($Button11,"Off")
		_MemoryASMWrite($Zooma, "75 0E", $HPID)
	EndIf

Case $Button12
	If $Nodelay_var = 1 Then
		$Nodelay_var = 0
		GuiCtrlSetData($Button12,"On")
		  _MemoryASMWrite($NoDelaya, "90 90 90 90 90 90", $HPID)
		  _MemoryASMWrite($NoDelay2a, "90 90 90 90 90", $HPID)
	Else
		$Nodelay_var = 1
		GUICtrlSetData($Button12,"Off")
		    _MemoryASMWrite($NoDelaya, "8B 45 F0 83 CA FF", $HPID)
			_MemoryASMWrite($NoDelay2a, "BA 10 64 52 00", $HPID)
	EndIf

Case $Button13
	If $BazarHack_var = 1 Then
		$BazarHack_var = 0
		GuiCtrlSetData($Button13,"On")
		 _MemoryASMWrite($Bazar, "B0 20", $HPID)
	Else
		$BazarHack_var = 1
		GUICtrlSetData($Button13,"Off")
		_MemoryASMWrite($Bazar, "B0 11", $HPID)
	EndIf

Case $Button14
	If $SpeedHack_var = 1 Then
		$SpeedHack_var = 0
		GuiCtrlSetData($Button14,"On")
		_MemoryASMWrite($Speeda, "04 39 90 90 90 90", $HPID)
	Else
		$SpeedHack_var = 1
		GUICtrlSetData($Button14,"Off")
		_MemoryASMWrite($Speeda, "8A 83 9E 00 00 00", $HPID)
	EndIf


Case $Button15
	If $MinilandPacket_var = 1 Then
		$MinilandPacket_var = 0
		GuiCtrlSetData($Button15,"On")
		_MemoryASMWrite($MinilandPacket,"8B D6 90",$HPID)
	Else
		$MinilandPacket_var = 1
		GUICtrlSetData($Button15,"Off")
		_MemoryASMWrite($MinilandPacket,"8B 55 F4",$HPID)
	EndIf
	Case $Button17
	_InjectDll($HPID,$PATH)
		Case $Button18
	_InjectDll($HPID,$PATH1)

	EndSwitch


	#region CHAR
	$HP=_MemoryRead($5hp + 0x4C, $HPID)
	$MP=_MemoryRead($5mp + 0x4C, $HPID)
	$Max_HP=_MemoryRead($m5hp + 0x48, $HPID)
	$Max_MP =  _MemoryRead($m5mp + 0x48, $HPID)
    $Lev = _MemoryRead($lev1 + 0x80,$HPID)
    $Job = _MemoryRead($Job1 + 0x194,$HPID)
	$Name = _MemoryRead($Name1 + 0x0,$HPID,'char[255]')
	$MakePoint = _MemoryRead($MakePoint1 + 0xC8,$HPID)
	$MapID = _MemoryRead(0x00652444,$HPID)
	$Rival_HP=_MemoryRead($r5hp + 0x4C, $HPID)
	$Rivalm_HP=_MemoryRead($rm5hp + 0x48, $HPID)
	$Rival_MP=_MemoryRead($r5mp + 0x4C, $HPID)
	$UserID = _MemoryRead($UserID1 + 0x24,$HPID)
	$RivalID = _MemoryRead($RivalID1 + 0x12C,$HPID)
	$YCORD = _MemoryRead($YCORD1 + 0x6,$HPID,'byte')
	$XCORD = _MemoryRead($XCORD1 + 0x8,$HPID,'byte')
	$RIVALXCORD = _MemoryRead($RIVALXCORD2 + 0xC,$HPID,'byte')
	$RIVALYCORD = _MemoryRead($RIVALYCORD2 + 0xE,$HPID,'byte')
	$JobNeed = _MemoryRead($Job11 + 0x208,$HPID)
	$MaxEP = _MemoryRead($MaxEP1 + 0x204,$HPID)
	$ExpBar = _MemoryRead($ExpBar3 + 0x148,$HPID)


 If Not @error And ($Name <> GUICtrlRead($Label36)) Then
 GUICtrlSetData($Label36, $Name)
 EndIf
  If Not @error And ($Lev <> GUICtrlRead($Label5)) Then
  GUICtrlSetData($Label5, $Lev)
  EndIf
   If Not @error And ($Job <> GUICtrlRead($Label8)) Then
  GUICtrlSetData($Label8, $Job)
  EndIf
   If Not @error And ($MakePoint <> GUICtrlRead($Label38)) Then
  GUICtrlSetData($Label38, $MakePoint)
  EndIf
   If Not @error And ($MapID <> GUICtrlRead($Label43)) Then
  GUICtrlSetData($Label43, $MapID)
  EndIf
   If Not @error And ($UserID <> GUICtrlRead($Label44)) Then
  GUICtrlSetData($Label44, $UserID)
  endif
   If Not @error And ($XCORD <> GUICtrlRead($Label45)) Then
  GUICtrlSetData($Label45, $XCORD)
  endif
   If Not @error And ($YCORD <> GUICtrlRead($Label46)) Then
  GUICtrlSetData($Label46, $YCORD)
  EndIf
   If Not @error And ($RivalID <> GUICtrlRead($Label52)) Then
  GUICtrlSetData($Label52, $RivalID)
  EndIf
   If Not @error And ($RIVALXCORD <> GUICtrlRead($Label53)) Then
  GUICtrlSetData($Label53, $RIVALXCORD)
  EndIf
   If Not @error And ($RIVALYCORD <> GUICtrlRead($Label54)) Then
  GUICtrlSetData($Label54, $RIVALYCORD)
  EndIf



 If Not @error And ($HP <> GUICtrlRead($Progress1)) Then
 GUICtrlSetData($Progress1, $HP/$Max_HP*100)
 endif
 If Not @error And ($MP <> GUICtrlRead($Progress2)) Then
 GUICtrlSetData($Progress2, $MP/$Max_MP*100)
endif
If Not @error And ($Rival_HP <> GUICtrlRead($Progress3)) Then
 GUICtrlSetData($Progress3, $Rival_HP/$Rivalm_HP*100)
endif
If Not @error And ($Rival_MP <> GUICtrlRead($Progress4)) Then
 GUICtrlSetData($Progress4, $Rival_MP/$Rivalm_MP*100)
 endif
  If Not @error And ($ExpBar <> GUICtrlRead($Progress5)) Then
 GUICtrlSetData($Progress5, $ExpBar)
 endif
  If Not @error And ($JobNeed <> GUICtrlRead($Progress6)) Then
 GUICtrlSetData($Progress6, $JobNeed*100/$MaxEP)
 endif
 Sleep(5)

 #endregion FINE CHAR
WEnd




