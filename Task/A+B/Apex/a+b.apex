static Integer sumOfTwoNums(Integer A, Integer B) {
    return A + B;
}

System.debug('A = 50 and B = 25: ' + sumOfTwoNums(50, 25));
System.debug('A = -50 and B = 25: ' +sumOfTwoNums(-50, 25));
System.debug('A = -50 and B = -25: ' +sumOfTwoNums(-50, -25));
System.debug('A = 50 and B = -25: ' +sumOfTwoNums(50, -25));

'''Output'''
A = 50 and B = 25: 75
A = -50 and B = 25: -25
A = -50 and B = -25: -75
A = 50 and B = -25: 25
