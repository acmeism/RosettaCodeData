say "{+$_} matching numbers:\n{.batch(10)».fmt('%3d').join: "\n"}" given
   (^1000).grep: -> $n { $n.contains(0) ?? False !! all |($n.comb).map($n %% *), $n % [*] $n.comb };
