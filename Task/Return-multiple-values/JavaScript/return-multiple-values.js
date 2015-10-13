//returns array with three values
var arrBind = function () {
  return [1, 2, 3]; //return array of three items to assign
};

//returns object with three named values
var objBind = function () {
  return {foo: "abc", bar: "123", baz: "zzz"};
};

//keep all three values
var [a, b, c] = arrBind();//assigns a => 1, b => 2, c => 3
//skip a value
var [a, , c] = arrBind();//assigns a => 1, c => 3
//keep final values together as array
var [a, ...rest] = arrBind();//assigns a => 1, rest => [2, 3]


//same return name
var {foo, bar, baz} = objBind();//assigns foo => "abc", bar => "123", baz => "zzz"
//different return name (ignoring baz)
var {baz: foo, buz: bar} = objBind();//assigns baz => "abc", buz => "123"
//keep rest of values together as object
var {foo, ...rest} = objBind();//assigns foo => "abc, rest => {bar: "123", baz: "zzz"}
