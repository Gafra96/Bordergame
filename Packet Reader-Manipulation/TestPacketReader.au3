#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <CCInject.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>
#include <PatternUDF.au3>

Local $packets_recv[100]
Local $packets_send[1000]
Local $old_opcode_recv,$old_opcode_send
Local $found_recv,$activated=0
Global $found=$Recv
Global $send =$Send

$memopen = _memoryopen(ProcessExists("NostaleX.dat"))
$alloc_var_recv = _allocatememoryforvariable($memopen)
$allocated_arr_recv = _allocatememoryfor2darray($memopen, UBound($packets_recv), 128, "char")
$asm_code_recv = _createasm_copyregisterto2darrayex($allocated_arr_recv, $alloc_var_recv, "edx")

$alloc_var_send=_AllocateMemoryForVariable($memopen)
$allocated_arr_send = _AllocateMemoryFor2DArray($memopen,Ubound($packets_send),128,"char")
$asm_code_send = _CreateASM_CopyRegisterTo2DArrayEx($allocated_arr_send,$alloc_var_send,"edx")

#Region ### START Koda GUI section ### Form=C:\Users\Gafra96\Desktop\PremiumTestShitTale.kxf
$Form1 = GUICreate("Form1", 575, 284, 192, 124)
$Group1 = GUICtrlCreateGroup("Charakter", 16, 48, 257, 217)
$Label1 = GUICtrlCreateLabel("HP", 32, 80, 19, 17)
$Label2 = GUICtrlCreateLabel("MP", 32, 104, 20, 17)
$Progress1 = GUICtrlCreateProgress(80, 80, 150, 17)
$Progress2 = GUICtrlCreateProgress(80, 104, 150, 17)
$Label3 = GUICtrlCreateLabel("Lev", 32, 136, 22, 17)
$Label4 = GUICtrlCreateLabel("UserID", 32, 192, 37, 17)
$Label5 = GUICtrlCreateLabel("X", 32, 216, 11, 17)
$Label6 = GUICtrlCreateLabel("Y", 32, 240, 11, 17)
$Label7 = GUICtrlCreateLabel("Job", 32, 168, 21, 17)
$Label8 = GUICtrlCreateLabel("Label8", 80, 136, 36, 17)
$Label9 = GUICtrlCreateLabel("Label9", 80, 168, 36, 17)
$Label10 = GUICtrlCreateLabel("Label10", 80, 192, 42, 17)
$Label11 = GUICtrlCreateLabel("Label11", 80, 216, 42, 17)
$Label12 = GUICtrlCreateLabel("Label12", 80, 240, 42, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Rival", 288, 48, 249, 217)
$Label13 = GUICtrlCreateLabel("HP", 304, 80, 19, 17)
$Label14 = GUICtrlCreateLabel("MP", 304, 104, 20, 17)
$Label15 = GUICtrlCreateLabel("UserID", 304, 128, 37, 17)
$Label16 = GUICtrlCreateLabel("Lev", 304, 152, 22, 17)
$Label17 = GUICtrlCreateLabel("Type", 304, 176, 28, 17)
$Label19 = GUICtrlCreateLabel("Y", 312, 232, 11, 17)
$Label18 = GUICtrlCreateLabel("X", 312, 208, 11, 17)
$Label20 = GUICtrlCreateLabel("Label20", 360, 80, 42, 17)
$Label21 = GUICtrlCreateLabel("Label21", 360, 104, 42, 17)
$Label22 = GUICtrlCreateLabel("Label22", 360, 128, 42, 17)
$Label23 = GUICtrlCreateLabel("Label23", 360, 152, 42, 17)
$Label24 = GUICtrlCreateLabel("Label24", 360, 176, 42, 17)
$Label25 = GUICtrlCreateLabel("Label25", 360, 208, 42, 17)
$Label26 = GUICtrlCreateLabel("Label26", 360, 232, 42, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Button1", 32, 8, 75, 25)
$Button2 = GUICtrlCreateButton("Button2", 120, 8, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	 if IsArray($old_opcode_recv) and $activated=1 Then

		$temp1=""
        $temp2=""
        $temp3=""
		$read="st"&@crlf&"stat"&@CRLF&"walk"&@CRLF&"lev"&@CRLF&"c_info"&@crlf&"gmapr"
        $splited=StringSplit($read,@CRLF,2)


For $i = 0 To UBound($packets_recv) - 1
		$packets_recv[$i] = _readmemory2darraystring($memopen, $allocated_arr_recv, $i)
			_memoryreset2darray($memopen, $allocated_arr_recv, $i)
			$temp1 = $temp1 & $packets_recv[$i] & @CRLF
				For $i2 = 0 To UBound($splited) - 1
					If $splited[$i2] &"" AND StringRegExp($packets_recv[$i], $splited[$i2]) = 1 Then
						$temp3 = $temp3 & $packets_recv[$i] & @CRLF
						ExitLoop
					EndIf
				Next
			Next

For $i=0 To Ubound($packets_send)-1
            $packets_send[$i]=_ReadMemory2DArrayString($memopen,$allocated_arr_send,$i)
                _MemoryReset2DArray($memopen,$allocated_arr_send,$i)
                $temp2=$temp2&$packets_send[$i]&@CRLF
                    For $i2=0 To UBound($splited)-1
                        if $splited[$i2]<>"" and StringRegExp($packets_send[$i], $splited[$i2])=1 Then
                            $temp3=$temp3&$packets_send[$i]&@CRLF
                            ExitLoop
                        EndIf
                    Next
				Next


		$st = StringSplit($temp3, " ")
         if $st[1] = "st" Then
	   GUICtrlSetData($Label20, $st[7])
	   GUICtrlSetData($Label21, $st[8])
	   GUICtrlSetData($Label22, $st[3])
	   GUICtrlSetData($Label23, $st[4])
	   GUICtrlSetData($Label24, $st[2])
   EndIf

      $stat = StringSplit($temp3," ")
	  if $stat[1] = "stat" Then
		  GUICtrlSetData($Progress1, $stat[2]/$stat[3]*100)
		  GUICtrlSetData($Progress2, $stat[4]/$stat[5]*100)
       EndIf

	$walk = StringSplit($temp3," ")
	if $walk[1] = "walk" Then
		GUICtrlSetData($Label11,$walk[2])
		GUICtrlSetData($Label12,$walk[3])
	EndIf

	$c_info = StringSplit($temp3," ")
	if $c_info[1] = "c_info" Then
		GUICtrlSetData($Label10,$c_info[2])
	EndIf

	$lev = StringSplit($temp3," ")
	if $lev[1] = "lev" Then
		GUICtrlSetData($Label8,$lev[1])
		GUICtrlSetData($Label9,$lev[3])
	EndIf

$gm = StringSplit($temp3," ")
	if $gm[1] = "gmapr" Then
		msgbox(64,"Attenzione","E' entrato in game un GM!")
	EndIf



#cs mv
	$mv = StringSplit($temp3," ")
	if $mv[1] = "mv " & $st[2]&" "& $st[3] Then
		msgbox(64,"",$mv[1])
		GUICtrlSetData($Label25,$mv[4])
		GUICtrlSetData($Label26,$mv[5])
	EndIf
#ce mv
    EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			 if $activated=0 Then
        $old_opcode_recv=_InjectASMAtAddress($memopen, $found, 6, $asm_code_recv)
		$old_opcode_send=_InjectASMAtAddress($memopen, $send, 6, $asm_code_send)
        $activated=1
    EndIf

Case $Button2
	   if IsArray($old_opcode_recv) and $activated=1 Then
        _MemoryBytesWrite($memopen,$found,$old_opcode_recv[3])
		 _MemoryBytesWrite($memopen,$send,$old_opcode_send[3])
        $activated=0
    EndIf
	EndSwitch
WEnd
