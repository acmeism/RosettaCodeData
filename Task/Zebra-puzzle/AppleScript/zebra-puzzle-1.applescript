on zebraPuzzle()
  -- From statement 10, the Norwegian lives in the first house,
  -- so from statement 15, the blue house must be the second one.
  -- From these and statements 5, 6, and 9, the green and white houses can only be the 4th & 5th,
  -- and the Englishman's red house (statement 2) must be the middle one, where (9) they drink
  -- milk. This only leaves the first house to claim the yellow colour and the Dunhill smokers
  -- (statement 8), which means the second house must have the the horse (statement 12).
  -- Initialise the house data accordingly.
  set mv to missing value
  set streetTemplate to {¬
    {resident:"Norwegian", colour:"yellow", pet:mv, drink:mv, smoke:"Dunhill"}, ¬
    {resident:mv, colour:"blue", pet:"horse", drink:mv, smoke:mv}, ¬
    {resident:"Englishman", colour:"red", pet:mv, drink:"milk", smoke:mv}, ¬
    {resident:mv, colour:"green", pet:mv, drink:"coffee", smoke:mv}, ¬
    {resident:mv, colour:"white", pet:mv, drink:mv, smoke:mv} ¬
      }

  -- Test all permutations of the remaining values.
  set solutions to {}
  set drinkPermutations to {{"beer", "water"}, {"water", "beer"}}
  set residentPermutations to {{"Swede", "Dane", "German"}, {"Swede", "German", "Dane"}, ¬
    {"Dane", "German", "Swede"}, {"Dane", "Swede", "German"}, ¬
    {"German", "Swede", "Dane"}, {"German", "Dane", "Swede"}}
  set petPermutations to {{"birds", "cats", "ZEBRA"}, {"birds", "ZEBRA", "cats"}, ¬
    {"cats", "ZEBRA", "birds"}, {"cats", "birds", "ZEBRA"}, ¬
    {"ZEBRA", "birds", "cats"}, {"ZEBRA", "cats", "birds"}}
  set smokePermutations to {{"Pall Mall", "Blend", "Blue Master"}, {"Pall Mall", "Blue Master", "Blend"}, ¬
    {"Blend", "Blue Master", "Pall Mall"}, {"Blend", "Pall Mall", "Blue Master"}, ¬
    {"Blue Master", "Pall Mall", "Blend"}, {"Blue Master", "Blend", "Pall Mall"}}
  repeat with residentPerm in residentPermutations
    -- Properties associated with resident.
    copy streetTemplate to sTemplate2
    set {r, OK} to {0, true}
    repeat with h in {2, 4, 5} -- House numbers with unknown residents.
      set thisHouse to sTemplate2's item h
      set r to r + 1
      set thisResident to residentPerm's item r
      if (thisResident is "Swede") then
        if (thisHouse's pet is not mv) then
          set OK to false
          exit repeat
        end if
        set thisHouse's pet to "dog"
      else if (thisResident is "Dane") then
        if (thisHouse's drink is not mv) then
          set OK to false
          exit repeat
        end if
        set thisHouse's drink to "tea"
      else
        set thisHouse's smoke to "Prince"
      end if
      set thisHouse's resident to thisResident
    end repeat
    -- Properties associated with cigarette brand.
    if (OK) then
      repeat with smokePerm in smokePermutations
        -- Fit in this permutation of smokes.
        copy sTemplate2 to sTemplate3
        set s to 0
        repeat with thisHouse in sTemplate3
          if (thisHouse's smoke is mv) then
            set s to s + 1
            set thisHouse's smoke to smokePerm's item s
          end if
        end repeat
        repeat with drinkPerm in drinkPermutations
          -- Try to fit this permutation of drinks.
          copy sTemplate3 to sTemplate4
          set {d, OK} to {0, true}
          repeat with h from 1 to 5
            set thisHouse to sTemplate4's item h
            if (thisHouse's drink is mv) then
              set d to d + 1
              set thisDrink to drinkPerm's item d
              if (((thisDrink is "beer") and (thisHouse's smoke is not "Blue Master")) or ¬
                ((thisDrink is "water") and not ¬
                  (((h > 1) and (sTemplate4's item (h - 1)'s smoke is "Blend")) or ¬
                    ((h < 5) and (sTemplate4's item (h + 1)'s smoke is "Blend"))))) then
                set OK to false
                exit repeat
              end if
              set thisHouse's drink to thisDrink
            end if
          end repeat
          if (OK) then
            repeat with petPerm in petPermutations
              -- Try to fit this permutation of pets.
              copy sTemplate4 to sTemplate5
              set {p, OK} to {0, true}
              repeat with h from 1 to 5
                set thisHouse to sTemplate5's item h
                if (thisHouse's pet is mv) then
                  set p to p + 1
                  set thisPet to petPerm's item p
                  if ((thisPet is "birds") and (thisHouse's smoke is not "Pall Mall")) or ¬
                    ((thisPet is "cats") and not ¬
                      (((h > 1) and (sTemplate5's item (h - 1)'s smoke is "Blend")) or ¬
                        ((h < 5) and (sTemplate5's item (h + 1)'s smoke is "Blend")))) then
                    set OK to false
                    exit repeat
                  end if
                  set thisHouse's pet to thisPet
                end if
              end repeat
              if (OK) then set end of solutions to sTemplate5
            end repeat
          end if
        end repeat
      end repeat
    end if
  end repeat

  set solutionCount to (count solutions)
  set owners to {}
  repeat with thisSolution in solutions
    repeat with thisHouse in thisSolution
      if (thisHouse's pet is "zebra") then
        set owners's end to thisHouse's resident
        exit repeat
      end if
    end repeat
  end repeat
  return {zebraOwners:owners, numberOfSolutions:solutionCount, solutions:solutions}
end zebraPuzzle

zebraPuzzle()
