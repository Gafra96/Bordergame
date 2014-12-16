#include <FASM.au3>

#include-once

;==================================================================================
; Function:			_MemoryManipulationOpen($iv_Pid[, $iv_DesiredAccess[, $iv_InheritHandle]])
; Description:		Opens a process and enables all possible access rights to the
;					process.  The Process ID of the process is used to specify which
;					process to open.  You must call this function before calling
;					_MemoryClose(), _MemoryRead(), or _MemoryWrite().
; Parameter(s):		$iv_Pid - The Process ID of the program you want to open.
;					$iv_DesiredAccess - (optional) Set to 0x1F0FFF by default, which
;										enables all possible access rights to the
;										process specified by the Process ID.
;					$iv_InheritHandle - (optional) If this value is TRUE, all processes
;										created by this process will inherit the access
;										handle.  Set to 1 (TRUE) by default.  Set to 0
;										if you want it FALSE.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing the Dll handle and an
;								 open handle to the specified process.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = Invalid $iv_Pid.
;							 2 = Failed to open Kernel32.dll.
;							 3 = Failed to open the specified process.
; Author(s):		Nomad
; Note(s):
;==================================================================================

Func _MemoryManipulationOpen($iv_pid, $iv_desiredaccess = 2035711, $if_inherithandle = 1)
	If Not ProcessExists($iv_pid) Then
		SetError(1)
		Return 0
	EndIf
	Local $ah_handle[2] = [DllOpen("kernel32.dll")]
	If @error Then
		SetError(2)
		Return 0
	EndIf
	Local $av_openprocess = DllCall($ah_handle[0], "int", "OpenProcess", "int", $iv_desiredaccess, "int", $if_inherithandle, "int", $iv_pid)
	If @error Then
		DllClose($ah_handle[0])
		SetError(3)
		Return 0
	EndIf
	$ah_handle[1] = $av_openprocess[0]
	Return $ah_handle
EndFunc   ;==>_MemoryManipulationOpen

#region Memory-Manipulation by Shadow992 (elitepvpers.com)



;==================================================================================
; Function:			_MemoryBytesWrite($ah_handle, $iadresse, $v_data)
; Description:		Writes some specified Opcode to the process specified at specfied address.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$iadress		 	 - Address where the bytes should be written to
;					$v_data 	 		 - The byte which should be written to specified address.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns the bytes which were at the specified addresse
;								 before this function was executed.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array
;							 2 = Failed to create $v_buffer_write.
;							 3 = Failed to create $v_buffer_read.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _MemoryBytesWrite($ah_handle, $iadress, $v_data)
	If $v_data <> "" Then
		Local $isplit = StringRegExp(StringReplace($v_data, " ", ""), "(..)", 3)
		Local $code = ""

		If Not IsArray($ah_handle) Then
			SetError(1)
			Return 0
		EndIf

		Local $v_buffer_write = DllStructCreate("byte")
		If @error Then
			SetError(2)
			Return 0
		EndIf

		Local $v_buffer_read = DllStructCreate("byte")
		If @error Then
			SetError(3)
			Return 0
		EndIf

		Local $ptr_write = DllStructGetPtr($v_buffer_write)
		Local $struct_size_write = DllStructGetSize($v_buffer_write)

		Local $ptr_read = DllStructGetPtr($v_buffer_read)
		Local $struct_size_read = DllStructGetSize($v_buffer_read)

		For $i = 0 To UBound($isplit) - 1
			DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $iadress + $i, "ptr", $ptr_read, "int", $struct_size_read, "int", "")
			$code &= Hex(DllStructGetData($v_buffer_read, 1), 2)

			DllStructSetData($v_buffer_write, 1, "0x" & $isplit[$i])
			DllCall($ah_handle[0], "int", "WriteProcessMemory", "int", $ah_handle[1], "int", $iadress + $i, "ptr", $ptr_write, "int", $struct_size_write, "int", "")
		Next
	Else
		Return 0
	EndIf
	Return $code
EndFunc   ;==>_MemoryBytesWrite


;==================================================================================
; Function:			_MemorySearchForBytes($ah_handle, $bytes [, $iv_addrStart[, $iv_addrEnd[, $mask[, $finds[, $after[, $istep]]]]]])
; Description:		Search for specified bytes in an specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$bytes			 	 - bytes which should be searched in process.
; 										   If the bytes which should be found are not known,
; 										   then use ?? instead of byte.
;										   The Search-Engine of this function uses StringRegExp,
; 										   so it is possible to use also regular expressions.
;					$iv_addrStart 	 	 - (optional) The address where search should be started.
;					$iv_addrEnd			 - (optional) The address where search should end.
;					$mask				 - (optional) This is made for the Pattern-Function of Olly Dbg,
; 										    just copy mask of pattern function into $mask.
;					$finds				 - (optional) This number indicates how much addresses
; 										    where $bytes were found should be returned.
;					$after				 - (optional) This indicates if the addresses are returned before $bytes were found (=False) or after $bytes were found (=True).
; 					$istep				 - (optional) This indicates the step which is used by ReadProcessMemory to search trough memory.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing $finds addresses where the bytes were found.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array
;							 2 = Failed to create $v_buffer.
; Author(s):		Shadow992
; Note(s):
; Example(s):		_MemorySearchForBytes($ah_handle, "909090????90??")
;==================================================================================

