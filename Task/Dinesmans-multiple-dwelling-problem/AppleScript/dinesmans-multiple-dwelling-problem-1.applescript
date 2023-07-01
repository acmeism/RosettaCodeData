on Dinesman()
  set output to {}
  (* American floor numbering used in these comments to match AppleScript's 1-based indices. *)
  -- Baker's not on the fifth floor.
  repeat with Baker from 1 to 4
    -- Cooper's not on the first floor. Nor on the fifth as Miller's somewhere above him.
    -- Fletcher's also not on these floors, so both are in the middle three. They're also
    -- at least two floors apart, so one must be on the second and the other on the fourth.
    repeat with Cooper from 2 to 4 by 2
      if (Cooper ≠ Baker) then
        set Fletcher to 6 - Cooper
        -- Miller's somewhere above Cooper.
        if (Fletcher ≠ Baker) then repeat with Miller from (Cooper + 1) to 5
          -- Try to fit Smith in somewhere not adjacent to Fletcher.
          if ((Miller ≠ Fletcher) and (Miller ≠ Baker)) then repeat with Smith from 1 to 5
            if ((Smith is not in {Baker, Cooper, Fletcher, Miller}) and ¬
              ((Fletcher - Smith > 1) or (Smith - Fletcher > 1))) then
              tell {missing value, missing value, missing value, missing value, missing value}
                set {item Baker, item Cooper, item Fletcher, item Miller, item Smith} to ¬
                  {"Baker", "Cooper", "Fletcher", "Miller", "Smith"}
                set end of output to {bottomToTop:it}
              end tell
            end if
          end repeat
        end repeat
      end if
    end repeat
  end repeat

  return {numberOfSolutions:(count output), solutions:output}
end Dinesman

return Dinesman()
