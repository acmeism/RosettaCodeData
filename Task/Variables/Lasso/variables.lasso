// declare thread variable, default type null
var(x)
$x->type // null

// declare local variable, default type null
local(x)
#x->type // null

// declare thread variable, initialize with a type, in this case integer
var(x = integer)

// declare local variable, initialize with a type, in this case integer
local(x = integer)

// assign a value to the thread var x
$x = 12

// assign a value to the local var x
$x = 177

// a var always has a data type, even if not declared - then it's null
// a var can either be assigned a type using the name of the type, or a value that is by itself the type
local(y = string)
local(y = 'hello')

'\r'
// demonstrating asCopyDeep and relationship between variables:
local(original) = array('radish', 'carrot', 'cucumber', 'olive')
local(originalaswell) = #original
local(copy)     = #original->asCopyDeep
iterate(#original) => {
    loop_value->uppercase
}
#original		// modified
//array(RADISH, CARROT, CUCUMBER, OLIVE)
'\r'
#originalaswell // modified as well as it was not a deep copy
//array(RADISH, CARROT, CUCUMBER, OLIVE)
'\r'
#copy			// unmodified as it used ascopydeep
//array(RADISH, CARROT, CUCUMBER, OLIVE)
