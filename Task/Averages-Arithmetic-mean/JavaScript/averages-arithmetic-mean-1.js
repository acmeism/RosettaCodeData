function mean(array)
{
 var sum = 0, i;
 for (i = 0; i < array.length; i++)
 {
  sum += array[i];
 }
  return array.length ? sum / array.length : 0;
}

alert( mean( [1,2,3,4,5] ) );   // 3
alert( mean( [] ) );            // 0
