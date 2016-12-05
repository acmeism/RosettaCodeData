//code, fragment name, autocollect, inplaintext
local(mycode = "'Hello world, it is '+date")
sourcefile('['+#mycode+']','arbritraty_name', true, true)->invoke

'\r'


var(x = 100)
local(mycode = "Outside Lasso\r['Hello world, var x is '+var(x)]")
// autocollect (3rd param): return any output generated
// inplaintext (4th param): if true, assumes this is mixed Lasso and plain text,
//		requires Lasso code to be in square brackets or other supported code block demarkation.
sourcefile(#mycode,'arbritraty_name', true, true)->invoke

'\r'

var(y = 2)
local(mycode = "'Hello world, is there output?\r'
var(x) *= var(y)")
// autocollect (3rd param): as false, no output returned
// inplaintext (4th param): as false, assumes this is Lasso code, no mixed-mode Lasso and text.
sourcefile(#mycode,'arbritraty_name', false, false)->invoke
'var x is now: '+$x

'\r'

var(z = 3)
local(mycode = "var(x) *= var(z)")
sourcefile(#mycode,'arbritraty_name', false, false)->invoke
'var x is now: '+$x
