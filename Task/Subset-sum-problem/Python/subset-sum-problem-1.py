words = { # some values are different from example
	"alliance": -624,	"archbishop": -925,	"balm":	397,
	"bonnet": 452,		"brute": 870,		"centipede": -658,
	"cobol": 362,		"covariate": 590,	"departure": 952,
	"deploy": 44,		"diophantine": 645,	"efferent": 54,
	"elysee": -326,		"eradicate": 376,	"escritoire": 856,
	"exorcism": -983,	"fiat": 170,		"filmy": -874,
	"flatworm": 503,	"gestapo": 915,		"infra": -847,
	"isis": -982,		"lindholm": 999,	"markham": 475,
	"mincemeat": -880,	"moresby": 756,		"mycenae": 183,
	"plugging": -266,	"smokescreen": 423,	"speakeasy": -745,
	"vein": 813
}

neg = 0
pos = 0
for (w,v) in words.iteritems():
	if v > 0: pos += v
	else:     neg += v

sums = [0] * (pos - neg + 1)

for (w,v) in words.iteritems():
	s = sums[:]
	if not s[v - neg]: s[v - neg] = (w,)

	for (i, w2) in enumerate(sums):
		if w2 and not s[i + v]:
			s[i + v] = w2 + (w,)

	sums = s
	if s[-neg]:
		for x in s[-neg]:
			print(x, words[x])
		break
