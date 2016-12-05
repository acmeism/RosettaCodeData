constant expansions = [1], [1,-1], -> @prior { [|@prior,0 Z- 0,|@prior] } ... *;

sub polyprime($p where 2..*) { so expansions[$p].[1 ..^ */2].all %% $p }
