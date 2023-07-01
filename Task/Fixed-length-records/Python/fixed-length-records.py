infile = open('infile.dat', 'rb')
outfile = open('outfile.dat', 'wb')

while True:
    onerecord = infile.read(80)
    if len(onerecord) < 80:
        break
    onerecordreversed = bytes(reversed(onerecord))
    outfile.write(onerecordreversed)

infile.close()
outfile.close()
