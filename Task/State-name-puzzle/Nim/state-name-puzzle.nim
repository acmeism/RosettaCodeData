import algorithm, sequtils, strformat, strutils, tables


const
  States = @["Alabama",  "Alaska",  "Arizona",  "Arkansas",
             "California",  "Colorado",  "Connecticut",  "Delaware",
             "Florida",  "Georgia",  "Hawaii",  "Idaho",  "Illinois",
             "Indiana",  "Iowa",  "Kansas",  "Kentucky",  "Louisiana",
             "Maine",  "Maryland",  "Massachusetts",  "Michigan",
             "Minnesota",  "Mississippi",  "Missouri",  "Montana",
             "Nebraska",  "Nevada",  "New Hampshire",  "New Jersey",
             "New Mexico",  "New York",  "North Carolina",  "North Dakota",
             "Ohio",  "Oklahoma",  "Oregon",  "Pennsylvania",  "Rhode Island",
             "South Carolina",  "South Dakota",  "Tennessee",  "Texas",
             "Utah",  "Vermont",  "Virginia",
             "Washington",  "West Virginia",  "Wisconsin",  "Wyoming"]

  Fictitious = @["New Kory", "Wen Kory", "York New", "Kory New", "New Kory"]

type MatchingPairs = ((string, string), (string, string))


proc matchingPairs(states: openArray[string]): seq[MatchingPairs] =
  ## Build the list of matching pairs of states.

  let states = sorted(states).deduplicate()

  # Build a mapping from ordered sequence of chars to sequence of (state, state).
  var mapping: Table[seq[char], seq[(string, string)]]
  for i in 0..<states.high:
    let s1 = states[i]
    for j in (i + 1)..states.high:
      let s2 = states[j]
      mapping.mgetOrPut(sorted(map(s1 & s2, toLowerAscii)), @[]).add (s1, s2)

  # Keep only the couples of pairs of states with no common state.
  for pairs in mapping.values:
    if pairs.len > 1:
      # These pairs are candidates.
      for i in 0..<pairs.high:
        let pair1 = pairs[i]
        for j in i..pairs.high:
          let pair2 = pairs[j]
          if pair1[0] != pair2[0] and pair1[0] != pair2[1] and
             pair1[1] != pair2[0] and pair1[1] != pair2[1]:
            # "pair1" and "pair2" have no common state.
            result.add (pair1, pair2)


proc `$`(pairs: MatchingPairs): string =
  ## Return the string representation of two matching pairs.
  "$1 & $2 = $3 & $4".format(pairs[0][0], pairs[0][1], pairs[1][0], pairs[1][1])

echo "For real states:"
for n, pairs in matchingPairs(States):
  echo &"{n+1:2}:  {pairs}"
echo()
echo "For real + fictitious states:"
for n, pairs in matchingPairs(States & Fictitious):
  echo &"{n+1:2}:  {pairs}"
