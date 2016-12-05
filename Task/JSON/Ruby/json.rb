require 'json'

ruby_obj = JSON.parse('{"blue": [1, 2], "ocean": "water"}')
puts ruby_obj

ruby_obj["ocean"] = { "water" => ["fishy", "salty"] }
puts JSON.generate(ruby_obj)
puts JSON.pretty_generate(ruby_obj)
