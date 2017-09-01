
Func _arrayadd(ByRef $avarray, $vvalue)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray)
	ReDim $avarray[$iubound + 1]
	$avarray[$iubound] = $vvalue
	Return $iubound
EndFunc

Func _arraybinarysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(5, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $imid = Int(($iend + $istart) / 2)
	If $avarray[$istart] > $vvalue OR $avarray[$iend] < $vvalue Then Return SetError(2, 0, -1)
	While $istart <= $imid AND $vvalue <> $avarray[$imid]
		If $vvalue < $avarray[$imid] Then
			$iend = $imid - 1
		Else
			$istart = $imid + 1
		EndIf
		$imid = Int(($iend + $istart) / 2)
	WEnd
	If $istart > $iend Then Return SetError(3, 0, -1)
	Return $imid
EndFunc

Func _arraycombinations(ByRef $avarray, $iset, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $in = UBound($avarray)
	Local $ir = $iset
	Local $aidx[$ir]
	For $i = 0 To $ir - 1
		$aidx[$i] = $i
	Next
	Local $itotal = __array_combinations($in, $ir)
	Local $ileft = $itotal
	Local $aresult[$itotal + 1]
	$aresult[0] = $itotal
	Local $icount = 1
	While $ileft > 0
		__array_getnext($in, $ir, $ileft, $itotal, $aidx)
		For $i = 0 To $iset - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	WEnd
	Return $aresult
EndFunc

Func _arrayconcatenate(ByRef $avarraytarget, Const ByRef $avarraysource, $istart = 0)
	If NOT IsArray($avarraytarget) Then Return SetError(1, 0, 0)
	If NOT IsArray($avarraysource) Then Return SetError(2, 0, 0)
	If UBound($avarraytarget, 0) <> 1 Then
		If UBound($avarraysource, 0) <> 1 Then Return SetError(5, 0, 0)
		Return SetError(3, 0, 0)
	EndIf
	If UBound($avarraysource, 0) <> 1 Then Return SetError(4, 0, 0)
	Local $iuboundtarget = UBound($avarraytarget) - $istart, $iuboundsource = UBound($avarraysource)
	ReDim $avarraytarget[$iuboundtarget + $iuboundsource]
	For $i = $istart To $iuboundsource - 1
		$avarraytarget[$iuboundtarget + $i] = $avarraysource[$i]
	Next
	Return $iuboundtarget + $iuboundsource
EndFunc

Func _arraycreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_array[@NumParams]
	Return $av_array
EndFunc

Func _arraydelete(ByRef $avarray, $ielement)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray, 1) - 1
	If NOT $iubound Then
		$avarray = ""
		Return 0
	EndIf
	If $ielement < 0 Then $ielement = 0
	If $ielement > $iubound Then $ielement = $iubound
	Switch UBound($avarray, 0)
		Case 1
			For $i = $ielement To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			ReDim $avarray[$iubound]
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			For $i = $ielement To $iubound - 1
				For $j = 0 To $isubmax
					$avarray[$i][$j] = $avarray[$i + 1][$j]
				Next
			Next
			ReDim $avarray[$iubound][$isubmax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	Return $iubound
EndFunc

Func _arraydisplay(Const ByRef $avarray, $stitle = "Array: ListView Display", $iitemlimit = -1, $itranspose = 0, $sseparator = "", $sreplace = "|", $sheader = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $idimension = UBound($avarray, 0), $iubound = UBound($avarray, 1) - 1, $isubmax = UBound($avarray, 2) - 1
	If $idimension > 2 Then Return SetError(2, 0, 0)
	If $sseparator = "" Then $sseparator = Chr(124)
	If _arraysearch($avarray, $sseparator, 0, 0, 0, 1) <> -1 Then
		For $x = 1 To 255
			If $x >= 32 AND $x <= 127 Then ContinueLoop 
			Local $sfind = _arraysearch($avarray, Chr($x), 0, 0, 0, 1)
			If $sfind = -1 Then
				$sseparator = Chr($x)
				ExitLoop 
			EndIf
		Next
	EndIf
	Local $vtmp, $ibuffer = 64
	Local $icollimit = 250
	Local $ioneventmode = Opt("GUIOnEventMode", 0), $sdataseparatorchar = Opt("GUIDataSeparatorChar", $sseparator)
	If $isubmax < 0 Then $isubmax = 0
	If $itranspose Then
		$vtmp = $iubound
		$iubound = $isubmax
		$isubmax = $vtmp
	EndIf
	If $isubmax > $icollimit Then $isubmax = $icollimit
	If $iitemlimit < 1 Then $iitemlimit = $iubound
	If $iubound > $iitemlimit Then $iubound = $iitemlimit
	If $sheader = "" Then
		$sheader = "Row  "
		For $i = 0 To $isubmax
			$sheader &= $sseparator & "Col " & $i
		Next
	EndIf
	Local $avarraytext[$iubound + 1]
	For $i = 0 To $iubound
		$avarraytext[$i] = "[" & $i & "]"
		For $j = 0 To $isubmax
			If $idimension = 1 Then
				If $itranspose Then
					$vtmp = $avarray[$j]
				Else
					$vtmp = $avarray[$i]
				EndIf
			Else
				If $itranspose Then
					$vtmp = $avarray[$j][$i]
				Else
					$vtmp = $avarray[$i][$j]
				EndIf
			EndIf
			$vtmp = StringReplace($vtmp, $sseparator, $sreplace, 0, 1)
			$avarraytext[$i] &= $sseparator & $vtmp
			$vtmp = StringLen($vtmp)
			If $vtmp > $ibuffer Then $ibuffer = $vtmp
		Next
	Next
	$ibuffer += 1
	Local Const $_arrayconstant_gui_dockborders = 102
	Local Const $_arrayconstant_gui_dockbottom = 64
	Local Const $_arrayconstant_gui_dockheight = 512
	Local Const $_arrayconstant_gui_dockleft = 2
	Local Const $_arrayconstant_gui_dockright = 4
	Local Const $_arrayconstant_gui_event_close = -3
	Local Const $_arrayconstant_lvif_param = 4
	Local Const $_arrayconstant_lvif_text = 1
	Local Const $_arrayconstant_lvm_getcolumnwidth = (4096 + 29)
	Local Const $_arrayconstant_lvm_getitemcount = (4096 + 4)
	Local Const $_arrayconstant_lvm_getitemstate = (4096 + 44)
	Local Const $_arrayconstant_lvm_insertitemw = (4096 + 77)
	Local Const $_arrayconstant_lvm_setextendedlistviewstyle = (4096 + 54)
	Local Const $_arrayconstant_lvm_setitemw = (4096 + 76)
	Local Const $_arrayconstant_lvs_ex_fullrowselect = 32
	Local Const $_arrayconstant_lvs_ex_gridlines = 1
	Local Const $_arrayconstant_lvs_showselalways = 8
	Local Const $_arrayconstant_ws_ex_clientedge = 512
	Local Const $_arrayconstant_ws_maximizebox = 65536
	Local Const $_arrayconstant_ws_minimizebox = 131072
	Local Const $_arrayconstant_ws_sizebox = 262144
	Local Const $_arrayconstant_taglvitem = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"
	Local $iaddmask = BitOR($_arrayconstant_lvif_text, $_arrayconstant_lvif_param)
	Local $tbuffer = DllStructCreate("wchar Text[" & $ibuffer & "]"), $pbuffer = DllStructGetPtr($tbuffer)
	Local $titem = DllStructCreate($_arrayconstant_taglvitem), $pitem = DllStructGetPtr($titem)
	DllStructSetData($titem, "Param", 0)
	DllStructSetData($titem, "Text", $pbuffer)
	DllStructSetData($titem, "TextMax", $ibuffer)
	Local $iwidth = 640, $iheight = 480
	Local $hgui = GUICreate($stitle, $iwidth, $iheight, Default, Default, BitOR($_arrayconstant_ws_sizebox, $_arrayconstant_ws_minimizebox, $_arrayconstant_ws_maximizebox))
	Local $aiguisize = WinGetClientSize($hgui)
	Local $hlistview = GUICtrlCreateListView($sheader, 0, 0, $aiguisize[0], $aiguisize[1] - 26, $_arrayconstant_lvs_showselalways)
	Local $hcopy = GUICtrlCreateButton("Copy Selected", 3, $aiguisize[1] - 23, $aiguisize[0] - 6, 20)
	GUICtrlSetResizing($hlistview, $_arrayconstant_gui_dockborders)
	GUICtrlSetResizing($hcopy, $_arrayconstant_gui_dockleft + $_arrayconstant_gui_dockright + $_arrayconstant_gui_dockbottom + $_arrayconstant_gui_dockheight)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_gridlines, $_arrayconstant_lvs_ex_gridlines)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_fullrowselect, $_arrayconstant_lvs_ex_fullrowselect)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_ws_ex_clientedge, $_arrayconstant_ws_ex_clientedge)
	Local $aitem
	For $i = 0 To $iubound
		If GUICtrlCreateListViewItem($avarraytext[$i], $hlistview) = 0 Then
			$aitem = StringSplit($avarraytext[$i], $sseparator)
			DllStructSetData($tbuffer, "Text", $aitem[1])
			DllStructSetData($titem, "Item", $i)
			DllStructSetData($titem, "SubItem", 0)
			DllStructSetData($titem, "Mask", $iaddmask)
			GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_insertitemw, 0, $pitem)
			DllStructSetData($titem, "Mask", $_arrayconstant_lvif_text)
			For $j = 2 To $aitem[0]
				DllStructSetData($tbuffer, "Text", $aitem[$j])
				DllStructSetData($titem, "SubItem", $j - 1)
				GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setitemw, 0, $pitem)
			Next
		EndIf
	Next
	$iwidth = 0
	For $i = 0 To $isubmax + 1
		$iwidth += GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getcolumnwidth, $i, 0)
	Next
	If $iwidth < 250 Then $iwidth = 230
	$iwidth += 20
	If $iwidth > @DesktopWidth Then $iwidth = @DesktopWidth - 100
	WinMove($hgui, "", (@DesktopWidth - $iwidth) / 2, Default, $iwidth)
	GUISetState(@SW_SHOW, $hgui)
	While 1
		Switch GUIGetMsg()
			Case $_arrayconstant_gui_event_close
				ExitLoop 
			Case $hcopy
				Local $sclip = ""
				Local $aicuritems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemcount, 0, 0)
					If GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemstate, $i, 2) Then
						$aicuritems[0] += 1
						ReDim $aicuritems[$aicuritems[0] + 1]
						$aicuritems[$aicuritems[0]] = $i
					EndIf
				Next
				If NOT $aicuritems[0] Then
					For $sitem In $avarraytext
						$sclip &= $sitem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aicuritems) - 1
						$sclip &= $avarraytext[$aicuritems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sclip)
		EndSwitch
	WEnd
	GUIDelete($hgui)
	Opt("GUIOnEventMode", $ioneventmode)
	Opt("GUIDataSeparatorChar", $sdataseparatorchar)
	Return 1
EndFunc

Func _arrayfindall(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $ipartial = 0, $isubitem = 0)
	$istart = _arraysearch($avarray, $vvalue, $istart, $iend, $icase, $ipartial, 1, $isubitem)
	If @error Then Return SetError(@error, 0, -1)
	Local $iindex = 0, $avresult[UBound($avarray)]
	Do
		$avresult[$iindex] = $istart
		$iindex += 1
		$istart = _arraysearch($avarray, $vvalue, $istart + 1, $iend, $icase, $ipartial, 1, $isubitem)
	Until @error
	ReDim $avresult[$iindex]
	Return $avresult
EndFunc

Func _arrayinsert(ByRef $avarray, $ielement, $vvalue = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) + 1
	ReDim $avarray[$iubound]
	For $i = $iubound - 1 To $ielement + 1 Step -1
		$avarray[$i] = $avarray[$i - 1]
	Next
	$avarray[$ielement] = $vvalue
	Return $iubound
EndFunc

Func _arraymax(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arraymaxindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arraymaxindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) OR UBound($avarray, 0) <> 1 Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $imaxindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$imaxindex]) < Number($avarray[$i]) Then $imaxindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$imaxindex] < $avarray[$i] Then $imaxindex = $i
		Next
	EndIf
	Return $imaxindex
EndFunc

Func _arraymin(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arrayminindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arrayminindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $iminindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$iminindex]) > Number($avarray[$i]) Then $iminindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$iminindex] > $avarray[$i] Then $iminindex = $i
		Next
	EndIf
	Return $iminindex
EndFunc

Func _arraypermute(ByRef $avarray, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $isize = UBound($avarray), $ifactorial = 1, $aidx[$isize], $aresult[1], $icount = 1
	For $i = 0 To $isize - 1
		$aidx[$i] = $i
	Next
	For $i = $isize To 1 Step -1
		$ifactorial *= $i
	Next
	ReDim $aresult[$ifactorial + 1]
	$aresult[0] = $ifactorial
	__array_exeterinternal($avarray, 0, $isize, $sdelim, $aidx, $aresult, $icount)
	Return $aresult
EndFunc

Func _arraypop(ByRef $avarray)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, "")
	Local $iubound = UBound($avarray) - 1, $slastval = $avarray[$iubound]
	If NOT $iubound Then
		$avarray = ""
	Else
		ReDim $avarray[$iubound]
	EndIf
	Return $slastval
EndFunc

Func _arraypush(ByRef $avarray, $vvalue, $idirection = 0)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If IsArray($vvalue) Then
		Local $iubounds = UBound($vvalue)
		If ($iubounds - 1) > $iubound Then Return SetError(2, 0, 0)
		If $idirection Then
			For $i = $iubound To $iubounds Step -1
				$avarray[$i] = $avarray[$i - $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i] = $vvalue[$i]
			Next
		Else
			For $i = 0 To $iubound - $iubounds
				$avarray[$i] = $avarray[$i + $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i + $iubound - $iubounds + 1] = $vvalue[$i]
			Next
		EndIf
	Else
		If $idirection Then
			For $i = $iubound To 1 Step -1
				$avarray[$i] = $avarray[$i - 1]
			Next
			$avarray[0] = $vvalue
		Else
			For $i = 0 To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			$avarray[$iubound] = $vvalue
		EndIf
	EndIf
	Return 1
EndFunc

Func _arrayreverse(ByRef $avarray, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $vtmp, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	For $i = $istart To Int(($istart + $iend - 1) / 2)
		$vtmp = $avarray[$i]
		$avarray[$i] = $avarray[$iend]
		$avarray[$iend] = $vtmp
		$iend -= 1
	Next
	Return 1
EndFunc

Func _arraysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $ipartial = 0, $iforward = 1, $isubitem = -1)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) > 2 OR UBound($avarray, 0) < 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $istep = 1
	If NOT $iforward Then
		Local $itmp = $istart
		$istart = $iend
		$iend = $itmp
		$istep = -1
	EndIf
	Switch UBound($avarray, 0)
		Case 1
			If NOT $ipartial Then
				If NOT $icase Then
					For $i = $istart To $iend Step $istep
						If $avarray[$i] = $vvalue Then Return $i
					Next
				Else
					For $i = $istart To $iend Step $istep
						If $avarray[$i] == $vvalue Then Return $i
					Next
				EndIf
			Else
				For $i = $istart To $iend Step $istep
					If StringInStr($avarray[$i], $vvalue, $icase) > 0 Then Return $i
				Next
			EndIf
		Case 2
			Local $iuboundsub = UBound($avarray, 2) - 1
			If $isubitem > $iuboundsub Then $isubitem = $iuboundsub
			If $isubitem < 0 Then
				$isubitem = 0
			Else
				$iuboundsub = $isubitem
			EndIf
			For $j = $isubitem To $iuboundsub
				If NOT $ipartial Then
					If NOT $icase Then
						For $i = $istart To $iend Step $istep
							If $avarray[$i][$j] = $vvalue Then Return $i
						Next
					Else
						For $i = $istart To $iend Step $istep
							If $avarray[$i][$j] == $vvalue Then Return $i
						Next
					EndIf
				Else
					For $i = $istart To $iend Step $istep
						If StringInStr($avarray[$i][$j], $vvalue, $icase) > 0 Then Return $i
					Next
				EndIf
			Next
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc

