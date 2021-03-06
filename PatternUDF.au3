#include-once
;=============================================================================================================================================
;Libreria Creata da Gafra96	& Naruomega96																											     ;
;AutoIt Version:   3.3.6.1 (beta)																									         ;
; Language:    Italiano																													     ;
; Platform:    All Windows system and Ubunto																							     ;
; Author:      Gafra96 & Narutomega96																											     ;
;Descrizione: Libreria per l'utilizzo dei pattern Su Nostale e non solo! Questa libreria permette di scrivere un address,pointer,ASM Inline  ;																				     ;
;==============================================================================================================================================

If Not WinExists("NosTale") = True Then
MsgBox(64,"Errore","Aprire prima Nostale!")
Exit 0
EndIf

;=============================================================================================================================================
;									                 Dichiarazione dei Pattern e dei Mask																		   																								       																																														     ;
;==============================================================================================================================================

Global Const $NoDelay = "\x8B\x45\xF0\x83\xCA\xFF\xE8\x00\x00\x00\x00\x89\x45\xFC\x8D\x4D\xEC\xBA\x00\x00\x00\x00\x8B\xC6"
Global Const $NoDelay_Mask = "xxxxxxx????xxxxxxx????xx"
Global Const $NoDelay2 = "\xBA\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x8D\x43\x20\x8B\xD6\xE8\x00\x00\x00\x00"
Global Const $NoDelay2_Mask = "x????x????xxxxxx????"
Global Const $Mob = "\x80\xBB\xCE\x00\x00\x00\x00"
Global Const $Mob_Mask = "xxx????"
Global Const $Item = "\x80\xBB\xCF\x00\x00\x00\x00"
Global Const $Item_Mask = "xxx????"
Global Const $NPC1 = "\x80\xBB\xC8\x00\x00\x00\x00\x0F\x84\x00\x00\x00\x00\x8B\x15\x00\x00\x00\x00\xA1\x00\x00\x00\x00\x8B\x00\xE8\x00\x00\x00\x00"
Global Const $NPC1_Mask = "xxxxxxxxx????xx????x????xxx????"
Global Const $NPC2 = "\x80\xBB\xCD\x00\x00\x00\x00\x0F\x84\x00\x00\x00\x00\x8B\x15\x00\x00\x00\x00\xA1\x00\x00\x00\x00"
Global Const $NPC2_Mask = "xxxxxxxxx????xx????x????"
Global Const $PlayerOnMap = "\x80\xBB\xCC\x00\x00\x00\x00\x0F\x84\x00\x00\x00\x00\x68\x00\x00\x00\x00\x33\xC9\xB2\xFF\xB0\xFF\xE8\x00\x00\x00\x00\xA1\x00\x00\x00\x00"
Global Const $PlayerOnMap_Mask = "xxxxxxxxx????x????xxxxxxx????x????"
Global Const $Zoom = "\x75\x0E\xD9\x43\x5C\xD8\x1D\x00\x00\x00\x00\xDF\xE0\x9E\x74\x2E\xD9\x05\x00\x00\x00\x00\xD8\x5B\x58\xDF\xE0\x9E\x73\x0A"
Global Const $Zoom_Mask = "xxxxxxx????xxxxxxx????xxxxxxxx"
Global Const $Speed = "\x8A\x83\x96\x00\x00\x00\x8B\x04\x85\x00\x00\x00\x00\x89\x04\x24\xE8\x00\x00\x00\x00\x89\x44\x24\x08\x33\xC0\x89\x44\x24\x0C\xDF\x6C\x24\x08\xD8\xA3\x00\x00\x00\x00\xD8\x0C\x24"
Global Const $Speed_Mask = "xx?xxxxxx????xxxx????xxxxxxxxxxxxxxxx????xxx"
Global Const $TS = "\x80\xBB\xCA\x00\x00\x00\x00\x0F\x84\x00\x00\x00\x00\xA1\x00\x00\x00\x00\xDF\x40\x04\xD8\x35\x00\x00\x00\x00"
Global Const $TS_Mask = "xxxxxxxxx????x????xxxxx????"
Global Const $Portal = "\x80\xBB\xC9\x00\x00\x00\x00\x0F\x84\x00\x00\x00\x00\xA1\x00\x00\x00\x00\xDF\x40\x04"
Global Const $Portal_Mask = "xxxxxxxxx????x????xxx"
Global Const $0PT = "\x8B\x00\x99\x52\x50\xA1\x00\x00\x00\x00\x8B\x00\x33\xD2\x33\x04\x24\x33\x54\x24\x04\x83\xC4\x08\x52\x50\x8D\x45\xF0\xE8\x00\x00\x00\x00"
Global Const $0PT_Mask ="xxxxxx????xxxxxxxxxxxxxxxxxxxx????"
Global Const $Akt4NameAdress = "\x0F\x8E\x00\x00\x00\x00\x66\xFF\xCE\x74\x11"
Global Const $Akt4NameAdress_Mask = "xx????xxxxx"
Global Const $ShowLvLAdress = "\x76\x20\x80\xC3\xFD\x80\xEB\x02\x73\x18\x8B\x86\x00\x00\x00\x00\x05\x00\x00\x00\x00\x8B\x15\x00\x00\x00\x00\x8B\x12\xE8\x00\x00\x00\x00"
Global Const $ShowLvLAdress_Mask = "xxxxxxxxxxxx????x????xx????xxx????"
Global Const $Akt4InfoAdress1 = "\x75\x1E\x6A\x01\xA1\x00\x00\x00\x00\x8B\x00"
Global Const $Akt4InfoAdress1_Mask = "xxxxx????xx"
Global Const $Akt4InfoAdress2 = "\x75\x33\x8B\x43\x08\x33\xD2\x52"
Global Const $Akt4InfoAdress2_Mask = "xxxxxxxx"
Global Const $GhostWalk = "\x55\x8B\xEC\x6A\x00\x6A\x00\x6A\x00\x6A\x00\x6A\x00\x6A\x00\x53\x56\x57\x8B\xF1\x8B\xDA\x33\xC0\x55\x68\x00\x00\x00\x00\x64\xFF\x30\x64\x89\x20\xA1\x00\x00\x00\x00"
Global Const $GhostWalk_Mask = "xxxxxxxxxxxxxxxxxxxxxxxxxx????xxxxxxx????"
Global Const $Life = "\x03\xC3\x2B\xC1\x99\x52\x50\xA1\x00\x00\x00\x00\x8B\x00\x33\xD2"
Global Const $Life_Mask ="xxxxxxxx????xxxx"
Global Const $Bad = "\x83\xC2\x0A\x8B\x45\xFC\xE8\x00\x00\x00\x00\x8B\x45\xFC\xFF\x80\x00\x00\x00\x00\x8B\x45\xFC\x05\x00\x00\x00\x00\xBA\x00\x00\x00\x00"
Global Const $Bad_Mask = "xxxxxxx????xxxxx????xxxx????x????"
Global Const $Good = "\x83\xC2\x1E\x8B\x45\xFC\xE8\x00\x00\x00\x00\x8B\x45\xFC\xFF\x80\x00\x00\x00\x00\x8B\x45\xFC\x05\x00\x00\x00\x00\xBA\x00\x00\x00\x00"
Global Const $Good_Mask = "xxxxxxx????xxxxx????xxxx????x????"
Global Const $Nice = "\x83\xC2\x3C\x8B\x45\xFC\xE8\x00\x00\x00\x00\x8B\x45\xFC\xFF\x80\x00\x00\x00\x00\x8B\x45\xFC\xFF\x80\x00\x00\x00\x00\x8B\x45\xFC\x05\x00\x00\x00\x00\xBA\x00\x00\x00\x00"
Global Const $Nice_Mask = "xxxxxxx????xxxxx????xxxxx????xxxx????x????"
Global Const $Taglia1 = "\x83\xC2\x3C\x8B\x45\xFC\xE8\x00\x00\x00\x00\x8B\x45\xFC\xFF\x80\x00\x00\x00\x00\x8B\x45\xFC"
Global Const $Taglia1_Mask = "xxxxxxx????xxxxx????xxx"
Global Const $Taglia2 = "\x83\xC2\x1E\x8B\x45\xFC\xE8\x00\x00\x00\x00\x8B\x45\xFC"
Global Const $Taglia2_Mask = "xxxxxxx????xxx"
Global Const $Taglia3 = "\x83\xC2\x0A\x8B\x45\xFC\xE8\x00\x00\x00\x00"
Global Const $Taglia3_Mask = "xxxxxxx????"
Global Const $Cava = "\xB8\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x8B\xD0\x03\x96\x00\x00\x00\x00\x83\xC2\x32"
Global Const $Cava_Mask = "x????x????xxxx????xxx"
Global Const $Pesci1 = "\xE8\x00\x00\x00\x00\xEB\x42\x33\xD2\x8A\x90\x5C\x17\x00\x00\x6B\xD2\x32\x03\x90\x00\x00\x00\x00"
Global Const $Pesci1_Mask = "x????xxxxxxxxxxxxxxx????"
Global Const $Spara1 = "\x83\xC2\x0A\x8B\xC3\xE8\x00\x00\x00\x00\xE9\x00\x00\x00\x00\x8B\x93\x00\x00\x00\x00\x83\xC2\x14"
Global Const $Spara1_Mask = "xxxxxx????x????xx????xxx"
Global Const $EagleEye1_Pattern = "\x55\x8B\xEC\x6A\x00\x6A\x00\x6A\x00\x53\x56\x57\x8B\xDA\x33\xC0\x55\x68\x00\x00\x00\x00\x64\xFF\x30\x64\x89\x20\x8B\xC3\x8B\x10\xFF\x52\x00\x83\xF8\x02\x0F\x8C\x00\x00\x00\x00\x8D\x4D\xF8\x33\xD2\x8B\xC3\x8B\x30\xFF\x56\x00\x8B\x45\xF8\x83\xCA\xFF\xE8\x00\x00\x00\x00\x89\x45\xFC\x8D\x4D\xFC\x8B\x55\xFC\xB0\x31\xE8\x00\x00\x00\x00\x8B\xF0\x85\xF6\x0F\x84\x00\x00\x00\x00\x8B\xC6\x8B\x15\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x84\xC0\x0F\x84\x00\x00\x00\x00\x8D\x4D\xF4"
Global Const $EagleEye1_Mask = "xxxxxxxxxxxxxxxxxx????xxxxxxxxxxxx?xxxxx????xxxxxxxxxxx?xxxxxxx????xxxxxxxxxxxx????xxxxxx????xxxx????x????xxxx????xxx"
Global Const $Recv_Pattern = "\x55\x8B\xEC\x83\xC4\xF4\x53\x56\x57\x33\xC9\x89\x4D\xF4\x89\x55\xFC\x8B\xD8\x8B\x45\xFC\xE8\x00\x00\x00\x00\x33\xC0\x55"
Global Const $Recv_Mask = "xxxxxxxxxxxxxxxxxxxxxxx????xxx"
Global Const $Send_Pattern = "\x53\x56\x8B\xF2\x8B\xD8\xEB\x04\xEB\x05\x39\x19\x8B\xD6\x8B\xC3\xE8\x00\x00\x00\x00\x84\xC0\x74\x1A\xE8\x00\x00\x00\x00"
Global Const $Send_Mask = "xxxxxxxxxxxxxxxxx????xxxxx????"
Global Const $MC = "\x0F\x85\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x48\x0F\x8C\x00\x00\x00\x00\x8D\x45\xEC\x50\x8D\x55\xE8\xB8\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x8B\x45\xE8\xB9\x00\x00\x00\x00\xBA\x00\x00\x00\x00\xE8\x00\x00\x00\x00\x8B\x45\xEC\xBA\x00\x00\x00\x00"
Global Const $MC_Mask = "xx????x????xxx????xxxxxxxx????x????xxxx????x????x????xxxx????"
Global Const $BazarSignature = "\xB0\x11\xE8\x00\x00\x00\x00\x84\xC0\x0F\x84\x00\x00\x00\x00\xE9\x00\x00\x00\x00\x33\xD2"
Global Const $Bazar_Mask = "xxx????xxxx????x????xx"
Global Const $MinilandSignature = "\x8B\x55\xF4\xA1\x00\x00\x00\x00\x8B\x00\xE8\x00\x00\x00\x00\x33\xC0\x5A\x59\x59\x64\x89\x10\x68\x00\x00\x00\x00\x8D\x45\xF0\xBA\x00\x00\x00\x00\xE8\x00\x00\x00\x00\xC3\xE9\x00\x00\x00\x00\xEB\xEB\x5E\x5B\x8B\xE5\x5D\xC3"
Global Const $Mini_Mask = "xxxx????xxx????xxxxxxxxx????xxxx????x????xx????xxxxxxxx"

