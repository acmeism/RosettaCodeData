function equilibrium (array) {
  var equilibriums = [];

  array.forEach(function(_, idx, arr) {
    var left = 0, right = 0;

    for (var i = 0; i < arr.length; i++) {
      if (i < idx) {
        left += array[i];
      } else if (i > idx) {
        right += array[i];
      }
    }

    if (left === right) equilibriums.push(idx);
  });

  return equilibriums;
}

console.log(equilibrium([-7,1,5,2,-4,3,0]));