Func _MemorySearchForBytes($ah_handle, $bytes, $iv_addrStart = -1, $iv_addrEnd = 0x0FFFFFFF, $mask = "", $finds = 1, $after = True, $istep = 500000)
	If $iv_addrEnd > 0x7FFFFFFF Then $iv_addrEnd = 0x7FFFFFFF
	If $iv_addrStart < 0 Then $iv_addrStart = 0x00400000

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf

	$bytes = StringReplace($bytes, " ", "")
	$bytes = StringReplace($bytes, "\x", "")

	If $mask <> "" Then
		Local $splited = StringRegExp($bytes, "(..)", 3)
		Local $splited2 = StringSplit($mask, "", 2)
		$bytes = ""
		For $i = 0 To UBound($splited2) - 1
			If $splited2[$i] = "?" Then
				$bytes &= "??"
			Else
				$bytes &= $splited[$i]
			EndIf
		Next
	EndIf

	$bytes = StringReplace(StringReplace($bytes, "??", "(..)"), "?", "(.)")

	If ($iv_addrEnd - $iv_addrStart) > $istep Then

		Local $v_buffer = DllStructCreate("byte[" & $istep & "]")
		If @error Then
			SetError(2)
			Return 0
		EndIf

		Local $ptr = DllStructGetPtr($v_buffer)
		Local $matches = 0, $temp = "", $found = 0, $found2 = 0, $found3 = 0, $found4 = 0
		Local $found_addr[$finds]
		Local $i_found = 0

		For $u = 0 To ($iv_addrEnd - $iv_addrStart) Step $istep - StringLen($bytes)
			If $iv_addrStart + $u < $iv_addrEnd Then
				$error = DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $u + $iv_addrStart, "ptr", $ptr, "int", $istep, "int", "")
				If $error[0] = 0 Then ExitLoop
			Else
				$error = DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", ($iv_addrStart + ($u - ($istep - StringLen($bytes)))) + ($istep - StringLen($bytes) - (($iv_addrStart + $u) - $iv_addrEnd)), "ptr", $ptr, "int", $istep - StringLen($bytes) - (($iv_addrStart + $u) - $iv_addrEnd), "int", "")
				If $error[0] = 0 Then ExitLoop
			EndIf
			$temp = StringTrimLeft(DllStructGetData($v_buffer, 1), 2)

			If $i_found < $finds Then
				If $i_found > 0 Then $temp = StringMid($temp, $found2 + $found)
				$match = StringRegExp($temp, $bytes, 2)

				If IsArray($match) Then
					$found = StringInStr($temp, $match[0])
					$found2 = StringLen($match[0])

					If $after = True Then
						$found3 = Int(($found - 1) / 2 + $iv_addrStart + $u + $found2 / 2)
					Else
						$found3 = Int(($found - 1) / 2 + $iv_addrStart + $u)
					EndIf

					$found4 = 0
					For $iu = 0 To $finds - 1
						If $found3 = $found_addr[$iu] Then $found4 = 1
					Next

					If $found4 = 0 Then $found_addr[$i_found] = $found3
					$i_found += 1

				EndIf
			Else
				ExitLoop
			EndIf

		Next
	Else
		Local $v_buffer = DllStructCreate("byte[" & ($iv_addrEnd - $iv_addrStart) & "]")
		If @error Then
			SetError(2)
			Return 0
		EndIf

		Local $size = DllStructGetSize($v_buffer)
		Local $ptr = DllStructGetPtr($v_buffer)
		Local $matches = 0, $temp = "", $found = 0, $found2 = 0
		Local $found_addr[$finds]

		DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $iv_addrStart, "ptr", $ptr, "int", $size, "int", "")
		$temp = StringTrimLeft(DllStructGetData($v_buffer, 1), 2)
		For $i = 0 To $finds - 1
			If $i > 0 Then $temp = StringMid($temp, $found2 + $found)
			$match = StringRegExp($temp, $bytes, 2)

			If IsArray($match) Then
				$found = StringInStr($temp, $match[0])
				$found2 = StringLen($match[0])

				If $after = True Then
					$iv_addrStart = ($found - 1) / 2 + $iv_addrStart + $found2 / 2
				Else
					$iv_addrStart = ($found - 1) / 2 + $iv_addrStart
				EndIf
				$found_addr[$i] = $iv_addrStart
			Else
				$found_addr[$i] = 0
				ExitLoop
			EndIf
		Next
	EndIf

	For $i = 0 To $finds - 1
		$found_addr[$i] = "0x" & hex(int($found_addr[$i]))
	Next

	Return $found_addr
EndFunc   ;==>_MemorySearchForBytes

;==================================================================================
; Function:			_AllocateMemoryForArray($ah_handle, $size[, $type])
; Description:		Allocates memory for an array in a specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$size			 	 - The size of the array.
;					$type		 	 	 - (optional) Type of Array (C-Style).
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing infos about allocated memory.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array
;							 2 = Failed to allocate memory at specified process.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _AllocateMemoryForArray($ah_handle, $size, $type = "int")

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf

	If $size <= 0 Then $size = 1

	Local $info[5]
	If $type = "byte" Or $type = "char" Then
		$info[0] = _AllocateMemory($ah_handle, $size)
		$info[1] = 1
	ElseIf $type = "short" Or $type = "word" Then
		$info[0] = _AllocateMemory($ah_handle, 2 * $size)
		$info[1] = 2
	Else
		$info[0] = _AllocateMemory($ah_handle, 4 * $size)
		$info[1] = 4
	EndIf
	$info[2] = $size
	$info[3] = $type
	$info[4] = 1

	If $info[0] = -2 Then
		SetError(2)
		Return 0
	EndIf

	Return $info
