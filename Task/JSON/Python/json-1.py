>>> import json
>>> data = json.loads('{ "foo": 1, "bar": [10, "apples"] }')
>>> sample = { "blue": [1,2], "ocean": "water" }
>>> json_string = json.dumps(sample)
>>> json_string
'{"blue": [1, 2], "ocean": "water"}'
>>> sample
{'blue': [1, 2], 'ocean': 'water'}
>>> data
{'foo': 1, 'bar': [10, 'apples']}
