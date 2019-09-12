lettercounts = countletters(sourcedata)
for letter,count in lettercounts.iteritems():
    print "%s=%s" % (letter, count),