Func _arraysort(ByRef $avarray, $idescending = 0, $istart = 0, $iend = 0, $isubitem = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	Switch UBound($avarray, 0)
		Case 1
			__arrayquicksort1d($avarray, $istart, $iend)
			If $idescending Then _arrayreverse($avarray, $istart, $iend)
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			If $isubitem > $isubmax Then Return SetError(3, 0, 0)
			If $idescending Then
				$idescending = -1
			Else
				$idescending = 1
			EndIf
			__arrayquicksort2d($avarray, $idescending, $istart, $iend, $isubitem, $isubmax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch
	Return 1
EndFunc

Func __arrayquicksort1d(ByRef $avarray, ByRef $istart, ByRef $iend)
	If $iend <= $istart Then Return 
	Local $vtmp
	If ($iend - $istart) < 15 Then
		Local $vcur
		For $i = $istart + 1 To $iend
			$vtmp = $avarray[$i]
			If IsNumber($vtmp) Then
				For $j = $i - 1 To $istart Step -1
					$vcur = $avarray[$j]
					If ($vtmp >= $vcur AND IsNumber($vcur)) OR (NOT IsNumber($vcur) AND StringCompare($vtmp, $vcur) >= 0) Then ExitLoop 
					$avarray[$j + 1] = $vcur
				Next
			Else
				For $j = $i - 1 To $istart Step -1
					If (StringCompare($vtmp, $avarray[$j]) >= 0) Then ExitLoop 
					$avarray[$j + 1] = $avarray[$j]
				Next
			EndIf
			$avarray[$j + 1] = $vtmp
		Next
		Return 
	EndIf
	Local $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($avarray[$l] < $vpivot AND IsNumber($avarray[$l])) OR (NOT IsNumber($avarray[$l]) AND StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While ($avarray[$r] > $vpivot AND IsNumber($avarray[$r])) OR (NOT IsNumber($avarray[$r]) AND StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While (StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While (StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			$vtmp = $avarray[$l]
			$avarray[$l] = $avarray[$r]
			$avarray[$r] = $vtmp
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort1d($avarray, $istart, $r)
	__arrayquicksort1d($avarray, $l, $iend)
EndFunc

Func __arrayquicksort2d(ByRef $avarray, ByRef $istep, ByRef $istart, ByRef $iend, ByRef $isubitem, ByRef $isubmax)
	If $iend <= $istart Then Return 
	Local $vtmp, $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)][$isubitem], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($istep * ($avarray[$l][$isubitem] - $vpivot) < 0 AND IsNumber($avarray[$l][$isubitem])) OR (NOT IsNumber($avarray[$l][$isubitem]) AND $istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * ($avarray[$r][$isubitem] - $vpivot) > 0 AND IsNumber($avarray[$r][$isubitem])) OR (NOT IsNumber($avarray[$r][$isubitem]) AND $istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While ($istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			For $i = 0 To $isubmax
				$vtmp = $avarray[$l][$i]
				$avarray[$l][$i] = $avarray[$r][$i]
				$avarray[$r][$i] = $vtmp
			Next
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort2d($avarray, $istep, $istart, $r, $isubitem, $isubmax)
	__arrayquicksort2d($avarray, $istep, $l, $iend, $isubitem, $isubmax)
EndFunc

Func _arrayswap(ByRef $vitem1, ByRef $vitem2)
	Local $vtmp = $vitem1
	$vitem1 = $vitem2
	$vitem2 = $vtmp
EndFunc

Func _arraytoclip(Const ByRef $avarray, $istart = 0, $iend = 0)
	Local $sresult = _arraytostring($avarray, @CR, $istart, $iend)
	If @error Then Return SetError(@error, 0, 0)
	Return ClipPut($sresult)
EndFunc

Func _arraytostring(Const ByRef $avarray, $sdelim = "|", $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, "")
	Local $sresult, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, "")
	For $i = $istart To $iend
		$sresult &= $avarray[$i] & $sdelim
	Next
	Return StringTrimRight($sresult, StringLen($sdelim))
EndFunc

Func _arraytrim(ByRef $avarray, $itrimnum, $idirection = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(5, 0, 0)
	If $idirection Then
		For $i = $istart To $iend
			$avarray[$i] = StringTrimRight($avarray[$i], $itrimnum)
		Next
	Else
		For $i = $istart To $iend
			$avarray[$i] = StringTrimLeft($avarray[$i], $itrimnum)
		Next
	EndIf
	Return 1
EndFunc

Func _arrayunique($aarray, $idimension = 1, $ibase = 0, $icase = 0, $vdelim = "|")
	Local $iubounddim
	If $vdelim = "|" Then $vdelim = Chr(1)
	If NOT IsArray($aarray) Then Return SetError(1, 0, 0)
	If NOT $idimension > 0 Then
		Return SetError(3, 0, 0)
	Else
		$iubounddim = UBound($aarray, 1)
		If @error Then Return SetError(3, 0, 0)
		If $idimension > 1 Then
			Local $aarraytmp[1]
			For $i = 0 To $iubounddim - 1
				_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
			Next
			_arraydelete($aarraytmp, 0)
		Else
			If UBound($aarray, 0) = 1 Then
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i])
				Next
				_arraydelete($aarraytmp, 0)
			Else
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
				Next
				_arraydelete($aarraytmp, 0)
			EndIf
		EndIf
	EndIf
	Local $shold
	For $icc = $ibase To UBound($aarraytmp) - 1
		If NOT StringInStr($vdelim & $shold, $vdelim & $aarraytmp[$icc] & $vdelim, $icase) Then $shold &= $aarraytmp[$icc] & $vdelim
	Next
	If $shold Then
		$aarraytmp = StringSplit(StringTrimRight($shold, StringLen($vdelim)), $vdelim, 1)
		Return $aarraytmp
	EndIf
	Return SetError(2, 0, 0)
EndFunc

Func __array_exeterinternal(ByRef $avarray, $istart, $isize, $sdelim, ByRef $aidx, ByRef $aresult, ByRef $icount)
	If $istart == $isize - 1 Then
		For $i = 0 To $isize - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	Else
		Local $itemp
		For $i = $istart To $isize - 1
			$itemp = $aidx[$i]
			$aidx[$i] = $aidx[$istart]
			$aidx[$istart] = $itemp
			__array_exeterinternal($avarray, $istart + 1, $isize, $sdelim, $aidx, $aresult, $icount)
			$aidx[$istart] = $aidx[$i]
			$aidx[$i] = $itemp
		Next
	EndIf
EndFunc

Func __array_combinations($in, $ir)
	Local $i_total = 1
	For $i = $ir To 1 Step -1
		$i_total *= ($in / $i)
		$in -= 1
	Next
	Return Round($i_total)
EndFunc

Func __array_getnext($in, $ir, ByRef $ileft, $itotal, ByRef $aidx)
	If $ileft == $itotal Then
		$ileft -= 1
		Return 
	EndIf
	Local $i = $ir - 1
	While $aidx[$i] == $in - $ir + $i
		$i -= 1
	WEnd
	$aidx[$i] += 1
	For $j = $i + 1 To $ir - 1
		$aidx[$j] = $aidx[$i] + $j - $i
	Next
	$ileft -= 1
EndFunc

Global Const $fc_nooverwrite = 0
Global Const $fc_overwrite = 1
Global Const $ft_modified = 0
Global Const $ft_created = 1
Global Const $ft_accessed = 2
Global Const $fo_read = 0
Global Const $fo_append = 1
Global Const $fo_overwrite = 2
Global Const $fo_binary = 16
Global Const $fo_unicode = 32
Global Const $fo_utf16_le = 32
Global Const $fo_utf16_be = 64
Global Const $fo_utf8 = 128
Global Const $fo_utf8_nobom = 256
Global Const $eof = -1
Global Const $fd_filemustexist = 1
Global Const $fd_pathmustexist = 2
Global Const $fd_multiselect = 4
Global Const $fd_promptcreatenew = 8
Global Const $fd_promptoverwrite = 16
Global Const $create_new = 1
Global Const $create_always = 2
Global Const $open_existing = 3
Global Const $open_always = 4
Global Const $truncate_existing = 5
Global Const $invalid_set_file_pointer = -1
Global Const $file_begin = 0
Global Const $file_current = 1
Global Const $file_end = 2
Global Const $file_attribute_readonly = 1
Global Const $file_attribute_hidden = 2
Global Const $file_attribute_system = 4
Global Const $file_attribute_directory = 16
Global Const $file_attribute_archive = 32
Global Const $file_attribute_device = 64
Global Const $file_attribute_normal = 128
Global Const $file_attribute_temporary = 256
Global Const $file_attribute_sparse_file = 512
Global Const $file_attribute_reparse_point = 1024
Global Const $file_attribute_compressed = 2048
Global Const $file_attribute_offline = 4096
Global Const $file_attribute_not_content_indexed = 8192
Global Const $file_attribute_encrypted = 16384
Global Const $file_share_read = 1
Global Const $file_share_write = 2
Global Const $file_share_delete = 4
Global Const $generic_all = 268435456
Global Const $generic_execute = 536870912
Global Const $generic_write = 1073741824
Global Const $generic_read = -2147483648

Func _filecountlines($sfilepath)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $sfilecontent = StringStripWS(FileRead($hfile), 2)
	FileClose($hfile)
	Local $atmp
	If StringInStr($sfilecontent, @LF) Then
		$atmp = StringSplit(StringStripCR($sfilecontent), @LF)
	ElseIf StringInStr($sfilecontent, @CR) Then
		$atmp = StringSplit($sfilecontent, @CR)
	Else
		If StringLen($sfilecontent) Then
			Return 1
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return $atmp[0]
EndFunc

Func _filecreate($sfilepath)
	Local $hopenfile = FileOpen($sfilepath, $fo_overwrite)
	If $hopenfile = -1 Then Return SetError(1, 0, 0)
	Local $hwritefile = FileWrite($hopenfile, "")
	FileClose($hopenfile)
	If $hwritefile = -1 Then Return SetError(2, 0, 0)
	Return 1
EndFunc

Func _filelisttoarray($spath, $sfilter = "*", $iflag = 0)
	Local $hsearch, $sfile, $sfilelist, $sdelim = "|"
	$spath = StringRegExpReplace($spath, "[\\/]+\z", "") & "\"
	If NOT FileExists($spath) Then Return SetError(1, 1, "")
	If StringRegExp($sfilter, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If NOT ($iflag = 0 OR $iflag = 1 OR $iflag = 2) Then Return SetError(3, 3, "")
	$hsearch = FileFindFirstFile($spath & $sfilter)
	If @error Then Return SetError(4, 4, "")
	While 1
		$sfile = FileFindNextFile($hsearch)
		If @error Then ExitLoop 
		If ($iflag + @extended = 2) Then ContinueLoop 
		$sfilelist &= $sdelim & $sfile
	WEnd
	FileClose($hsearch)
	If NOT $sfilelist Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($sfilelist, 1), "|")
EndFunc

Func _fileprint($s_file, $i_show = @SW_HIDE)
	Local $a_ret = DllCall("shell32.dll", "int", "ShellExecuteW", "hwnd", 0, "wstr", "print", "wstr", $s_file, "wstr", "", "wstr", "", "int", $i_show)
	If @error Then Return SetError(@error, @extended, 0)
	If $a_ret[0] <= 32 Then Return SetError(10, $a_ret[0], 0)
	Return 1
EndFunc

Func _filereadtoarray($sfilepath, ByRef $aarray)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $afile = FileRead($hfile, FileGetSize($sfilepath))
	If StringRight($afile, 1) = @LF Then $afile = StringTrimRight($afile, 1)
	If StringRight($afile, 1) = @CR Then $afile = StringTrimRight($afile, 1)
	FileClose($hfile)
	If StringInStr($afile, @LF) Then
		$aarray = StringSplit(StringStripCR($afile), @LF)
	ElseIf StringInStr($afile, @CR) Then
		$aarray = StringSplit($afile, @CR)
	Else
		If StringLen($afile) Then
			Dim $aarray[2] = [1, $afile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc

Func _filewritefromarray($file, $a_array, $i_base = 0, $i_ubound = 0)
	If NOT IsArray($a_array) Then Return SetError(2, 0, 0)
	Local $last = UBound($a_array) - 1
	If $i_ubound < 1 OR $i_ubound > $last Then $i_ubound = $last
	If $i_base < 0 OR $i_base > $last Then $i_base = 0
	Local $hfile
	If IsString($file) Then
		$hfile = FileOpen($file, $fo_overwrite)
	Else
		$hfile = $file
	EndIf
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $errorsav = 0
	For $x = $i_base To $i_ubound
		If FileWrite($hfile, $a_array[$x] & @CRLF) = 0 Then
			$errorsav = 3
			ExitLoop 
		EndIf
	Next
	If IsString($file) Then FileClose($hfile)
	If $errorsav Then Return SetError($errorsav, 0, 0)
	Return 1
EndFunc

Func _filewritelog($slogpath, $slogmsg, $iflag = -1)
	Local $iopenmode = $fo_append
	Local $sdatenow = @YEAR & "-" & @MON & "-" & @MDAY
	Local $stimenow = @HOUR & ":" & @MIN & ":" & @SEC
	Local $smsg = $sdatenow & " " & $stimenow & " : " & $slogmsg
	If $iflag <> -1 Then
		$smsg &= @CRLF & FileRead($slogpath)
		$iopenmode = $fo_overwrite
	EndIf
	Local $hopenfile = FileOpen($slogpath, $iopenmode)
	If $hopenfile = -1 Then Return SetError(1, 0, 0)
	Local $iwritefile = FileWriteLine($hopenfile, $smsg)
	Local $iret = FileClose($hopenfile)
	If $iwritefile = -1 Then Return SetError(2, $iret, 0)
	Return $iret
EndFunc

Func _filewritetoline($sfile, $iline, $stext, $foverwrite = 0)
	If $iline <= 0 Then Return SetError(4, 0, 0)
	If NOT IsString($stext) Then
		$stext = String($stext)
		If $stext = "" Then Return SetError(6, 0, 0)
	EndIf
	If $foverwrite <> 0 AND $foverwrite <> 1 Then Return SetError(5, 0, 0)
	If NOT FileExists($sfile) Then Return SetError(2, 0, 0)
	Local $sread_file = FileRead($sfile)
	Local $asplit_file = StringSplit(StringStripCR($sread_file), @LF)
	If UBound($asplit_file) < $iline Then Return SetError(1, 0, 0)
	Local $hfile = FileOpen($sfile, $fo_overwrite)
	If $hfile = -1 Then Return SetError(3, 0, 0)
	$sread_file = ""
	For $i = 1 To $asplit_file[0]
		If $i = $iline Then
			If $foverwrite = 1 Then
				If $stext <> "" Then $sread_file &= $stext & @CRLF
			Else
				$sread_file &= $stext & @CRLF & $asplit_file[$i] & @CRLF
			EndIf
		ElseIf $i < $asplit_file[0] Then
			$sread_file &= $asplit_file[$i] & @CRLF
		ElseIf $i = $asplit_file[0] Then
			$sread_file &= $asplit_file[$i]
		EndIf
	Next
	FileWrite($hfile, $sread_file)
	FileClose($hfile)
	Return 1
EndFunc

Func _pathfull($srelativepath, $sbasepath = @WorkingDir)
	If NOT $srelativepath OR $srelativepath = "." Then Return $sbasepath
	Local $sfullpath = StringReplace($srelativepath, "/", "\")
	Local Const $sfullpathconst = $sfullpath
	Local $spath
	Local $brootonly = StringLeft($sfullpath, 1) = "\" AND StringMid($sfullpath, 2, 1) <> "\"
	For $i = 1 To 2
		$spath = StringLeft($sfullpath, 2)
		If $spath = "\\" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			Local $nserverlen = StringInStr($sfullpath, "\") - 1
			$spath = "\\" & StringLeft($sfullpath, $nserverlen)
			$sfullpath = StringTrimLeft($sfullpath, $nserverlen)
			ExitLoop 
		ElseIf StringRight($spath, 1) = ":" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			ExitLoop 
		Else
			$sfullpath = $sbasepath & "\" & $sfullpath
		EndIf
	Next
	If $i = 3 Then Return ""
	If StringLeft($sfullpath, 1) <> "\" Then
		If StringLeft($sfullpathconst, 2) = StringLeft($sbasepath, 2) Then
			$sfullpath = $sbasepath & "\" & $sfullpath
		Else
			$sfullpath = "\" & $sfullpath
		EndIf
	EndIf
	Local $atemp = StringSplit($sfullpath, "\")
	Local $apathparts[$atemp[0]], $j = 0
	For $i = 2 To $atemp[0]
		If $atemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf NOT ($atemp[$i] = "" AND $i <> $atemp[0]) AND $atemp[$i] <> "." Then
			$apathparts[$j] = $atemp[$i]
			$j += 1
		EndIf
	Next
	$sfullpath = $spath
	If NOT $brootonly Then
		For $i = 0 To $j - 1
			$sfullpath &= "\" & $apathparts[$i]
		Next
	Else
		$sfullpath &= $sfullpathconst
		If StringInStr($sfullpath, "..") Then $sfullpath = _pathfull($sfullpath)
	EndIf
	While StringInStr($sfullpath, ".\")
		$sfullpath = StringReplace($sfullpath, ".\", "\")
	WEnd
	Return $sfullpath
EndFunc

Func _pathgetrelative($sfrom, $sto)
	If StringRight($sfrom, 1) <> "\" Then $sfrom &= "\"
	If StringRight($sto, 1) <> "\" Then $sto &= "\"
	If $sfrom = $sto Then Return SetError(1, 0, StringTrimRight($sto, 1))
	Local $asfrom = StringSplit($sfrom, "\")
	Local $asto = StringSplit($sto, "\")
	If $asfrom[1] <> $asto[1] Then Return SetError(2, 0, StringTrimRight($sto, 1))
	Local $i = 2
	Local $idiff = 1
	While 1
		If $asfrom[$i] <> $asto[$i] Then
			$idiff = $i
			ExitLoop 
		EndIf
		$i += 1
	WEnd
	$i = 1
	Local $srelpath = ""
	For $j = 1 To $asto[0]
		If $i >= $idiff Then
			$srelpath &= "\" & $asto[$i]
		EndIf
		$i += 1
	Next
	$srelpath = StringTrimLeft($srelpath, 1)
	$i = 1
	For $j = 1 To $asfrom[0]
		If $i > $idiff Then
			$srelpath = "..\" & $srelpath
		EndIf
		$i += 1
	Next
	If StringRight($srelpath, 1) == "\" Then $srelpath = StringTrimRight($srelpath, 1)
	Return $srelpath
EndFunc

Func _pathmake($szdrive, $szdir, $szfname, $szext)
	If StringLen($szdrive) Then
		If NOT (StringLeft($szdrive, 2) = "\\") Then $szdrive = StringLeft($szdrive, 1) & ":"
	EndIf
	If StringLen($szdir) Then
		If NOT (StringRight($szdir, 1) = "\") AND NOT (StringRight($szdir, 1) = "/") Then $szdir = $szdir & "\"
	EndIf
	If StringLen($szext) Then
		If NOT (StringLeft($szext, 1) = ".") Then $szext = "." & $szext
	EndIf
	Return $szdrive & $szdir & $szfname & $szext
EndFunc

Func _pathsplit($szpath, ByRef $szdrive, ByRef $szdir, ByRef $szfname, ByRef $szext)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos
	Local $array[5]
	$array[0] = $szpath
	If StringMid($szpath, 2, 1) = ":" Then
		$drive = StringLeft($szpath, 2)
		$szpath = StringTrimLeft($szpath, 2)
	ElseIf StringLeft($szpath, 2) = "\\" Then
		$szpath = StringTrimLeft($szpath, 2)
		$pos = StringInStr($szpath, "\")
		If $pos = 0 Then $pos = StringInStr($szpath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szpath
			$szpath = ""
		Else
			$drive = "\\" & StringLeft($szpath, $pos - 1)
			$szpath = StringTrimLeft($szpath, $pos - 1)
		EndIf
	EndIf
	Local $nposforward = StringInStr($szpath, "/", 0, -1)
	Local $nposbackward = StringInStr($szpath, "\", 0, -1)
	If $nposforward >= $nposbackward Then
		$pos = $nposforward
	Else
		$pos = $nposbackward
	EndIf
	$dir = StringLeft($szpath, $pos)
	$fname = StringRight($szpath, StringLen($szpath) - $pos)
	If StringLen($dir) = 0 Then $fname = $szpath
	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf
	$szdrive = $drive
	$szdir = $dir
	$szfname = $fname
	$szext = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc

Func _replacestringinfile($szfilename, $szsearchstring, $szreplacestring, $fcaseness = 0, $foccurance = 1)
	Local $iretval = 0
	Local $ncount, $sendswith
	If StringInStr(FileGetAttrib($szfilename), "R") Then Return SetError(6, 0, -1)
	Local $hfile = FileOpen($szfilename, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, -1)
	Local $s_totfile = FileRead($hfile, FileGetSize($szfilename))
	If StringRight($s_totfile, 2) = @CRLF Then
		$sendswith = @CRLF
	ElseIf StringRight($s_totfile, 1) = @CR Then
		$sendswith = @CR
	ElseIf StringRight($s_totfile, 1) = @LF Then
		$sendswith = @LF
	Else
		$sendswith = ""
	EndIf
	Local $afilelines = StringSplit(StringStripCR($s_totfile), @LF)
	FileClose($hfile)
	Local $hwritehandle = FileOpen($szfilename, $fo_overwrite)
	If $hwritehandle = -1 Then Return SetError(2, 0, -1)
	For $ncount = 1 To $afilelines[0]
		If StringInStr($afilelines[$ncount], $szsearchstring, $fcaseness) Then
			$afilelines[$ncount] = StringReplace($afilelines[$ncount], $szsearchstring, $szreplacestring, 1 - $foccurance, $fcaseness)
			$iretval = $iretval + 1
			If $foccurance = 0 Then
				$iretval = 1
				ExitLoop 
			EndIf
		EndIf
	Next
	For $ncount = 1 To $afilelines[0] - 1
		If FileWriteLine($hwritehandle, $afilelines[$ncount]) = 0 Then
			FileClose($hwritehandle)
			Return SetError(3, 0, -1)
		EndIf
	Next
	If $afilelines[$ncount] <> "" Then FileWrite($hwritehandle, $afilelines[$ncount] & $sendswith)
	FileClose($hwritehandle)
	Return $iretval
EndFunc

Func _tempfile($s_directoryname = @TempDir, $s_fileprefix = "~", $s_fileextension = ".tmp", $i_randomlength = 7)
	If NOT FileExists($s_directoryname) Then $s_directoryname = @TempDir
	If NOT FileExists($s_directoryname) Then $s_directoryname = @ScriptDir
	If StringRight($s_directoryname, 1) <> "\" Then $s_directoryname = $s_directoryname & "\"
	Local $s_tempname
	Do
		$s_tempname = ""
		While StringLen($s_tempname) < $i_randomlength
			$s_tempname = $s_tempname & Chr(Random(97, 122, 1))
		WEnd
		$s_tempname = $s_directoryname & $s_fileprefix & $s_tempname & $s_fileextension
	Until NOT FileExists($s_tempname)
	Return $s_tempname
EndFunc

Global Const $gui_event_close = -3
Global Const $gui_event_minimize = -4
Global Const $gui_event_restore = -5
Global Const $gui_event_maximize = -6
Global Const $gui_event_primarydown = -7
Global Const $gui_event_primaryup = -8
Global Const $gui_event_secondarydown = -9
Global Const $gui_event_secondaryup = -10
Global Const $gui_event_mousemove = -11
Global Const $gui_event_resized = -12
Global Const $gui_event_dropped = -13
Global Const $gui_rundefmsg = "GUI_RUNDEFMSG"
Global Const $gui_avistop = 0
Global Const $gui_avistart = 1
Global Const $gui_aviclose = 2
Global Const $gui_checked = 1
Global Const $gui_indeterminate = 2
Global Const $gui_unchecked = 4
Global Const $gui_dropaccepted = 8
Global Const $gui_nodropaccepted = 4096
Global Const $gui_acceptfiles = $gui_dropaccepted
Global Const $gui_show = 16
Global Const $gui_hide = 32
Global Const $gui_enable = 64
Global Const $gui_disable = 128
Global Const $gui_focus = 256
Global Const $gui_nofocus = 8192
Global Const $gui_defbutton = 512
Global Const $gui_expand = 1024
Global Const $gui_ontop = 2048
Global Const $gui_fontitalic = 2
Global Const $gui_fontunder = 4
Global Const $gui_fontstrike = 8
Global Const $gui_dockauto = 1
Global Const $gui_dockleft = 2
Global Const $gui_dockright = 4
Global Const $gui_dockhcenter = 8
Global Const $gui_docktop = 32
Global Const $gui_dockbottom = 64
Global Const $gui_dockvcenter = 128
Global Const $gui_dockwidth = 256
Global Const $gui_dockheight = 512
Global Const $gui_docksize = 768
Global Const $gui_dockmenubar = 544
Global Const $gui_dockstatebar = 576
Global Const $gui_dockall = 802
Global Const $gui_dockborders = 102
Global Const $gui_gr_close = 1
Global Const $gui_gr_line = 2
Global Const $gui_gr_bezier = 4
Global Const $gui_gr_move = 6
Global Const $gui_gr_color = 8
Global Const $gui_gr_rect = 10
Global Const $gui_gr_ellipse = 12
Global Const $gui_gr_pie = 14
Global Const $gui_gr_dot = 16
Global Const $gui_gr_pixel = 18
Global Const $gui_gr_hint = 20
Global Const $gui_gr_refresh = 22
Global Const $gui_gr_pensize = 24
Global Const $gui_gr_nobkcolor = -2
Global Const $gui_bkcolor_default = -1
Global Const $gui_bkcolor_transparent = -2
Global Const $gui_bkcolor_lv_alternate = -33554432
Global Const $gui_ws_ex_parentdrag = 1048576
Global Const $ss_left = 0
Global Const $ss_center = 1
Global Const $ss_right = 2
Global Const $ss_icon = 3
Global Const $ss_blackrect = 4
Global Const $ss_grayrect = 5
Global Const $ss_whiterect = 6
Global Const $ss_blackframe = 7
Global Const $ss_grayframe = 8
Global Const $ss_whiteframe = 9
Global Const $ss_simple = 11
Global Const $ss_leftnowordwrap = 12
Global Const $ss_bitmap = 14
Global Const $ss_etchedhorz = 16
Global Const $ss_etchedvert = 17
Global Const $ss_etchedframe = 18
Global Const $ss_noprefix = 128
Global Const $ss_notify = 256
Global Const $ss_centerimage = 512
Global Const $ss_rightjust = 1024
Global Const $ss_sunken = 4096
Global Const $gui_ss_default_label = 0
Global Const $gui_ss_default_graphic = 0
Global Const $gui_ss_default_icon = $ss_notify
Global Const $gui_ss_default_pic = $ss_notify
Global Const $cb_err = -1
Global Const $cb_errattribute = -3
Global Const $cb_errrequired = -4
Global Const $cb_errspace = -2
Global Const $cb_okay = 0
Global Const $state_system_invisible = 32768
Global Const $state_system_pressed = 8
Global Const $cbs_autohscroll = 64
Global Const $cbs_disablenoscroll = 2048
Global Const $cbs_dropdown = 2
Global Const $cbs_dropdownlist = 3
Global Const $cbs_hasstrings = 512
Global Const $cbs_lowercase = 16384
Global Const $cbs_nointegralheight = 1024
Global Const $cbs_oemconvert = 128
Global Const $cbs_ownerdrawfixed = 16
Global Const $cbs_ownerdrawvariable = 32
Global Const $cbs_simple = 1
Global Const $cbs_sort = 256
Global Const $cbs_uppercase = 8192
Global Const $cbm_first = 5888
Global Const $cb_addstring = 323
Global Const $cb_deletestring = 324
Global Const $cb_dir = 325
Global Const $cb_findstring = 332
Global Const $cb_findstringexact = 344
Global Const $cb_getcomboboxinfo = 356
Global Const $cb_getcount = 326
Global Const $cb_getcuebanner = ($cbm_first + 4)
Global Const $cb_getcursel = 327
Global Const $cb_getdroppedcontrolrect = 338
Global Const $cb_getdroppedstate = 343
Global Const $cb_getdroppedwidth = 351
Global Const $cb_geteditsel = 320
Global Const $cb_getextendedui = 342
Global Const $cb_gethorizontalextent = 349
Global Const $cb_getitemdata = 336
Global Const $cb_getitemheight = 340
Global Const $cb_getlbtext = 328
Global Const $cb_getlbtextlen = 329
Global Const $cb_getlocale = 346
Global Const $cb_getminvisible = 5890
Global Const $cb_gettopindex = 347
Global Const $cb_initstorage = 353
Global Const $cb_limittext = 321
Global Const $cb_resetcontent = 331
Global Const $cb_insertstring = 330
Global Const $cb_selectstring = 333
Global Const $cb_setcuebanner = ($cbm_first + 3)
Global Const $cb_setcursel = 334
Global Const $cb_setdroppedwidth = 352
Global Const $cb_seteditsel = 322
Global Const $cb_setextendedui = 341
Global Const $cb_sethorizontalextent = 350
Global Const $cb_setitemdata = 337
Global Const $cb_setitemheight = 339
Global Const $cb_setlocale = 345
Global Const $cb_setminvisible = 5889
Global Const $cb_settopindex = 348
Global Const $cb_showdropdown = 335
Global Const $cbn_closeup = 8
Global Const $cbn_dblclk = 2
Global Const $cbn_dropdown = 7
Global Const $cbn_editchange = 5
Global Const $cbn_editupdate = 6
Global Const $cbn_errspace = (-1)
Global Const $cbn_killfocus = 4
Global Const $cbn_selchange = 1
Global Const $cbn_selendcancel = 10
Global Const $cbn_selendok = 9
Global Const $cbn_setfocus = 3
Global Const $cbes_ex_casesensitive = 16
Global Const $cbes_ex_noeditimage = 1
Global Const $cbes_ex_noeditimageindent = 2
Global Const $cbes_ex_nosizelimit = 8
Global Const $cbes_ex_pathwordbreakproc = 4
Global Const $__comboboxconstant_wm_user = 1024
Global Const $cbem_deleteitem = $cb_deletestring
Global Const $cbem_getcombocontrol = ($__comboboxconstant_wm_user + 6)
Global Const $cbem_geteditcontrol = ($__comboboxconstant_wm_user + 7)
Global Const $cbem_getexstyle = ($__comboboxconstant_wm_user + 9)
Global Const $cbem_getextendedstyle = ($__comboboxconstant_wm_user + 9)
Global Const $cbem_getimagelist = ($__comboboxconstant_wm_user + 3)
Global Const $cbem_getitema = ($__comboboxconstant_wm_user + 4)
Global Const $cbem_getitemw = ($__comboboxconstant_wm_user + 13)
Global Const $cbem_getunicodeformat = 8192 + 6
Global Const $cbem_haseditchanged = ($__comboboxconstant_wm_user + 10)
Global Const $cbem_insertitema = ($__comboboxconstant_wm_user + 1)
Global Const $cbem_insertitemw = ($__comboboxconstant_wm_user + 11)
Global Const $cbem_setexstyle = ($__comboboxconstant_wm_user + 8)
Global Const $cbem_setextendedstyle = ($__comboboxconstant_wm_user + 14)
Global Const $cbem_setimagelist = ($__comboboxconstant_wm_user + 2)
Global Const $cbem_setitema = ($__comboboxconstant_wm_user + 5)
Global Const $cbem_setitemw = ($__comboboxconstant_wm_user + 12)
Global Const $cbem_setunicodeformat = 8192 + 5
Global Const $cbem_setwindowtheme = 8192 + 11
Global Const $cben_first = (-800)
Global Const $cben_last = (-830)
Global Const $cben_beginedit = ($cben_first - 4)
Global Const $cben_deleteitem = ($cben_first - 2)
Global Const $cben_dragbegina = ($cben_first - 8)
Global Const $cben_dragbeginw = ($cben_first - 9)
Global Const $cben_endedita = ($cben_first - 5)
Global Const $cben_endeditw = ($cben_first - 6)
Global Const $cben_getdispinfo = ($cben_first - 0)
Global Const $cben_getdispinfoa = ($cben_first - 0)
Global Const $cben_getdispinfow = ($cben_first - 7)
Global Const $cben_insertitem = ($cben_first - 1)
Global Const $cbeif_di_setitem = 268435456
Global Const $cbeif_image = 2
Global Const $cbeif_indent = 16
Global Const $cbeif_lparam = 32
Global Const $cbeif_overlay = 8
Global Const $cbeif_selectedimage = 4
Global Const $cbeif_text = 1
Global Const $__comboboxconstant_ws_vscroll = 2097152
Global Const $gui_ss_default_combo = BitOR($cbs_dropdown, $cbs_autohscroll, $__comboboxconstant_ws_vscroll)
Global Const $ws_tiled = 0
Global Const $ws_overlapped = 0
Global Const $ws_maximizebox = 65536
Global Const $ws_minimizebox = 131072
Global Const $ws_tabstop = 65536
Global Const $ws_group = 131072
Global Const $ws_sizebox = 262144
Global Const $ws_thickframe = 262144
Global Const $ws_sysmenu = 524288
Global Const $ws_hscroll = 1048576
Global Const $ws_vscroll = 2097152
Global Const $ws_dlgframe = 4194304
Global Const $ws_border = 8388608
Global Const $ws_caption = 12582912
Global Const $ws_overlappedwindow = 13565952
Global Const $ws_tiledwindow = 13565952
Global Const $ws_maximize = 16777216
Global Const $ws_clipchildren = 33554432
Global Const $ws_clipsiblings = 67108864
Global Const $ws_disabled = 134217728
Global Const $ws_visible = 268435456
Global Const $ws_minimize = 536870912
Global Const $ws_child = 1073741824
Global Const $ws_popup = -2147483648
Global Const $ws_popupwindow = -2138570752
Global Const $ds_modalframe = 128
Global Const $ds_setforeground = 512
Global Const $ds_contexthelp = 8192
Global Const $ws_ex_acceptfiles = 16
Global Const $ws_ex_mdichild = 64
Global Const $ws_ex_appwindow = 262144
Global Const $ws_ex_composited = 33554432
Global Const $ws_ex_clientedge = 512
Global Const $ws_ex_contexthelp = 1024
Global Const $ws_ex_dlgmodalframe = 1
Global Const $ws_ex_leftscrollbar = 16384
Global Const $ws_ex_overlappedwindow = 768
Global Const $ws_ex_right = 4096
Global Const $ws_ex_staticedge = 131072
Global Const $ws_ex_toolwindow = 128
Global Const $ws_ex_topmost = 8
Global Const $ws_ex_transparent = 32
Global Const $ws_ex_windowedge = 256
Global Const $ws_ex_layered = 524288
Global Const $ws_ex_controlparent = 65536
Global Const $ws_ex_layoutrtl = 4194304
Global Const $ws_ex_rtlreading = 8192
Global Const $wm_gettextlength = 14
Global Const $wm_gettext = 13
Global Const $wm_size = 5
Global Const $wm_sizing = 532
Global Const $wm_user = 1024
Global Const $wm_create = 1
Global Const $wm_destroy = 2
Global Const $wm_move = 3
Global Const $wm_activate = 6
Global Const $wm_setfocus = 7
Global Const $wm_killfocus = 8
Global Const $wm_enable = 10
Global Const $wm_setredraw = 11
Global Const $wm_settext = 12
Global Const $wm_paint = 15
Global Const $wm_close = 16
Global Const $wm_quit = 18
Global Const $wm_erasebkgnd = 20
Global Const $wm_syscolorchange = 21
Global Const $wm_showwindow = 24
Global Const $wm_wininichange = 26
Global Const $wm_devmodechange = 27
Global Const $wm_activateapp = 28
Global Const $wm_fontchange = 29
Global Const $wm_timechange = 30
Global Const $wm_cancelmode = 31
Global Const $wm_setcursor = 32
Global Const $wm_mouseactivate = 33
Global Const $wm_childactivate = 34
Global Const $wm_queuesync = 35
Global Const $wm_getminmaxinfo = 36
Global Const $wm_painticon = 38
Global Const $wm_iconerasebkgnd = 39
Global Const $wm_nextdlgctl = 40
Global Const $wm_spoolerstatus = 42
Global Const $wm_drawitem = 43
Global Const $wm_measureitem = 44
Global Const $wm_deleteitem = 45
Global Const $wm_vkeytoitem = 46
Global Const $wm_chartoitem = 47
Global Const $wm_setfont = 48
Global Const $wm_getfont = 49
Global Const $wm_sethotkey = 50
Global Const $wm_gethotkey = 51
Global Const $wm_querydragicon = 55
Global Const $wm_compareitem = 57
Global Const $wm_getobject = 61
Global Const $wm_compacting = 65
Global Const $wm_commnotify = 68
Global Const $wm_windowposchanging = 70
Global Const $wm_windowposchanged = 71
Global Const $wm_power = 72
Global Const $wm_notify = 78
Global Const $wm_copydata = 74
Global Const $wm_canceljournal = 75
Global Const $wm_inputlangchangerequest = 80
Global Const $wm_inputlangchange = 81
Global Const $wm_tcard = 82
Global Const $wm_help = 83
Global Const $wm_userchanged = 84
Global Const $wm_notifyformat = 85
Global Const $wm_cut = 768
Global Const $wm_copy = 769
Global Const $wm_paste = 770
Global Const $wm_clear = 771
Global Const $wm_undo = 772
Global Const $wm_contextmenu = 123
Global Const $wm_stylechanging = 124
Global Const $wm_stylechanged = 125
Global Const $wm_displaychange = 126
Global Const $wm_geticon = 127
Global Const $wm_seticon = 128
Global Const $wm_nccreate = 129
Global Const $wm_ncdestroy = 130
Global Const $wm_nccalcsize = 131
Global Const $wm_nchittest = 132
Global Const $wm_ncpaint = 133
Global Const $wm_ncactivate = 134
Global Const $wm_getdlgcode = 135
Global Const $wm_syncpaint = 136
Global Const $wm_ncmousemove = 160
Global Const $wm_nclbuttondown = 161
Global Const $wm_nclbuttonup = 162
Global Const $wm_nclbuttondblclk = 163
Global Const $wm_ncrbuttondown = 164
Global Const $wm_ncrbuttonup = 165
Global Const $wm_ncrbuttondblclk = 166
Global Const $wm_ncmbuttondown = 167
Global Const $wm_ncmbuttonup = 168
Global Const $wm_ncmbuttondblclk = 169
Global Const $wm_keydown = 256
Global Const $wm_keyup = 257
Global Const $wm_char = 258
Global Const $wm_deadchar = 259
Global Const $wm_syskeydown = 260
Global Const $wm_syskeyup = 261
Global Const $wm_syschar = 262
Global Const $wm_sysdeadchar = 263
Global Const $wm_initdialog = 272
Global Const $wm_command = 273
Global Const $wm_syscommand = 274
Global Const $wm_timer = 275
Global Const $wm_hscroll = 276
Global Const $wm_vscroll = 277
Global Const $wm_initmenu = 278
Global Const $wm_initmenupopup = 279
Global Const $wm_menuselect = 287
Global Const $wm_menuchar = 288
Global Const $wm_enteridle = 289
Global Const $wm_menurbuttonup = 290
Global Const $wm_menudrag = 291
Global Const $wm_menugetobject = 292
Global Const $wm_uninitmenupopup = 293
Global Const $wm_menucommand = 294
Global Const $wm_changeuistate = 295
Global Const $wm_updateuistate = 296
Global Const $wm_queryuistate = 297
Global Const $wm_ctlcolormsgbox = 306
Global Const $wm_ctlcoloredit = 307
Global Const $wm_ctlcolorlistbox = 308
Global Const $wm_ctlcolorbtn = 309
Global Const $wm_ctlcolordlg = 310
Global Const $wm_ctlcolorscrollbar = 311
Global Const $wm_ctlcolorstatic = 312
Global Const $wm_ctlcolor = 25
Global Const $mn_gethmenu = 481
Global Const $nm_first = 0
Global Const $nm_outofmemory = $nm_first - 1
Global Const $nm_click = $nm_first - 2
Global Const $nm_dblclk = $nm_first - 3
Global Const $nm_return = $nm_first - 4
Global Const $nm_rclick = $nm_first - 5
Global Const $nm_rdblclk = $nm_first - 6
Global Const $nm_setfocus = $nm_first - 7
Global Const $nm_killfocus = $nm_first - 8
Global Const $nm_customdraw = $nm_first - 12
Global Const $nm_hover = $nm_first - 13
Global Const $nm_nchittest = $nm_first - 14
Global Const $nm_keydown = $nm_first - 15
Global Const $nm_releasedcapture = $nm_first - 16
Global Const $nm_setcursor = $nm_first - 17
Global Const $nm_char = $nm_first - 18
Global Const $nm_tooltipscreated = $nm_first - 19
Global Const $nm_ldown = $nm_first - 20
Global Const $nm_rdown = $nm_first - 21
Global Const $nm_themechanged = $nm_first - 22
Global Const $wm_mousemove = 512
Global Const $wm_lbuttondown = 513
Global Const $wm_lbuttonup = 514
Global Const $wm_lbuttondblclk = 515
Global Const $wm_rbuttondown = 516
Global Const $wm_rbuttonup = 517
Global Const $wm_rbuttondblck = 518
Global Const $wm_mbuttondown = 519
Global Const $wm_mbuttonup = 520
Global Const $wm_mbuttondblck = 521
Global Const $wm_mousewheel = 522
Global Const $wm_xbuttondown = 523
Global Const $wm_xbuttonup = 524
Global Const $wm_xbuttondblclk = 525
Global Const $wm_mousehwheel = 526
Global Const $ps_solid = 0
Global Const $ps_dash = 1
Global Const $ps_dot = 2
Global Const $ps_dashdot = 3
Global Const $ps_dashdotdot = 4
Global Const $ps_null = 5
Global Const $ps_insideframe = 6
Global Const $lwa_alpha = 2
Global Const $lwa_colorkey = 1
Global Const $rgn_and = 1
Global Const $rgn_or = 2
Global Const $rgn_xor = 3
Global Const $rgn_diff = 4
Global Const $rgn_copy = 5
Global Const $errorregion = 0
Global Const $nullregion = 1
Global Const $simpleregion = 2
Global Const $complexregion = 3
Global Const $transparent = 1
Global Const $opaque = 2
Global Const $ccm_first = 8192
Global Const $ccm_getunicodeformat = ($ccm_first + 6)
Global Const $ccm_setunicodeformat = ($ccm_first + 5)
Global Const $ccm_setbkcolor = $ccm_first + 1
Global Const $ccm_setcolorscheme = $ccm_first + 2
Global Const $ccm_getcolorscheme = $ccm_first + 3
Global Const $ccm_getdroptarget = $ccm_first + 4
Global Const $ccm_setwindowtheme = $ccm_first + 11
Global Const $ga_parent = 1
Global Const $ga_root = 2
Global Const $ga_rootowner = 3
Global Const $sm_cxscreen = 0
Global Const $sm_cyscreen = 1
Global Const $sm_cxvscroll = 2
Global Const $sm_cyhscroll = 3
Global Const $sm_cycaption = 4
Global Const $sm_cxborder = 5
Global Const $sm_cyborder = 6
Global Const $sm_cxdlgframe = 7
Global Const $sm_cydlgframe = 8
Global Const $sm_cyvthumb = 9
Global Const $sm_cxhthumb = 10
Global Const $sm_cxicon = 11
Global Const $sm_cyicon = 12
Global Const $sm_cxcursor = 13
Global Const $sm_cycursor = 14
Global Const $sm_cymenu = 15
Global Const $sm_cxfullscreen = 16
Global Const $sm_cyfullscreen = 17
Global Const $sm_cykanjiwindow = 18
Global Const $sm_mousepresent = 19
Global Const $sm_cyvscroll = 20
Global Const $sm_cxhscroll = 21
Global Const $sm_debug = 22
Global Const $sm_swapbutton = 23
Global Const $sm_reserved1 = 24
Global Const $sm_reserved2 = 25
Global Const $sm_reserved3 = 26
Global Const $sm_reserved4 = 27
Global Const $sm_cxmin = 28
Global Const $sm_cymin = 29
Global Const $sm_cxsize = 30
Global Const $sm_cysize = 31
Global Const $sm_cxframe = 32
Global Const $sm_cyframe = 33
Global Const $sm_cxmintrack = 34
Global Const $sm_cymintrack = 35
Global Const $sm_cxdoubleclk = 36
Global Const $sm_cydoubleclk = 37
Global Const $sm_cxiconspacing = 38
Global Const $sm_cyiconspacing = 39
Global Const $sm_menudropalignment = 40
Global Const $sm_penwindows = 41
Global Const $sm_dbcsenabled = 42
Global Const $sm_cmousebuttons = 43
Global Const $sm_secure = 44
Global Const $sm_cxedge = 45
Global Const $sm_cyedge = 46
Global Const $sm_cxminspacing = 47
Global Const $sm_cyminspacing = 48
Global Const $sm_cxsmicon = 49
Global Const $sm_cysmicon = 50
Global Const $sm_cysmcaption = 51
Global Const $sm_cxsmsize = 52
Global Const $sm_cysmsize = 53
Global Const $sm_cxmenusize = 54
Global Const $sm_cymenusize = 55
Global Const $sm_arrange = 56
Global Const $sm_cxminimized = 57
Global Const $sm_cyminimized = 58
Global Const $sm_cxmaxtrack = 59
Global Const $sm_cymaxtrack = 60
Global Const $sm_cxmaximized = 61
Global Const $sm_cymaximized = 62
Global Const $sm_network = 63
Global Const $sm_cleanboot = 67
Global Const $sm_cxdrag = 68
Global Const $sm_cydrag = 69
Global Const $sm_showsounds = 70
Global Const $sm_cxmenucheck = 71
Global Const $sm_cymenucheck = 72
Global Const $sm_slowmachine = 73
Global Const $sm_mideastenabled = 74
Global Const $sm_mousewheelpresent = 75
Global Const $sm_xvirtualscreen = 76
Global Const $sm_yvirtualscreen = 77
Global Const $sm_cxvirtualscreen = 78
Global Const $sm_cyvirtualscreen = 79
Global Const $sm_cmonitors = 80
Global Const $sm_samedisplayformat = 81
Global Const $sm_immenabled = 82
Global Const $sm_cxfocusborder = 83
Global Const $sm_cyfocusborder = 84
Global Const $sm_tabletpc = 86
Global Const $sm_mediacenter = 87
Global Const $sm_starter = 88
Global Const $sm_serverr2 = 89
Global Const $sm_cmetrics = 90
Global Const $sm_remotesession = 4096
Global Const $sm_shuttingdown = 8192
Global Const $sm_remotecontrol = 8193
Global Const $sm_caretblinkingenabled = 8194
Global Const $blackness = 66
Global Const $captureblt = 1073741824
Global Const $dstinvert = 5570569
Global Const $mergecopy = 12583114
Global Const $mergepaint = 12255782
Global Const $nomirrorbitmap = -2147483648
Global Const $notsrccopy = 3342344
Global Const $notsrcerase = 1114278
Global Const $patcopy = 15728673
Global Const $patinvert = 5898313
Global Const $patpaint = 16452105
Global Const $srcand = 8913094
Global Const $srccopy = 13369376
Global Const $srcerase = 4457256
Global Const $srcinvert = 6684742
Global Const $srcpaint = 15597702
Global Const $whiteness = 16711778
Global Const $dt_bottom = 8
Global Const $dt_calcrect = 1024
Global Const $dt_center = 1
Global Const $dt_editcontrol = 8192
Global Const $dt_end_ellipsis = 32768
Global Const $dt_expandtabs = 64
Global Const $dt_externalleading = 512
Global Const $dt_hideprefix = 1048576
Global Const $dt_internal = 4096
Global Const $dt_left = 0
Global Const $dt_modifystring = 65536
Global Const $dt_noclip = 256
Global Const $dt_nofullwidthcharbreak = 524288
Global Const $dt_noprefix = 2048
Global Const $dt_path_ellipsis = 16384
Global Const $dt_prefixonly = 2097152
Global Const $dt_right = 2
Global Const $dt_rtlreading = 131072
Global Const $dt_singleline = 32
Global Const $dt_tabstop = 128
Global Const $dt_top = 0
Global Const $dt_vcenter = 4
Global Const $dt_wordbreak = 16
Global Const $dt_word_ellipsis = 262144
Global Const $rdw_erase = 4
Global Const $rdw_frame = 1024
Global Const $rdw_internalpaint = 2
Global Const $rdw_invalidate = 1
Global Const $rdw_noerase = 32
Global Const $rdw_noframe = 2048
Global Const $rdw_nointernalpaint = 16
Global Const $rdw_validate = 8
Global Const $rdw_erasenow = 512
Global Const $rdw_updatenow = 256
Global Const $rdw_allchildren = 128
Global Const $rdw_nochildren = 64
Global Const $wm_renderformat = 773
Global Const $wm_renderallformats = 774
Global Const $wm_destroyclipboard = 775
Global Const $wm_drawclipboard = 776
Global Const $wm_paintclipboard = 777
Global Const $wm_vscrollclipboard = 778
Global Const $wm_sizeclipboard = 779
Global Const $wm_askcbformatname = 780
Global Const $wm_changecbchain = 781
Global Const $wm_hscrollclipboard = 782
Global Const $hterror = -2
Global Const $httransparent = -1
Global Const $htnowhere = 0
Global Const $htclient = 1
Global Const $htcaption = 2
Global Const $htsysmenu = 3
Global Const $htgrowbox = 4
Global Const $htsize = $htgrowbox
Global Const $htmenu = 5
Global Const $hthscroll = 6
Global Const $htvscroll = 7
Global Const $htminbutton = 8
Global Const $htmaxbutton = 9
Global Const $htleft = 10
Global Const $htright = 11
Global Const $httop = 12
Global Const $httopleft = 13
Global Const $httopright = 14
Global Const $htbottom = 15
Global Const $htbottomleft = 16
Global Const $htbottomright = 17
Global Const $htborder = 18
Global Const $htreduce = $htminbutton
Global Const $htzoom = $htmaxbutton
Global Const $htsizefirst = $htleft
Global Const $htsizelast = $htbottomright
Global Const $htobject = 19
Global Const $htclose = 20
Global Const $hthelp = 21
Global Const $color_scrollbar = 0
Global Const $color_background = 1
Global Const $color_activecaption = 2
Global Const $color_inactivecaption = 3
Global Const $color_menu = 4
Global Const $color_window = 5
Global Const $color_windowframe = 6
Global Const $color_menutext = 7
Global Const $color_windowtext = 8
Global Const $color_captiontext = 9
Global Const $color_activeborder = 10
Global Const $color_inactiveborder = 11
Global Const $color_appworkspace = 12
Global Const $color_highlight = 13
Global Const $color_highlighttext = 14
Global Const $color_btnface = 15
Global Const $color_btnshadow = 16
Global Const $color_graytext = 17
Global Const $color_btntext = 18
Global Const $color_inactivecaptiontext = 19
Global Const $color_btnhighlight = 20
Global Const $color_3ddkshadow = 21
Global Const $color_3dlight = 22
Global Const $color_infotext = 23
Global Const $color_infobk = 24
Global Const $color_hotlight = 26
Global Const $color_gradientactivecaption = 27
Global Const $color_gradientinactivecaption = 28
Global Const $color_menuhilight = 29
Global Const $color_menubar = 30
Global Const $color_desktop = 1
Global Const $color_3dface = 15
Global Const $color_3dshadow = 16
Global Const $color_3dhighlight = 20
Global Const $color_3dhilight = 20
Global Const $color_btnhilight = 20
Global Const $hinst_commctrl = -1
Global Const $idb_std_small_color = 0
Global Const $idb_std_large_color = 1
Global Const $idb_view_small_color = 4
Global Const $idb_view_large_color = 5
Global Const $idb_hist_small_color = 8
Global Const $idb_hist_large_color = 9
Global Const $startf_forceofffeedback = 128
Global Const $startf_forceonfeedback = 64
Global Const $startf_runfullscreen = 32
Global Const $startf_usecountchars = 8
Global Const $startf_usefillattribute = 16
Global Const $startf_usehotkey = 512
Global Const $startf_useposition = 4
Global Const $startf_useshowwindow = 1
Global Const $startf_usesize = 2
Global Const $startf_usestdhandles = 256
Global Const $cdds_prepaint = 1
Global Const $cdds_postpaint = 2
Global Const $cdds_preerase = 3
Global Const $cdds_posterase = 4
Global Const $cdds_item = 65536
Global Const $cdds_itemprepaint = 65537
Global Const $cdds_itempostpaint = 65538
Global Const $cdds_itempreerase = 65539
Global Const $cdds_itemposterase = 65540
Global Const $cdds_subitem = 131072
Global Const $cdis_selected = 1
Global Const $cdis_grayed = 2
Global Const $cdis_disabled = 4
Global Const $cdis_checked = 8
Global Const $cdis_focus = 16
Global Const $cdis_default = 32
Global Const $cdis_hot = 64
Global Const $cdis_marked = 128
Global Const $cdis_indeterminate = 256
Global Const $cdis_showkeyboardcues = 512
Global Const $cdis_nearhot = 1024
Global Const $cdis_othersidehot = 2048
Global Const $cdis_drophilited = 4096
Global Const $cdrf_dodefault = 0
Global Const $cdrf_newfont = 2
Global Const $cdrf_skipdefault = 4
Global Const $cdrf_notifypostpaint = 16
Global Const $cdrf_notifyitemdraw = 32
Global Const $cdrf_notifysubitemdraw = 32
Global Const $cdrf_notifyposterase = 64
Global Const $cdrf_doerase = 8
Global Const $cdrf_skippostpaint = 256
Global Const $gui_ss_default_gui = BitOR($ws_minimizebox, $ws_caption, $ws_popup, $ws_sysmenu)
$name = "Universal Extractor"
$version = "1.6.1"
$title = $name & " v" & $version
$website = "http://www.legroom.net/software/uniextract"
$prefs = @ScriptDir & "\UniExtract.ini"
$reg = "HKCU\Software\UniExtract"
$peidtitle = "PEiD v"
Opt("GUIOnEventMode", 1)
Global $langdir = @ScriptDir & "\lang"
Global $height = @DesktopHeight / 4
Global $globalprefs = 1
Global $language = "English"
Global $debugdir = @TempDir
Global $history = 1
Global $appendext = 0
Global $removetemp = 1
Global $removedupe = 1
Global $warnexecute = 1
Dim $file, $filename, $filedir, $fileext, $initoutdir, $outdir, $filetype
Dim $prompt, $packed, $return, $output, $langlist, $prefsonly
Dim $exsig, $loadplugins, $stayontop
Dim $testinno, $testarj, $testace, $test7z, $testzip, $testie
Dim $innofailed, $arjfailed, $acefailed, $7zfailed, $zipfailed, $iefailed, $isfailed
Dim $aceinst, $kgbinst, $peainst, $sitinst
Dim $oldpath
Dim $createdir, $dirmtime
Dim $exitcode = 0
$7z = "7z.exe"
$ace = "xace.exe"
$arc = "arc.exe"
$arj = "arj.exe"
$aspack = "AspackDie.exe"
$bin = "bin2iso.exe"
$cdi = "cdirip.exe"
$dbx = "cmdTotal.exe dbxplug.wcx"
$hlp = "helpdeco.exe"
$ie = "cmdTotal.exe InstExpl.wcx"
$img = "EXTRACT.EXE"
$inno = "innounp.exe"
$is3arc = "i3comp.exe"
$is3exe = "stix_d.exe"
$is6cab = "i6comp.exe"
$is5cab = "i5comp.exe"
$isexe = "IsXunpack.exe"
$kgb = "kgb_arch_decompress.exe"
$lit = "clit.exe"
$lzo = "lzop.exe"
$lzx = "unlzx.exe"
$mht = "extractMHT.exe"
$mht_ct = "cmdTotal.exe MHTUnp.wcx"
$msi_ct = "cmdTotal.exe msi.wcx"
$msi_msix = "MsiX.exe"
$nbh = "NBHextract.exe"
$nrg = "nrg2iso.exe"
$pea = "pea.exe"
$peid = "peid.exe"
$rai = "RAIU.EXE"
$rar = "unrar.exe"
$sis = "cmdTotal.exe PDunSIS.wcx"
$sit = "Expander.exe"
$trid = "trid.exe"
$uharc = "UNUHARC06.EXE"
$uharc04 = "UHARC04.EXE"
$uharc02 = "UHARC02.EXE"
$upx = "upx.exe"
$uu = "uudeview.exe"
$wise_ewise = "e_wise_w.exe"
$wise_wun = "wun.exe"
$zip = "unzip.exe"
$zoo = "booz.exe"
readprefs()
If $cmdline[0] = 0 Then
	$prompt = 1
Else
	If $cmdline[1] = "/help" OR $cmdline[1] = "/h" OR $cmdline[1] = "/?" OR $cmdline[1] = "-h" OR $cmdline[1] = "-?" Then
		terminate("syntax", "", "")
	ElseIf $cmdline[1] = "/prefs" Then
		$prefsonly = True
		gui_prefs()
		$finishprefs = False
		While 1
			If $finishprefs Then ExitLoop 
			Sleep(10)
		WEnd
		terminate("silent", "", "")
	Else
		If FileExists($cmdline[1]) Then
			$file = _pathfull($cmdline[1])
		Else
			terminate("syntax", "", "")
		EndIf
		If $cmdline[0] > 1 Then
			$outdir = $cmdline[2]
		Else
			$prompt = 1
		EndIf
	EndIf
EndIf
If $prompt Then
	creategui()
	$finishgui = False
	While 1
		If $finishgui Then ExitLoop 
		Sleep(10)
	WEnd
EndIf
filenameparse($file)
If $outdir = "/sub" Then
	$outdir = $initoutdir
ElseIf StringMid($outdir, 2, 1) <> ":" Then
	If StringLeft($outdir, 1) == "\" AND StringMid($outdir, 2, 1) <> "\" Then
		$outdir = StringLeft($filedir, 2) & $outdir
	ElseIf StringLeft($outdir, 2) <> "\\" Then
		$outdir = _pathfull($filedir & "\" & $outdir)
	EndIf
EndIf
If StringRight(envparse($debugdir), 1) <> "\" Then $debugdir &= "\"
$debugfile = FileGetShortName(envparse($debugdir)) & "uniextract.txt"
$testdebug = FileOpen($debugfile, 2)
If $testdebug == -1 Then
	MsgBox(48, $title, t("CANNOT_DEBUG", createarray(envparse($debugdir))))
	$debugdir = @TempDir & "\"
	$debugfile = FileGetShortName($debugdir) & "uniextract.txt"
Else
	FileClose($testdebug)
	FileDelete($debugfile)
EndIf
If $history Then
	writehist("file", $file)
	writehist("directory", $outdir)
EndIf
$cmd = @ComSpec & " /d /c "
$output = " 2>&1 | tee.exe " & $debugfile
EnvSet("path", @ScriptDir & "\bin" & ";" & EnvGet("path"))
If pathsearch($ace) Then $aceinst = True
If pathsearch($kgb) Then $kgbinst = True
If pathsearch($pea) Then $peainst = True
If pathsearch($sit) Then $sitinst = True
If $fileext = "ipk" OR $fileext = "tbz2" OR $fileext = "tgz" OR $fileext = "tz" OR $fileext = "tlz" OR $fileext = "txz" Then
	extract("ctar", "Compressed Tar " & t("TERM_ARCHIVE"))
ElseIf $fileext = "bin" OR $fileext = "cue" Then
	extract("bin", "BIN/CUE CD-ROM " & t("TERM_IMAGE"))
ElseIf $fileext = "cdi" Then
	extract("cdi", "CDI CD-ROM " & t("TERM_IMAGE"))
ElseIf $fileext = "iso" Then
	extract("7z", "ISO CD-ROM " & t("TERM_IMAGE"))
ElseIf $fileext = "nrg" OR $fileext = "cue" Then
	extract("nrg", "NRG CD-ROM " & t("TERM_IMAGE"))
Else
	SplashTextOn($title, t("SCANNING_FILE"), 330, 50, -1, $height, 16)
	filescan($file)
EndIf
If $fileext = "exe" OR StringInStr($filetype, "Executable", 0) Then
	$scantypes = createarray("deep", "hard", "ext")
	For $i = 0 To UBound($scantypes) - 1
		If $scantypes[$i] == "hard" Then
			$tempftype = exescan($file, $scantypes[$i])
		Else
			exescan($file, $scantypes[$i])
		EndIf
		SplashTextOn($title, t("TERM_TESTING") & " " & t("TERM_UNKNOWN") & " " & t("TERM_EXECUTABLE"), 330, 50, -1, $height, 16)
		If $testinno AND NOT $innofailed Then checkinno()
		If $testarj AND NOT $arjfailed Then checkarj()
		If $testace AND NOT $acefailed Then checkace()
		If $testzip AND NOT $zipfailed Then checkzip()
		If $testie AND NOT $iefailed Then checkie()
		If $scantypes[$i] == "ext" AND $test7z AND NOT $7zfailed Then check7z()
		SplashOff()
	Next
	$filetype = $tempftype
	If NOT $7zfailed Then check7z()
	If NOT $zipfailed Then checkzip()
	If NOT $iefailed Then checkie()
	If $packed Then unpack()
	terminate("unknownexe", $file, $filetype)
ElseIf $fileext = "1" OR $fileext = "lib" Then
	extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
ElseIf $fileext = "7z" Then
	extract("7z", "7-Zip " & t("TERM_ARCHIVE"))
ElseIf $fileext = "ace" AND $aceinst Then
	extract("ace", "ACE " & t("TERM_ARCHIVE"))
ElseIf $fileext = "arc" Then
	extract("arc", "ARC " & t("TERM_ARCHIVE"))
ElseIf $fileext = "arj" Then
	extract("arj", "ARJ " & t("TERM_ARCHIVE"))
ElseIf $fileext = "b64" Then
	extract("uu", "Base64 " & t("TERM_ENCODED"))
ElseIf $fileext = "bz2" Then
	extract("bz2", "bzip2 " & t("TERM_COMPRESSED"))
ElseIf $fileext = "cab" Then
	RunWait($cmd & $7z & ' l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If StringInStr(FileReadLine($debugfile, 4), "Listing archive:", 0) Then
		extract("cab", "Microsoft CAB " & t("TERM_ARCHIVE"))
	Else
		extract("iscab", "InstallShield CAB " & t("TERM_ARCHIVE"))
	EndIf
	FileDelete($debugfile)
ElseIf $fileext = "chm" Then
	extract("chm", "Compiled HTML " & t("TERM_HELP"))
ElseIf $fileext = "cpio" Then
	extract("7z", "CPIO " & t("TERM_ARCHIVE"))
ElseIf $fileext = "dbx" Then
	extract("dbx", "Outlook Express " & t("TERM_ARCHIVE"))
ElseIf $fileext = "deb" Then
	extract("7z", "Debian " & t("TERM_PACKAGE"))
ElseIf $fileext = "dll" Then
	exescan($file, "deep")
	If $packed Then
		unpack()
	Else
		terminate("unknownexe", $file, $filetype)
	EndIf
ElseIf $fileext = "gz" Then
	extract("gz", "gzip " & t("TERM_COMPRESSED"))
ElseIf $fileext = "hlp" Then
	extract("hlp", "Windows " & t("TERM_HELP"))
ElseIf $fileext = "imf" Then
	extract("cab", "IncrediMail " & t("TERM_ECARD"))
ElseIf $fileext = "img" Then
	extract("img", "Floppy " & t("TERM_DISK") & " " & t("TERM_IMAGE"))
ElseIf ($fileext = "kgb" OR $fileext = "kge") AND $kgbinst Then
	extract("kgb", "KGB " & t("TERM_ARCHIVE"))
ElseIf $fileext = "lit" Then
	extract("lit", "Microsoft LIT " & t("TERM_EBOOK"))
ElseIf $fileext = "lzh" OR $fileext = "lha" Then
	extract("7z", "LZH " & t("TERM_COMPRESSED"))
ElseIf $fileext = "lzma" Then
	extract("7z", "LZMA " & t("TERM_COMPRESSED"))
ElseIf $fileext = "lzo" Then
	extract("lzo", "LZO " & t("TERM_COMPRESSED"))
ElseIf $fileext = "lzx" Then
	extract("lzx", "LZX " & t("TERM_COMPRESSED"))
ElseIf $fileext = "mht" Then
	extract("mht", "MHTML " & t("TERM_ARCHIVE"))
ElseIf $fileext = "msi" Then
	extract("msi", "Windows Installer (MSI) " & t("TERM_PACKAGE"))
ElseIf $fileext = "msm" Then
	extract("msm", "Windows Installer (MSM) " & t("TERM_MERGE_MODULE"))
ElseIf $fileext = "msp" Then
	extract("msp", "Windows Installer (MSP) " & t("TERM_PATCH"))
ElseIf $fileext = "nbh" Then
	extract("nbh", "NBH " & t("TERM_IMAGE"))
ElseIf $fileext = "pea" AND $peainst Then
	extract("pea", "Pea " & t("TERM_ARCHIVE"))
ElseIf $fileext = "rar" OR $fileext = "001" OR $fileext = "cbr" Then
	extract("rar", "RAR " & t("TERM_ARCHIVE"))
ElseIf $fileext = "rpm" Then
	extract("7z", "RPM " & t("TERM_PACKAGE"))
ElseIf $fileext = "sis" Then
	extract("sis", "SymbianOS " & t("TERM_INSTALLER"))
ElseIf $fileext = "sit" AND $sitinst Then
	extract("sit", "StuffIt " & t("TERM_ARCHIVE"))
ElseIf $fileext = "tar" Then
	extract("tar", "Tar " & t("TERM_ARCHIVE"))
ElseIf $fileext = "uha" Then
	extract("uha", "UHARC " & t("TERM_ARCHIVE"))
ElseIf $fileext = "uu" OR $fileext = "uue" OR $fileext = "xx" OR $fileext = "xxe" Then
	extract("uu", "UUencode " & t("TERM_ENCODED"))
ElseIf $fileext = "wim" Then
	extract("7z", "WIM " & t("TERM_IMAGE"))
ElseIf $fileext = "xz" Then
	extract("xz", "XZ " & t("TERM_COMPRESSED"))
ElseIf $fileext = "yenc" OR $fileext = "ntx" Then
	extract("uu", "yEnc " & t("TERM_ENCODED"))
ElseIf $fileext = "z" Then
	If NOT check7z() Then extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
ElseIf $fileext = "zip" OR $fileext = "cbz" OR $fileext = "jar" OR $fileext = "xpi" OR $fileext = "wz" Then
	extract("zip", "ZIP " & t("TERM_ARCHIVE"))
ElseIf $fileext = "zoo" Then
	extract("zoo", "ZOO " & t("TERM_ARCHIVE"))
Else
	SplashOff()
	terminate("unknownext", $file, "")
EndIf

Func filenameparse($f)
	$filedir = StringLeft($f, StringInStr($f, "\", 0, -1) - 1)
	$filename = StringTrimLeft($f, StringInStr($f, "\", 0, -1))
	If StringInStr($filename, ".") Then
		$fileext = StringTrimLeft($filename, StringInStr($filename, ".", 0, -1))
		$filename = StringTrimRight($filename, StringLen($fileext) + 1)
		$initoutdir = $filedir & "\" & $filename
	Else
		$fileext = ""
		$initoutdir = $filedir
	EndIf
EndFunc

Func envparse($string)
	$arr = StringRegExp($string, "%.*%", 2)
	For $i = 0 To UBound($arr) - 1
		$string = StringReplace($string, $arr[$i], EnvGet(StringReplace($arr[$i], "%", "")))
	Next
	Return $string
EndFunc

Func t($t, $vars = "")
	Local $ldir = @ScriptDir
	If $language <> "English" Then $ldir &= "\lang"
	$return = IniRead($ldir & "\" & $language & ".ini", "UniExtract", $t, "")
	If $return == "" Then $return = IniRead(@ScriptDir & "\English.ini", "UniExtract", $t, "???")
	$return = StringReplace($return, "%n", @CRLF)
	$return = StringReplace($return, "%t", @TAB)
	For $i = 0 To UBound($vars) - 1
		$return = StringReplace($return, "%s", $vars[$i], 1)
	Next
	Return $return
EndFunc

Func readprefs()
	$section = "UniExtract Preferences"
	$value = IniRead($prefs, $section, "globalprefs", "")
	If $value <> "" Then $globalprefs = Int($value)
	$value = IniRead($prefs, $section, "history", "")
	If $value <> "" Then $history = Int($value)
	$value = IniRead($prefs, $section, "debugdir", "")
	If $value <> "" Then $debugdir = $value
	$value = IniRead($prefs, $section, "language", "")
	If $value <> "" Then $language = $value
	$value = IniRead($prefs, $section, "appendext", "")
	If $value <> "" Then $appendext = Int($value)
	$value = IniRead($prefs, $section, "removetemp", "")
	If $value <> "" Then $removetemp = Int($value)
	$value = IniRead($prefs, $section, "removedupe", "")
	If $value <> "" Then $removedupe = Int($value)
	$value = IniRead($prefs, $section, "warnexecute", "")
	If $value <> "" Then $warnexecute = Int($value)
	If NOT $globalprefs Then
		$value = RegRead($reg, "history")
		If $value <> "" Then $history = Int($value)
		$value = RegRead($reg, "debugdir")
		If $value <> "" Then $debugdir = $value
		$value = RegRead($reg, "language")
		If $value <> "" Then $language = $value
		$value = RegRead($reg, "appendext")
		If $value <> "" Then $appendext = Int($value)
		$value = RegRead($reg, "removetemp")
		If $value <> "" Then $removetemp = Int($value)
		$value = RegRead($reg, "removedupe")
		If $value <> "" Then $removedupe = Int($value)
		$value = RegRead($reg, "warnexecute")
		If $value <> "" Then $warnexecute = Int($value)
	EndIf
	$langlist = ""
	Dim $langarr[1]
	$temp = FileFindFirstFile($langdir & "\*.ini")
	If $temp <> -1 Then
		Local $langarr = _filelisttoarray($langdir, "*.ini", 1)
		FileClose($temp)
	EndIf
	$langarr[0] = "English.ini"
	_arraysort($langarr)
	For $i = 0 To UBound($langarr) - 1
		$langlist &= StringTrimRight($langarr[$i], 4) & "|"
	Next
	$langlist = StringTrimRight($langlist, 1)
EndFunc

Func writeprefs()
	If $globalprefs Then
		$section = "UniExtract Preferences"
		IniWrite($prefs, $section, "history", $history)
		IniWrite($prefs, $section, "debugdir", $debugdir)
		IniWrite($prefs, $section, "language", $language)
		IniWrite($prefs, $section, "appendext", $appendext)
		IniWrite($prefs, $section, "removetemp", $removetemp)
		IniWrite($prefs, $section, "removedupe", $removedupe)
		IniWrite($prefs, $section, "warnexecute", $warnexecute)
	Else
		RegWrite($reg, "history", "REG_SZ", $history)
		RegWrite($reg, "debugdir", "REG_SZ", $debugdir)
		RegWrite($reg, "language", "REG_SZ", $language)
		RegWrite($reg, "appendext", "REG_SZ", $appendext)
		RegWrite($reg, "removetemp", "REG_SZ", $removetemp)
		RegWrite($reg, "removedupe", "REG_SZ", $removedupe)
		RegWrite($reg, "warnexecute", "REG_SZ", $warnexecute)
	EndIf
EndFunc

Func readhist($field)
	Local $items
	If $globalprefs Then
		If $field = "file" Then
			$section = "File History"
		ElseIf $field = "directory" Then
			$section = "Directory History"
		Else
			Return 
		EndIf
		For $i = 0 To 9
			$value = IniRead($prefs, $section, $i, "")
			If $value <> "" Then $items &= "|" & $value
		Next
	Else
		If $field = "file" Then
			$key = $reg & "\File"
		ElseIf $field = "directory" Then
			$key = $reg & "\Directory"
		Else
			Return 
		EndIf
		For $i = 0 To 9
			$value = RegRead($key, $i)
			If $value <> "" Then $items &= "|" & $value
		Next
	EndIf
	Return StringTrimLeft($items, 1)
EndFunc

Func writehist($field, $new)
	If $globalprefs Then
		If $field = "file" Then
			$section = "File History"
		ElseIf $field = "directory" Then
			$section = "Directory History"
		Else
			Return 
		EndIf
		$histarr = StringSplit(readhist($field), "|")
		IniWrite($prefs, $section, "0", $new)
		If $histarr[1] == "" Then Return 
		For $i = 1 To $histarr[0]
			If $i > 9 Then ExitLoop 
			If $histarr[$i] = $new Then
				IniDelete($prefs, $section, String($i))
				ContinueLoop 
			EndIf
			IniWrite($prefs, $section, String($i), $histarr[$i])
		Next
	Else
		If $field = "file" Then
			$key = $reg & "\File"
		ElseIf $field = "directory" Then
			$key = $reg & "\Directory"
		Else
			Return 
		EndIf
		$histarr = StringSplit(readhist($field), "|")
		RegWrite($key, "0", "REG_SZ", $new)
		If $histarr[1] == "" Then Return 
		For $i = 1 To $histarr[0]
			If $i > 9 Then ExitLoop 
			If $histarr[$i] = $new Then
				RegDelete($key, String($i))
				ContinueLoop 
			EndIf
			RegWrite($key, String($i), "REG_SZ", $histarr[$i])
		Next
	EndIf
EndFunc

Func filescan($f, $analyze = 1)
	RunWait($cmd & $trid & ' "' & $f & '" >' & $debugfile, $filedir, @SW_HIDE)
	$filetype = ""
	$infile = FileOpen($debugfile, 0)
	$line = FileReadLine($infile)
	Do
		If StringInStr($line, "%") Then $filetype &= $line
		$line = FileReadLine($infile)
	Until @error
	FileClose($infile)
	If NOT $analyze Then Return $filetype
	Select 
		Case StringInStr($filetype, "7-Zip compressed archive", 0)
			extract("7z", "7-Zip " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ACE compressed archive", 0) OR StringInStr($filetype, "ACE Self-Extracting Archive", 0)
			If $aceinst Then extract("ace", t("TERM_SFX") & " ACE " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ARC Compressed archive", 0) AND NOT StringInStr($filetype, "UHARC", 0)
			extract("arc", "ARC " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ARJ compressed archive", 0)
			extract("arj", "ARJ " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "bzip2 compressed archive", 0)
			extract("bz2", "bzip2 " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "Microsoft Cabinet Archive", 0) OR StringInStr($filetype, "IncrediMail letter/ecard", 0)
			extract("cab", "Microsoft CAB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Compiled HTML Help File", 0)
			extract("chm", "Compiled HTML " & t("TERM_HELP"))
		Case StringInStr($filetype, "CPIO Archive", 0)
			extract("7z", "CPIO " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Debian Linux Package", 0)
			extract("7z", "Debian " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Gentee Installer executable", 0)
			extract("ie", "Gentee " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "GZipped File", 0)
			extract("gz", "gzip " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "Windows Help File", 0)
			extract("hlp", "Windows " & t("TERM_HELP"))
		Case StringInStr($filetype, "Generic PC disk image", 0)
			extract("img", "Floppy " & t("TERM_DISK") & " " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Inno Setup installer", 0)
			checkinno()
		Case StringInStr($filetype, "Installer VISE executable", 0)
			extract("ie", "Installer VISE " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "InstallShield archive", 0)
			extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "InstallShield compressed archive", 0)
			extract("iscab", "InstallShield CAB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "KGB archive", 0)
			If $kgbinst Then extract("kgb", "KGB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "LHARC/LZARK compressed archive", 0)
			extract("7z", "LZH " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "lzop compressed", 0)
			extract("lzo", "LZO " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "LZX Amiga compressed archive", 0)
			extract("lzx", "LZX " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "Microsoft Internet Explorer Web Archive", 0)
			extract("mht", "MHTML " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Microsoft Reader eBook", 0)
			extract("lit", "Microsoft LIT " & t("TERM_EBOOK"))
		Case StringInStr($filetype, "Microsoft Windows Installer merge module", 0)
			extract("msm", "Windows Installer (MSM) " & t("TERM_MERGE_MODULE"))
		Case StringInStr($filetype, "Microsoft Windows Installer package", 0)
			extract("msi", "Windows Installer (MSI) " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Microsoft Windows Installer patch", 0)
			extract("msp", "Windows Installer (MSP) " & t("TERM_PATCH"))
		Case StringInStr($filetype, "HTC NBH ROM Image", 0)
			extract("nbh", "NBH " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Outlook Express E-mail folder", 0)
			extract("dbx", "Outlook Express " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "PEA archive", 0)
			If $peainst Then extract("pea", "Pea " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "RAR Archive", 0)
			extract("rar", "RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "RAR Self Extracting archive", 0)
			checkzip()
			extract("rar", "RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Reflexive Arcade installer wrapper", 0)
			extract("inno", "Reflexive Arcade " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "RPM Linux Package", 0)
			extract("7z", "RPM " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Setup Factory 6.x Installer", 0)
			extract("ie", "Setup Factory " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "StuffIT SIT compressed archive", 0)
			If $sitinst Then extract("sit", "StuffIt " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "SymbianOS Installer", 0)
			extract("sis", "SymbianOS " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "TAR archive", 0)
			extract("tar", "Tar " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "UHARC compressed archive", 0)
			extract("uha", "UHARC " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Base64 Encoded file", 0)
			extract("uu", "Base64 " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "Quoted-Printable Encoded file", 0)
			extract("uu", "Quoted-Printable " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "UUencoded file", 0) OR StringInStr($filetype, "XXencoded file", 0)
			extract("uu", "UUencoded " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "yEnc Encoded file", 0)
			extract("uu", "yEnc " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "Windows Imaging Format", 0)
			extract("7z", "WIM " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Wise Installer Executable", 0)
			extract("wise", "Wise Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "UNIX Compressed file", 0)
			extract("Z", "LZW " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "ZIP compressed archive", 0) OR StringInStr($filetype, "Winzip Win32 self-extracting archive", 0)
			extract("zip", "ZIP " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Zip Self-Extracting archive", 0)
			checkinno()
		Case StringInStr($filetype, "ZOO compressed archive", 0)
			extract("zoo", "ZOO " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "LZMA compressed file", 0)
			check7z()
		Case StringInStr($filetype, "InstallShield setup", 0)
			checkinstallshield()
	EndSelect
EndFunc

Func exescan($f, $scantype, $analyze = 1)
	SplashTextOn($title, t("SCANNING_EXE", createarray($scantype)), 330, 50, -1, $height, 16)
	$exsig = RegRead("HKCU\Software\PEiD", "ExSig")
	$loadplugins = RegRead("HKCU\Software\PEiD", "LoadPlugins")
	$stayontop = RegRead("HKCU\Software\PEiD", "StayOnTop")
	RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", 1)
	RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", 0)
	RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", 0)
	$filetype = ""
	Run($peid & " -" & $scantype & ' "' & $f & '"', @ScriptDir, @SW_HIDE)
	WinWait($peidtitle)
	While ($filetype = "") OR ($filetype = "Scanning...")
		Sleep(100)
		$filetype = ControlGetText($peidtitle, "", "Edit2")
	WEnd
	WinClose($peidtitle)
	If $exsig Then RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", $exsig)
	If $loadplugins Then RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", $loadplugins)
	If $stayontop Then RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", $stayontop)
	SplashOff()
	If NOT $analyze Then Return $filetype
	Select 
		Case StringInStr($filetype, "ARJ SFX", 0)
			extract("arj", t("TERM_SFX") & " ARJ " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Borland Delphi", 0) AND NOT StringInStr($filetype, "RAR SFX", 0)
			$testinno = True
			$testzip = True
		Case StringInStr($filetype, "Gentee Installer", 0)
			extract("ie", "Gentee " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Inno Setup", 0)
			checkinno()
		Case StringInStr($filetype, "Installer VISE", 0)
			extract("ie", "Installer VISE " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "InstallShield", 0)
			If NOT $isfailed Then extract("isexe", "InstallShield " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "KGB SFX", 0)
			If $kgbinst Then extract("kgb", t("TERM_SFX") & " KGB " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Microsoft Visual C++", 0) AND NOT StringInStr($filetype, "SPx Method", 0) AND NOT StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "7.0", 0)
			$test7z = True
			$testie = True
		Case StringInStr($filetype, "Microsoft Visual C++ 7.0", 0) AND StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "Hotfix", 0)
			extract("vssfx", "Visual C++ " & t("TERM_SFX") & " " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Microsoft Visual C++ 6.0", 0) AND StringInStr($filetype, "Custom", 0)
			extract("vssfxpath", "Visual C++ " & t("TERM_SFX") & "" & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Netopsystems FEAD Optimizer", 0)
			extract("fead", "Netopsystems FEAD " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Nullsoft PiMP SFX", 0)
			checknsis()
		Case StringInStr($filetype, "PEtite", 0)
			$testarj = True
			If $aceinst Then $testace = True
		Case StringInStr($filetype, "RAR SFX", 0)
			extract("rar", t("TERM_SFX") & " RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Reflexive Arcade Installer", 0)
			extract("inno", "Reflexive Arcade " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "RoboForm Installer", 0)
			extract("robo", "RoboForm " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Setup Factory 6.x", 0)
			extract("ie", "Setup Factory " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "SPx Method", 0) OR StringInStr($filetype, "CAB SFX", 0)
			extract("cab", t("TERM_SFX") & " Microsoft CAB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "SuperDAT", 0)
			extract("superdat", "McAfee SuperDAT " & t("TERM_UPDATER"))
		Case StringInStr($filetype, "Wise", 0) OR StringInStr($filetype, "PEncrypt 4.0", 0)
			extract("wise", "Wise Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "ZIP SFX", 0)
			extract("zip", t("TERM_SFX") & " ZIP " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "upx", 0) OR StringInStr($filetype, "aspack", 0)
			$packed = True
		Case Else
			$test7z = True
			$testzip = True
			$testie = True
	EndSelect
	Return $filetype
EndFunc

Func check7z()
	SplashTextOn($title, t("TERM_TESTING") & " 7-Zip " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	RunWait($cmd & $7z & ' l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If StringInStr(FileReadLine($debugfile, 4), "Listing archive:", 0) Then
		$infile = FileOpen($debugfile, 0)
		$line = FileReadLine($infile)
		Do
			If StringInStr($line, "_sfx_manifest_") Then
				FileClose($infile)
				FileDelete($debugfile)
				SplashOff()
				extract("hotfix", "Microsoft " & t("TERM_HOTFIX"))
			EndIf
			$line = FileReadLine($infile)
		Until @error
		FileClose($infile)
		SplashOff()
		If $fileext = "exe" Then
			extract("7z", "7-Zip " & t("TERM_INSTALLER") & " " & t("TERM_PACKAGE"))
		ElseIf $fileext = "xz" Then
			extract("xz", "XZ " & t("TERM_COMPRESSED"))
		ElseIf $fileext = "z" Then
			extract("Z", "LZW " & t("TERM_COMPRESSED"))
		EndIf
	EndIf
	FileDelete($debugfile)
	SplashOff()
	$7zfailed = True
	Return False
EndFunc

Func checkarj()
	SplashTextOn($title, t("TERM_TESTING") & " SFX ARJ " & t("TERM_ARCHIVE"), 330, 50, -1, $height, 16)
	RunWait($cmd & $arj & ' l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If StringInStr(FileReadLine($debugfile, 5), "Archive created:", 0) Then
		SplashOff()
		extract("arj", t("TERM_SFX") & " ARJ " & t("TERM_ARCHIVE"))
	EndIf
	FileDelete($debugfile)
	SplashOff()
	$arjfailed = True
	Return False
EndFunc

Func checkace()
	extract("ace", t("TERM_SFX") & " ACE " & t("TERM_ARCHIVE"))
	$acefailed = True
	Return False
EndFunc

Func checkie()
	SplashTextOn($title, t("TERM_TESTING") & " InstallExplorer " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	RunWait($cmd & $ie & ' l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If StringInStr(FileReadLine($debugfile, 11), "##", 0) Then
		$type = StringStripWS(StringReplace(StringTrimLeft(FileReadLine($debugfile, 11), StringInStr(FileReadLine($debugfile, 11), "-> ", 0) + 2), "##", ""), 3)
		extract("ie", $type & " " & t("TERM_INSTALLER"))
	EndIf
	FileDelete($debugfile)
	SplashOff()
	$iefailed = True
	Return False
EndFunc

Func checkinno()
	SplashTextOn($title, t("TERM_TESTING") & " Inno Setup " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	RunWait($cmd & $inno & ' "' & $file & '" >' & $debugfile, $filedir, @SW_HIDE)
	If (StringInStr(FileReadLine($debugfile, 1), "Version detected:", 0) AND NOT (StringInStr(FileReadLine($debugfile, 2), "error", 0) OR StringInStr(FileReadLine($debugfile, 3), "error", 0))) OR (StringInStr(FileReadLine($debugfile, 1), "Signature detected:", 0) AND NOT StringInStr(FileReadLine($debugfile, 1), "not a supported version", 0)) Then
		SplashOff()
		extract("inno", "Inno Setup " & t("TERM_INSTALLER"))
	EndIf
	FileDelete($debugfile)
	SplashOff()
	$innofailed = True
	checkie()
	Return False
EndFunc

Func checkinstallshield()
	extract("isexe", "InstallShield " & t("TERM_INSTALLER"))
	Return False
EndFunc

Func checknsis()
	SplashTextOn($title, t("TERM_TESTING") & " NSIS " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	RunWait($cmd & $7z & ' l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If StringInStr(FileReadLine($debugfile, 4), "Listing archive:", 0) Then
		SplashOff()
		extract("7z", "NSIS " & t("TERM_INSTALLER"))
	EndIf
	FileDelete($debugfile)
	SplashOff()
	checkie()
	Return False
EndFunc

Func checkzip()
	SplashTextOn($title, t("TERM_TESTING") & " SFX ZIP " & t("TERM_ARCHIVE"), 330, 50, -1, $height, 16)
	RunWait($cmd & $zip & ' -l "' & $file & '"' & $output, $filedir, @SW_HIDE)
	If NOT StringInStr(FileReadLine($debugfile, 2), "signature not found", 0) Then
		SplashOff()
		extract("zip", t("TERM_SFX") & " ZIP " & t("TERM_ARCHIVE"))
	EndIf
	FileDelete($debugfile)
	SplashOff()
	$zipfailed = True
	Return False
EndFunc

Func extract($arctype, $arcdisp)
	SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
	If StringRight($outdir, 1) = "\" Then $outdir = StringTrimRight($outdir, 1)
	If NOT FileExists($outdir) Then
		$validdir = DirCreate($outdir)
		If NOT $validdir Then terminate("invaliddir", $outdir, "")
		$createdir = True
	Else
		$dirmtime = FileGetTime($outdir, 0, 1)
	EndIf
	$initdirsize = DirGetSize($outdir)
	$tempoutdir = _tempfile($outdir, "uni_", "")
	Select 
		Case $arctype == "7z"
			Local $appendargs = ""
			If StringInStr($filetype, "Nullsoft Install System", 0) Then
				$appendargs = "-aos"
			EndIf
			RunWait($cmd & $7z & " x " & $appendargs & ' "' & $file & '"', $outdir)
			If StringInStr($filetype, "RPM Linux Package", 0) Then
				If FileExists($outdir & "\" & $filename & ".cpio") Then
					RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '.cpio"', $outdir)
					FileDelete($outdir & "\" & $filename & ".cpio")
				EndIf
			ElseIf StringInStr($filetype, "Debian Linux Package", 0) Then
				If FileExists($outdir & "\data.tar") Then
					RunWait($cmd & $7z & ' x "' & $outdir & '\data.tar"', $outdir)
					FileDelete($outdir & "\data.tar")
				EndIf
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "ace"
			Opt("WinTitleMatchMode", 3)
			$pid = Run($ace & ' -x "' & $file & '" "' & $outdir & '"', $filedir)
			While 1
				If NOT ProcessExists($pid) Then ExitLoop 
				If WinExists("Error") Then
					ProcessClose($pid)
					ExitLoop 
				EndIf
				Sleep(100)
			WEnd
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "arc"
			RunWait($cmd & $arc & ' x "' & $file & '"' & $output, $outdir)
		Case $arctype == "arj"
			RunWait($cmd & $arj & ' x "' & $file & '"', $outdir)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "bin"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("BIN/CUE")))
			If $convert <> 1 Then
				If $createdir Then DirRemove($outdir, 0)
				terminate("silent", "", "")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			$binfile = $filedir & "\" & $filename & ".bin"
			$cuefile = $filedir & "\" & $filename & ".cue"
			Local $missing
			If NOT FileExists($binfile) Then
				$missing = "bin"
			ElseIf NOT FileExists($cuefile) Then
				$missing = "cue"
			EndIf
			If $missing Then
				SplashOff()
				MsgBox(48, $title, t("CONVERT_BIN_MISSING", createarray($filedir, $filename, $missing, $filename, $filename)))
				If $createdir Then DirRemove($outdir, 0)
				terminate("silent", "", "")
			EndIf
			$newcue = $filedir & "\" & $filename & "_uniextract.cue"
			$infile = FileOpen($cuefile, 0)
			$outfile = FileOpen($newcue, 2)
			$line = FileReadLine($infile)
			Do
				If StringLeft($line, 4) <> "REM " Then FileWriteLine($outfile, $line)
				$line = FileReadLine($infile)
			Until @error
			FileClose($outfile)
			FileClose($infile)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "BIN/CUE CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			RunWait($cmd & $bin & ' "' & $newcue & '"' & $output, $filedir)
			$isofile = FileFindFirstFile($filedir & "\" & $filename & "-*.iso")
			FileDelete($newcue)
			If $isofile == -1 OR NOT FileExists($binfile) Then
				SplashOff()
				If NOT FileExists($binfile) Then
					$isofilename = FileFindNextFile($isofile)
					FileMove($filedir & "\" & $isofilename, $binfile)
				EndIf
				FileClose($isofile)
				MsgBox(64, $title, t("CONVERT_CDROM_STAGE1_FAILED"))
				If $createdir Then DirRemove($outdir, 0)
				terminate("failed", $file, $arcdisp)
			Else
				$isofilename = FileFindNextFile($isofile)
				FileClose($isofile)
				ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "BIN/CUE CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 2)")
				RunWait($cmd & $7z & ' x "' & $filedir & "\" & $isofilename & '"', $outdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
				If DirGetSize($outdir) <= $initdirsize Then
					$image = MsgBox(52, $title, t("CONVERT_CDROM_STAGE2_FAILED", createarray("BIN/CUE")))
					If $image == 7 Then FileDelete($filedir & "\" & $isofilename)
					If $createdir Then DirRemove($outdir, 0)
					terminate("silent", "", "")
				Else
					FileDelete($filedir & "\" & $isofilename)
				EndIf
			EndIf
		Case $arctype == "bz2"
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			If FileExists($outdir & "\" & $filename) Then
				RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"', $outdir)
				FileDelete($outdir & "\" & $filename)
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "cab"
			If StringInStr($filetype, "Type 1", 0) Then
				If $warnexecute Then warn_execute($filename & '.exe /q /x:"<outdir>"')
				RunWait('"' & $file & '" /q /x:"' & $outdir & '"', $outdir)
			Else
				RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
			EndIf
		Case $arctype == "cdi"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("CDI")))
			If $convert <> 1 Then
				If $createdir Then DirRemove($outdir, 0)
				terminate("silent", "", "")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			DirCreate($tempoutdir)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			RunWait($cmd & $cdi & ' "' & $file & '" -iso' & $output, $tempoutdir)
			$isos = FileFindFirstFile($tempoutdir & "\*.iso")
			If @error Then
				FileClose($isos)
				SplashOff()
				MsgBox(64, $title, t("CONVERT_CDROM_STAGE1_FAILED"))
				DirRemove($tempoutdir, 1)
				If $createdir Then DirRemove($outdir, 0)
				terminate("failed", $file, $arcdisp)
			Else
				ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 2)")
				While 1
					$isofile = FileFindNextFile($isos)
					If @error Then ExitLoop 
					RunWait($cmd & $7z & ' x "' & $tempoutdir & "\" & $isofile & '"', $outdir)
					FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
				WEnd
				FileClose($isos)
				If DirGetSize($outdir) <= $initdirsize Then
					$image = MsgBox(52, $title, t("CONVERT_CDROM_STAGE2_FAILED", createarray("CDI")))
					If $image == 7 Then DirRemove($tempoutdir, 1)
					If $createdir Then DirRemove($outdir, 0)
					terminate("silent", "", "")
				Else
					DirRemove($tempoutdir, 1)
					If $createdir Then DirRemove($outdir, 0)
				EndIf
			EndIf
		Case $arctype == "chm"
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			FileDelete($outdir & "\#*")
			FileDelete($outdir & "\$*")
			$dirs = FileFindFirstFile($outdir & "\*")
			If $dirs <> -1 Then
				$dir = FileFindNextFile($dirs)
				Do
					If StringLeft($dir, 1) == "#" OR StringLeft($dir, 1) == "$" Then DirRemove($outdir & "\" & $dir, 1)
					$dir = FileFindNextFile($dirs)
				Until @error
			EndIf
			FileClose($dirs)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "dbx"
			RunWait($cmd & $dbx & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir)
		Case $arctype == "fead"
			If $warnexecute Then warn_execute($filename & '.exe /s -nos_ne -nos_o"<outdir>"')
			RunWait($file & ' /s -nos_ne -nos_o"' & $tempoutdir & '"', $filedir)
			FileSetAttrib($tempoutdir & "\*", "-R", 1)
			movefiles($tempoutdir, $outdir)
			DirRemove($tempoutdir)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "gz"
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"', $outdir)
				FileDelete($outdir & "\" & $filename)
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "hlp"
			RunWait($cmd & $hlp & ' "' & $file & '"', $outdir)
			If DirGetSize($outdir) > $initdirsize Then
				DirCreate($tempoutdir)
				RunWait($cmd & $hlp & ' /r /n "' & $file & '"' & $output, $tempoutdir)
				FileMove($tempoutdir & "\" & $filename & ".rtf", $outdir & "\" & $filename & "_Reconstructed.rtf")
				DirRemove($tempoutdir, 1)
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "hotfix"
			If $warnexecute Then warn_execute($filename & '.exe /q /x:"<outdir>"')
			RunWait('"' & $file & '" /q /x:"' & $outdir & '"', $outdir)
		Case $arctype == "ie"
			DirCreate($tempoutdir)
			RunWait($cmd & $ie & ' x "' & $file & '" "' & $tempoutdir & '"' & $output, $filedir)
			If $removedupe Then
				Local $iefiles[1]
				$infile = FileOpen($debugfile, 0)
				$line = FileReadLine($infile, 12)
				Do
					_arrayadd($iefiles, StringTrimLeft($line, StringInStr($line, "-> ", 0) + 2))
					$line = FileReadLine($infile)
				Until @error
				$exfiles = filesearch($tempoutdir)
				For $i = 1 To $exfiles[0]
					For $j = 1 To UBound($iefiles) - 1
						If $exfiles[$i] = $tempoutdir & "\" & $iefiles[$j] Then
							ContinueLoop 2
						EndIf
					Next
					FileDelete($exfiles[$i])
				Next
				For $i = 1 To $exfiles[0]
					If StringInStr(FileGetAttrib($exfiles[$i]), "D") Then
						If DirGetSize($exfiles[$i]) == 0 Then
							DirRemove($exfiles[$i], 1)
						EndIf
					EndIf
				Next
			EndIf
			If $appendext Then
				appendextensions($tempoutdir)
			EndIf
			movefiles($tempoutdir & "\ò", $tempoutdir)
			DirRemove($tempoutdir & "\ò")
			movefiles($tempoutdir, $outdir)
			DirRemove($tempoutdir)
		Case $arctype == "img"
			RunWait($cmd & $img & ' -x "' & $file & '"' & $output, $outdir)
		Case $arctype == "inno"
			If StringInStr($filetype, "Reflexive Arcade", 0) Then
				DirCreate($tempoutdir)
				RunWait($cmd & $rai & ' "' & $file & '" "' & $tempoutdir & "\" & $filename & '.exe"' & $output, $filedir)
				RunWait($cmd & $inno & ' -x -m -a "' & $tempoutdir & "\" & $filename & '.exe"' & $output, $outdir)
				FileDelete($tempoutdir & "\" & $filename & ".exe")
				DirRemove($tempoutdir)
			Else
				RunWait($cmd & $inno & ' -x -m -a "' & $file & '"' & $output, $outdir)
			EndIf
		Case $arctype == "ctar"
			$oldfiles = returnfiles($outdir)
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			$handle = FileFindFirstFile($outdir & "\*")
			If NOT @error Then
				While 1
					$fname = FileFindNextFile($handle)
					If @error Then ExitLoop 
					If NOT StringInStr($oldfiles, $fname) Then
						RunWait($cmd & $7z & ' l "' & $outdir & "\" & $fname & '"' & $output, $outdir, @SW_HIDE)
						If StringInStr(FileReadLine($debugfile, 4), "Listing archive:", 0) Then
							RunWait($cmd & $7z & ' x "' & $outdir & "\" & $fname & '"', $outdir, @SW_HIDE)
							FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
							FileDelete($outdir & "\" & $fname)
						EndIf
					EndIf
				WEnd
			EndIf
			FileClose($handle)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "is3arc"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "i3comp" Then
				RunWait($cmd & $is3arc & ' "' & $file & '" *.* -d -i' & $output, $outdir)
			ElseIf $choice == "STIX" Then
				RunWait($cmd & $is3exe & " " & FileGetShortName($file) & " " & FileGetShortName($outdir) & $output, $filedir)
			EndIf
		Case $arctype == "iscab"
			Local $isfiles[1]
			RunWait($cmd & $is6cab & ' l -o -r -d "' & $file & '"' & $output, $outdir)
			$infile = FileOpen($debugfile, 0)
			$line = FileReadLine($infile)
			Do
				_arrayadd($isfiles, StringTrimLeft($line, 50))
				$line = FileReadLine($infile)
			Until @error
			FileClose($infile)
			If $isfiles[1] <> "" Then
				SplashOff()
				iscabextract($is6cab, $isfiles, $arcdisp)
			EndIf
			If $isfiles[1] == "" OR DirGetSize($outdir) <= $initdirsize Then
				Local $isfiles[1]
				RunWait($cmd & $is5cab & ' l -o -r -d "' & $file & '"' & $output, $outdir)
				$infile = FileOpen($debugfile, 0)
				$line = FileReadLine($infile)
				Do
					_arrayadd($isfiles, StringTrimLeft($line, 47))
					$line = FileReadLine($infile)
				Until @error
				FileClose($infile)
				If $isfiles[1] <> "" Then
					SplashOff()
					iscabextract($is5cab, $isfiles, $arcdisp)
				EndIf
			EndIf
		Case $arctype == "isexe"
			exescan($file, "ext", 0)
			If StringInStr($filetype, "3.x", 0) Then
				RunWait($cmd & $is3exe & " " & FileGetShortName($file) & " " & FileGetShortName($outdir) & $output, $filedir)
			Else
				$choice = methodselect($arctype, $arcdisp)
				If $choice == "not InstallShield" Then
					$isfailed = True
					Return False
				ElseIf $choice == "isxunpack" Then
					FileMove($file, $outdir)
					Run($cmd & $isexe & ' "' & $outdir & "\" & $filename & "." & $fileext & '"' & $output, $outdir)
					WinWait(@ComSpec)
					WinActivate(@ComSpec)
					Send("{ENTER}")
					ProcessWaitClose($isexe)
					FileMove($outdir & "\" & $filename & "." & $fileext, $filedir)
				ElseIf $choice == "InstallShield /b" Then
					If $warnexecute Then warn_execute($filename & '.exe /b"<outdir>" /v"/l "<debugfile>""')
					SplashTextOn($title, t("INIT_WAIT"), 330, 70, -1, $height, 16)
					Run('"' & $file & '" /b"' & $tempoutdir & '" /v"/l "' & $debugfile & '""', $filedir)
					Opt("WinTitleMatchMode", 4)
					Local $success
					For $i = 1 To 40
						If NOT WinExists("classname=MsiDialogCloseClass") Then
							Sleep(500)
						Else
							$msihandle = FileFindFirstFile($tempoutdir & "\*.msi")
							If NOT @error Then
								While 1
									$msiname = FileFindNextFile($msihandle)
									If @error Then ExitLoop 
									$tsearch = filesearch(EnvGet("temp") & "\" & $msiname)
									If NOT @error Then
										$isdir = StringLeft($tsearch[1], StringInStr($tsearch[1], "\", 0, -1) - 1)
										$ishandle = FileFindFirstFile($isdir & "\*")
										$fname = FileFindNextFile($ishandle)
										Do
											If $fname <> $msiname Then
												FileCopy($isdir & "\" & $fname, $tempoutdir)
											EndIf
											$fname = FileFindNextFile($ishandle)
										Until @error
										FileClose($ishandle)
									EndIf
								WEnd
								FileClose($msihandle)
							EndIf
							SplashOff()
							MsgBox(32, $title, t("INIT_COMPLETE", createarray(t("TERM_SUCCEEDED"))))
							movefiles($tempoutdir, $outdir)
							DirRemove($tempoutdir, 1)
							$success = True
							ExitLoop 
						EndIf
					Next
					If NOT $success Then
						SplashOff()
						MsgBox(48, $title, t("INIT_COMPLETE", createarray(t("TERM_FAILED"))))
					EndIf
				EndIf
			EndIf
		Case $arctype == "kgb"
			$show_stats = RegRead("HKCU\Software\KGB Archiver", "show_stats")
			RegWrite("HKCU\Software\KGB Archiver", "show_stats", "REG_DWORD", 0)
			RunWait($kgb & ' /s "' & $file & '" "' & $outdir & '"', $outdir)
			If $show_stats == "" Then
				RegDelete("HKCU\Software\KGB Archiver")
			Else
				RegWrite("HKCU\Software\KGB Archiver", "show_stats", "REG_DWORD", $show_stats)
			EndIf
		Case $arctype == "lit"
			RunWait($cmd & $lit & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir)
		Case $arctype == "lzo"
			RunWait($cmd & $lzo & ' -d -p"' & $outdir & '" "' & $file & '"' & $output, $filedir)
		Case $arctype == "lzx"
			RunWait($cmd & $lzx & ' -x "' & $file & '"' & $output, $outdir)
		Case $arctype == "mht"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "ExtractMHT" Then
				RunWait($mht & ' "' & $file & '" "' & $outdir & '"')
			ElseIf $choice == "MHT TC Packer" Then
				DirCreate($tempoutdir)
				RunWait($cmd & $mht_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $tempoutdir)
				movefiles($tempoutdir, $outdir)
				DirRemove($tempoutdir)
			EndIf
		Case $arctype == "msi"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "MSI" Then
				RunWait('msiexec.exe /a "' & $file & '" /qb /l ' & $debugfile & ' TARGETDIR="' & $outdir & '"', $filedir)
			ElseIf $choice == "MsiX" Then
				Local $appendargs = ""
				If $appendext Then $appendargs = "/ext"
				RunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir)
			ElseIf $choice == "MSI TC Packer" Then
				DirCreate($tempoutdir)
				RunWait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir)
				$cabfiles = filesearch($tempoutdir)
				For $i = 1 To $cabfiles[0]
					filescan($cabfiles[$i], 0)
					If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
						RunWait($cmd & $7z & ' x "' & $cabfile[$i] & '"', $outdir)
						FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
						FileDelete($cabfiles[$i])
					EndIf
				Next
				If $appendext Then
					appendextensions($tempoutdir)
				EndIf
				movefiles($tempoutdir, $outdir)
				DirRemove($tempoutdir)
			EndIf
		Case $arctype == "msm"
			Local $appendargs = ""
			If $appendext Then $appendargs = "/ext"
			RunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir)
		Case $arctype == "msp"
			$choice = methodselect($arctype, $arcdisp)
			DirCreate($tempoutdir)
			If $choice == "MSI TC Packer" Then
				RunWait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir)
			ElseIf $choice == "MsiX" Then
				RunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $tempoutdir & '"' & $output, $filedir)
			ElseIf $choice == "7-Zip" Then
				RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
			EndIf
			$cabfiles = filesearch($tempoutdir)
			For $i = 1 To $cabfiles[0]
				filescan($cabfiles[$i], 0)
				If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
					RunWait($cmd & $7z & ' x "' & $cabfiles[$i] & '"', $outdir)
					FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
					FileDelete($cabfiles[$i])
				EndIf
			Next
			If $appendext Then
				appendextensions($tempoutdir)
			EndIf
			movefiles($tempoutdir, $outdir)
			DirRemove($tempoutdir)
		Case $arctype == "nbh"
			RunWait($cmd & $nbh & ' "' & $file & '"', $outdir)
		Case $arctype == "nrg"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("NRG")))
			If $convert <> 1 Then
				If $createdir Then DirRemove($outdir, 0)
				terminate("silent", "", "")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "NRG CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			$isofile = $filedir & "\" & $filename & ".iso"
			RunWait($cmd & $nrg & ' "' & $file & '" "' & $isofile & '"' & $output, $filedir)
			If NOT FileExists($isofile) Then
				SplashOff()
				MsgBox(64, $title, t("CONVERT_CDROM_STAGE1_FAILED"))
				If $createdir Then DirRemove($outdir, 0)
				terminate("failed", $file, $arcdisp)
			Else
				ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "NRG CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 2)")
				RunWait($cmd & $7z & ' x "' & $isofile & '"', $outdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
				If DirGetSize($outdir) <= $initdirsize Then
					$image = MsgBox(52, $title, t("CONVERT_CDROM_STAGE2_FAILED", createarray("NRG")))
					If $image == 7 Then FileDelete($isofile)
					If $createdir Then DirRemove($outdir, 0)
					terminate("silent", "", "")
				Else
					FileDelete($isofile)
				EndIf
			EndIf
		Case $arctype == "pea"
			Local $pid, $windows, $title, $status
			$pid = Run($pea & ' UNPEA "' & $file & '" "' & $tempoutdir & '" RESETDATE SETATTR EXTRACT2DIR INTERACTIVE', $filedir)
			WinWait("PEA", "", 20)
			$windows = WinList("PEA")
			For $i = 0 To $windows[0][0]
				If WinGetProcess($windows[$i][0]) == $pid Then
					$peatitle = $windows[$i][0]
				EndIf
			Next
			While ProcessExists($pid)
				$status = ControlGetText($peatitle, "", "Button1")
				If StringLeft($status, 4) = "Done" Then ProcessClose($pid)
				Sleep(10)
			WEnd
			movefiles($tempoutdir, $outdir)
			DirRemove($tempoutdir)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "rar"
			RunWait($cmd & $rar & ' x "' & $file & '"' & $output, $outdir)
		Case $arctype == "robo"
			If $warnexecute Then warn_execute($filename & '.exe /unpack="<outdir>"')
			RunWait($file & ' /unpack="' & $outdir & '"', $filedir)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "sis"
			RunWait($cmd & $sis & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir)
		Case $arctype == "sit"
			DirCreate($tempoutdir)
			FileMove($file, $tempoutdir)
			RunWait($sit & ' "' & $tempoutdir & "\" & $filename & "." & $fileext & '"', $tempoutdir)
			FileMove($tempoutdir & "\" & $filename & "." & $fileext, $file)
			movefiles($tempoutdir & "\" & $filename, $outdir)
			DirRemove($tempoutdir, 1)
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
		Case $arctype == "superdat"
			If $warnexecute Then warn_execute($filename & '.exe /e "<outdir>"')
			RunWait($file & ' /e "' & $outdir & '"', $outdir)
			FileMove($filedir & "\SuperDAT.log", $debugfile, 1)
		Case $arctype == "tar"
			If $fileext = "tar" Then
				RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			Else
				RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
				RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '.tar"', $outdir)
				FileDelete($outdir & "\" & $filename & ".tar")
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "vssfx"
			If $warnexecute Then warn_execute($filename & ".exe /extract")
			FileMove($file, $outdir)
			RunWait($outdir & "\" & $filename & "." & $fileext & " /extract", $outdir)
			FileMove($outdir & "\" & $filename & "." & $fileext, $filedir)
		Case $arctype == "vssfxpath"
			If $warnexecute Then warn_execute($filename & '.exe /extract:"<outdir>" /quiet')
			RunWait($file & ' /extract:"' & $outdir & '" /quiet', $outdir)
		Case $arctype == "wise"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "E_Wise" Then
				RunWait($cmd & $wise_ewise & ' "' & $file & '" "' & $outdir & '"' & $output, $filedir)
				If DirGetSize($outdir) > $initdirsize Then
					RunWait($cmd & "00000000.BAT", $outdir, @SW_HIDE)
					FileDelete($outdir & "\00000000.BAT")
				EndIf
			ElseIf $choice == "WUN" Then
				RunWait($cmd & $wise_wun & ' "' & $filename & '" "' & $tempoutdir & '"', $filedir)
				If $removetemp Then
					FileDelete($tempoutdir & "\INST0*")
					FileDelete($tempoutdir & "\WISE0*")
				Else
					FileMove($tempoutdir & "\INST0*", $outdir)
					FileMove($tempoutdir & "\WISE0*", $outdir)
				EndIf
				movefiles($tempoutdir, $outdir)
				DirRemove($tempoutdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
			ElseIf $choice == "Wise Installer /x" Then
				If $warnexecute Then warn_execute($filename & ".exe /x <outdir>")
				RunWait($file & " /x " & $outdir, $filedir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
			ElseIf $choice == "Wise MSI" Then
				SplashOff()
				$continue = MsgBox(65, $title, t("WISE_MSI_PROMPT", createarray($name)))
				If $continue <> 1 Then
					If $createdir Then DirRemove($outdir, 0)
					terminate("silent", "", "")
				EndIf
				If $warnexecute Then warn_execute($filename & ".exe /?")
				SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
				$oldfiles = returnfiles(@CommonFilesDir & "\Wise Installation Wizard")
				Opt("WinTitleMatchMode", 3)
				$pid = Run($file & " /?", $filedir)
				While 1
					Sleep(10)
					If WinExists("Windows Installer") Then
						WinSetState("Windows Installer", "", @SW_HIDE)
						ExitLoop 
					Else
						If NOT ProcessExists($pid) Then ExitLoop 
					EndIf
				WEnd
				movefiles(@CommonFilesDir & "\Wise Installation Wizard", $outdir, 0, $oldfiles)
				DirRemove(@CommonFilesDir & "\Wise Installation Wizard", 0)
				WinClose("Windows Installer")
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray($arcdisp)))
			ElseIf $choice == "Unzip" Then
				$return = RunWait($cmd & $zip & ' -x "' & $file & '"', $outdir)
				If $return <> 0 Then
					RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
					FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
				EndIf
			EndIf
			If $appendext Then
				appendextensions($outdir)
			EndIf
		Case $arctype == "uha"
			RunWait($cmd & $uharc & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir)
			If DirGetSize($outdir) <= $initdirsize Then
				$error = FileReadLine($debugfile, 6)
				If StringInStr($error, "use UHARC version", 0) Then
					$version = StringTrimLeft($error, StringInStr($error, " ", 0, -1))
					If $version == "0.4" Then
						RunWait($cmd & $uharc04 & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir)
					ElseIf $version == "0.2" Then
						RunWait($cmd & $uharc02 & " x -t" & FileGetShortName($outdir) & " " & FileGetShortName($file) & $output, $outdir)
					EndIf
				EndIf
			EndIf
		Case $arctype == "uu"
			RunWait($cmd & $uu & ' -p "' & $outdir & '" -i "' & $file & '"', $filedir)
		Case $arctype == "xz"
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"', $outdir)
				FileDelete($outdir & "\" & $filename)
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "Z"
			RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				RunWait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"', $outdir)
				FileDelete($outdir & "\" & $filename)
			EndIf
			FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
		Case $arctype == "zip"
			$return = RunWait($cmd & $zip & ' -x "' & $file & '"' & $output, $outdir)
			If $return > 1 Then
				RunWait($cmd & $7z & ' x "' & $file & '"', $outdir)
				FileWriteLine($debugfile, t("CANNOT_LOG", createarray("7-Zip " & $arcdisp)))
			EndIf
		Case $arctype == "zoo"
			DirCreate($tempoutdir)
			FileMove($file, $tempoutdir)
			RunWait($cmd & $zoo & " x " & FileGetShortName($filename & "." & $fileext) & $output, $tempoutdir)
			FileMove($tempoutdir & "\" & $filename & "." & $fileext, $file)
			movefiles($tempoutdir, $outdir)
			DirRemove($tempoutdir)
	EndSelect
	SplashOff()
	If $createdir Then
		If DirGetSize($outdir) <= $initdirsize Then
			If $createdir Then DirRemove($outdir, 0)
			If $arctype == "ace" AND $fileext = "exe" Then Return False
			terminate("failed", $file, $arcdisp)
		EndIf
	Else
		If FileGetTime($outdir, 0, 1) == $dirmtime Then
			terminate("failed", $file, $arcdisp)
		EndIf
	EndIf
	terminate("success", "", "")
EndFunc

Func unpack()
	Local $packer
	If StringInStr($filetype, "UPX", 0) OR $fileext = "dll" Then
		$packer = "UPX"
	ElseIf StringInStr($filetype, "ASPack", 0) Then
		$packer = "ASPack"
	EndIf
	$unpack = MsgBox(65, $title, t("UNPACK_PROMPT", createarray($packer, $filedir, $filename, $fileext)))
	If $unpack <> 1 Then Return 
	If $packer == "UPX" Then
		RunWait($cmd & $upx & ' -d -k "' & $file & '"', $filedir)
		$tempext = StringTrimRight($fileext, 1) & "~"
		If FileExists($filedir & "\" & $filename & "." & $tempext) Then
			FileMove($file, $filedir & "\" & $filename & "_" & t("TERM_UNPACKED") & "." & $fileext)
			FileMove($filedir & "\" & $filename & "." & $tempext, $file)
			terminate("success", "", "")
		Else
			MsgBox(48, $title, t("UNPACK_FAILED", createarray($file)))
			terminate("silent", "", "")
		EndIf
	ElseIf $packer == "ASPack" Then
		RunWait($cmd & $aspack & ' "' & $file & '" "' & $filedir & "\" & $filename & "_" & t("TERM_UNPACKED") & '.exe" /NO_PROMPT', $filedir)
		If FileExists($filedir & "\" & $filename & "_" & t("TERM_UNPACKED") & ".exe") Then
			terminate("success", "", "")
			MsgBox(48, $title, t("UNPACK_FAILED", createarray($file)))
			terminate("silent", "", "")
		EndIf
	EndIf
	Return 
EndFunc

Func returnfiles($dir)
	Local $handle, $files, $fname
	$handle = FileFindFirstFile($dir & "\*")
	If NOT @error Then
		While 1
			$fname = FileFindNextFile($handle)
			If @error Then ExitLoop 
			$files &= $fname & "|"
		WEnd
		StringTrimRight($files, 1)
		FileClose($handle)
	Else
		SetError(1)
		Return 
	EndIf
	Return $files
EndFunc

Func movefiles($source, $dest, $force = 0, $omit = "")
	Local $handle, $fname
	DirCreate($dest)
	$handle = FileFindFirstFile($source & "\*")
	If NOT @error Then
		While 1
			$fname = FileFindNextFile($handle)
			If @error Then
				ExitLoop 
			ElseIf StringInStr($omit, $fname) Then
				ContinueLoop 
			Else
				If StringInStr(FileGetAttrib($source & "\" & $fname), "D") Then
					DirMove($source & "\" & $fname, $dest, 1)
				Else
					FileMove($source & "\" & $fname, $dest, $force)
				EndIf
			EndIf
		WEnd
		FileClose($handle)
	Else
		SetError(1)
		Return 
	EndIf
EndFunc

Func iscabextract($iscab, $files, $subtitle)
	ProgressOn($title, $subtitle, "", -1, $height, 16)
	For $i = 1 To UBound($files) - 1
		ProgressSet(Round($i / (UBound($files) - 1), 2) * 100, "Extracting: " & $files[$i])
		RunWait($cmd & $iscab & ' x -r -d "' & $file & '" "' & $files[$i] & '"', $outdir, @SW_HIDE)
	Next
	ProgressOff()
EndFunc

Func appendextensions($dir)
	Local $files
	$files = filesearch($dir)
	If $files[1] <> "" Then
		For $i = 1 To $files[0]
			If NOT StringInStr(FileGetAttrib($files[$i]), "D") Then
				$filename = StringTrimLeft($files[$i], StringInStr($files[$i], "\", 0, -1))
				If NOT StringInStr($filename, ".") OR StringLeft($filename, 7) = "Binary." OR StringRight($filename, 4) = ".bin" Then
					RunWait($cmd & $trid & ' "' & $files[$i] & '" -ae', $dir, @SW_HIDE)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func filesearch($s_mask = "", $i_recurse = 1)
	Local $s_buf = ""
	If $i_recurse Then
		Local $s_command = ' /c dir /B /S "'
	Else
		Local $s_command = ' /c dir /B "'
	EndIf
	$i_pid = Run(@ComSpec & $s_command & $s_mask & '"', @WorkingDir, @SW_HIDE, 2 + 4)
	While NOT @error
		$s_buf &= StdoutRead($i_pid)
	WEnd
	$s_buf = StringSplit(StringTrimRight($s_buf, 2), @CRLF, 1)
	ProcessClose($i_pid)
	If UBound($s_buf) = 2 AND $s_buf[1] = "" Then SetError(1)
	Return $s_buf
EndFunc

Func pathsearch($file)
	$dir = StringSplit(EnvGet("path"), ";")
	ReDim $dir[$dir[0] + 1]
	$dir[$dir[0]] = @ScriptDir
	For $i = 1 To $dir[0]
		$exefiles = FileFindFirstFile($dir[$i] & "\*.exe")
		If $exefiles == -1 Then ContinueLoop 
		$exename = FileFindNextFile($exefiles)
		Do
			If $exename = $file Then
				FileClose($exefiles)
				Return _pathfull($dir[$i] & "\" & $exename)
			EndIf
			$exename = FileFindNextFile($exefiles)
		Until @error
		FileClose($exefiles)
	Next
	Return False
EndFunc

Func terminate($status, $fname, $id)
	Select 
		Case $status == "syntax"
			$syntax = t("HELP_SUMMARY")
			$syntax &= t("HELP_SYNTAX", createarray(@ScriptName))
			$syntax &= t("HELP_ARGUMENTS")
			$syntax &= t("HELP_HELP")
			$syntax &= t("HELP_PREFS")
			$syntax &= t("HELP_FILENAME")
			$syntax &= t("HELP_DESTINATION")
			$syntax &= t("HELP_SUB", createarray($name))
			$syntax &= t("HELP_EXAMPLE1")
			$syntax &= t("HELP_EXAMPLE2", createarray(@ScriptName))
			$syntax &= t("HELP_NOARGS", createarray($name))
			MsgBox(48, $title, $syntax)
			$exitcode = 0
		Case $status == "debug"
			MsgBox(48, $title, t("CANNOT_DEBUG", createarray($fname, $name)))
			$exitcode = 2
		Case $status == "unknownexe"
			$prompt = MsgBox(305, $title, t("CANNOT_EXTRACT", createarray($file, $id)))
			If $prompt == 1 Then
				Run($peid & ' "' & $file & '"', $filedir)
				WinWait($peidtitle)
				WinActivate($peidtitle)
			EndIf
			$exitcode = 3
		Case $status == "unknownext"
			MsgBox(48, $title, t("UNKNOWN_EXT", createarray($file)))
			$exitcode = 4
		Case $status == "invaliddir"
			MsgBox(48, $title, t("INVALID_DIR", createarray($fname)))
			$exitcode = 5
		Case $status == "failed"
			RunWait($cmd & "type " & FileGetShortName($debugfile) & " >" & FileGetShortName(envparse($debugdir)) & "uniextract_temp.txt", envparse($debugdir), @SW_HIDE)
			FileMove(FileGetShortName(envparse($debugdir)) & "uniextract_temp.txt", $debugfile, 1)
			$prompt = MsgBox(305, $title, t("EXTRACT_FAILED", createarray($file, $id, FileGetLongName($debugfile))))
			If $prompt == 1 Then
				ShellExecute($debugfile)
			EndIf
			$exitcode = 1
		Case $status == "success"
			FileDelete($debugfile)
			$exitcode = 0
		Case $status == "silent"
			$exitcode = 0
	EndSelect
	Exit $exitcode
EndFunc

Func methodselect($format, $splashdisp)
	SplashOff()
	$base_height = 130
	$base_radio = 100
	$url = "dummy"
	If $format == "wise" Then
		$select_type = "Wise Installer"
		Dim $method[5][2], $select[5]
		$method[0][0] = "E_Wise"
		$method[0][1] = "METHOD_UNPACKER_RADIO"
		$method[1][0] = "WUN"
		$method[1][1] = "METHOD_UNPACKER_RADIO"
		$method[2][0] = "Wise Installer /x"
		$method[2][1] = "METHOD_SWITCH_RADIO"
		$method[3][0] = "Wise MSI"
		$method[3][1] = "METHOD_EXTRACTION_RADIO"
		$method[4][0] = "Unzip"
		$method[4][1] = "METHOD_EXTRACTION_RADIO"
	ElseIf $format == "msi" Then
		$select_type = "MSI Installer"
		Dim $method[3][2], $select[3]
		$method[0][0] = "MSI"
		$method[0][1] = "METHOD_ADMIN_RADIO"
		$method[1][0] = "MsiX"
		$method[1][1] = "METHOD_EXTRACTION_RADIO"
		$method[2][0] = "MSI TC Packer"
		$method[2][1] = "METHOD_EXTRACTION_RADIO"
	ElseIf $format == "msp" Then
		$select_type = "MSP Package"
		Dim $method[3][2], $select[3]
		$method[0][0] = "MSI TC Packer"
		$method[0][1] = "METHOD_EXTRACTION_RADIO"
		$method[1][0] = "MsiX"
		$method[1][1] = "METHOD_EXTRACTION_RADIO"
		$method[2][0] = "7-Zip"
		$method[2][1] = "METHOD_EXTRACTION_RADIO"
	ElseIf $format == "mht" Then
		$select_type = "MHTML Archive"
		Dim $method[2][2], $select[2]
		$method[0][0] = "ExtractMHT"
		$method[0][1] = "METHOD_EXTRACTION_RADIO"
		$method[1][0] = "MHT TC Packer"
		$method[1][1] = "METHOD_EXTRACTION_RADIO"
	ElseIf $format == "is3arc" Then
		$select_type = "InstallShield 3.x Archive"
		Dim $method[2][2], $select[2]
		$method[0][0] = "i3comp"
		$method[0][1] = "METHOD_EXTRACTION_RADIO"
		$method[1][0] = "STIX"
		$method[1][1] = "METHOD_EXTRACTION_RADIO"
	ElseIf $format == "isexe" Then
		$select_type = "InstallShield Installer"
		Dim $method[3][2], $select[3]
		$method[0][0] = "isxunpack"
		$method[0][1] = "METHOD_EXTRACTION_RADIO"
		$method[1][0] = "InstallShield /b"
		$method[1][1] = "METHOD_SWITCH_RADIO"
		$method[2][0] = "not InstallShield"
		$method[2][1] = "METHOD_NOTIS_RADIO"
	EndIf
	Opt("GUIOnEventMode", 0)
	Local $guimethod = GUICreate($title, 330, $base_height + (UBound($method) * 20))
	$header = GUICtrlCreateLabel(t("METHOD_HEADER", createarray($select_type)), 5, 5, 320, 20)
	GUICtrlCreateLabel(t("METHOD_TEXT_LABEL", createarray($name, $select_type, $name)), 5, 25, 320, 65, $ss_left)
	GUICtrlCreateGroup(t("METHOD_RADIO_LABEL"), 5, $base_radio, 215, 25 + (UBound($method) * 20))
	For $i = 0 To UBound($method) - 1
		$select[$i] = GUICtrlCreateRadio(t($method[$i][1], createarray($method[$i][0])), 10, $base_radio + 20 + ($i * 20), 205, 20)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ok = GUICtrlCreateButton(t("OK_BUT"), 235, $base_radio - 10 + (UBound($method) * 10), 80, 20)
	$cancel = GUICtrlCreateButton(t("CANCEL_BUT"), 235, $base_radio - 10 + (UBound($method) * 10) + 30, 80, 20)
	GUICtrlSetFont($header, -1, 1200)
	GUICtrlSetState($select[0], $gui_checked)
	GUICtrlSetState($ok, $gui_defbutton)
	GUISetState(@SW_SHOW)
	While 1
		$action = GUIGetMsg()
		Select 
			Case $action == $ok
				For $i = 0 To UBound($method) - 1
					If GUICtrlRead($select[$i]) == $gui_checked Then
						GUIDelete($guimethod)
						SplashTextOn($title, t("EXTRACTING") & @CRLF & $splashdisp, 330, 70, -1, $height, 16)
						Return $method[$i][0]
					EndIf
				Next
			Case $action == $gui_event_close OR $action == $cancel
				If $createdir Then DirRemove($outdir, 0)
				terminate("silent", "", "")
		EndSelect
	WEnd
EndFunc

Func warn_execute($command)
	$prompt = MsgBox(49, $title, t("WARN_EXECUTE", createarray($command)))
	If $prompt <> 1 Then
		If $createdir Then DirRemove($outdir, 0)
		terminate("silent", "", "")
	EndIf
	Return True
EndFunc

Func createarray($i0, $i1 = 0, $i2 = 0, $i3 = 0, $i4 = 0, $i5 = 0, $i6 = 0, $i7 = 0, $i8 = 0, $i9 = 0)
	Local $arr[10] = [$i0, $i1, $i2, $i3, $i4, $i5, $i6, $i7, $i8, $i9]
	ReDim $arr[@NumParams]
	Return $arr
EndFunc

Func creategui()
	Global $guimain = GUICreate($title, 300, 135, -1, -1, -1, $ws_ex_acceptfiles)
	Local $dropzone = GUICtrlCreateLabel("", 0, 0, 300, 135)
	Local $filemenu = GUICtrlCreateMenu(t("MENU_FILE_LABEL"))
	Local $quititem = GUICtrlCreateMenuItem(t("MENU_FILE_QUIT_LABEL"), $filemenu)
	Local $editmenu = GUICtrlCreateMenu(t("MENU_EDIT_LABEL"))
	Local $prefsitem = GUICtrlCreateMenuItem(t("MENU_EDIT_PREFS_LABEL"), $editmenu)
	Local $helpmenu = GUICtrlCreateMenu(t("MENU_HELP_LABEL"))
	Local $webitem = GUICtrlCreateMenuItem(t("MENU_HELP_WEB_LABEL", createarray($name)), $helpmenu)
	GUICtrlCreateLabel(t("MAIN_FILE_LABEL"), 5, 5, -1, 15)
	If $history Then
		Global $filecont = GUICtrlCreateCombo("", 5, 20, 260, 20)
	Else
		Global $filecont = GUICtrlCreateInput("", 5, 20, 260, 20)
	EndIf
	Local $filebut = GUICtrlCreateButton("...", 270, 20, 25, 20)
	GUICtrlCreateLabel(t("MAIN_DEST_DIR_LABEL"), 5, 45, -1, 15)
	If $history Then
		Global $dircont = GUICtrlCreateCombo("", 5, 60, 260, 20)
	Else
		Global $dircont = GUICtrlCreateInput("", 5, 60, 260, 20)
	EndIf
	Local $dirbut = GUICtrlCreateButton("...", 270, 60, 25, 20)
	Global $ok = GUICtrlCreateButton(t("OK_BUT"), 55, 90, 80, 20)
	Local $cancel = GUICtrlCreateButton(t("CANCEL_BUT"), 165, 90, 80, 20)
	GUICtrlSetBkColor($dropzone, $gui_bkcolor_transparent)
	GUICtrlSetState($dropzone, $gui_disable)
	GUICtrlSetState($dropzone, $gui_dropaccepted)
	GUICtrlSetState($filecont, $gui_focus)
	GUICtrlSetState($ok, $gui_defbutton)
	If $file <> "" Then
		filenameparse($file)
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
			$dirlist = "|" & $initoutdir & "|" & readhist("directory")
			GUICtrlSetData($dircont, $dirlist, $initoutdir)
		Else
			GUICtrlSetData($filecont, $file)
			GUICtrlSetData($dircont, $initoutdir)
		EndIf
		GUICtrlSetState($dircont, $gui_focus)
	ElseIf $history Then
		GUICtrlSetData($filecont, readhist("file"))
		GUICtrlSetData($dircont, readhist("directory"))
	EndIf
	GUISetOnEvent($gui_event_dropped, "GUI_Drop")
	GUICtrlSetOnEvent($filebut, "GUI_File")
	GUICtrlSetOnEvent($dirbut, "GUI_Directory")
	GUICtrlSetOnEvent($prefsitem, "GUI_Prefs")
	GUICtrlSetOnEvent($webitem, "GUI_Website")
	GUICtrlSetOnEvent($ok, "GUI_Ok")
	GUICtrlSetOnEvent($cancel, "GUI_Exit")
	GUICtrlSetOnEvent($quititem, "GUI_Exit")
	GUISetOnEvent($gui_event_close, "GUI_Exit")
	GUISetState(@SW_SHOW)
EndFunc

Func getpos($gui, $control, $offset = 0)
	$location = ControlGetPos($gui, "", $control)
	If @error Then
		SetError(1, "", 0)
	Else
		Return $location[0] + $location[2] + $offset
	EndIf
EndFunc

Func charcount($string, $char)
	Local $count = StringSplit($string, $char, 1)
	Return $count[0]
EndFunc

Func gui_file()
	$file = FileOpenDialog(t("OPEN_FILE"), "", t("SELECT_FILE") & " (*.*)", 1)
	If NOT @error Then
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			filenameparse($file)
			If $history Then
				$dirlist = "|" & $initoutdir & "|" & readhist("directory")
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
		GUICtrlSetState($ok, $gui_focus)
	EndIf
EndFunc

Func gui_directory()
	If FileExists(GUICtrlRead($dircont)) Then
		$defdir = GUICtrlRead($dircont)
	ElseIf FileExists(GUICtrlRead($filecont)) Then
		$defdir = StringLeft(GUICtrlRead($filecont), StringInStr(GUICtrlRead($filecont), "\", 0, -1) - 1)
	Else
		$defdir = ""
	EndIf
	$outdir = FileSelectFolder(t("EXTRACT_TO"), "", 3, $defdir)
	If NOT @error Then
		If $history Then
			$dirlist = "|" & $outdir & "|" & readhist("directory")
			GUICtrlSetData($dircont, $dirlist, $outdir)
		Else
			GUICtrlSetData($dircont, $outdir)
		EndIf
	EndIf
EndFunc

Func gui_prefs_debug()
	If FileExists(envparse(GUICtrlRead(($debugcont)))) Then
		$defdir = envparse(GUICtrlRead($debugcont))
	ElseIf FileExists(envparse($debugdir)) Then
		$defdir = envparse($debugdir)
	Else
		$defdir = @TempDir
	EndIf
	If StringRight($defdir, 1) == ":" Then $defdir &= "\"
	$tempdir = FileSelectFolder(t("WRITE_TO"), "", 3, $defdir)
	If NOT @error Then GUICtrlSetData($debugcont, $tempdir)
EndFunc

Func gui_prefs_exit()
	GUIDelete($guiprefs)
	If $prefsonly Then
		terminate("silent", "", "")
	EndIf
EndFunc

Func gui_prefs_ok()
	$redrawgui = False
	If FileExists(envparse(GUICtrlRead($debugcont))) AND StringInStr(FileGetAttrib(envparse(GUICtrlRead($debugcont))), "D") Then
		$debugdir = GUICtrlRead($debugcont)
	Else
		MsgBox(48, $title, t("INVALID_DIR_SELECTED", createarray(GUICtrlRead($debugcont))))
		Return 
	EndIf
	If GUICtrlRead($historyopt) == $gui_checked Then
		If $history == 0 Then
			$history = 1
			$redrawgui = True
		EndIf
	Else
		If $history == 1 Then
			$history = 0
			If $globalprefs Then
				IniDelete($prefs, "File History")
				IniDelete($prefs, "Directory History")
			Else
				RegDelete($reg & "\File")
				RegDelete($reg & "\Directory")
			EndIf
			$redrawgui = True
		EndIf
	EndIf
	If $language <> GUICtrlRead($langselect) Then
		$language = GUICtrlRead($langselect)
		$redrawgui = True
	EndIf
	If GUICtrlRead($warnexecuteopt) == $gui_checked Then
		$warnexecute = 1
	Else
		$warnexecute = 0
	EndIf
	If GUICtrlRead($removedupeopt) == $gui_checked Then
		$removedupe = 1
	Else
		$removedupe = 0
	EndIf
	If GUICtrlRead($removetempopt) == $gui_checked Then
		$removetemp = 1
	Else
		$removetemp = 0
	EndIf
	If GUICtrlRead($appendextopt) == $gui_checked Then
		$appendext = 1
	Else
		$appendext = 0
	EndIf
	writeprefs()
	GUIDelete($guiprefs)
	If $prefsonly Then
		$finishprefs = True
	ElseIf $redrawgui Then
		GUIDelete($guimain)
		creategui()
	EndIf
EndFunc

Func gui_ok()
	$file = envparse(GUICtrlRead($filecont))
	If FileExists($file) Then
		If envparse(GUICtrlRead($dircont)) == "" Then
			$outdir = "/sub"
		Else
			$outdir = envparse(GUICtrlRead($dircont))
		EndIf
		GUIDelete($guimain)
		$finishgui = True
	Else
		If $file == "" Then
			$file = ""
		Else
			$file &= " " & t("DOES_NOT_EXIST")
		EndIf
		MsgBox(48, $title, t("INVALID_FILE_SELECTED", createarray($file)))
		Return 
	EndIf
EndFunc

Func gui_drop()
	If FileExists(@GUI_DragFile) Then
		$file = @GUI_DragFile
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			filenameparse($file)
			If $history Then
				$dirlist = "|" & $initoutdir & "|" & readhist("directory")
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
	EndIf
EndFunc

Func gui_prefs()
	If $prefsonly Then
		Global $guiprefs = GUICreate(t("PREFS_TITLE_LABEL"), 250, 240)
	Else
		Global $guiprefs = GUICreate(t("PREFS_TITLE_LABEL"), 250, 240, -1, -1, -1, -1, $guimain)
	EndIf
	GUICtrlCreateGroup(t("PREFS_UNIEXTRACT_OPTS_LABEL"), 5, 0, 240, 100)
	Global $historyopt = GUICtrlCreateCheckbox(t("PREFS_HISTORY_LABEL"), 10, 15, -1, 20)
	Local $langlabel = GUICtrlCreateLabel(t("PREFS_LANG_LABEL"), 10, 38, -1, 15)
	Local $langselectpos = getpos($guiprefs, $langlabel, -8)
	Global $langselect = GUICtrlCreateCombo("", $langselectpos, 35, 245 - $langselectpos - 4, 20 * charcount($langlist, "|"), $cbs_dropdownlist)
	Local $debuglabel = GUICtrlCreateLabel(t("PREFS_DEBUG_LABEL"), 10, 60, -1, 20)
	Global $debugcont = GUICtrlCreateInput($debugdir, 10, 75, 200, 20)
	Local $debugbut = GUICtrlCreateButton("...", 215, 75, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup(t("PREFS_FORMAT_OPTS_LABEL"), 5, 105, 240, 100)
	Global $warnexecuteopt = GUICtrlCreateCheckbox(t("PREFS_WARN_EXECUTE_LABEL"), 10, 120, -1, 20)
	Global $removedupeopt = GUICtrlCreateCheckbox(t("PREFS_REMOVE_DUPE_LABEL"), 10, 140, -1, 20)
	Global $removetempopt = GUICtrlCreateCheckbox(t("PREFS_REMOVE_TEMP_LABEL"), 10, 160, -1, 20)
	Global $appendextopt = GUICtrlCreateCheckbox(t("PREFS_APPEND_EXT_LABEL"), 10, 180, -1, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $prefsok = GUICtrlCreateButton(t("OK_BUT"), 55, 215, 60, 20)
	Local $prefscancel = GUICtrlCreateButton(t("CANCEL_BUT"), 135, 215, 60, 20)
	GUICtrlSetState($prefsok, $gui_defbutton)
	If $history Then GUICtrlSetState($historyopt, $gui_checked)
	If $warnexecute Then GUICtrlSetState($warnexecuteopt, $gui_checked)
	If $removedupe Then GUICtrlSetState($removedupeopt, $gui_checked)
	If $removetemp Then GUICtrlSetState($removetempopt, $gui_checked)
	If $appendext Then GUICtrlSetState($appendextopt, $gui_checked)
	If StringInStr($langlist, $language, 0) Then
		GUICtrlSetData($langselect, $langlist, $language)
	Else
		GUICtrlSetData($langselect, $langlist, "English")
	EndIf
	GUICtrlSetOnEvent($debugbut, "GUI_Prefs_Debug")
	GUICtrlSetOnEvent($prefsok, "GUI_Prefs_Ok")
	GUICtrlSetOnEvent($prefscancel, "GUI_Prefs_Exit")
	GUISetOnEvent($gui_event_close, "GUI_Prefs_Exit")
	GUISetState(@SW_SHOW)
EndFunc

Func gui_website()
	ShellExecute($website)
EndFunc

Func gui_exit()
	terminate("silent", "", "")
EndFunc
