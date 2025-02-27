#include <stdio.h>

int main(void) {
    char dna[] = "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG"
                "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG"
                "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT"
                "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT"
                "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG"
                "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA"
                "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT"
                "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG"
                "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC"
                "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT";
    int c_count = 0, t_count = 0, a_count = 0, g_count = 0, total;

    for (total = 0; dna[total]; total++) {
        if (total % 50 == 0)
            printf("\n%3d - %3d: %c", total + 1, total + 50, dna[total]);
        else if (total % 5 == 0)
            printf(" %c", dna[total]);
        else
            printf("%c", dna[total]);

        switch (dna[total]) {
            case 'C': c_count++; break;
            case 'T': t_count++; break;
            case 'A': a_count++; break;
            case 'G': g_count++; break;
        }
    }

    printf("\n\nC count: %3d\nT count: %3d\nA count: %3d\nG count: %3d\n  Total: %3d\n\n",
            c_count, t_count, a_count, g_count, total);

    return 0;
}
