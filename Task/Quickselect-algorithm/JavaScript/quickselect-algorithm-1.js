// this just helps make partition read better
function swap(items, firstIndex, secondIndex) {
  var temp = items[firstIndex];
  items[firstIndex] = items[secondIndex];
  items[secondIndex] = temp;
};

// many algorithms on this page violate
// the constraint that partition operates in place
function partition(array, from, to) {
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
  var pivotIndex = getRandomInt(from, to),
      pivot = array[pivotIndex];
  swap(array, pivotIndex, to);
  pivotIndex = from;

  for(var i = from; i <= to; i++) {
    if(array[i] < pivot) {
      swap(array, pivotIndex, i);
      pivotIndex++;
    }
  };
  swap(array, pivotIndex, to);

  return pivotIndex;
};

// later versions of JS have TCO so this is safe
function quickselectRecursive(array, from, to, statistic) {
  if(array.length === 0 || statistic > array.length - 1) {
    return undefined;
  };

  var pivotIndex = partition(array, from, to);
  if(pivotIndex === statistic) {
    return array[pivotIndex];
  } else if(pivotIndex < statistic) {
    return quickselectRecursive(array, pivotIndex, to, statistic);
  } else if(pivotIndex > statistic) {
    return quickselectRecursive(array, from, pivotIndex, statistic);
  }
};

function quickselectIterative(array, k) {
  if(array.length === 0 || k > array.length - 1) {
    return undefined;
  };

  var from = 0, to = array.length,
      pivotIndex = partition(array, from, to);

  while(pivotIndex !== k) {
    pivotIndex = partition(array, from, to);
    if(pivotIndex < k) {
      from = pivotIndex;
    } else if(pivotIndex > k) {
      to = pivotIndex;
    }
  };

  return array[pivotIndex];
};

KthElement = {
  find: function(array, element) {
    var k = element - 1;
    return quickselectRecursive(array, 0, array.length, k);
    // you can also try out the Iterative version
    // return quickselectIterative(array, k);
  }
}
