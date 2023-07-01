import io

FASTA='''\
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED'''

infile = io.StringIO(FASTA)

def fasta_parse(infile):
    key = ''
    for line in infile:
        if line.startswith('>'):
            if key:
                yield key, val
            key, val = line[1:].rstrip().split()[0], ''
        elif key:
            val += line.rstrip()
    if key:
        yield key, val

print('\n'.join('%s: %s' % keyval for keyval in fasta_parse(infile)))
