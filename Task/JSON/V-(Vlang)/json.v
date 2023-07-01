import json

struct User {
	// Adding a [required] attribute will make decoding fail, if that
	// field is not present in the input.
	// If a field is not [required], but is missing, it will be assumed
	// to have its default value, like 0 for numbers, or '' for strings,
	// and decoding will not fail.
	name string [required]
	age  int
	// Use the `skip` attribute to skip certain fields
	foo int [skip]
	// If the field name is different in JSON, it can be specified
	last_name string [json: lastName]
	possessions []string
}

fn main() {
	data := '{ "name": "Frodo", "lastName": "Baggins", "age": 25, "possessions": ["shirt","ring","sting"] }'
	user := json.decode(User, data) or {
		eprintln('Failed to decode json, error: $err')
		return
	}
	println(user)

	println(json.encode(user))
}
