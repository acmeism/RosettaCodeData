ScreenLock()
Open "c:\Users\Default\Documents\myDaemon.log" For Append As #1
'Open "myDaemon.log" For Append As #1 'Ruta de archivo relativa para la salida // Relative file path for the output

For i As Byte = 1 To 5               'Entonces esto no se ejecuta ad infinitum // So this is not executed ad infinitum
    Print #1, Time + " - Running"    'Imprime en el archivo previamente abierto la hora actual del sistema (hh:mm:ss) y una nota
                                     'Prints in the previously opened file the current system time (hh: mm: ss) and a note
    Sleep 1000                       'Espera 1 segundo // Wait 1 second
Next i
Close #1                             'Cierra el archivo previamente abierto para escritura // Close the file previously open for writing
ScreenUnlock()
End
