Dim matriz(0 To 3, 0 To 4) As Integer = {{78,19,30,12,36},_
{49,10,65,42,50},_
{30,93,24,78,10},_
{39,68,27,64,29}}
Dim As Integer mtranspuesta(Lbound(matriz, 2) To Ubound(matriz, 2), Lbound(matriz, 1) To Ubound(matriz, 1))
Dim As Integer fila, columna

For fila = Lbound(matriz,1) To Ubound(matriz,1)
    For columna = Lbound(matriz,2) To Ubound(matriz,2)
        mtranspuesta(columna, fila) = matriz(fila, columna)
        Print ; matriz(fila,columna); " ";
    Next columna
    Print
Next fila
Print

For fila = Lbound(mtranspuesta,1) To Ubound(mtranspuesta,1)
    For columna = Lbound(mtranspuesta,2) To Ubound(mtranspuesta,2)
        Print ; mtranspuesta(fila,columna); " ";
    Next columna
    Print
Next fila
Sleep