;=============================================================================================================================================
;									                      Dichiarazione del Processo Di Nostale!															   																								       																																														     ;
;==============================================================================================================================================

Global $HPID =_MemoryOpen(ProcessExists("NostaleX.dat"))
;Global $HPID1 =_MemoryOpen(ProcessExists("Nostale.dat"))

;=============================================================================================================================================
;									                     Ricerca degli addres!	NostaleX.dat																   																								       																																														     ;
;==============================================================================================================================================

Global $Taglia1a=_MemoryPatternSearch($HPID,$Taglia1,$Taglia1_Mask)
Global $Taglia2a=_MemoryPatternSearch($HPID,$Taglia2,$Taglia2_Mask)
Global $Taglia3a=_MemoryPatternSearch($HPID,$Taglia3,$Taglia3_Mask)
Global $Cavaa=_MemoryPatternSearch($HPID,$Cava,$Cava_Mask)
Global $Pesci1a=_MemoryPatternSearch($HPID,$Pesci1,$Pesci1_Mask)
Global $Spara1a=_MemoryPatternSearch($HPID,$Spara1,$Spara1_Mask)
Global $NoDelaya=_MemoryPatternSearch($HPID,$NoDelay,$NoDelay_Mask)
Global $NoDelay2a=_MemoryPatternSearch($HPID,$NoDelay2,$NoDelay2_Mask)
Global $Itema =_MemoryPatternSearch($HPID,$Item,$Item_Mask)
Global $Moba =_MemoryPatternSearch($HPID,$Mob,$Mob_Mask)
Global $Zooma =_MemoryPatternSearch($HPID,$Zoom,$Zoom_Mask)
Global $Speeda =_MemoryPatternSearch($HPID,$Speed,$Speed_Mask)
Global $NPC1a =_MemoryPatternSearch($HPID,$NPC1,$NPC1_Mask)
Global $NPc2a =_MemoryPatternSearch($HPID,$NPC2,$NPC2_Mask)
Global $Player =_MemoryPatternSearch($HPID,$PlayerOnMap,$PlayerOnMap_Mask)
Global $TSa =_MemoryPatternSearch($HPID,$TS,$TS_Mask)
Global $Portala =_MemoryPatternSearch($HPID,$Portal,$Portal_Mask)
Global $0pta =_MemoryPatternSearch($HPID,$0PT,$0PT_Mask)
Global $Akt4NameAdressa =_MemoryPatternSearch($HPID,$Akt4NameAdress,$Akt4NameAdress_Mask)
Global $ShowLvLAdressa =_MemoryPatternSearch($HPID,$ShowLvLAdress,$ShowLvLAdress_Mask)
Global $Akt4InfoAdress1a =_MemoryPatternSearch($HPID,$Akt4InfoAdress1,$Akt4InfoAdress1_Mask)
Global $Akt4InfoAdress2a =_MemoryPatternSearch($HPID,$Akt4InfoAdress2,$Akt4InfoAdress2_Mask)
Global $GhostWalkFinal =_MemoryPatternSearch($HPID,$GhostWalk,$GhostWalk_Mask)
Global $LifeAddress=_MemoryPatternSearch($HPID,$Life,$Life_Mask)
Global $EagleEye1=_MemoryPatternSearch($HPID,$EagleEye1_Pattern,$EagleEye1_Mask)
Global $Recv =_MemoryPatternSearch($HPID,$Recv_Pattern,$Recv_Mask)
Global $Send =_MemoryPatternSearch($HPID,$Send_Pattern,$Send_Mask)
Global $MCa=_MemoryPatternSearch($HPID,$MC,$MC_Mask)
Global $Bazar=_MemoryPatternSearch($HPID,$BazarSignature,$Bazar_Mask)
Global $MinilandPacket=_MemoryPatternSearch($HPID,$MinilandSignature,$Mini_Mask)
MsgBox(0,"",$Send)

