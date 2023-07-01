var obj = Object.create({
    name: 'proto',
    proto: true,
    doNothing: function() {}
  }, {
    name: {value: 'obj', writable: true, configurable: true, enumerable: true},
    obj: {value: true, writable: true, configurable: true, enumerable: true},
    'non-enum': {value: 'non-enumerable', writable: true, enumerable: false},
    doStuff: {value: function() {}, enumerable: true}
});

// get enumerable properties on an object and its ancestors
function get_property_names(obj) {
    var properties = [];
    for (var p in obj) {
        properties.push(p);
    }
    return properties;
}

get_property_names(obj);
//["name", "obj", "doStuff", "proto", "doNothing"]

Object.getOwnPropertyNames(obj);
//["name", "obj", "non-enum", "doStuff"]

Object.keys(obj);
//["name", "obj", "doStuff"]

Object.entries(obj);
//[["name", "obj"], ["obj", true], ["doStuff", function()]]
