with open('Traceback.txt', 'r' ) as f:
    rawText = f.read()

paragraphs = rawText.split( "\n\n" )

for p in paragraphs:
    if "SystemError" in p:

        index = p.find( "Traceback (most recent call last):" )

        if -1 != index:
            print( p[index:] )
            print( "----------------" )