;=============================================================================================================================================
;									                     Ricerca degli addres!	Nostale.dat																   																								       																																														     ;
;==============================================================================================================================================

;Global $Taglia1a=_MemoryPatternSearch($HPID1,$Taglia1,$Taglia1_Mask)
;Global $Taglia2a=_MemoryPatternSearch($HPID1,$Taglia2,$Taglia2_Mask)
;Global $Taglia3a=_MemoryPatternSearch($HPID1,$Taglia3,$Taglia3_Mask)
;Global $Cavaaa=_MemoryPatternSearch($HPID1,$Cava,$Cava_Mask)
;Global $Pesci1a=_MemoryPatternSearch($HPID1,$Pesci1,$Pesci1_Mask)
;Global $Spara1a=_MemoryPatternSearch($HPID1,$Spara1,$Spara1_Mask)
;Global $NoDelaya=_MemoryPatternSearch($HPID1,$NoDelay,$NoDelay_Mask)
;Global $NoDelay2a=_MemoryPatternSearch($HPID1,$NoDelay2,$NoDelay2_Mask)
;Global $Itema =_MemoryPatternSearch($HPID1,$Item,$Item_Mask)
;Global $Moba =_MemoryPatternSearch($HPID1,$Mob,$Mob_Mask)
;Global $Zooma =_MemoryPatternSearch($HPID1,$Zoom,$Zoom_Mask)
;Global $Speeda =_MemoryPatternSearch($HPID1,$Speed,$Speed_Mask)
;Global $NPC1a =_MemoryPatternSearch($HPID1,$NPC1,$NPC1_Mask)
;Global $NPc2a =_MemoryPatternSearch($HPID1,$NPC2,$NPC2_Mask)
;Global $Player =_MemoryPatternSearch($HPID1,$PlayerOnMap,$PlayerOnMap_Mask)
;Global $TSa =_MemoryPatternSearch($HPID1,$TS,$TS_Mask)
;Global $Portala =_MemoryPatternSearch($HPID1,$Portal,$Portal_Mask)
;Global $0pta =_MemoryPatternSearch($HPID1,$0PT,$0PT_Mask)
;Global $Akt4NameAdressa =_MemoryPatternSearch($HPID1,$Akt4NameAdress,$Akt4NameAdress_Mask)
;Global $ShowLvLAdressa =_MemoryPatternSearch($HPID1,$ShowLvLAdress,$ShowLvLAdress_Mask)
;Global $Akt4InfoAdress1a =_MemoryPatternSearch($HPID1,$Akt4InfoAdress1,$Akt4InfoAdress1_Mask)
;Global $Akt4InfoAdress2a =_MemoryPatternSearch($HPID1,$Akt4InfoAdress2,$Akt4InfoAdress2_Mask)
;Global $GhostWalkAdress1a =_MemoryPatternSearch($HPID1,$GhostWalkAdress1,$GhostWalkAdress1_Mask)
;Global $GhostWalkAdress2a =_MemoryPatternSearch($HPID1,$GhostWalkAdress2,$GhostWalkAdress2_Mask)
;Global $LifeAddress=_MemoryPatternSearch($HPID1,$Life,$Life_Mask)
;Global $EagleEye1=_MemoryPatternSearch($HPID1,$EagleEye1_Pattern,$EagleEye1_Mask)
;Global $EagleEye2=_MemoryPatternSearch($HPID1,$EagleEye2_Pattern,$EagleEye2_Mask)
;Global $Recv =_MemoryPatternSearch($HPID1,$Recv_Pattern,$Recv_Mask)
;Global $Send =_MemoryPatternSearch($HPID1,$Send_Pattern,$Send_Mask)
;Global $MCa=_MemoryPatternSearch($HPID1,$MC,$MC_Mask)

