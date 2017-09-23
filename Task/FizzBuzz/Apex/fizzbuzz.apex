for(integer i=1; i <= 100; i++){
    String output = '';
    if(math.mod(i, 3) == 0) output += 'Fizz';
    if(math.mod(i, 5) == 0) output += 'Buzz';
    if(output != ''){
        System.debug(output);
    } else {
        System.debug(i);
    }
}
