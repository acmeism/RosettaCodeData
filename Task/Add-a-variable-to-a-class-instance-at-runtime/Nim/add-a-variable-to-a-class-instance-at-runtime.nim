import json
{.experimental: "dotOperators".}
template `.=`(js: JsonNode, field: untyped, value: untyped) =
  js[astToStr(field)] = %value
template `.`(js: JsonNode, field: untyped): JsonNode = js[astToStr(field)]
var obj = newJObject()
obj.foo = "bar"
echo(obj.foo)
obj.key = 3
echo(obj.key)
