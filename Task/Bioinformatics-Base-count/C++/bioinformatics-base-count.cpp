#include <map>
#include <string>
#include <iostream>
#include <iomanip>

const std::string DEFAULT_DNA = "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG"
                                "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG"
                                "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT"
                                "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT"
                                "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG"
                                "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA"
                                "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT"
                                "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG"
                                "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC"
                                "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT";

class DnaBase {
public:
    DnaBase(const std::string& dna = DEFAULT_DNA, int width = 50) : genome(dna), displayWidth(width) {
        // Map each character to a counter
        for (auto elm : dna) {
            if (count.find(elm) == count.end())
                count[elm] = 0;
            ++count[elm];
        }
    }

    void viewGenome() {
        std::cout << "Sequence:" << std::endl;
        std::cout << std::endl;
        int limit = genome.size() / displayWidth;
        if (genome.size() % displayWidth != 0)
            ++limit;

        for (int i = 0; i < limit; ++i) {
            int beginPos = i * displayWidth;
            std::cout << std::setw(4) << beginPos << "  :" << std::setw(4) << genome.substr(beginPos, displayWidth) << std::endl;
        }
        std::cout << std::endl;
        std::cout << "Base Count" << std::endl;
        std::cout << "----------" << std::endl;
        std::cout << std::endl;
        int total = 0;
        for (auto elm : count) {
            std::cout << std::setw(4) << elm.first << " : " << elm.second << std::endl;
            total += elm.second;
        }
        std::cout << std::endl;
        std::cout << "Total: " << total << std::endl;
    }

private:
    std::string genome;
    std::map<char, int> count;
    int displayWidth;
};

int main(void) {
    auto d = new DnaBase();
    d->viewGenome();
    delete d;
    return 0;
}