EndFunc   ;==>_AllocateMemoryForArray


;==================================================================================
; Function:			_AllocateMemoryFor2DArray($ah_handle, $size1,$size2,[, $type])
; Description:		Allocates memory for a 2D-array in a specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$size1			 	 - The size of the 1. dimension of array.
;					$size2			 	 - The size of the 2. dimension of array.
;					$type		 	 	 - (optional) Type of Array (C-Style).
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing infos about allocated memory.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array
;							 2 = Failed to allocate memory at specified process.
; Author(s):		Shadow992
; Note(s):			Will allocate memory on this way: $array[$size1][$size2]
;==================================================================================

Func _AllocateMemoryFor2DArray($ah_handle, $size1,$size2, $type = "int")

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf

	If $size1 <= 0 Then $size1 = 1
	If $size2 <= 0 Then $size2 = 1

	Local $info[5]
	If $type = "byte" Or $type = "char" Then
		$info[0] = _AllocateMemory($ah_handle, $size1*$size2)
		$info[1] = 1
	ElseIf $type = "short" Or $type = "word" Then
		$info[0] = _AllocateMemory($ah_handle, 2 * $size1*$size2)
		$info[1] = 2
	Else
		$info[0] = _AllocateMemory($ah_handle, 4 * $size1*$size2)
		$info[1] = 4
	EndIf
	$info[2] = $size2
	$info[3] = $type
	$info[4] = $size1

	If $info[0] = -2 Then
		SetError(2)
		Return 0
	EndIf

	Return $info
EndFunc   ;==>_AllocateMemoryForArray

;==================================================================================
; Function:			_AllocateMemoryForVariable($ah_handle [, $type])
; Description:		Allocates memory for a variable in a specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$type		 	 	 - (optional) Type of Array (C-Style).
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing infos about allocated memory.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array
;							 2 = Failed to allocate memory at specified process.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _AllocateMemoryForVariable($ah_handle, $type = "int")

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf

	Local $info[5]
	If $type = "byte" Or $type = "char" Then
		$info[0] = _AllocateMemory($ah_handle, 1)
		$info[1] = 1
	ElseIf $type = "short" Or $type = "word" Then
		$info[0] = _AllocateMemory($ah_handle, 2)
		$info[1] = 2
	Else
		$info[0] = _AllocateMemory($ah_handle, 4)
		$info[1] = 4
	EndIf
	$info[2] = 1
	$info[3] = $type
	$info[4] = 1

	If $info[0] = -2 Then
		SetError(2)
		Return 0
	EndIf

	Return $info
EndFunc   ;==>_AllocateMemoryForVariable


;==================================================================================
; Function:			_ReadMemoryVariable($ah_handle, $allocated_var)
; Description:		Reads value of specified variable.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$allocated_var		 - Handle returned by _AllocateMemoryForVariable.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns value which is stored in variable.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
;							 2 = $allocated_var is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================
Func _ReadMemoryVariable($ah_handle, $allocated_var)
	If IsArray($allocated_var) = 0 Then
		SetError(2)
		Return 0
	EndIf

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf

	Local $v_buffer = DllStructCreate($allocated_var[3])
	Local $read_var

	DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $allocated_var[0], "ptr", DllStructGetPtr($v_buffer), "int", DllStructGetSize($v_buffer), "int", "")

	$read_var = DllStructGetData($v_buffer, 1)

	Return $read_var
EndFunc   ;==>_ReadMemoryVariable

;==================================================================================
; Function:			_ReadMemoryArray($ah_handle, $allocated_array)
; Description:		Reads values of specified array.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$allocated_array	 - Handle returned by _AllocateMemoryForArray.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an array containing values which are stored in array.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
;							 2 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================
Func _ReadMemoryArray($ah_handle, $allocated_array)
	If IsArray($allocated_array) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If Not IsArray($ah_handle) Then
		SetError(2)
		Return 0
	EndIf

	Local $v_buffer = DllStructCreate($allocated_array[3] & "[" & $allocated_array[2] & "]")
	Local $read_array[$allocated_array[2]]

	DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $allocated_array[0], "ptr", DllStructGetPtr($v_buffer), "int", DllStructGetSize($v_buffer), "int", "")

	For $i = 0 To $allocated_array[2] - 1
		$read_array[$i] = DllStructGetData($v_buffer, 1, $i)
	Next

	Return $read_array
EndFunc   ;==>_ReadMemoryArray

