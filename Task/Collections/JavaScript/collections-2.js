var map = {};
map['foo'] = 'xyz'; //equivalent to: map.foo = 'xyz';
map['bar'] = new MyClass; //equivalent to: map.bar = new MyClass;
map['1x; ~~:-b'] = 'text'; //no equivalent
alert( map['1x; ~~:-b'] );
