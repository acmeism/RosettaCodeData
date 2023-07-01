// Cannot / Do not need to instantiate the algorithm implementation (e.g, HashMap).
Map<String, String> strMap = new Map<String, String>();
strMap.put('a', 'aval');
strMap.put('b', 'bval');

System.assert( strMap.containsKey('a') );
System.assertEquals( 'bval', strMap.get('b') );
// String keys are case-sensitive
System.assert( !strMap.containsKey('A') );
