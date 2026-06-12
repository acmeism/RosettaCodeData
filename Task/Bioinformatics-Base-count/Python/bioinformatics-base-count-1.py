from collections import Counter

def basecount(dna):
    return sorted(Counter(dna).items())

def seq_split(dna, n=50):
    return [dna[i: i+n] for i in range(0, len(dna), n)]

def seq_pp(dna, n=50):
    for i, part in enumerate(seq_split(dna, n)):
        print(f"{i*n:>5}: {part}")
    print("\n  BASECOUNT:")
    tot = 0
    for base, count in basecount(dna):
        print(f"    {base:>3}: {count}")
        tot += count
    base, count = 'TOT', tot
    print(f"    {base:>3}= {count}")

if __name__ == '__main__':
    print("SEQUENCE:")
    sequence = '''\
CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG\
CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG\
AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT\
GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT\
CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG\
TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA\
TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT\
CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG\
TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC\
GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT'''
    seq_pp(sequence)
