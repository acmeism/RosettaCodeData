var set = new Set();

set.add(0);
set.add(1);
set.add('two');
set.add('three');

set.has(0); //=> true
set.has(3); //=> false
set.has('two'); // true
set.has(Math.sqrt(4)); //=> false
set.has('TWO'.toLowerCase()); //=> true

set.size; //=> 4

set.delete('two');
set.has('two'); //==> false
set.size; //=> 3

//iterating set using ES6 for..of
//Set order is preserved in order items are added.
for (var item of set) {
  console.log('item is ' + item);
}
