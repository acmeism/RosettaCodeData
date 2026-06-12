def is_abc_word:
  [index("a", "b", "c")]
  | all(.[]; . != null) and .[0] < .[1] and .[1] < .[2] ;

select(is_abc_word)