;==================================================================================
; Function:            _MemoryOpen($iv_Pid[, $iv_DesiredAccess[, $iv_InheritHandle]])
; Description:        Opens a process and enables all possible access rights to the
;                    process.  The Process ID of the process is used to specify which
;                    process to open.  You must call this function before calling
;                    _MemoryClose(), _MemoryRead(), or _MemoryWrite().
; Parameter(s):        $iv_Pid - The Process ID of the program you want to open.
;                    $iv_DesiredAccess - (optional) Set to 0x1F0FFF by default, which
;                                        enables all possible access rights to the
;                                        process specified by the Process ID.
;                    $iv_InheritHandle - (optional) If this value is TRUE, all processes
;                                        created by this process will inherit the access
;                                        handle.  Set to 1 (TRUE) by default.  Set to 0
;                                        if you want it FALSE.
; Requirement(s):    None.
; Return Value(s):     On Success - Returns an array containing the Dll handle and an
;                                 open handle to the specified process.
;                    On Failure - Returns 0
;                    @Error - 0 = No error.
;                             1 = Invalid $iv_Pid.
;                             2 = Failed to open Kernel32.dll.
;                             3 = Failed to open the specified process.
; Author(s):        Nomad
; Note(s):
;==================================================================================

Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $iv_InheritHandle = 1)

    If Not ProcessExists($iv_Pid) Then
        SetError(1)
        Return 0
    EndIf

    Local $ah_Handle[2] = [DllOpen('kernel32.dll')]

    If @Error Then
        SetError(2)
        Return 0
    EndIf

    Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $iv_InheritHandle, 'int', $iv_Pid)

    If @Error Then
        DllClose($ah_Handle[0])
        SetError(3)
        Return 0
    EndIf

    $ah_Handle[1] = $av_OpenProcess[0]

    Return $ah_Handle

