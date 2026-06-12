i = 1
ii=0.23
s = "Hello world"
a = split("Hello World"," ")
b=Array(i,ii,s,a)
Set c=CreateObject("Scripting.dictionary")
Class d
 Private a,b
End Class
Set e=New d


WScript.Echo TypeName(b)
WScript.Echo TypeName(b(0))
WScript.Echo TypeName(b(1))
WScript.Echo TypeName(b(2))
WScript.Echo TypeName(b(3))
WScript.Echo TypeName(b(3)(0))
WScript.Echo TypeName(c)
WScript.Echo TypeName(e)
