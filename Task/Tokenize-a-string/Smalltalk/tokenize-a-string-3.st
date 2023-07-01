|array |
array := 'Hello,How,Are,You,Today' subStrings: $,.
array inject: '' into: [:concatenation :string | concatenation, string, '.' ]
