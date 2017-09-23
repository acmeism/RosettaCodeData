(["the","that","a"] | amb(true)) as $word1
  | (["frog","elephant","thing"] | amb( [$word1, .] | joins)) as $word2
  | (["walked","treaded","grows"] | amb( [$word2, .] | joins)) as $word3
  | (["slowly","quickly"] | amb( [$word3, .] | joins)) as $word4
  | [$word1, $word2,$word3, $word4]
