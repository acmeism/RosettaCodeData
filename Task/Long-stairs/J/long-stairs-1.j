stairsim=:{{
  t=. 0 NB. fifths of a second
  echo ;_8 _16 _20{.each 'seconds';'steps to top';'steps from bottom'
  for_trial. i.1e4 do.
    loc=. {.'min max'=. 0 100
    while. loc < max do.
      if. 0=5|t=.t+1 do.
        loc=. loc+1
        if. 0=trial do.
          if. 1=2999 3046 I.t do.
            echo 8 16 20":(t%5),(max-loc),(loc-min)
          end.
        end.
      end.
      ins=. min+?max-min
      if. ins < loc do. min=. min-1 else. max=. max+1 end.
    end.
  end.
  echo 'Average steps taken: ',":t%5e4
  echo 'Average length of staircase: ',":100+t%1e4
}}
