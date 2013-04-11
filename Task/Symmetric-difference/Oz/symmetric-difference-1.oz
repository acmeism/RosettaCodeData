declare
  fun {SymDiff A B}
     {Union {Diff A B} {Diff B A}}
  end

  %% implement sets in terms of lists
  fun {MakeSet Xs}
     set({Nub2 Xs nil})
  end

  fun {Diff set(A) set(B)}
     set({FoldL B List.subtract A})
  end

  fun {Union set(A) set(B)}
     set({Append A B})
  end

  %% --
  fun {Nub2 Xs Ls}
     case Xs of nil then nil
     [] X|Xr andthen {Member X Ls} then {Nub2 Xr Ls}
     [] X|Xr then X|{Nub2 Xr X|Ls}
     end
  end
in
  {Show {SymDiff
	 {MakeSet [john bob mary serena]}
	 {MakeSet [jim mary john bob]}}}
  {Show {SymDiff
	 {MakeSet [john serena bob mary serena]}
	 {MakeSet [jim mary john jim bob]}}}
