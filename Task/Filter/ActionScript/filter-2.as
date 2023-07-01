var arr:Array = new Array(1, 2, 3, 4, 5);
arr = arr.filter(function(item:int, index:int, array:Array) {
  return item % 2 == 0;
});
