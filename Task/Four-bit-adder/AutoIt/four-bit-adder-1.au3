Func _NOT($_A)
	Return (Not $_A) *1
EndFunc  ;==>_NOT

Func _AND($_A, $_B)
	Return BitAND($_A, $_B)
EndFunc  ;==>_AND

Func _OR($_A, $_B)
	Return BitOR($_A, $_B)
EndFunc  ;==>_OR

Func _XOR($_A, $_B)
	Return _OR( _
		_AND( $_A, _NOT($_B) ), _
		_AND( _NOT($_A), $_B) )
EndFunc  ;==>_XOR

Func _HalfAdder($_A, $_B, ByRef $_CO)
	$_CO = _AND($_A, $_B)
	Return _XOR($_A, $_B)
EndFunc  ;==>_HalfAdder

Func _FullAdder($_A, $_B, $_CI, ByRef $_CO)
	Local $CO1, $CO2, $Q1, $Q2
	$Q1 = _HalfAdder($_A, $_B, $CO1)
	$Q2 = _HalfAdder($Q1, $_CI, $CO2)
	$_CO = _OR($CO2, $CO1)
	Return $Q2
EndFunc  ;==>_FullAdder

Func _4BitAdder($_A1, $_A2, $_A3, $_A4, $_B1, $_B2, $_B3, $_B4, $_CI, ByRef $_CO)
	Local $CO1, $CO2, $CO3, $CO4, $Q1, $Q2, $Q3, $Q4
	$Q1 = _FullAdder($_A4, $_B4, $_CI, $CO1)
	$Q2 = _FullAdder($_A3, $_B3, $CO1, $CO2)
	$Q3 = _FullAdder($_A2, $_B2, $CO2, $CO3)
	$Q4 = _FullAdder($_A1, $_B1, $CO3, $CO4)
	$_CO = $CO4
	Return $Q4 & $Q3 & $Q2 & $Q1
EndFunc  ;==>_4BitAdder
