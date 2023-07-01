import 'dart:convert' show jsonDecode, jsonEncode;

main(){
	var json_string = '''
	{
		"rosetta_code": {
			"task": "json",
			"language": "dart",
			"descriptions": [ "fun!", "easy to learn!", "awesome!" ]
		}
	}
	''';
	
	// decode string into Map<String, dynamic>
	var json_object = jsonDecode(json_string);
	
	for ( var description in json_object["rosetta_code"]["descriptions"] )
		print( "dart is $description" );

	var dart = {
		"compiled": true,
		"interpreted": true,
		"creator(s)":[ "Lars Bak", "Kasper Lund"],
		"development company": "Google"
	};

	var as_json_text = jsonEncode(dart);

	assert(as_json_text == '{"compiled":true,"interpreted":true,"creator(s)":["Lars Bak","Kasper Lund"],"development company":"Google"}');
}
