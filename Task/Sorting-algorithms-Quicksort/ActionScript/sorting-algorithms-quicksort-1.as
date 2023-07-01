function quickSort (array:Array):Array
{
    if (array.length <= 1)
        return array;

    var pivot:Number = array[Math.round(array.length / 2)];

    return quickSort(array.filter(function (x:Number, index:int, array:Array):Boolean { return x <  pivot; })).concat(
            array.filter(function (x:Number, index:int, array:Array):Boolean { return x == pivot; })).concat(
        quickSort(array.filter(function (x:Number, index:int, array:Array):Boolean { return x > pivot; })));
}
