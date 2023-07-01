import
  iup, strutils, math

# assumes you have the iup  .dll or .so installed

randomize()
discard iup.open(nil,nil)


var lbl = Label("Value:")
setAttribute(lbl,"PADDING","2x2")

var valu = Text(nil)
SetAtt(nil, valu, "PADDING", "2x2", "VALUE", "0", nil)

var txtBox = Hbox(lbl, valu, nil)
SetAttribute(txtBox, "MARGIN", "10x10")

var incBtn = Button("+1", "")
var decBtn = Button("-1", "")
SetAttribute(incBtn,"RASTERSIZE","25x25")
SetAttribute(decBtn,"RASTERSIZE","25x25")
var btnBox = Vbox(incBtn, decBtn, nil)
SetAttribute(btnBox, "MARGIN", "5x5")


proc toCB(fp: proc): ICallback =
   return cast[ICallback](fp)

proc setValuState(value: int) =
    if value == 0:
        SetAttribute(valu, "ACTIVE", $(true))
    else:
        SetAttribute(valu, "ACTIVE", $(false))

proc setBtnsState(value: int) =
   if value <= 0:
      SetAttribute(decBtn,"ACTIVE", $(false))
      SetAtt(nil, incBtn,"ACTIVE", $(true), "FOCUS", $(true), nil)
   elif value >= 10:
      SetAttribute(incBtn,"ACTIVE", $(false))
      SetAtt(nil, decBtn,"ACTIVE", $(true), "FOCUS", $(true), nil)
   else:
      SetAttribute(decBtn,"ACTIVE", $(true))
      SetAttribute(incBtn,"ACTIVE", $(true))


# Click handler for Click button
proc incClick(ih:PIhandle): cint {.cdecl.} =
    var s: string = $(GetAttribute(valu,"VALUE"))
    var x: int = 0
    try:
       x = 1 + parseInt(s)
    except:
       x = 1         # default to 1 if non-numeric entry
    setAttribute(valu,"VALUE", $x)
    setValuState(x)
    setBtnsState(x)
    return IUP_DEFAULT

# Click handler for Decrement button
proc decClick(ih:PIhandle): cint {.cdecl.} =
    var s: string = $(GetAttribute(valu,"VALUE"))
    var x: int = 0
    try:
       x = -1 + parseInt(s)
    except:
       x = 1         # default to 1 if non-numeric entry
    setAttribute(valu,"VALUE", $x)
    setValuState(x)
    setBtnsState(x)
    return IUP_DEFAULT

# Key handler to check for Esc pressed
proc key_cb(ih:PIhandle, c: cint):cint {.cdecl.} =
  #echo c
  if (c == Iup.K_esc) and (Iup.Alarm("Exit?", "Had enough?","Yes","Keep going",nil) == 1):
    return IUP_CLOSE    # Exit application
  return IUP_CONTINUE

var contents = Hbox(txtBox, btnBox, nil)
SetAttribute(contents, "MARGIN", "5x5")

discard setCallback(incBtn,"ACTION", toCB(incClick))
discard setCallback(decBtn,"ACTION", toCB(decClick))
discard setCallback(contents,"K_ANY", toCB(key_cb))

var dlg = Dialog(contents)
SetAtt(nil, dlg, "TITLE","GUI Interaction", "SIZE","200x75", nil)

discard dlg.show()
discard mainloop()
iup.close()
