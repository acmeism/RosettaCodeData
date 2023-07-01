>>> import codecs
>>> codecs.encode("The quick brown fox jumps over the lazy dog", "rot13")
'Gur dhvpx oebja sbk whzcf bire gur ynml qbt'
>>> codecs.decode(_, "rot13")
'The quick brown fox jumps over the lazy dog'
