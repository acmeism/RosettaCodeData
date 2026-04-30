Local $CarryOut, $sResult
$sResult = _4BitAdder(0, 0, 1, 1, 0, 1, 1, 1, 0, $CarryOut)  ; adds 3 + 7
ConsoleWrite('result: ' & $sResult & '  ==> carry out: ' & $CarryOut & @LF)

$sResult = _4BitAdder(1, 0, 1, 1, 1, 0, 0, 0, 0, $CarryOut)  ; adds 11 + 8
ConsoleWrite('result: ' & $sResult & '  ==> carry out: ' & $CarryOut & @LF)
