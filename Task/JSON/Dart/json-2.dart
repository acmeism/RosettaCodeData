import 'dart:convert';

main(){
	var data = jsonDecode('{ "foo": 1, "bar": [10, "apples"] }');

	var sample = { "blue": [1,2], "ocean": "water" };

	var json_string = jsonEncode(sample);
}
