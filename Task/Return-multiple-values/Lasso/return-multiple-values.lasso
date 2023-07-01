define multi_value() => {
	return (:'hello word',date)
}
// shows that single method call will return multiple values
// the two values returned are assigned in order to the vars x and y
local(x,y) = multi_value

'x: '+#x
'\ry: '+#y
