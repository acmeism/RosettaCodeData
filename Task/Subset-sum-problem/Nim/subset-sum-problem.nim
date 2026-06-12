import sequtils, strformat, strutils
import itertools

const Words = {"alliance": -624,
               "archbishop": -915,
               "balm": 397,
               "bonnet": 452,
               "brute": 870,
               "centipede": -658,
               "cobol": 362,
               "covariate": 590,
               "departure": 952,
               "deploy": 44,
               "diophantine": 645,
               "efferent": 54,
               "elysee": -326,
               "eradicate": 376,
               "escritoire": 856,
               "exorcism": -983,
               "fiat": 170,
               "filmy": -874,
               "flatworm": 503,
               "gestapo": 915,
               "infra": -847,
               "isis": -982,
               "lindholm": 999,
               "markham": 475,
               "mincemeat": -880,
               "moresby": 756,
               "mycenae": 183,
               "plugging": -266,
               "smokescreen": 423,
               "speakeasy": -745,
               "vein": 813}

var words: seq[string]
var values: seq[int]
for (word, value) in Words:
  words.add word
  values.add value

for lg in 1..words.len:
  block checkCombs:
    for comb in combinations(words.len, lg):
      var sum = 0
      for idx in comb: sum += values[idx]
      if sum == 0:
        echo &"For length {lg}, found for example: ", comb.mapIt(words[it]).join(" ")
        break checkCombs
    echo &"For length {lg}, no set found."
