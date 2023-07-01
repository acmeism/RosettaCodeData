dim flat
set flat = new flattener
flat.itemSeparator = "~"
wscript.echo join( flat.flatten( array( array( 1 ),2,array(array(3,4),5),array(array(array())),array(array(array(6))),7,8,array())), "!")
