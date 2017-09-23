(["the","that","a"] | amb) as $word1
  | (["frog","elephant","thing"] | amb) as $word2
  | [$word1, $word2] | joins
  | (["walked","treaded","grows"] | amb) as $word3
  | [$word2, $word3] | joins
  | (["slowly","quickly"] | amb) as $word4
  | [$word3, $word4] | joins
  | [$word1, $word2, $word3, $word4]
