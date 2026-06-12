verb define ''
	fkh =. ;@:,@:(":&.>) NB. format k hash

	assert. 'r2e2 e2s1' (-: [: fkh 2&mfkh)&>&;: 'research seeking'
	assert. 2 = mfks 2 mfkh&.> 'research';'seeking'

	assert. 'n1i1 n1a1' (-: [: fkh 2&mfkh)&>&;: 'night nacht'
	assert. 9 = 2 10 mfksDF 'night';'nacht'

	assert. 'm1y1 a1'  (-: [: fkh 2&mfkh)&>&;: 'my a'
	assert. 10 = 2 10 mfksDF 'my';'a'

	assert. 'r2e2' -: fkh 2 mfkh 'research'
	assert. 6 = 2 10 mfksDF 'research';'research'  NB. task says 8; right answer is 6

	assert. 'a5b4 a5b4' (-: [: fkh 2&mfkh)&>&;: 'aaaaabbbb ababababa'
	assert. 1 = 2 10 mfksDF 'aaaaabbbb';'ababababa'

	assert. 'i3n2 i3a2' (-: [: fkh 2&mfkh)&>&;:  'significant capabilities'
	assert. 7 = 2 10 mfksDF  'significant';'capabilities' NB. task says 5; right answer is 7

	assert. 'L9T8 F9L8' (-: [: fkh 2&mfkh)&>&;: 'LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG'
	assert. 100 = 2 100 mfksDF 'LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV';'EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG'
	NB. task says 83; right answer is 100

	'pass'
)
   pass
