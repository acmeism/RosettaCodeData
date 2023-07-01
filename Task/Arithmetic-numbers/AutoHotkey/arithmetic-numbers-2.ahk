MsgBox % Result := "The first 100 arithmetic numbers:`n"
. ArithmeticNumbers(0, 100).1
. "`nThe  1000th arithmetic number: "
. ArithmeticNumbers(1000).1
. "`tcomposites = "
. ArithmeticNumbers(1000).2
. "`nThe 10000th arithmetic number: "
. ArithmeticNumbers(10000).1
. "`tcomposites = "
. ArithmeticNumbers(10000).2
