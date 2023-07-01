def duplicate_timestamps:
  [.[][0]] | sort | runs | map( select(.[1]>1) );
