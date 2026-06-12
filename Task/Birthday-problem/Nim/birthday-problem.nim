import random, sequtils, strformat

proc equalBirthdays(nSharers, groupSize, nRepetitions: int): float =
  randomize(1)
  var eq = 0
  for _ in 1..nRepetitions:
    var group: array[1..365, int]
    for _ in 1..groupSize:
      inc group[rand(1..group.len)]
    eq += ord(group.anyIt(it >= nSharers))
  result = eq * 100 / nRepetitions

proc main() =

  var groupEst = 2
  for sharers in 2..5:

    # Coarse.
    var groupSize = groupEst + 1
    while equalBirthdays(sharers, groupSize, 100) < 50:
      inc groupSize

    # Finer.
    let inf = (groupSize.toFloat - (groupSize - groupEst) / 4).toInt()
    for gs in inf..(groupSize+998):
      let eq = equalBirthdays(sharers, groupSize, 250)
      if eq > 50:
        groupSize = gs
        break

    # Finest.
    for gs in (groupSize-1)..(groupSize+998):
      let eq = equalBirthdays(sharers, gs, 50_000)
      if eq > 50:
        groupEst = gs
        echo &"{sharers} independent people in a group of {gs:3} ",
             &"share a common birthday ({eq:4.1f}%)"
        break

main()
