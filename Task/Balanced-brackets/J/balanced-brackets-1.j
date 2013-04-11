bracketDepth    =:  '[]' -&(+/\)/@:(=/) ]
checkBalanced   =:  _1 -.@e. bracketDepth
genBracketPairs =:  (?~@# { ])@#"0 1&'[]'          NB. bracket pairs in arbitrary order
