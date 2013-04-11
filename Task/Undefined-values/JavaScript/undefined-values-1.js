var a;

typeof(a) === "undefined";
typeof(b) === "undefined";

var obj = {}; // Empty object.
typeof(obj.c) === "undefined";

obj.c = 42;

obj.c === 42;
delete obj.c;
typeof(obj.c) === "undefined";