EndFunc

;==================================================================================
; Function:            _MemoryRead($iv_Address, $ah_Handle[, $sv_Type])
; Description:        Reads the value located in the memory address specified.
; Parameter(s):        $iv_Address - The memory address you want to read from. It must
;                                  be in hex format (0x00000000).
;                    $ah_Handle - An array containing the Dll handle and the handle
;                                 of the open process as returned by _MemoryOpen().
;                    $sv_Type - (optional) The "Type" of value you intend to read.
;                                This is set to 'dword'(32bit(4byte) signed integer)
;                                by default.  See the help file for DllStructCreate
;                                for all types.  An example: If you want to read a
;                                word that is 15 characters in length, you would use
;                                'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):    On Success - Returns the value located at the specified address.
;                    On Failure - Returns 0
;                    @Error - 0 = No error.
;                             1 = Invalid $ah_Handle.
;                             2 = $sv_Type was not a string.
;                             3 = $sv_Type is an unknown data type.
;                             4 = Failed to allocate the memory needed for the DllStructure.
;                             5 = Error allocating memory for $sv_Type.
;                             6 = Failed to read from the specified process.
; Author(s):        Nomad
; Note(s):            Values returned are in Decimal format, unless specified as a
;                    'char' type, then they are returned in ASCII format.  Also note
;                    that size ('char[size]') for all 'char' types should be 1
;                    greater than the actual size.
;==================================================================================

Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Local $v_Value = DllStructGetData($v_Buffer, 1)
        Return $v_Value
    Else
        SetError(6)
        Return 0
    EndIf

EndFunc

;==================================================================================
; Function:            _MemoryWrite($iv_Address, $ah_Handle, $v_Data[, $sv_Type])
; Description:        Writes data to the specified memory address.
; Parameter(s):        $iv_Address - The memory address which you want to write to.
;                                  It must be in hex format (0x00000000).
;                    $ah_Handle - An array containing the Dll handle and the handle
;                                 of the open process as returned by _MemoryOpen().
;                    $v_Data - The data to be written.
;                    $sv_Type - (optional) The "Type" of value you intend to write.
;                                This is set to 'dword'(32bit(4byte) signed integer)
;                                by default.  See the help file for DllStructCreate
;                                for all types.  An example: If you want to write a
;                                word that is 15 characters in length, you would use
;                                'char[16]' since a 'char' is 8 bits (1 byte) in size.
; Return Value(s):    On Success - Returns 1
;                    On Failure - Returns 0
;                    @Error - 0 = No error.
;                             1 = Invalid $ah_Handle.
;                             2 = $sv_Type was not a string.
;                             3 = $sv_Type is an unknown data type.
;                             4 = Failed to allocate the memory needed for the DllStructure.
;                             5 = Error allocating memory for $sv_Type.
;                             6 = $v_Data is not in the proper format to be used with the
;                                 "Type" selected for $sv_Type, or it is out of range.
;                             7 = Failed to write to the specified process.
; Author(s):        Nomad
; Note(s):            Values sent must be in Decimal format, unless specified as a
;                    'char' type, then they must be in ASCII format.  Also note
;                    that size ('char[size]') for all 'char' types should be 1
;                    greater than the actual size.
;==================================================================================

Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    Else
        DllStructSetData($v_Buffer, 1, $v_Data)
        If @Error Then
            SetError(6)
            Return 0
        EndIf
    EndIf

    DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Return 1
    Else
        SetError(7)
        Return 0
    EndIf

EndFunc

;==================================================================================
; Function:            _MemoryClose($ah_Handle)
; Description:        Closes the process handle opened by using _MemoryOpen().
; Parameter(s):        $ah_Handle - An array containing the Dll handle and the handle
;                                 of the open process as returned by _MemoryOpen().
; Return Value(s):    On Success - Returns 1
;                    On Failure - Returns 0
;                    @Error - 0 = No error.
;                             1 = Invalid $ah_Handle.
;                             2 = Unable to close the process handle.
; Author(s):        Nomad
; Note(s):
;==================================================================================

Func _MemoryClose($ah_Handle)

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
    If Not @Error Then
        DllClose($ah_Handle[0])
        Return 1
    Else
        DllClose($ah_Handle[0])
        SetError(2)
        Return 0
    EndIf

EndFunc

;==================================================================================
; Function:            SetPrivilege( $privilege, $bEnable )
; Description:        Enables (or disables) the $privilege on the current process
;                   (Probably) requires administrator privileges to run
;
; Author(s):        Larry (from autoitscript.coms Forum)
; Notes(s):
; http://www.autoitscript.com/forum/index.php?s=&showtopic=31248&view=findpost&p=223999
;==================================================================================

