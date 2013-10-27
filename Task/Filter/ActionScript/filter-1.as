var arr:Array = new Array(1, 2, 3, 4, 5);
var evens:Array = new Array();
for (var i:int = 0; i < arr.length(); i++) {
    if (arr[i] % 2 == 0)
        evens.push(arr[i]);
}
