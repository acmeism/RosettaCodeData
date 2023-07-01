def demo:
 "levenshteinDistance between \(.[0]) and \(.[1]) is \( levenshteinDistance(.[0]; .[1]) )";

(["kitten", "sitting"] | demo),
(["rosettacode","raisethysword"] | demo),
(["edocattesor", "drowsyhtesiar"] | demo),
(["this_algorithm_is_similar_to",
  "Damerau-Levenshtein_distance"] | demo)