Func SetPrivilege( $privilege, $bEnable )
    Const $MY_TOKEN_ADJUST_PRIVILEGES = 0x0020
    Const $MY_TOKEN_QUERY = 0x0008
    Const $MY_SE_PRIVILEGE_ENABLED = 0x0002
    Local $hToken, $SP_auxret, $SP_ret, $hCurrProcess, $nTokens, $nTokenIndex, $priv
    $nTokens = 1
    $LUID = DLLStructCreate("dword;int")
    If IsArray($privilege) Then    $nTokens = UBound($privilege)
    $TOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
    $NEWTOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
    $hCurrProcess = DLLCall("kernel32.dll","hwnd","GetCurrentProcess")
    $SP_auxret = DLLCall("advapi32.dll","int","OpenProcessToken","hwnd",$hCurrProcess[0],   _
            "int",BitOR($MY_TOKEN_ADJUST_PRIVILEGES,$MY_TOKEN_QUERY),"int*",0)
    If $SP_auxret[0] Then
        $hToken = $SP_auxret[3]
        DLLStructSetData($TOKEN_PRIVILEGES,1,1)
        $nTokenIndex = 1
        While $nTokenIndex <= $nTokens
            If IsArray($privilege) Then
                $priv = $privilege[$nTokenIndex-1]
            Else
                $priv = $privilege
            EndIf
            $ret = DLLCall("advapi32.dll","int","LookupPrivilegeValue","str","","str",$priv,   _
                    "ptr",DLLStructGetPtr($LUID))
            If $ret[0] Then
                If $bEnable Then
                    DLLStructSetData($TOKEN_PRIVILEGES,2,$MY_SE_PRIVILEGE_ENABLED,(3 * $nTokenIndex))
                Else
                    DLLStructSetData($TOKEN_PRIVILEGES,2,0,(3 * $nTokenIndex))
                EndIf
                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,1),(3 * ($nTokenIndex-1)) + 1)
                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,2),(3 * ($nTokenIndex-1)) + 2)
                DLLStructSetData($LUID,1,0)
                DLLStructSetData($LUID,2,0)
            EndIf
            $nTokenIndex += 1
        WEnd
        $ret = DLLCall("advapi32.dll","int","AdjustTokenPrivileges","hwnd",$hToken,"int",0,   _
                "ptr",DllStructGetPtr($TOKEN_PRIVILEGES),"int",DllStructGetSize($NEWTOKEN_PRIVILEGES),   _
                "ptr",DllStructGetPtr($NEWTOKEN_PRIVILEGES),"int*",0)
        $f = DLLCall("kernel32.dll","int","GetLastError")
    EndIf
    $NEWTOKEN_PRIVILEGES=0
    $TOKEN_PRIVILEGES=0
    $LUID=0
    If $SP_auxret[0] = 0 Then Return 0
    $SP_auxret = DLLCall("kernel32.dll","int","CloseHandle","hwnd",$hToken)
    If Not $ret[0] And Not $SP_auxret[0] Then Return 0
    return $ret[0]
EndFunc   ;==>SetPrivilege

;=================================================================================================
; Function:			_MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset(, $sv_Type))
; Description:		Reads a chain of pointers and returns an array containing the destination
;					address and the data at the address.
; Parameter(s):		$iv_Address - The static memory address you want to start at. It must be in
;								  hex format (0x00000000).
;					$ah_Handle - An array containing the Dll handle and the handle of the open
;								 process as returned by _MemoryOpen().
;					$av_Offset - An array of offsets for the pointers.  Each pointer must have an
;								 offset.  If there is no offset for a pointer, enter 0 for that
;								 array dimension. (Offsets must be in decimal format, NOT hex!)
;					$sv_Type - (optional) The "Type" of data you intend to read at the destination
;								 address.  This is set to 'dword'(32bit(4byte) signed integer) by
;								 default.  See the help file for DllStructCreate for all types.
; Requirement(s):	The $ah_Handle returned from _MemoryOpen.
; Return Value(s):	On Success - Returns an array containing the destination address and the value
;								 located at the address.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $av_Offset is not an array.
;							 2 = Invalid $ah_Handle.
;							 3 = $sv_Type is not a string.
;							 4 = $sv_Type is an unknown data type.
;							 5 = Failed to allocate the memory needed for the DllStructure.
;							 6 = Error allocating memory for $sv_Type.
;							 7 = Failed to read from the specified process.
; Author(s):		Nomad
; Note(s):			Values returned are in Decimal format, unless a 'char' type is selected.
;					Set $av_Offset like this:
;					$av_Offset[0] = NULL (not used)
;					$av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;					$av_Offset[2] = Offset for pointer 2
;					etc...
;					(The number of array dimensions determines the number of pointers)
;=================================================================================================

Func _MemoryPointerRead($iv_Address, $ah_Handle, $av_Offset, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_Data[2], $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 To $iv_PointerCount

        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @error Then
                SetError(@error + 2)
                Return 0
            EndIf

            $iv_Address = '0x' & Hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & Hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        EndIf

    Next

    $iv_Data[0] = $iv_Address

    Return $iv_Data

EndFunc

;=================================================================================================
; Function:			_MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data(, $sv_Type))
; Description:		Reads a chain of pointers and writes the data to the destination address.
; Parameter(s):		$iv_Address - The static memory address you want to start at. It must be in
;								  hex format (0x00000000).
;					$ah_Handle - An array containing the Dll handle and the handle of the open
;								 process as returned by _MemoryOpen().
;					$av_Offset - An array of offsets for the pointers.  Each pointer must have an
;								 offset.  If there is no offset for a pointer, enter 0 for that
;								 array dimension.
;					$v_Data - The data to be written.
;					$sv_Type - (optional) The "Type" of data you intend to write at the destination
;								 address.  This is set to 'dword'(32bit(4byte) signed integer) by
;								 default.  See the help file for DllStructCreate for all types.
; Requirement(s):	The $ah_Handle returned from _MemoryOpen.
; Return Value(s):	On Success - Returns the destination address.
;					On Failure - Returns 0.
;					@Error - 0 = No error.
;							 1 = $av_Offset is not an array.
;							 2 = Invalid $ah_Handle.
;							 3 = Failed to read from the specified process.
;							 4 = $sv_Type is not a string.
;							 5 = $sv_Type is an unknown data type.
;							 6 = Failed to allocate the memory needed for the DllStructure.
;							 7 = Error allocating memory for $sv_Type.
;							 8 = $v_Data is not in the proper format to be used with the
;								 "Type" selected for $sv_Type, or it is out of range.
;							 9 = Failed to write to the specified process.
; Author(s):		Nomad
; Note(s):			Data written is in Decimal format, unless a 'char' type is selected.
;					Set $av_Offset like this:
;					$av_Offset[0] = NULL (not used, doesn't matter what's entered)
;					$av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;					$av_Offset[2] = Offset for pointer 2
;					etc...
;					(The number of array dimensions determines the number of pointers)
;=================================================================================================

