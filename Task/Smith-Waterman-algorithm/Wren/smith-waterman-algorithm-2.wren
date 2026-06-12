/*
MIT License

Copyright (c) 2022 Grace Raper

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import "./math" for Nums
import "random" for Random

// Map of amino acids to corresponding index in the BLOSUM62 scoring matrix.
var AMINO_TO_INDEX = {
    "A": 0,  "R": 1,  "N": 2,  "D": 3,  "C": 4,
    "Q": 5,  "E": 6,  "G": 7,  "H": 8,  "I": 9,
    "L": 10, "K": 11, "M": 12, "F": 13, "P": 14,
    "S": 15, "T": 16, "W": 17, "Y": 18, "V": 19,
    "a": 0,  "r": 1,  "n": 2,  "d": 3,  "c": 4,
    "q": 5,  "e": 6,  "g": 7,  "h": 8,  "i": 9,
    "l": 10, "k": 11, "m": 12, "f": 13, "p": 14,
    "s": 15, "t": 16, "w": 17, "y": 18, "v": 19
}

// BLOSUM62 scoring matrix.
var BLOSUM62 = [
    [ 4, -1, -2, -2,  0, -1, -1,  0, -2, -1, -1, -1, -1, -2, -1,  1,  0, -3, -2,  0],
    [-1,  5,  0, -2, -3,  1,  0, -2,  0, -3, -2,  2, -1, -3, -2, -1, -1, -3, -2, -3],
    [-2,  0,  6,  1, -3,  0,  0,  0,  1, -3, -3,  0, -2, -3, -2,  1,  0, -4, -2, -3],
    [-2, -2,  1,  6, -3,  0,  2, -1, -1, -3, -4, -1, -3, -3, -1,  0, -1, -4, -3, -3],
    [ 0, -3, -3, -3,  9, -3, -4, -3, -3, -1, -1, -3, -1, -2, -3, -1, -1, -2, -2, -1],
    [-1,  1,  0,  0, -3,  5,  2, -2,  0, -3, -2,  1,  0, -3, -1,  0, -1, -2, -1, -2],
    [-1,  0,  0,  2, -4,  2,  5, -2,  0, -3, -3,  1, -2, -3, -1,  0, -1, -3, -2, -2],
    [ 0, -2,  0, -1, -3, -2, -2,  6, -2, -4, -4, -2, -3, -3, -2,  0, -2, -2, -3, -3],
    [-2,  0,  1, -1, -3,  0,  0, -2, 8,  -3, -3, -1, -2, -1, -2, -1, -2, -2,  2, -3],
    [-1, -3, -3, -3, -1, -3, -3, -4, -3,  4,  2, -3,  1,  0, -3, -2, -1, -3, -1,  3],
    [-1, -2, -3, -4, -1, -2, -3, -4, -3,  2,  4, -2,  2,  0, -3, -2, -1, -2, -1,  1],
    [-1,  2,  0, -1, -3,  1,  1, -2, -1, -3, -2,  5, -1, -3, -1,  0, -1, -3, -2, -2],
    [-1, -1, -2, -3, -1,  0, -2, -3, -2,  1,  2, -1,  5,  0, -2, -1, -1, -1, -1,  1],
    [-2, -3, -3, -3, -2, -3, -3, -3, -1,  0,  0, -3,  0,  6, -4, -2, -2,  1,  3, -1],
    [-1, -2, -2, -1, -3, -1, -1, -2, -2, -3, -3, -1, -2, -4,  7, -1, -1, -4, -3, -2],
    [ 1, -1,  1,  0, -1,  0,  0,  0, -1, -2, -2,  0, -1, -2, -1,  4,  1, -3, -2, -2],
    [ 0, -1,  0, -1, -1, -1, -1, -2, -2, -1, -1, -1, -1, -2, -1,  1,  5, -2, -2,  0],
    [-3, -3, -4, -4, -2, -2, -3, -2, -2, -3, -2, -3, -1,  1, -4, -3, -2, 11,  2, -3],
    [-2, -2, -2, -3, -2, -1, -2, -3,  2, -1, -1, -2, -1,  3, -3, -2, -2,  2,  7, -1],
    [ 0, -3, -3, -3, -1, -2, -2, -3, -3,  3,  1, -2,  1, -1, -2, -2,  0, -3, -1,  4]
]

// Linear gap cost (used when a '-' is inserted into the alignment).
var GAP_COST = -4

// Random number generator.
var Rand = Random.new()

class SmithWaterman {
    construct new(s1id, s2id, s1, s2, n) {
        _s1id  = s1id
        _s2id  = s2id
        _s1    = s1
        _s2    = s2
        _n     = n
        _score = List.filled(s1.count + 1, null)
        for (i in 0..s1.count) _score[i] = List.filled(s2.count + 1, 0)
        for (i in 1..._score.count) {
            for (j in 1..._score[0].count) {
                var options = []
                var b = BLOSUM62[AMINO_TO_INDEX[s1[i - 1]]][AMINO_TO_INDEX[s2[j - 1]]]
                options.add(_score[i - 1][j - 1] + b)
                options.add(_score[i - 1][j] + GAP_COST)
                options.add(_score[i][j - 1] + GAP_COST)
                options.add(0)
                _score[i][j] = Nums.max(options)
            }
        }
        // Optimize alignment.
        _maxVal = 0
        _maxI   = 0
        _maxJ   = 0

        // Iterate through the list updating max when a larger value is found.
        for (i in 1...s1.count) {
            for (j in 1...s2.count) {
                if (_score[i][j] > _maxVal) {
                    _maxVal = _score[i][j]
                    _maxI   = i
                    _maxJ   = j
                }
            }
        }
    }

    // Get score.
    score { _maxVal }

    // Returns p-val (iterations are determined by constructor).
    pval {
        var better = 0
        for (k in 0..._n) {
            var s2chars = _s2.toList
            for (i in 0...s2chars.count) {
                var j = Rand.int(s2chars.count)
                s2chars.swap(i, j)
            }
            var s2random = s2chars.join("")
            var sm = SmithWaterman.new("", "", _s1, s2random, 0)
            if (sm.score >= this.score) better = better + 1
        }
        return (better + 1) / (_n + 1)
    }

    // Prints alignment.
    // If both string are less than 15 characters, scoring matrix is printed.
    // If n > 0, p-value is printed.
    printAlignment() {
        // Backtrack for the maxVal to find the optimal solution!
        var i = _maxI
        var j = _maxJ
        var s1print = ""
        var compare = ""
        var s2print = ""

        // Begin by adding the last amino acid to the sequence.
        s1print = _s1[i] + s1print
        s2print = _s2[j] + s2print

        // Compare that match is s1 and s2 to add to compare string.
        if (_s1[i] == _s2[j]) {
            compare = _s1[i] + compare
        } else if (BLOSUM62[AMINO_TO_INDEX[_s1[i]]][AMINO_TO_INDEX[_s2[j]]] > 0) {
            compare = "+" + compare
        } else {
            compare = " " + compare
        }

        // Continue to format strings.
        while (_score[i][j] > 0) {
            if (_score[i][j] - GAP_COST == _score[i - 1][j]) {
                i = i - 1
                s1print = _s1[i] + s1print
                s2print = "-" + s2print
                compare = " " + compare
            } else if (_score[i][j] - GAP_COST == _score[i][j - 1]) {
                j = j - 1
                s1print = "-" + s1print
                s2print = _s2[j] + s2print
                compare = " " + compare
            } else {
                i = i - 1
                j = j - 1
                s1print = _s1[i] + s1print
                s2print = _s2[j] + s2print
                if (_s1[i] == _s2[j]) {
                    compare = _s1[i] + compare
                } else if (BLOSUM62[AMINO_TO_INDEX[_s1[i]]][AMINO_TO_INDEX[_s2[j]]] > 0) {
                    compare = "+" + compare
                } else {
                    compare = " " + compare
                }
            }
        }

        // Print some of the basics.
        System.print("COMPARISON OF %(_s1id) AND %(_s2id)\n")
        System.print("Score: %(_maxVal)\n")
        System.print("Alignment:")

        // Print sequence alignment using s1print, compare, s2print.
        // 60 characters per line.
        // At the start of line print identifier and location in input string.
        var a = "%(_s1id):\t%(i)\t"
        var b = "\t\t\t"
        var c = "%(_s2id):\t%(j)\t"
        for (k in 0...s1print.count) {
            if (k != 0 && k % 60 == 0) {
                System.print(a)
                System.print(b)
                System.print(c)
                System.print()
                a = "%(_s1id):\t%(i)\t"
                b = "\t\t\t"
                c = "%(_s2id):\t%(j)\t"
            }
            a = a + s1print[k]
            b = b + compare[k]
            c = c + s2print[k]
            if (s1print[k] != "-") i = i + 1
            if (s2print[k] != "-") j = j + 1
        }
        System.print(a)
        System.print(b)
        System.print(c)

        // If both strings are less than 15 letters long, print score matrix.
        if (_s1.count < 15 && _s2.count < 15) {
            System.print("\nScore Matrix:")
            for (l in 0..._score.count) System.print(_score[l])
        }

        // If n > 0 print p-value.
        if (_n > 0) {
            System.print("\np-value: %(pval)")
        }
    }
}

var ACC_TO_SEQ = {
    "O95363": "MVGSALRRGAHAYVYLVSKASHISRGHQHQAWGSRPPAAECATQRAPGSVVELLGKSYPQ" +
        "DDHSNLTRKVLTRVGRNLHNQQHHPLWLIKERVKEHFYKQYVGRFGTPLFSVYDNLSPVV" +
        "TTWQNFDSLLIPADHPSRKKGDNYYLNRTHMLRAHTSAHQWDLLHAGLDAFLVVGDVYRR" +
        "DQIDSQHYPIFHQLEAVRLFSKHELFAGIKDGESLQLFEQSSRSAHKQETHTMEAVKLVE" +
        "FDLKQTLTRLMAHLFGDELEIRWVDCYFPFTHPSFEMEINFHGEWLEVLGCGVMEQQLVN" +
        "SAGAQDRIGWAFGLGLERLAMILYDIPDIRLFWCEDERFLKQFCVSNINQKVKFQPLSKY" +
        "PAVINDISFWLPSENYAENDFYDLVRTIGGDLVEKVDLIDKFVHPKTHKTSHCYRITYRH" +
        "MERTLSQREVRHIHQALQEAAVQLLGVEGRF",
    "Q10574": "MSWEQYQMYVPQCHPSFMYQGSIQSTMTTPLQSPNFSLDSPNYPDSLSNGGGKDDKKKCR" +
         "RYKTPSPQLLRMRRSAANERERRRMNTLNVAYDELREVLPEIDSGKKLSKFETLQMAQKY" +
         "IECLSQILKQDSKNENLKSKSG",
    "P22816": "MTKYNSGSSEMPAAQTIKQEYHNGYGQPTHPGYGFSAYSQQNPIAHPGQNPHQTLQNFFS" +
         "RFNAVGDASAGNGGAASISANGSGSSCNYSHANHHPAELDKPLGMNMTPSPIYTTDYDDE" +
         "NSSLSSEEHVLAPLVCSSAQSSRPCLTWACKACKKKSVTVDRRKAATMRERRRLRKVNEA" +
         "FEILKRRTSSNPNQRLPKVEILRNAIEYIESLEDLLQESSTTRDGDNLAPSLSGKSCQSD" +
         "YLSSYAGAYLEDKLSFYNKHMEKYGQFTDFDGNANGSSLDCLNLIVQSINKSTTSPIQNK" +
         "ATPSASDTQSPPSSGATAPTSLHVNFKRKCST",
    "Q8IU24": "MEFVELSSCRFDATPTFCDRPAAPNATVLPGEHFPVPNGSYEDQGDGHVLAPGPSFHGPG" +
         "RCLLWACKACKKKTVPIDRRKAATMRERRRLVKVNEAFDILKKKSCANPNQRLPKVEILR" +
         "NAISYIEQLHKLLRDSKENSSGEVSDTSAPSPGSCSDGMAAHSPHSFCTDTSGNSSWEQG" +
         "DGQPGNGYENQSCGNTVSSLDCLSLIVQSISTIEGEENNNASNTPR",
    "Q90477": "MELSDIPFPIPSADDFYDDPCFNTNDMHFFEDLDPRLVHVSLLKPDEHHHIEDEHVRAPS" +
         "GHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNDAFETLKRCTSTNPNQRLP" +
         "KVEILRNAISYIESLQALLRSQEDNYYPVLEHYSGDSDASSPRSNCSDGMMDFMGPTCQT" +
         "RRRNSYDSSYFNDTPNADARNNKNSVVSSLDCLSSIVERISTETPACPVLSVPEGHEESP" +
         "CSPHEGSVLSDTGTTAPSPTSCPQQQAQETIYQVL",
    "P13904": "MELLPPPLRDMEVTEGSLCAFPTPDDFYDDPCFNTSDMSFFEDLDPRLVHVTLLKPEEPH" +
         "HNEDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAFETLKR" +
         "YTSTNPNQRLPKVEILRNAIRYIESLQALLHDQDEAFYPVLEHYSGDSDASSPRSNCSDG" +
         "MMDYNSPPCGSRRRNSYDSSFYSDSPNDSRLGKSSVISSLDCLSSIVERISTQSPSCPVP" +
         "TAVDSGSEGSPCSPLQGETLSERVITIPSPSNTCTQLSQDPSSTIYHVL",
    "P16075": "MDLLGPMEMTEGSLCSFTAADDFYDDPCFNTSDMHFFEDLDPRLVHVGGLLKPEEHPHTR" +
         "APPREPTEEEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAF" +
         "ETLKRCTSTNPNQRLPKVEILRNAIRYIESLQALLREQEDAYYPVLEHYSGESDASSPRS" +
         "NCSDGMMEYSGPPCSSRRRNSYDSSYYTESPNDPKHGKSSVVSSLDCLSSIVERISTDNS" +
         "TCPILPPAEAVAEGSPCSPQEGGNLSDSGAQIPSPTNCTPLPQESSSSSSSNPIYQVL",
    "P10085": "MELLSPPLRDIDLTGPDGSLCSFETADDFYDDPCFDSPDLRFFEDLDPRLVHMGALLKPE" +
         "EHAHFPTAVHPGPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" +
         "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAFYAP" +
         "GPLPPGRGSEHYSGDSDASSPRSNCSDGMMDYSGPPSGPRRQNGYDTAYYSEAARESRPG" +
         "KSAAVSSLDCLSSIVERISTDSPAAPALLLADAPPESPPGPPEGASLSDTEQGTQTPSPD" +
         "AAPQCPAGSNPNAIYQVL",
    "P17542": "MTERPPSEAARSDPQLEGRDAAEASMAPPHLVLLNGVAKETSRAAAAEPPVIELGARGGP" +
         "GGGPAGGGGAARDLKGRDAATAEARHRVPTTELCRPPGPAPAPAPASVTAELPGDGRMVQ" +
         "LSPPALAAPAAPGRALLYSLSQPLASLGSGFFGEPDAFPMFTTNNRVKRRPSPYEMEITD" +
         "GPHTKVVRRIFTNSRERWRQQNVNGAFAELRKLIPTHPPDKKLSKNEILRLAMKYINFLA" +
         "KLLNDQEEEGTQRAKTGKDPVVGAGGGGGGGGGGAPPDDLLQDVLSPNSSCGSSLDGAAS" +
         "PDSYTEEPAPKHTARSLHPAMLPAADGAGPR",
    "P15172": "MELLSPPLRDVDLTAPDGSLCSFATTDDFYDDPCFDSPDLRFFEDLDPRLMHVGALLKPE" +
         "EHSHFPAAVHPAPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" +
         "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAAFYA" +
         "PGPLPPGRGGEHYSGDSDASSPRSNCSDGMMDYSGPPSGARRRNCYEGAYYNEAPSEPRP" +
         "GKSAAVSSLDCLSSIVERISTESPAAPALLLADVPSESPPRRQEAAAPSEGESSGDPTQS" +
         "PDAAPQCPAGANPNPIYQVL"
}

var ACCESSIONS = ["P15172", "P17542", "P10085", "P16075", "P13904",
                  "Q90477", "Q8IU24", "P22816", "Q10574", "O95363"]

// Part 1 of the test cases.
var test1 = SmithWaterman.new("str001", "str002", "deadly", "ddgearlyk", 999)
test1.printAlignment()
System.print()

// Part 2 of the test cases.
var test2 = List.filled(ACCESSIONS.count, null)
for (i in 0...test2.count) {
   test2[i] = List.filled(ACCESSIONS.count, 0)
   for (j in i...test2.count) {
        var temp = SmithWaterman.new(ACCESSIONS[i], ACCESSIONS[j],
                   ACC_TO_SEQ[ACCESSIONS[i]], ACC_TO_SEQ[ACCESSIONS[j]], 0)
        test2[i][j] = temp.score
        temp.printAlignment()
        System.print()
    }
}
for (i in 0...test2.count) System.print(test2[i])
System.print()

// Part 3 of the test cases.
var comp1 = SmithWaterman.new("P15172", "Q10574", ACC_TO_SEQ["P15172"], ACC_TO_SEQ["Q10574"], 999)
var comp2 = SmithWaterman.new("P15172", "Q10574", ACC_TO_SEQ["P15172"], ACC_TO_SEQ["O95363"], 999)
System.print("p-value for P15172 versus Q10574: %(comp1.pval)")
System.print()
System.print("p-value for P15172 versus O95363: %(comp2.pval)")
