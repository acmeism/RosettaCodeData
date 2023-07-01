p bad = "¿como\u0301 esta\u0301s?" # => "¿comó estás?"
p bad.unicode_normalized?          # => false
p bad.unicode_normalize!           # => "¿comó estás?"
p bad.unicode_normalized?          # => true