Func _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_StructData, $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 to $iv_PointerCount
        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @Error Then
                SetError(@Error + 3)
                Return 0
            EndIf

            DllStructSetData($v_Buffer, 1, $v_Data)
            If @Error Then
                SetError(8)
                Return 0
            EndIf

            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(9)
                Return 0
            Else
                Return $iv_Address
            EndIf
        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        EndIf
    Next

EndFunc

;===================================================================================================
; Function........:  _MemoryGetBaseAddress($ah_Handle, $iHD)
;
; Description.....:  Reads the 'Allocation Base' from the open process.
;
; Parameter(s)....:  $ah_Handle - An array containing the Dll handle and the handle of the open
;                               process as returned by _MemoryOpen().
;                    $iHD - Return type:
;                       |0 = Hex (Default)
;                       |1 = Dec
;
; Requirement(s)..:  A valid process ID.
;
; Return Value(s).:  On Success - Returns the 'allocation Base' address and sets @Error to 0.
;                    On Failure - Returns 0 and sets @Error to:
;                  |1 = Invalid $ah_Handle.
;                  |2 = Failed to find correct allocation address.
;                  |3 = Failed to read from the specified process.
;
; Author(s).......:  Nomad. Szhlopp.
; URL.............:  http://www.autoitscript.com/forum/index.php?showtopic=78834
; Note(s).........:  Go to Www.CheatEngine.org for the latest version of CheatEngine.
;===================================================================================================

Func _MemoryGetBaseAddress($ah_Handle, $iHexDec = 0)

    Local $iv_Address = 0x00100000
    Local $v_Buffer = DllStructCreate('dword;dword;dword;dword;dword;dword;dword')
    Local $vData
    Local $vType

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf


    DllCall($ah_Handle[0], 'int', 'VirtualQueryEx', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer))

    If Not @Error Then

        $vData = Hex(DllStructGetData($v_Buffer, 2))
        $vType = Hex(DllStructGetData($v_Buffer, 3))

        While $vType <> "00000080"
            DllCall($ah_Handle[0], 'int', 'VirtualQueryEx', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer))
            $vData = Hex(DllStructGetData($v_Buffer, 2))
            $vType = Hex(DllStructGetData($v_Buffer, 3))
            If Hex($iv_Address) = "01000000" Then ExitLoop
            $iv_Address += 65536

        WEnd

        If $vType = "00000080" Then
            SetError(0)
            If $iHexDec = 1 Then
                Return Dec($vData)
            Else
                Return $vData
            EndIf

        Else
            SetError(2)
            Return 0
        EndIf

    Else
        SetError(3)
        Return 0
    EndIf

EndFunc

;==================================================================================
; Function:            MemoryASMWrite( $privilege, $bEnable )
; Description:        You can write byte in specific location
;Parameter(s):        $IADRESSE - Addres where you want to change byte
;                     $ISTACK - New byte
;                     $IMEMOPEN - Process
; Author(s):
; Notes(s): Instruction write by Gafra96 www.bordergame.it
;==================================================================================

Func _MemoryASMWrite($IADRESSE, $ISTACK, $IMEMOPEN)
	Local $ISPLIT = StringRegExp(StringReplace($ISTACK, " ", ""), "(..)", 3)
	Local $ISTEP = 0
	For $I = 0 To $ISPLIT
		_MemoryWrite($IADRESSE + $ISTEP, $IMEMOPEN, "0x" & $ISPLIT[$ISTEP], "byte")
		$ISTEP += 1
	Next
EndFunc

;==================================================================================
; Function:			_MemoryPatternSearch($ah_handle, $Pattern, $mask [, $after[, $iv_addrStart[, $iv_addrEnd[, $step]]]])
; Description:		Search for specified bytes in an specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
;					$Pattern			 	 - bytes which should be searched in process.
;					$mask				 - This is made for the Pattern-Function of Olly Dbg,
; 										    just copy mask of pattern function into $mask.
;					$iv_addrStart 	 	 - (optional) The address where search should be started.
;					$iv_addrEnd			 - (optional) The address where search should end.
; 					$step				 - (optional) This indicates the step which is used by ReadProcessMemory to search trough memory.
; Requirement(s):	None.
; Author(s):
; Note(s):
; Example(s):		Global Const $Pattern = "\0x21\0x34\0x23\0x54\0x34\0x00\0x54\0x00\0x00\0x54\0x34"
;                   Global Const $Pattern_Mask = "xxxxx?x??xx"
;                   _MemoryPatternSearch($ah_Handle,$Pattern,$Mask)
;                   Example make by Gafra96 www.bordergame.it
;==================================================================================

