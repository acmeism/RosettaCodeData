declare
  %% describe the possible solutions of the beer 'puzzle'
  proc {BeerDescription Solution}
     N = {FD.int 1#99} %% N is an integer in [1, 99]
  in
    %% distribute starting with highest value
    {FD.distribute generic(value:max) [N]}

     Solution =
     {Bottles N}#" of beer on the wall\n"#
     {Bottles N}#" bottles of beer\n"#
     "Take one down, pass it around\n"#
     {Bottles N-1}#" of beer on the wall\n"
  end

  %% pluralization
  proc {Bottles N Txt}
     cond N = 1 then Txt ="1 bottle"
     else Txt = N#" bottles"
     end
  end
in
  %% show all solutions to the 'puzzle'
  {ForAll {SearchAll BeerDescription}
   System.showInfo}
