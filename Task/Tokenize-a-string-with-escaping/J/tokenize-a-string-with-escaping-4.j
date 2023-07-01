charTokens =: (0;(3 2 2$(2 1 1 1 2 2 1 2 1 0 1 0));<<'^')&;:  NB. sequential machine
splitTokens =: ((<,'|')&= <;._1 ])@:((<,'|'),])
removeExtra =: (}.^:(1<#)) L:0
tokenize3=: tokenize=: ; each @: (removeExtra @: splitTokens @: charTokens)
