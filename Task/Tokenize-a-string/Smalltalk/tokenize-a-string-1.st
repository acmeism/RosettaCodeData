|array |
array := 'Hello,How,Are,You,Today' subStrings: $,.
array fold: [:concatenation :string | concatenation, '.', string ]
