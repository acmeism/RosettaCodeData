import
  iup

# assumes you have the iup  .dll or .so installed

discard iup.open(nil,nil)

var scrnFullSize = GetGlobal("FULLSIZE")
var scrnSize = GetGlobal("SCREENSIZE")
var scrnMInfo = GetGlobal("MONITORSINFO")
var scrnVScreen = GetGlobal("VIRTUALSCREEN")

var dlg = Dialog(nil)
SetAttribute(dlg, "SIZE", "FULL")
var scrnXSize = GetAttribute(dlg,"MAXSIZE")

echo scrnFullSize, "\n", scrnSize, "\n", scrnMInfo, "\n", scrnVScreen, "\n", scrnXSize

discard iup.Alarm("Screen client size", scrnFullSize ,"Ok",nil, nil)

#discard iup.mainloop()
iup.close()
