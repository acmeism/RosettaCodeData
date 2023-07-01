var array = [1, 2, 3, 4, 5],
    sum = 0,
    prod = 1,
    i;
for (i = 0; i < array.length; i += 1) {
    sum += array[i];
    prod *= array[i];
}
alert(sum + ' ' + prod);
