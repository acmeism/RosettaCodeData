String x = 'testing123';
//Test1: testing123
System.debug('Test1: ' + x.substring(0,x.length()));
//Test2: esting123
System.debug('Test2: ' + x.substring(1,x.length()));
//Test3: testing123
System.debug('Test3: ' + x.substring(0));
//Test4: 3
System.debug('Test4: ' + x.substring(x.length()-1));
//Test5:
System.debug('Test5: ' + x.substring(1,1));
//Test 6: testing123
System.debug('Test6: ' + x.substring(x.indexOf('testing')));
//Test7: e
System.debug('Test7: ' + x.substring(1,2));
