var map = new Map(),
    fn = function () {},
    obj = {};

map.set(fn, 123);
map.set(obj, 'abc');
map.set('key', 'val');
map.set(3, x => x + x);

map.get(fn); //=> 123
map.get(function () {}); //=> undefined because not the same function
map.get(obj); //=> 'abc'
map.get({}); //=> undefined because not the same object
map.get('key'); //=> 'val'
map.get(3); //=> (x => x + x)

map.size; //=> 4

//iterating using ES6 for..of syntax
for (var key of map.keys()) {
  console.log(key + ' => ' + map.get(key));
}
