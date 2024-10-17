let jortSortArray ary =
  let originalArray = Array.copy ary in
  Array.sort compare ary;
  originalArray = ary
