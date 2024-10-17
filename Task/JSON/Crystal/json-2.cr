require "json"

class Foo
  include JSON::Serializable

  property num : Int64
  property array : Array(String)
end

def json
  foo = Foo.from_json(%({"num": 1, "array": ["a", "b"]}))
  puts("#{foo.num} #{foo.array}")
  puts(foo.to_json)
end
