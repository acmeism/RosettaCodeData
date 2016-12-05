function merge(left, right, arr) {
  var a = 0;

  while (left.length && right.length) {
    arr[a++] = (right[0] < left[0]) ? right.shift() : left.shift();
  }
  while (left.length) {
    arr[a++] = left.shift();
  }
  while (right.length) {
    arr[a++] = right.shift();
  }
}

function mergeSort(arr) {
  var len = arr.length;

  if (len === 1) { return; }

  var mid = Math.floor(len / 2),
      left = arr.slice(0, mid),
      right = arr.slice(mid);

  mergeSort(left);
  mergeSort(right);
  merge(left, right, arr);
}

var arr = [1, 5, 2, 7, 3, 9, 4, 6, 8];
mergeSort(arr); // arr will now: 1, 2, 3, 4, 5, 6, 7, 8, 9
