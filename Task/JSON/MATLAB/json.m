>> jsondecode('{ "foo": 1, "bar": [10, "apples"] }')
ans =
  struct with fields:

    foo: 1
    bar: {2×1 cell}
>> jsonencode(ans)
ans =
{"foo":1,"bar":[10,"apples"]}
