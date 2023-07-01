"""
http://rosettacode.org/wiki/ASCII_art_diagram_converter

Python example based off Go example:

http://rosettacode.org/wiki/ASCII_art_diagram_converter#Go

"""

def validate(diagram):

    # trim empty lines

    rawlines = diagram.splitlines()
    lines = []
    for line in rawlines:
        if line != '':
            lines.append(line)

    # validate non-empty lines

    if len(lines) == 0:
        print('diagram has no non-empty lines!')
        return None

    width = len(lines[0])
    cols = (width - 1) // 3

    if cols not in [8, 16, 32, 64]:
        print('number of columns should be 8, 16, 32 or 64')
        return None

    if len(lines)%2 == 0:
        print('number of non-empty lines should be odd')
        return None

    if lines[0] != (('+--' * cols)+'+'):
            print('incorrect header line')
            return None

    for i in range(len(lines)):
        line=lines[i]
        if i == 0:
            continue
        elif i%2 == 0:
            if line != lines[0]:
                print('incorrect separator line')
                return None
        elif len(line) != width:
            print('inconsistent line widths')
            return None
        elif line[0] != '|' or line[width-1] != '|':
            print("non-separator lines must begin and end with '|'")
            return None

    return lines

"""

results is list of lists like:

[[name, bits, start, end],...

"""

def decode(lines):
    print("Name     Bits  Start  End")
    print("=======  ====  =====  ===")

    startbit = 0

    results = []

    for line in lines:
        infield=False
        for c in line:
            if not infield and c == '|':
                infield = True
                spaces = 0
                name = ''
            elif infield:
                if c == ' ':
                    spaces += 1
                elif c != '|':
                    name += c
                else:
                    bits = (spaces + len(name) + 1) // 3
                    endbit = startbit + bits - 1
                    print('{0:7}    {1:2d}     {2:2d}   {3:2d}'.format(name, bits, startbit, endbit))
                    reslist = [name, bits, startbit, endbit]
                    results.append(reslist)
                    spaces = 0
                    name = ''
                    startbit += bits

    return results

def unpack(results, hex):
    print("\nTest string in hex:")
    print(hex)
    print("\nTest string in binary:")
    bin = f'{int(hex, 16):0>{4*len(hex)}b}'
    print(bin)
    print("\nUnpacked:\n")
    print("Name     Size  Bit pattern")
    print("=======  ====  ================")
    for r in results:
        name = r[0]
        size = r[1]
        startbit = r[2]
        endbit = r[3]
        bitpattern = bin[startbit:endbit+1]
        print('{0:7}    {1:2d}  {2:16}'.format(name, size, bitpattern))


diagram = """
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

"""

lines = validate(diagram)

if lines == None:
    print("No lines returned")
else:
    print(" ")
    print("Diagram after trimming whitespace and removal of blank lines:")
    print(" ")
    for line in lines:
        print(line)

    print(" ")
    print("Decoded:")
    print(" ")

    results = decode(lines)

    # test string

    hex = "78477bbf5496e12e1bf169a4"

    unpack(results, hex)
