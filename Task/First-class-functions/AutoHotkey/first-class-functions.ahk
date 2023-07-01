#NoEnv
; Set the floating-point precision
SetFormat, Float, 0.15
; Super-global variables for function objects
Global F, G
; User-defined functions
Cube(X) {
   Return X ** 3
}
CubeRoot(X) {
   Return X ** (1/3)
}
; Function arrays, Sin/ASin and Cos/ACos are built-in
FuncArray1 := [Func("Sin"),  Func("Cos"),  Func("Cube")]
FuncArray2 := [Func("ASin"), Func("ACos"), Func("CubeRoot")]
; Compose
Compose(FN1, FN2) {
   Static FG := Func("ComposedFunction")
   F := FN1, G:= FN2
   Return FG
}
ComposedFunction(X) {
   Return F.(G.(X))
}
; Run
X := 0.5 + 0
Result := "Input:`n" . X . "`n`nOutput:"
For Index In FuncArray1
   Result .= "`n" . Compose(FuncArray1[Index], FuncArray2[Index]).(X)
MsgBox, 0, First-Class Functions, % Result
ExitApp