Func _MemoryPatternSearch($ah_Handle, $pattern, $mask , $after = False, $iv_addrStart = 0x00400000, $iv_addrEnd = 0x0FFFFFFF, $step = 51200) ;try 500000 0x08FFFFFF
	If Not IsArray($ah_Handle) Then
		SetError(1)
		Return -1
	EndIf
		  $pattern = StringRegExpReplace($pattern, "[^0123456789ABCDEFabcdef.]", "")
	If StringLen($pattern) = 0 Then
		SetError(2)
		Return -2
	EndIf
	If Stringlen($pattern)/2 <> Stringlen($mask) Then
		SetError(4)
		Return -4
	EndIf
	Local $formatedpattern=""
	Local $BufferPattern
	Local $BufferMask
	for $i = 0 to stringlen($mask)-1
		  $BufferPattern = StringLeft($pattern,2)
		  $pattern = StringRight($pattern,StringLen($pattern)-2)
		  $BufferMask = StringLeft($mask,1)
		  $mask = StringRight($mask,StringLen($mask)-1)
	if $BufferMask = "?" then $BufferPattern = ".."
		  $formatedpattern = $formatedpattern&$BufferPattern
		Next
		  $pattern = $formatedpattern
	For $addr = $iv_addrStart To $iv_addrEnd Step $step - (StringLen($pattern) / 2)
		StringRegExp(_MemoryRead($addr, $ah_Handle, "byte[" & $step & "]"), $pattern, 1, 2)
	If Not @error Then
	If $after Then
		Return StringFormat("0x%.8X", $addr + ((@extended - 2) / 2))
	Else
		Return StringFormat("0x%.8X", $addr + ((@extended - StringLen($pattern) - 2) / 2))
	EndIf
EndIf
	Next
	Return -3
EndFunc   ;==>__MemoryPatternSearch

Func _Message($ErrorCode)
    If $ErrorCode <> 0 Then
        MsgBox(48, "Wait", "Error injected dll. Please retry " & @CRLF & "Error code: " & @error)
    Else
        MsgBox(64, "Info", "Injection successful!")
    EndIf
EndFunc


;=================================================================================================
; Function:            _InjectDll($ProcessId, $DllPath)
; Description:        Injects a .dll into a running program.
; Return Value(s):    On Success - Returns true
;                    On Failure - Returns false
;                    @Error - 0 = No error.
;                             1 = Invalid ProcessId.
;                             2 = File does not exist.
;                             3 = File is not a .dll (invalid file).
;                             4 = Failed to open 'Advapi32.dll'.
;                             5 = Failed to get the full path.
;                             6 = Failed to open the process.
;                             7 = Failed to call 'GetModuleHandle'.
;                             8 = Failed to call 'GetProcAddress'.
;                             9 = Failed to call 'VirtualAllocEx'.
;                             10 = Failed to write the memory.
;                             11 = Failed to create the 'RemoteThread'.
; Author(s):        KillerDeluxe
;=================================================================================================

Func _InjectDll($ProcessId, $DllPath)
    If $ProcessId == 0 Then Return SetError(1, "", False)
    If Not(FileExists($DllPath)) Then Return SetError(2, "", False)
    If Not(StringRight($DllPath, 4) == ".dll") Then Return SetError(3, "", False)

    $Kernel32 = DllOpen("kernel32.dll")
    If @error Then Return SetError(4, "", False)

    $DLL_Path = DllStructCreate("char[255]")
    DllCall($Kernel32, "DWORD", "GetFullPathNameA", "str", $DllPath, "DWORD", 255, "ptr", DllStructGetPtr($DLL_Path), "int", 0)
    If @error Then Return SetError(5, "", False)

    $hProcess = DllCall($Kernel32, "DWORD", "OpenProcess", "DWORD", 0x1F0FFF, "int", 0, "DWORD", $ProcessId)
    If @error Then Return SetError(6, "", False)

    $hModule = DllCall($Kernel32, "DWORD", "GetModuleHandleA", "str", "kernel32.dll")
    If @error Then Return SetError(7, "", False)

    $lpStartAddress = DllCall($Kernel32, "DWORD", "GetProcAddress", "DWORD", $hModule[0], "str", "LoadLibraryA")
    If @error Then Return SetError(8, "", False)

    $lpParameter = DllCall($Kernel32, "DWORD", "VirtualAllocEx", "int", $hProcess[0], "int", 0, "ULONG_PTR", DllStructGetSize($DLL_Path), "DWORD", 0x3000, "int", 4)
    If @error Then Return SetError(9, "", False)

    DllCall("kernel32.dll", "BOOL", "WriteProcessMemory", "int", $hProcess[0], "DWORD", $lpParameter[0], "str", DllStructGetData($DLL_Path, 1), "ULONG_PTR", DllStructGetSize($DLL_Path), "int", 0)
    If @error Then Return SetError(10, "", False)

    $hThread = DllCall($Kernel32, "int", "CreateRemoteThread", "DWORD", $hProcess[0], "int", 0, "int", 0, "DWORD", $lpStartAddress[0], "DWORD", $lpParameter[0], "int", 0, "int", 0)
    If @error Then Return SetError(11, "", False)

    DllCall($Kernel32, "BOOL", "CloseHandle", "DWORD", $hProcess[0])
    DllClose($Kernel32)

    Return SetError(0, "", True)
EndFunc


;FineUDF