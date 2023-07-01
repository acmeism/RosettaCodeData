import
  iup, strutils, math

# assumes you have the iup  .dll or .so installed

randomize()
discard iup.open(nil,nil)


var lbl = Label("Value:")
setAttribute(lbl,"PADDING","2x2")

var valu = Text(nil)
SetAttribute(valu, "PADDING", "2x2")
SetAttribute(valu, "VALUE", "0")

proc toCB(fp: proc): ICallback =
   return cast[ICallback](fp)

# Click handler for Click button
proc incClick(ih:PIhandle): cint {.cdecl.} =
    var s: string = $(GetAttribute(valu,"VALUE"))
    var x: int = 0
    try:
       x = 1 + parseInt(s)
    except:
       x = 1         # default to 1 if non-numeric entry
    setAttribute(valu,"VALUE", $x)
    return IUP_DEFAULT

# Click handler for Random button
proc randClick(ih:PIhandle): cint {.cdecl.} =
    if Iup.Alarm("Random Value?", "Set value to a random numer < 100 ?","Yes","No",nil) == 1:
        setAttribute(valu,"VALUE", $random(100))
    return IUP_DEFAULT

# Key handler to check for Esc pressed
proc key_cb(ih:PIhandle, c: cint):cint {.cdecl.} =
  #echo c
  if (c == Iup.K_esc) and (Iup.Alarm("Exit?", "Had enough?","Yes","Keep going",nil) == 1):
    return IUP_CLOSE    # Exit application
  return IUP_CONTINUE


var txtBox = Hbox(lbl, valu, nil)
SetAttribute(txtBox, "MARGIN", "10x10")

var incBtn = Button("&Increment", "")
var randBtn = Button("&Randomize", "")
var btnBox = Vbox(incBtn, randBtn, nil)
SetAttribute(btnBox, "MARGIN", "5x5")

var contents = Hbox(txtBox, btnBox, nil)
SetAttribute(contents, "MARGIN", "2x2")

discard setCallback(incBtn,"ACTION", toCB(incClick))
discard setCallback(randBtn,"ACTION", toCB(randClick))
discard setCallback(contents,"K_ANY", toCB(key_cb))

var dlg = Dialog(contents)
discard dlg.show()
discard mainloop()
iup.close()
