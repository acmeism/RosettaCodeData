(function() {
  var i;

  for (i = 1; i <= 100; i++) {
    console.log([i % 3 === 0 ? 'Fizz' : void 0] + [i % 5 === 0 ? 'Buzz' : void 0] || i);
  }

}).call(this);
