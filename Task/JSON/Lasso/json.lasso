// Javascript objects are represented by maps in Lasso
local(mymap = map(
	'success'	= true,
	'numeric'	= 11,
	'string'	= 'Eleven'
))

json_serialize(#mymap) // {"numeric": 11,"string": "Eleven","success": true}
'<br />'

// Javascript arrays are represented by arrays
local(opendays = array(
	'Monday',
	'Tuesday'
))

local(closeddays = array(
	'Wednesday',
	'Thursday',
	'Friday'
))

json_serialize(#opendays) // ["Monday", "Tuesday"]
'<br />'
json_serialize(#closeddays) // ["Wednesday", "Thursday", "Friday"]
'<br />'

#mymap -> insert('Open' = #opendays)
#mymap -> insert('Closed' = #closeddays)

local(myjson = json_serialize(#mymap))
#myjson // {"Closed": ["Wednesday", "Thursday", "Friday"],"numeric": 11,"Open": ["Monday", "Tuesday"],"string": "Eleven","success": true}
'<br />'

json_deserialize(#myjson) // map(Closed = array(Wednesday, Thursday, Friday), numeric = 11, Open = array(Monday, Tuesday), string = Eleven, success = true)
