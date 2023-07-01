Window+ w  \ create a window
View v     \ create a view
300 30 430 230 put: frameRect  \ size a rectangle for the view
frameRect " Test" docWindow v new: w  \ activate the view and window
show: w  \ display the window
