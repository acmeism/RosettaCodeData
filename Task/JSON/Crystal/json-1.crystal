require "json_mapping"

class Foo
  JSON.mapping(
    num: Int64,
    array: Array(String),
  )
end

def json
  foo = Foo.from_json(%({"num": 1, "array": ["a", "b"]}))
  puts("#{foo.num} #{foo.array}")
  puts(foo.to_json)
end