;==================================================================================
; Function:			_CreateASM_CopyRegisterToVariable($allocated_var [, $register = "eax"[, $copy_address = 1[, $create_opcode = 0]]])
; Description:		Creates ASM-Code/Opcode for copying register to specified variable.
; Parameter(s):		$allocated_var		 - Handle returned by _AllocateMemoryForVariable.
;					$register			 - (optional) Register which should be copied to variable.
;					$copy_address		 - (optional) Specifies if address of $register should be copied (=1)
;										   or the value at the address in $register (=0).
;					$create_opcode		 - (optional) Specifies if Opcode (=1) should be returned or ASM-Code (=0) should be returned.
; Requirement(s):	FASM.au3
; Return Value(s): 	On Success - Returns the code specified by $create_opcode.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _CreateASM_CopyRegisterToVariable($allocated_var, $register = "eax", $copy_address = 1, $create_opcode = 0)
	If IsArray($allocated_var) = 0 Then
		SetError(1)
		Return 0
	EndIf

	Local $temp_register = "edx"

	If $temp_register = $register Then
		$temp_register = "ebx"
	EndIf

	If $copy_address = 1 Then
		If $allocated_var[1] = 4 Then
			Local $code = "MOV [" & $allocated_var[0] & "]," & $register
		ElseIf $allocated_var[1] = 2 Then
			Local $code = "MOV word [" & $allocated_var[0] & "]," & StringTrimLeft($register, 1)
		ElseIf $allocated_var[1] = 1 Then
			Local $code = "MOV byte [" & $allocated_var[0] & "]," & StringTrimRight(StringTrimLeft($register, 1), 1) & "l"
		EndIf
	Else
		If $allocated_var[1] = 4 Then
			Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & _
					"MOV " & $temp_register & ",[" & $register & "]" & @CRLF & _
					"MOV [" & $allocated_var[0] & "]," & $temp_register & @CRLF & _
					"POP " & $register & @CRLF & "POP " & $temp_register
		ElseIf $allocated_var[1] = 2 Then
			Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "XOR " & $temp_register & "," & $temp_register & @CRLF & _
					"MOV " & StringTrimLeft($temp_register, 1) & ",word [" & $register & "]" & @CRLF & _
					"MOV word [" & $allocated_var[0] & "]," & StringTrimLeft($temp_register, 1) & @CRLF & _
					"POP " & $register & @CRLF & "POP " & $temp_register
		ElseIf $allocated_var[1] = 1 Then
			Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "XOR " & $temp_register & "," & $temp_register & @CRLF & _
					"MOV " & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l, byte[" & $register & "]" & @CRLF & _
					"MOV byte[" & $allocated_var[0] & "]," & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l" & @CRLF & _
					"POP " & $register & @CRLF & "POP " & $temp_register
		EndIf

	EndIf

	If $create_opcode = 1 Then
		Local $splited = StringSplit($code, @CRLF, 2)

		Local $Fasm = FasmInit()
		FasmReset($Fasm)
		FasmAdd($Fasm, "use32")

		For $i = 0 To UBound($splited) - 1
			If $splited[$i] <> "" Then
				$splited[$i] = StringReplace(StringReplace($splited[$i], @LF, ""), @CR, "")
				FasmAdd($Fasm, $splited[$i])
			EndIf
		Next

		$code = StringTrimLeft(FasmGetBinary($Fasm), 2)
	EndIf

	Return $code
EndFunc   ;==>_CreateASM_CopyRegisterToVariable

