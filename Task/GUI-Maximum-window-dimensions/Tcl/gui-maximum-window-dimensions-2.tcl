TYPE syswindowstru
  screenheight AS INTEGER
  screenwidth AS INTEGER
  maxheight AS INTEGER
  maxwidth AS INTEGER
END TYPE

DIM syswindow AS syswindowstru

' Determine the height and width of the screen

syswindow.screenwidth = Screen.Width / Screen.TwipsPerPixelX
syswindow.screenheight=Screen.Height / Screen.TwipsPerPixelY

' Make adjustments for window decorations and menubars
