 prm:{$[0=x;,!0;,/(prm x-1){?[1+x;y;0]}/:\:!x]}
perm:{x[prm[#x]]}

(("some";"random";"text")
 ("random";"some";"text")
 ("random";"text";"some")
 ("some";"text";"random")
 ("text";"some";"random")
 ("text";"random";"some"))
