import std/[algorithm, math, random, sequtils, strformat, sugar]

type

  TreatmentClass {.pure.} = enum Untreated, Irregular, Regular

  Subject = object
    cumDose: float
    category: TreatmentClass
    hadCovid: bool

const DoseForRegular = 100

func categorize(subject: var Subject) =
  ## Set treatment category based on cumulative treatment taken.
  subject.category = if subject.cumDose == 0: Untreated
                     elif subject.cumDose >= DoseForRegular: Regular
                     else: Irregular

proc update(subject: var Subject; pCovid = 0.001;
            pStart = 0.005; pDosing = 0.25; doses = @[3, 6, 9]) =
  ## Daily update on the subject to check for infection and randomly dose.
  if not subject.hadCovid:
    if rand(1.0) < pCovid:
      subject.hadCovid = true
    elif (subject.cumDose == 0 and rand(1.0) < pStart) or
         (subject.cumDose > 0 and rand(1.0) < pDosing):
      subject.cumDose += sample(doses).toFloat
      subject.categorize()

func kruskalWallis(a, b, c: seq[bool]): float =

  # Aggregate and sort.
  let s = sorted(a & b & c)
  # Find rank of first occurrence of "true".
  let ix = s.find(true) + 1
  # Calculate average ranks for "false" and "true".
  let n = s.len
  let arf = ix / 2
  let art = (ix + n) / 2
  # Calculate sum of ranks for each list.
  let sra = sum(a.mapIt(if it: art else: arf))
  let srb = sum(b.mapIt(if it: art else: arf))
  let src = sum(c.mapIt(if it: art else: arf))
  # Calculate H.
  result = 12 / (n * (n + 1)) * (sra * sra / a.len.toFloat + srb * srb / b.len.toFloat +
                                 src * src / c.len.toFloat) - 3 * float(n + 1)

proc runStudy(numSubjects = 1000; duration = 180; interval= 30) =
  ## Run the study using the population of size "numSubjects" for "duration" days.
  var population = newSeqWith(numSubjects, Subject())
  var unt, untCovid, irr, irrCovid, reg, regCovid = 0
  echo &"Total subjects: {num_subjects}"

  for day in 1..duration:
    for subj in population.mitems:
      subj.update()

    if day mod interval == 0:
      echo &"\nDay {day}:"
      unt = population.countIt(it.category == Untreated)
      untCovid = population.countIt(it.category == Untreated and it.hadCovid)
      echo &"Untreated: N = {unt}, with infection = {untCovid}"
      irr = population.countIt(it.category == IRREGULAR)
      irrCovid = population.countIt(it.category == IRREGULAR and it.hadCovid)
      echo &"Irregular Use: N = {irr}, with infection = {irrCovid}"
      reg = population.countIt(it.category == REGULAR)
      regCovid = population.countIt(it.category == REGULAR and it.hadCovid)
      echo &"Regular Use: N = {reg}, with infection = {reg_covid}"

    if day == duration div 2:
      echo "\nAt midpoint, infection case percentages are:"
      echo "  Untreated : ", 100 * untCovid / unt
      echo "  Irregulars: ", 100 * irrCovid / irr
      echo "  Regulars  : ", 100 * regCovid / reg

  echo "\nAt study end, infection case percentages are:"
  echo &"  Untreated : {100 * untCovid / unt} of group size of {unt}"
  echo &"  Irregulars: {100 * irrCovid / irr} of group size of {irr}"
  echo &"  Regulars  : {100 * regCovid / reg} of group size of {reg}"
  let untreated = collect:
                    for s in population:
                      if s.category == Untreated:
                        s.hadCovid
  let irregular = collect:
                    for s in population:
                      if s.category == Irregular:
                        s.hadCovid
  let regular = collect:
                  for s in population:
                    if s.category == Regular:
                      s.hadCovid
  echo "\nFinal statistics: ", kruskalWallis(untreated, irregular, regular)

randomize()
runStudy(10_000)
