>>> from itertools import combinations
>>>
>>> word2weight = {"alliance": -624, "archbishop": -915, "balm": 397, "bonnet": 452,
  "brute": 870, "centipede": -658, "cobol": 362, "covariate": 590,
  "departure": 952, "deploy": 44, "diophantine": 645, "efferent": 54,
  "elysee": -326, "eradicate": 376, "escritoire": 856, "exorcism": -983,
  "fiat": 170, "filmy": -874, "flatworm": 503, "gestapo": 915,
  "infra": -847, "isis": -982, "lindholm": 999, "markham": 475,
  "mincemeat": -880, "moresby": 756, "mycenae": 183, "plugging": -266,
  "smokescreen": 423, "speakeasy": -745, "vein": 813}
>>> answer = None
>>> for r in range(1, len(word2weight)+1):
	if not answer:
		for comb in combinations(word2weight, r):
			if sum(word2weight[w] for w in comb) == 0:
				answer = [(w, word2weight[w]) for w in comb]
				break

			
>>> answer
[('archbishop', -915), ('gestapo', 915)]
