def tco_step_up:
  .[0] as $time | .[1] as $goal
  | if $goal == 0 then $time
    else
       if $time|step then $goal - 1 else $goal + 1 end
       | [ ($time|tick), .] | tco_step_up
    end ;
