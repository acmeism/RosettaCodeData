local(test = map(
		'a' = '0cc175b9c0f1b6a831c399e269772661',
		'abc' = '900150983cd24fb0d6963f7d28e17f72',
		'message digest' = 'f96b697d7cb7938d525a2f31aaf161d0',
		'abcdefghijklmnopqrstuvwxyz' = 'c3fcd3d76192e4007dfb496cca67e13b',
		'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' = 'd174ab98d277d9f5a5611c2c9f419d9f',
		'12345678901234567890123456789012345678901234567890123456789012345678901234567890' = '57edf4a22be3c955ac49da2e2107b67a'
	)
)
with a in #test->keys do =>  {^
	'testing: "'+#a+'": '+(Encrypt_MD5(#a)->asBytes == #test->find(#a)->asBytes)+'\r'
^}
