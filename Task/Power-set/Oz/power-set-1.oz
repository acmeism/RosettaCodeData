declare
  %% Given a set as a list, returns its powerset (again as a list)
  fun {Powerset Set}
     proc {Describe Root}
        %% Describe sets by lower bound (nil) and upper bound (Set)
        Root = {FS.var.bounds nil Set}
        %% enumerate all possible sets
        {FS.distribute naive [Root]}
     end
     AllSets = {SearchAll Describe}
  in
     %% convert to list representation
     {Map AllSets FS.reflect.lowerBoundList}
  end
in
  {Inspect {Powerset [1 2 3 4]}}
