Map<String, String> strMap = new Map<String, String>{
  'a' => 'aval',
  'b' => 'bval'
};

System.assert( strMap.containsKey('a') );
System.assertEquals( 'bval', strMap.get('b') );
