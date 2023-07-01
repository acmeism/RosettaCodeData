var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
var evens = [i for (i in numbers) if (i % 2 == 0)];

function range(limit) {
  for(var i = 0; i < limit; i++) {
    yield i;
  }
}

var evens2 = [i for (i in range(100)) if (i % 2 == 0)];
