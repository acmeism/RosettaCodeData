put "{+$_} such numbers:\n", .batch(10)».fmt('%5d').join("\n") given
(^25000).grep: -> $n { all (2,4,16).map: { $n.base($_) eq $n.base($_).flip } }
