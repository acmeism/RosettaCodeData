// Sample classes for reflection
function Super(name) {
    this.name = name;
    this.superOwn = function() { return 'super owned'; };
}
Super.prototype = {
    constructor: Super
    className: 'super',
    toString: function() { return "Super(" + this.name + ")"; },
    doSup: function() { return 'did super stuff'; }
}

function Sub() {
    Object.getPrototypeOf(this).constructor.apply(this, arguments);
    this.rest = [].slice.call(arguments, 1);
    this.subOwn = function() { return 'sub owned'; };
}
Sub.prototype = Object.assign(
    new Super('prototype'),
    {
        constructor: Sub
        className: 'sub',
        toString: function() { return "Sub(" + this.name + ")"; },
        doSub: function() { return 'did sub stuff'; }
    });

Object.defineProperty(Sub.prototype, 'shush', {
    value: function() { return ' non-enumerable'; },
    enumerable: false // the default
});

var sup = new Super('sup'),
    sub = new Sub('sub', 0, 'I', 'two');

Object.defineProperty(sub, 'quiet', {
    value: function() { return 'sub owned non-enumerable'; },
    enumerable: false
});

// get enumerable methods on an object and its ancestors
function get_method_names(obj) {
    var methods = [];
    for (var p in obj) {
        if (typeof obj[p] == 'function') {
            methods.push(p);
        }
    }
    return methods;
}

get_method_names(sub);
//["subOwn", "superOwn", "toString", "doSub", "doSup"]

// get enumerable properties on an object and its ancestors
function get_property_names(obj) {
    var properties = [];
    for (var p in obj) {
        properties.push(p);
    }
    return properties;
}

// alternate way to get enumerable method names on an object and its ancestors
function get_method_names(obj) {
    return get_property_names(obj)
        .filter(function(p) {return typeof obj[p] == 'function';});
}

get_method_names(sub);
//["subOwn", "superOwn", "toString", "doSub", "doSup"]

// get enumerable & non-enumerable method names set directly on an object
Object.getOwnPropertyNames(sub)
    .filter(function(p) {return typeof sub[p] == 'function';})
//["subOwn", "shhh"]

// get enumerable method names set directly on an object
Object.keys(sub)
    .filter(function(p) {return typeof sub[p] == 'function';})
//["subOwn"]

// get enumerable method names & values set directly on an object
Object.entries(sub)
    .filter(function(p) {return typeof p[1] == 'function';})
//[["subOwn", function () {...}]]
