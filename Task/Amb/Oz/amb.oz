declare

  fun {Amb Xs}
     case Xs of nil then fail
     [] [X] then X
     [] X|Xr then
        choice X
        [] {Amb Xr}
        end
     end
  end

  fun {Example}
     W1 = {Amb ["the" "that" "a"]}
     W2 = {Amb ["frog" "elephant" "thing"]}
     W3 = {Amb ["walked" "treaded" "grows"]}
     W4 = {Amb ["slowly" "quickly"]}
  in
     {List.last W1 W2.1}
     {List.last W2 W3.1}
     {List.last W3 W4.1}
     W1#" "#W2#" "#W3#" "#W4
  end

in

  {ForAll {SearchAll Example} System.showInfo}
