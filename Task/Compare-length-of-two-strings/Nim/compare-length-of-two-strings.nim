import strformat, unicode

const
  S1 = "marche"
  S2 = "marché"

echo &"“{S2}”, byte length = {S2.len}, code points: {S2.toRunes.len}"
echo &"“{S1}”, byte length = {S1.len}, code points: {S1.toRunes.len}"
