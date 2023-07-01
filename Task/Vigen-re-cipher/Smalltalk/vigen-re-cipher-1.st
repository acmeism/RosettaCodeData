prep := [:s | s select:[:ch | ch isLetter] thenCollect:[:ch | ch asUppercase]].
encrypt := [:s :cypher | (prep value:s) keysAndValuesCollect:[:i :ch | ch rot:((cypher at:((i-1)\\key size+1))-$A) ]].
decrypt := [:s :cypher | (prep value:s) keysAndValuesCollect:[:i :ch | ch rot:26-((cypher at:((i-1)\\key size+1))-$A) ]].
