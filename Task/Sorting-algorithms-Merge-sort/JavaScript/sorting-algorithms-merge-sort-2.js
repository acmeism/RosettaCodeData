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

// here is improved faster version, also often faster than QuickSort!

function mergeSort2(a) {
  if (a.length <= 1) return
  const mid = Math.floor(a.length / 2), left = a.slice(0, mid), right = a.slice(mid)
  mergeSort2(left)
  mergeSort2(right)
  let ia = 0, il = 0, ir = 0
  while (il < left.length && ir < right.length)
    a[ia++] = left[il] < right[ir] ? left[il++] : right[ir++]
  while (il < left.length)
    a[ia++] = left[il++]
  while (ir < right.length)
    a[ia++] = right[ir++]
}
