import iup

# assumes you have the iup  .dll or .so installed

proc toCB(fp: proc): ICallback =
   return cast[ICallback](fp)

discard iup.open(nil,nil)

var btnRestore = button("restore","")
var btnFull = button("Full screen","")
var btnMin = button("minimize","")
var btnMax = button("maximize","")
var btnHide = button("Transparent","")
#var btnHide = button("Hide (close)","")
var btnShow = button("Show","")

var hbox = Hbox(btnRestore, btnFull, btnMax, btnMin, btnShow, btnHide, nil)
setAttribute(hbox,"MARGIN", "10x10")
setAttribute(hbox,"PADDING", "5x5")

var dlg = Dialog(hbox)
#SetAttribute(dlg, "SIZE", "100x50")

proc doFull(ih:PIhandle): cint {.cdecl.} =
    setAttribute(dlg,"FULLSCREEN","YES")
    return IUP_DEFAULT

proc doMax(ih:PIhandle): cint {.cdecl.} =
    #setAttribute(dlg,"FULLSCREEN","YES")
    setAttribute(dlg,"PLACEMENT","MAXIMIZED")
    # this is a work-around to get the dialog minimised (on win platform)
    setAttribute(dlg,"VISIBLE","YES")
    return IUP_DEFAULT

proc doMin(ih:PIhandle): cint {.cdecl.} =
    setAttribute(dlg,"PLACEMENT","MINIMIZED")
    # this is a work-around to get the dialog minimised (on win platform)
    setAttribute(dlg,"VISIBLE","YES")
    return IUP_DEFAULT

proc doRestore(ih:PIhandle): cint {.cdecl.} =
    setAttribute(dlg,"OPACITY","255")
    setAttribute(dlg,"FULLSCREEN","NO")
    setAttribute(dlg,"PLACEMENT","NORMAL")
    setAttribute(dlg,"VISIBLE","YES")
    return IUP_DEFAULT

proc doHide(ih:PIhandle): cint {.cdecl.} =
    #setAttribute(dlg,"VISIBLE","NO")
    setAttribute(dlg,"OPACITY","60")
    return IUP_DEFAULT

proc doShow(ih:PIhandle): cint {.cdecl.} =
    setAttribute(dlg,"OPACITY","255")
    setAttribute(dlg,"VISIBLE","YES")
    return IUP_DEFAULT

discard setCallback(btnRestore,"ACTION", toCB(doRestore))
discard setCallback(btnFull,"ACTION", toCB(doFull))
discard setCallback(btnMax,"ACTION", toCB(doMax))
discard setCallback(btnMin,"ACTION", toCB(doMin))
discard setCallback(btnShow,"ACTION", toCB(doShow))
discard setCallback(btnHide,"ACTION", toCB(doHide))

discard dlg.show()
discard mainloop()
iup.Close()
