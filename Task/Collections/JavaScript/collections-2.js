var obj = {};
obj['foo'] = 'xyz'; //equivalent to: obj.foo = 'xyz';
obj['bar'] = new MyClass; //equivalent to: obj.bar = new MyClass;
obj['1x; ~~:-b'] = 'text'; //no equivalent
console.log(obj['1x; ~~:-b']);
