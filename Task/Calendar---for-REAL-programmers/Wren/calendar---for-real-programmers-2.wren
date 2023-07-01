import "io" for File
import "/str" for Str
import "meta" for Meta

var keywords = ["import", "for", "var", "in", "if", "else"]
var modules  = ["/date", "/fmt", "/seq"]
var classes  = ["Date", "Fmt", "Lst", "Fn", "List", "System"]
var methods  = ["print", "filled", "chunks", "write", "new", "dayOfWeek", "monthLength", "call"]
var formats  = ["$70m", "\\n", "$20m", "$2d"]

var text = File.read("calendar_real_uc.txt")
for (keyword in keywords) text = text.replace(Str.upper(keyword) + " ", keyword + " ")
for (module  in modules)  text = text.replace(Str.upper(module), module)
for (clazz   in classes)  text = text.replace(Str.upper(clazz), clazz)
for (method  in methods)  text = text.replace("." + Str.upper(method), "." + method)
for (format  in formats)  text = text.replace(Str.upper(format), format)

Meta.compile(text).call()
