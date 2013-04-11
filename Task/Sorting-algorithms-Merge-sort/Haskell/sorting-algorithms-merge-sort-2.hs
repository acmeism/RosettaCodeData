mergePairs (sorted1 : sorted2 : sorteds) = merge sorted1 sorted2 : mergePairs sorteds
mergePairs sorteds = sorteds

mergeSortBottomUp list = mergeAll (map (\x -> [x]) list)

mergeAll [sorted] = sorted
mergeAll sorteds = mergeAll (mergePairs sorteds)
