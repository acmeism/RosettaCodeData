import algorithm, sequtils, strformat, strutils, tables

const ACGT = ['A', 'C', 'G', 'T']   # Four DNA bases.

iterator permutations(slist: seq[string]): seq[string] =
  var slist = sorted(slist)
  yield slist
  while slist.nextPermutation():
    yield slist


proc printCounts(dnaSeq: string) =
  ## Given a DNA sequence, report the sequence, length and base counts.
  let counts = dnaSeq.toCountTable()
  echo &"\nNucleotide counts for {dnaSeq}:\n"
  for base in ACGT:
    echo &"{($base):>10} {counts[base]:11}"
  var others = 0
  for base in counts.keys:
    if base notin ACGT: inc others, counts[base]
  echo &"     Other {others:11}"
  echo &"  ————————————————————"
  echo &"  Total length {dnaSeq.len: 7}"


func headTailOverlap(s1, s2: string): int =
  ## Return the position in "s1" of the start of overlap
  ## of tail of string "s1" with head of string "s2".
  var start = 0
  while true:
    start = s1.find(s2[0], start)
    if start < 0: return 0
    if s2.startsWith(s1[start..^1]): return s1.len - start
    inc start


proc deduplicate(slist: seq[string]): seq[string] =
  ## Remove duplicates and strings contained within a larger string from a list of strings.
  let slist = sequtils.deduplicate(slist)
  for i, s1 in slist:
    block check:
      for j, s2 in slist:
        if j != i and s1 in s2:
          break check
      # "s1" is not contained in another string.
      result.add s1


func shortestCommonSuperstring(slist: seq[string]): string =
  ## Return shortest common superstring of a list of strings.

  let slist = slist.deduplicate()
  result = slist.join()
  for perm in slist.permutations():
    var sup = perm[0]
    for i in 0..<slist.high:
      let overlapPos = headTailOverlap(perm[i], perm[i+1])
      sup &= perm[i+1][overlapPos..^1]
    if sup.len < result.len: result = sup


const TestSequences = [
  @["TA", "AAG", "TA", "GAA", "TA"],
  @["CATTAGGG", "ATTAG", "GGG", "TA"],
  @["AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"],
  @["ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
    "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
    "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
    "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
    "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
    "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
    "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
    "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
    "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
    "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
    "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
    "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
    "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"]]

for test in TestSequences:
  let scs = test.shortestCommonSuperstring
  scs.printCounts()
