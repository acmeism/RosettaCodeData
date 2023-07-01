function quickSort (array:Array):Array
{
    if (array.length <= 1)
        return array;

    var pivot:Number = array[Math.round(array.length / 2)];

    var less:Array = [];
    var equal:Array = [];
    var greater:Array = [];

    for each (var x:Number in array) {
        if (x < pivot)
            less.push(x);
        if (x == pivot)
            equal.push(x);
        if (x > pivot)
            greater.push(x);
    }

    return quickSort(less).concat(
            equal).concat(
            quickSort(greater));
}
