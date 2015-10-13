WScript.StdOut.Write "Enter the temperature in Kelvin:"
tmp = WScript.StdIn.ReadLine

WScript.StdOut.WriteLine "Kelvin: " & tmp
WScript.StdOut.WriteLine "Fahrenheit: " & fahrenheit(CInt(tmp))
WScript.StdOut.WriteLine "Celsius: " & celsius(CInt(tmp))
WScript.StdOut.WriteLine "Rankine: " & rankine(CInt(tmp))

Function fahrenheit(k)
	fahrenheit = (k*1.8)-459.67
End Function

Function celsius(k)
	celsius = k-273.15
End Function

Function rankine(k)
	rankine = (k-273.15)*1.8+491.67
End Function
