[System.Collections.Generic.HashSet[object]]$set1 = 1..4
[System.Collections.Generic.HashSet[object]]$set2 = 3..6

#            Operation           +     Definition      +          Result
#--------------------------------+---------------------+-------------------------
$set1.UnionWith($set2)           # Union                 $set1 = 1, 2, 3, 4, 5, 6
$set1.IntersectWith($set2)       # Intersection          $set1 = 3, 4
$set1.ExceptWith($set2)          # Difference            $set1 = 1, 2
$set1.SymmetricExceptWith($set2) # Symmetric difference  $set1 = 1, 2, 6, 5
$set1.IsSupersetOf($set2)        # Test superset         False
$set1.IsSubsetOf($set2)          # Test subset           False
$set1.Equals($set2)              # Test equality         False
$set1.IsProperSupersetOf($set2)  # Test proper superset  False
$set1.IsProperSubsetOf($set2)    # Test proper subset    False

5 -in $set1                      # Test membership       False
7 -notin $set1                   # Test non-membership   True