;==================================================================================
; Function:			_CreateASM_CopyRegisterToArray($allocated_array [, $register = "eax"[,  $offset = 0[, $create_opcode = 0]]])
; Description:		Creates ASM-Code/Opcode for copying register to specified array.
; Parameter(s):		$allocated_array	 - Handle returned by _AllocateMemoryForArray.
;					$register			 - (optional) Register which should be copied to array.
;					$offset				 - (optional) Specifies the offset of $register which should be copied.
;					$create_opcode		 - (optional) Specifies if Opcode (=1) should be returned or ASM-Code (=0) should be returned.
; Requirement(s):	FASM.au3
; Return Value(s): 	On Success - Returns the code specified by $create_opcode.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _CreateASM_CopyRegisterToArray($allocated_array, $register = "eax", $terminate_asc_code_char=0, $offset = 0, $create_opcode = 0)
	If IsArray($allocated_array) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If $offset = 0 Then
		$offset = $allocated_array[1]
	EndIf

	Local $count_register = "ecx"
	Local $temp_register = "edx"
	Local $temp_terminate= ""

	If $count_register = $register Then
		$count_register = "ebx"
	ElseIf $temp_register = $register Then
		$temp_register = "ebx"
	EndIf

	if $terminate_asc_code_char>-1 Then
		If $allocated_array[1] = 4 Then
			$temp_terminate= "CMP " & $temp_register & ",0x" & hex(Int($terminate_asc_code_char)) & @CRLF & _
			"JE End" & @CRLF
		ElseIf $allocated_array[1] = 2 Then
			$temp_terminate= "CMP " & StringTrimLeft($temp_register, 1) & ",word [0x" & hex(Int($terminate_asc_code_char))& "]" & @CRLF & _
			"JE End" & @CRLF
		ElseIf $allocated_array[1] = 1 Then
			$temp_terminate= "CMP " & StringTrimLeft($temp_register, 1) & "l,byte [0x" & hex(Int($terminate_asc_code_char))& "]" & @CRLF & _
			"JE End" & @CRLF
		EndIf
	EndIf
	If $allocated_array[1] = 4 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & $temp_register & ", dword [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV dword [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register & "]," & $temp_register & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp_terminate & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"End:" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 2 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimLeft($temp_register, 1) & ",word [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV word [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register & "]," & StringTrimLeft($temp_register, 1) & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp_terminate & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"End:" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 1 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l,byte [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV byte [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register & "]," & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l" & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp_terminate & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"End:" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	EndIf

	If $create_opcode = 1 Then
		Local $splited = StringSplit($code, @CRLF, 2)

		Local $Fasm = FasmInit()
		FasmReset($Fasm)
		FasmAdd($Fasm, "use32")

		For $i = 0 To UBound($splited) - 1
			If $splited[$i] <> "" Then
				$splited[$i] = StringReplace(StringReplace($splited[$i], @LF, ""), @CR, "")
				FasmAdd($Fasm, $splited[$i])
			EndIf
		Next

		$code = StringTrimLeft(FasmGetBinary($Fasm), 2)
	EndIf

	Return $code
EndFunc   ;==>_CreateASM_CopyRegisterToArray

;==================================================================================
; Function:			_AllocateMemory($ah_handle, $bytes)
; Description:		Allocates memory in a specified process.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$bytes				 - The amount of memory in bytes which should be allocated.
; Requirement(s):
; Return Value(s): 	On Success - Returns the base address of allocated memory.
;					On Failure - Returns -1
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _AllocateMemory($ah_handle, $bytes)
	If Not IsArray($ah_handle) Then
		SetError(1)
		Return -1
	EndIf

	Local $info[2]

	$ret = DllCall($ah_handle[0], "int", "VirtualAllocEx", "int", $ah_handle[1], "int", 0, "int", $bytes, "int", 0x00001000, "int", 0x40)

	If $ret[0] = 0 Then
		SetError(2)
		Return -2
	EndIf

	Return $ret[0]
EndFunc   ;==>_AllocateMemory

;==================================================================================
; Function:			_InjectOpcodeAtAddress($memopen, $des_address, $size, $opcodes)
; Description:		Injects an Code-Cave with specified Opcodes at an specified address.
;					The Opcodes which was at $des_address are restored and will be executed
;					even with active Code-Cave.
; Parameter(s):		$memopen			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$des_address		 - Address where Opcode should be injected.
;					$size				 - Size of bytes used at $des_address (min. 5 bytes) to get complete command.
;					$opcodes			 - The Opcode which should be injected into process.
; Requirement(s):
; Return Value(s): 	On Success - Returns array of information:
;									0 - Code-Cave's baseaddress
;									1 - Old Opcode at Code-Cave's address (should be 0000...)
;									2 - Opcode which was injected
;									3 - Opcode which was at $des_address
;									4 - New Opcode which is now at $des_address
;					On Failure - Returns -1
;					@Error - 0 = No error.
;							 1 = $size is less than 5.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _InjectOpcodeAtAddress($memopen, $des_address, $size, $opcodes)
	$opcodes = StringReplace($opcodes, " ", "")
	$opcodes = StringReplace($opcodes, "0x", "")

	If $size < 5 Then
		SetError(1)
		Return -1
	EndIf

	Local $old_opcode[5], $temp, $code_cave_address = 0
	Local $code_cave_address_bytes, $bytes_for_code_cave

	Local $nops = ""
	For $i = 5 To $size - 1
		$nops &= "90"
	Next

	$len = StringLen($opcodes) / 2 + 5 + $size
	$code_cave_address = _AllocateMemory($memopen, $len + 1)
	$temp = $code_cave_address - $des_address - 5
	$code_cave_address_bytes = _ConvertHexToBytes(Hex($temp), 8)

	$old_opcode[3] = _MemoryBytesWrite($memopen, $des_address, "E9" & $code_cave_address_bytes & $nops)
	$old_opcode[1] = _MemoryBytesWrite($memopen, $code_cave_address, $old_opcode[3] & $opcodes & "E9" & _ConvertHexToBytes(Hex(($des_address + $size) - ($code_cave_address + StringLen($opcodes) / 2 + 5 + StringLen($old_opcode[3]) / 2)), 8))
	$old_opcode[2] = $old_opcode[3] & $opcodes & "E9" & _ConvertHexToBytes(Hex(($des_address + $size) - ($code_cave_address + StringLen($opcodes) / 2 + 5 + StringLen($old_opcode[3]) / 2)), 8)

	$old_opcode[4] = "E9 " & $code_cave_address_bytes & $nops
	$old_opcode[0] = Hex($code_cave_address)

	Return $old_opcode
EndFunc   ;==>_InjectOpcodeAtAddress

;==================================================================================
; Function:			_InjectASMAtAddress($memopen, $des_address, $size, $asm)
; Description:		Injects an Code-Cave with specified ASM-Code at an specified address.
;					The Opcodes which was at $des_address are restored and will be executed
;					even with active/injected Code-Cave.
; Parameter(s):		$memopen			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$des_address		 - Address where ASM-Code should be injected.
;					$size				 - Size of bytes used at $des_address (min. 5 bytes) to get complete command.
;					$asm				 - The ASM-Code which should be injected into process.
; Requirement(s):	FASM.au3
; Return Value(s): 	On Success - Returns array of information:
;									0 - Code-Cave's baseaddress
;									1 - Old Opcode at Code-Cave's address (should be 0000...)
;									2 - Opcode which was injected
;									3 - Opcode which was at $des_address
;									4 - New Opcode which is now at $des_address
;					On Failure - Returns -1
;					@Error - 0 = No error.
;							 1 = $size is less than 5.
;							 2 = ASM-Code could not be compiled successfully.
; Author(s):		Shadow992
; Note(s):			The ASM-Commands in $asm have to be seperated by @CRLF or ";".
;==================================================================================

Func _InjectASMAtAddress($memopen, $des_address, $size, $asm)

	If $size < 5 Then
		SetError(1)
		Return -1
	EndIf

	Local $splited = StringSplit($asm, ";" & @CRLF, 2)

	Local $Fasm = FasmInit()
	FasmReset($Fasm)
	FasmAdd($Fasm, "use32")

	For $i = 0 To UBound($splited) - 1
		If $splited[$i] <> "" Then
			FasmAdd($Fasm, $splited[$i])
		EndIf
	Next

	Local $bytecode = FasmGetBinary($Fasm)

	If $bytecode <> "" Then
		Return _InjectOpcodeAtAddress($memopen, $des_address, $size, $bytecode)
	Else
		SetError(2)
		Return -1
	EndIf
EndFunc   ;==>_InjectASMAtAddress


;==================================================================================
; Function:			_ConvertHexToBytes($hex [, $len])
; Description:		Converts a Hex-Value to Bytes used as Opcode.
; Parameter(s):		$hex				 - Hex-Value
;					$len				 - Length which the Opcode should have got.
; Requirement(s):
; Return Value(s): 	On Success - Returns Opcode specified by $hex.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _ConvertHexToBytes($hex, $len = 8)
	Local $bytes = ""
	$hex = StringReplace($hex, "0x", "")

	While StringLen($hex) <> $len And StringLen($hex) < $len
		$hex = "0" & $hex
	WEnd

	Local $splited = StringRegExp($hex, "(..)", 3)

	For $i = UBound($splited) - 1 To 0 Step -1
		$bytes &= $splited[$i]
	Next

	Return $bytes
EndFunc   ;==>_ConvertHexToBytes

;==================================================================================
; Function:			_ReadMemoryArrayString($ah_handle, $allocated_array)
; Description:		Reads values of specified array.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$allocated_array	 - Handle returned by _AllocateMemoryForArray.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an string containing values which are stored in allocated array.
;								 This function was made for copying string array to AutoIt-String.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
;							 2 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _ReadMemoryArrayString($ah_handle, $allocated_array)
	If IsArray($allocated_array) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If Not IsArray($ah_handle) Then
		SetError(2)
		Return 0
	EndIf


	Local $v_buffer = DllStructCreate($allocated_array[3] & "[" & $allocated_array[2] & "]")
	Local $read_string=""

	DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $allocated_array[0], "ptr", DllStructGetPtr($v_buffer), "int", DllStructGetSize($v_buffer), "int", "")

	For $i = 1 To $allocated_array[2] - 1
		$temp=DllStructGetData($v_buffer, 1, $i)
		if $temp=Chr(0) Then
			ExitLoop
		Else
			$read_string&=$temp
		EndIf

	Next

	Return $read_string
EndFunc   ;==>_ReadMemoryArrayString


;==================================================================================
; Function:			_ReadMemory2DArrayString($ah_handle, $allocated_array[,$index])
; Description:		Reads values of specified array and returns values of 2. Dimension of array as a string.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$allocated_array	 - Handle returned by _AllocateMemoryForArray.
;					$index				 - (optional) The index of the 1. dimension
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns an string containing values which are stored in allocated array.
;								 This function was made for copying string array to AutoIt-String.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
;							 2 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _ReadMemory2DArrayString($ah_handle, $allocated_array,$index=0)
	If IsArray($allocated_array) = 0 Then
		SetError(2)
		Return 0
	EndIf

	If Not IsArray($ah_handle) Then
		SetError(1)
		Return 0
	EndIf


	Local $v_buffer = DllStructCreate($allocated_array[3] & "[" & $allocated_array[2] & "]")
	Local $read_string=""

	DllCall($ah_handle[0], "int", "ReadProcessMemory", "int", $ah_handle[1], "int", $allocated_array[0]+$index*$allocated_array[2], "ptr", DllStructGetPtr($v_buffer), "int", DllStructGetSize($v_buffer), "int", "")

	For $i = 1 To $allocated_array[2] - 1
		$temp=DllStructGetData($v_buffer, 1, $i)
		if $temp=Chr(0) Then
			ExitLoop
		Else
			$read_string&=$temp
		EndIf

	Next

	Return $read_string
EndFunc   ;==>_ReadMemoryArrayString

;==================================================================================
; Function:			_CreateASM_CopyRegisterTo2DArray($allocated_array [, $register = "eax"[,$index = 0[,  $offset = 0[, $create_opcode = 0]]]])
; Description:		Creates ASM-Code/Opcode for copying register to specified 2D-array.
; Parameter(s):		$allocated_array	 - Handle returned by _AllocateMemoryForArray.
;					$register			 - (optional) Register which should be copied to array.
;					$index				 - (optional) Index of 1. Dimension which should be returned.
;					$offset				 - (optional) Specifies the offset of $register which should be copied.
;					$create_opcode		 - (optional) Specifies if Opcode (=1) should be returned or ASM-Code (=0) should be returned.
; Requirement(s):	FASM.au3
; Return Value(s): 	On Success - Returns the code specified by $create_opcode.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _CreateASM_CopyRegisterTo2DArray($allocated_array, $register = "eax",$index=0, $offset = 0, $create_opcode = 0)
	If IsArray($allocated_array) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If $offset = 0 Then
		$offset = $allocated_array[1]
	EndIf

	Local $count_register = "ecx"
	Local $temp_register = "edx"

	If $count_register = $register Then
		$count_register = "ebx"
	ElseIf $temp_register = $register Then
		$temp_register = "ebx"
	EndIf

	If $allocated_array[1] = 4 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & $temp_register & ", dword [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV dword [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register &"+" & $allocated_array[2]*$index & "]," & $temp_register & @CRLF & _
				"INC " & $count_register & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 2 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimLeft($temp_register, 1) & ",word [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV word [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register & "+" & $allocated_array[2]*$index & "]," & StringTrimLeft($temp_register, 1) & @CRLF & _
				"INC " & $count_register & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 1 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l,byte [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV byte [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register &"+" & $allocated_array[2]*$index & "]," & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l" & @CRLF & _
				"INC " & $count_register & @CRLF & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	EndIf

	If $create_opcode = 1 Then
		Local $splited = StringSplit($code, @CRLF, 2)

		Local $Fasm = FasmInit()
		FasmReset($Fasm)
		FasmAdd($Fasm, "use32")

		For $i = 0 To UBound($splited) - 1
			If $splited[$i] <> "" Then
				$splited[$i] = StringReplace(StringReplace($splited[$i], @LF, ""), @CR, "")
				FasmAdd($Fasm, $splited[$i])
			EndIf
		Next

		$code = StringTrimLeft(FasmGetBinary($Fasm), 2)
	EndIf

	Return $code
EndFunc   ;==>_CreateASM_CopyRegisterToArray


;==================================================================================
; Function:			_CreateASM_CopyRegisterTo2DArrayEx($allocated_array, $var_to_hold_last_address [, $register = "eax"[,  $offset = 0[, $create_opcode = 0]]])
; Description:		Creates ASM-Code/Opcode for copying register to specified 2D-array.
;					The created ASM/Opcode always copies register to the next array index,
;					increasing index for each loop by 1, if ASM-Code reaches end of array,
;					the ASM-Code will set index to 0 again.
;					$array[0]=register_first_execution
;					$array[1]=register_second_execution
;					...
;					$array[size_of_array]=register_size_of_array_execution
;					$array[0]=register_x_execution
;					...
;
; Parameter(s):		$allocated_array	 		 - Handle returned by _AllocateMemoryForArray.
;					$var_to_hold_last_address	 - Handle returned by _AllocateMemoryForVariable, variable must be of type int.
;					$register					 - (optional) Register which should be copied to array.
;					$delimiter					 - (optional) Specifies which delimiter should end the string,
;												   must be the asc-code of the character which should be used as delimiter.
;					$offset						 - (optional) Specifies the offset of $register which should be copied.
;					$create_opcode				 - (optional) Specifies if Opcode (=1) should be returned or ASM-Code (=0) should be returned.
; Requirement(s):	FASM.au3
; Return Value(s): 	On Success - Returns the code specified by $create_opcode.
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $allocated_array is not an array.
;							 2 = $var_to_hold_last_address is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _CreateASM_CopyRegisterTo2DArrayEx($allocated_array, $var_to_hold_last_address,$register = "eax",$delimiter=-1, $offset = 0, $create_opcode = 0)
	If IsArray($allocated_array) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If IsArray($var_to_hold_last_address) = 0 Then
		SetError(2)
		Return 0
	EndIf

	If $offset = 0 Then
		$offset = $allocated_array[1]
	EndIf

	Local $count_register = "ecx"
	Local $temp_register = "edx"
	Local $var_register = "esi"

	If $count_register = $register Then
		$count_register = "ebx"
	ElseIf $temp_register = $register Then
		$temp_register = "ebx"
	ElseIf $var_register = $register Then
		$var_register = "ebx"
	EndIf

	if $delimiter>-1 then
		If $allocated_array[1] = 4 Then
			$temp="CMP " & $temp_register & "," & $delimiter & @CRLF & "JE Sprung3"& @CRLF
		ElseIf $allocated_array[1] = 2 Then
			$temp="CMP " & StringTrimLeft($temp_register, 1) & "," & $delimiter & @CRLF & "JE Sprung3"& @CRLF
		ElseIf $allocated_array[1] = 1 Then
			$temp="CMP " & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l," & $delimiter & @CRLF & "JE Sprung3"& @CRLF
		EndIf
	Else
		$temp=""
	EndIf

	If $allocated_array[1] = 4 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register& @CRLF & "PUSH " & $var_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"MOV " & $var_register &","&" dword ["&$var_to_hold_last_address[0]&"]"& @CRLF & _
				"PUSH eax" & @CRLF & _
				"MOV eax,"&$var_register& @CRLF & _
				"MOV "&$var_register&","&$allocated_array[2]& @CRLF & _
				"PUSH edx" & @CRLF & _
				"MUL "&$var_register& @CRLF & _
				"POP edx" & @CRLF & _
				"MOV "&$var_register&", eax"& @CRLF & _
				"POP eax" & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & $temp_register & ", dword [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV dword [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register &"+" & $var_register & "]," & $temp_register & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp  & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"Sprung3: "& @CRLF & _
				"INC dword [" & $var_to_hold_last_address[0]&"]"& @CRLF & _
				"CMP dword [" & $var_to_hold_last_address[0]&"], "&$allocated_array[4]& @CRLF & _
				"JL Sprung2"& @CRLF & _
				"MOV dword [" & $var_to_hold_last_address[0]&"]" &",0"& @CRLF & _
				"Sprung2:" & @CRLF & _
				"POP " & $var_register & @CRLF & "POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 2 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "PUSH " & $var_register & @CRLF &"XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"MOV " & $var_register &","&" dword ["&$var_to_hold_last_address[0]&"]"& @CRLF & _
				"PUSH eax" & @CRLF & _
				"MOV eax,"&$var_register& @CRLF & _
				"MOV "&$var_register&","&$allocated_array[2]& @CRLF & _
				"PUSH edx" & @CRLF & _
				"MUL "&$var_register& @CRLF & _
				"POP edx" & @CRLF & _
				"MOV "&$var_register&", eax"& @CRLF & _
				"POP eax" & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimLeft($temp_register, 1) & ",word [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV word [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register & "+" & $var_register & "]," & StringTrimLeft($temp_register, 1) & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"Sprung3: "& @CRLF & _
				"INC dword [" & $var_to_hold_last_address[0]&"]"& @CRLF & _
				"CMP dword [" & $var_to_hold_last_address[0]&"], "&$allocated_array[4]& @CRLF & _
				"JL Sprung2"& @CRLF & _
				"MOV dword [" & $var_to_hold_last_address[0]&"]" &",0"& @CRLF & _
				"Sprung2:" & @CRLF & _
				"POP " & $var_register & @CRLF & "POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	ElseIf $allocated_array[1] = 1 Then
		Local $code = "PUSH " & $temp_register & @CRLF & "PUSH " & $register & @CRLF & "PUSH " & $count_register & @CRLF & "PUSH " & $var_register & @CRLF & "XOR " & $count_register & "," & $count_register & @CRLF & _
				"XOR " & $temp_register & "," & $temp_register & @CRLF & _
				"MOV " & $var_register &","&" dword ["&$var_to_hold_last_address[0]&"]"& @CRLF & _
				"PUSH eax" & @CRLF & _
				"MOV eax,"&$var_register& @CRLF & _
				"MOV "&$var_register&","&$allocated_array[2]& @CRLF & _
				"PUSH edx" & @CRLF & _
				"MUL "&$var_register& @CRLF & _
				"POP edx" & @CRLF & _
				"MOV "&$var_register&", eax"& @CRLF & _
				"POP eax" & @CRLF & _
				"Sprung1:" & @CRLF & _
				"MOV " & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l,byte [" & $register & "+" & $offset & "*" & $count_register & "]" & @CRLF & _
				"MOV byte [" & $allocated_array[0] & "+" & $allocated_array[1] & "*" & $count_register &"+" & $var_register & "]," & StringTrimRight(StringTrimLeft($temp_register, 1), 1) & "l" & @CRLF & _
				"INC " & $count_register & @CRLF & _
				$temp & _
				"CMP " & $count_register & "," & $allocated_array[2] - 1 & @CRLF & _
				"JNE Sprung1" & @CRLF & _
				"Sprung3: "& @CRLF & _
				"INC dword [" & $var_to_hold_last_address[0]&"]"& @CRLF & _
				"CMP dword [" & $var_to_hold_last_address[0]&"], "&$allocated_array[4]& @CRLF & _
				"JL Sprung2"& @CRLF & _
				"MOV dword [" & $var_to_hold_last_address[0]&"]" &",0"& @CRLF & _
				"Sprung2:" & @CRLF & _
				"POP " & $var_register & @CRLF & "POP " & $count_register & @CRLF & "POP " & $register & @CRLF & "POP " & $temp_register
	EndIf

	If $create_opcode = 1 Then
		Local $splited = StringSplit($code, @CRLF, 2)

		Local $Fasm = FasmInit()
		FasmReset($Fasm)
		FasmAdd($Fasm, "use32")

		For $i = 0 To UBound($splited) - 1
			If $splited[$i] <> "" Then
				$splited[$i] = StringReplace(StringReplace($splited[$i], @LF, ""), @CR, "")
				FasmAdd($Fasm, $splited[$i])
			EndIf
		Next

		$code = StringTrimLeft(FasmGetBinary($Fasm), 2)
	EndIf

	Return $code
EndFunc   ;==>_CreateASM_CopyRegisterToArray

;==================================================================================
; Function:			MemoryReset2DArray($ah_handle,$allocated_array,$index)
; Description:		Resets value of specified 2D-array at specified index.
; Parameter(s):		$ah_handle			 - A handle returned by _MemoryOpen (Nomad.au3)
; 									       or _MemoryManipulationOpen (CCInject.au3)
;					$allocated_array	 - Handle returned by _AllocateMemoryForArray.
;					$index				 - The 1. dimension index which should be reseted.
; Requirement(s):	None.
; Return Value(s): 	On Success - Returns 1
;					On Failure - Returns 0
;					@Error - 0 = No error.
;							 1 = $ah_handle is not an array.
;							 2 = $allocated_array is not an array.
; Author(s):		Shadow992
; Note(s):
;==================================================================================

Func _MemoryReset2DArray($ah_handle,$allocated_array,$index)

	If IsArray($ah_handle) = 0 Then
		SetError(1)
		Return 0
	EndIf

	If IsArray($allocated_array) = 0 Then
		SetError(2)
		Return 0
	EndIf

	Local $v_buffer_write = DllStructCreate("byte")
	Local $ptr_write = DllStructGetPtr($v_buffer_write)
	Local $struct_size_write = DllStructGetSize($v_buffer_write)

	DllStructSetData($v_buffer_write, 1, "0x0")

	DllCall($ah_handle[0], "int", "WriteProcessMemory", "int", $ah_handle[1], "int", $allocated_array[1]*$index*$allocated_array[2]+$allocated_array[0], "ptr", $ptr_write, "int", $struct_size_write, "int", "")
	Return 1
EndFunc
#endregion Memory-Manipulation by Shadow992 (elitepvpers.com)
