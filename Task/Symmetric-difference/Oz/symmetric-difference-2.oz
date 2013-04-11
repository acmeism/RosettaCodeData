declare
  fun {SymDiff A B}
     {FS.union {FS.diff A B} {FS.diff B A}}
  end

  A = {FS.value.make [1 2 3 4]}
  B = {FS.value.make [5 3 1 2]}
in
  {Show {SymDiff A B}}
