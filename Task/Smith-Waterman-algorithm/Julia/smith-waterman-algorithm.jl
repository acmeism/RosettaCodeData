# Smith-Waterman implementation in Julia
# see Java code at https://github.com/grace-raper/smith-waterman/blob/main/SmithWaterman.java

import Random.shuffle!

# Map of amino acids to corresponding index in the BLOSUM62 scoring matrix
const AMINO_TO_INDEX = Dict{Char, Int}(
    'A' => 1, 'R' => 2, 'N' => 3, 'D' => 4, 'C' => 5,
    'Q' => 6, 'E' => 7, 'G' => 8, 'H' => 9, 'I' => 10,
    'L' => 11, 'K' => 12, 'M' => 13, 'F' => 14, 'P' => 15,
    'S' => 16, 'T' => 17, 'W' => 18, 'Y' => 19, 'V' => 20,
    'a' => 1, 'r' => 2, 'n' => 3, 'd' => 4, 'c' => 5,
    'q' => 6, 'e' => 7, 'g' => 8, 'h' => 9, 'i' => 10,
    'l' => 11, 'k' => 12, 'm' => 13, 'f' => 14, 'p' => 15,
    's' => 16, 't' => 17, 'w' => 18, 'y' => 19, 'v' => 20,
)

# BLOSUM62 scoring matrix
const BLOSUM62 = [
    [4, -1, -2, -2, 0, -1, -1, 0, -2, -1, -1, -1, -1, -2, -1, 1, 0, -3, -2, 0],
    [-1, 5, 0, -2, -3, 1, 0, -2, 0, -3, -2, 2, -1, -3, -2, -1, -1, -3, -2, -3],
    [-2, 0, 6, 1, -3, 0, 0, 0, 1, -3, -3, 0, -2, -3, -2, 1, 0, -4, -2, -3],
    [-2, -2, 1, 6, -3, 0, 2, -1, -1, -3, -4, -1, -3, -3, -1, 0, -1, -4, -3, -3],
    [0, -3, -3, -3, 9, -3, -4, -3, -3, -1, -1, -3, -1, -2, -3, -1, -1, -2, -2, -1],
    [-1, 1, 0, 0, -3, 5, 2, -2, 0, -3, -2, 1, 0, -3, -1, 0, -1, -2, -1, -2],
    [-1, 0, 0, 2, -4, 2, 5, -2, 0, -3, -3, 1, -2, -3, -1, 0, -1, -3, -2, -2],
    [0, -2, 0, -1, -3, -2, -2, 6, -2, -4, -4, -2, -3, -3, -2, 0, -2, -2, -3, -3],
    [-2, 0, 1, -1, -3, 0, 0, -2, 8, -3, -3, -1, -2, -1, -2, -1, -2, -2, 2, -3],
    [-1, -3, -3, -3, -1, -3, -3, -4, -3, 4, 2, -3, 1, 0, -3, -2, -1, -3, -1, 3],
    [-1, -2, -3, -4, -1, -2, -3, -4, -3, 2, 4, -2, 2, 0, -3, -2, -1, -2, -1, 1],
    [-1, 2, 0, -1, -3, 1, 1, -2, -1, -3, -2, 5, -1, -3, -1, 0, -1, -3, -2, -2],
    [-1, -1, -2, -3, -1, 0, -2, -3, -2, 1, 2, -1, 5, 0, -2, -1, -1, -1, -1, 1],
    [-2, -3, -3, -3, -2, -3, -3, -3, -1, 0, 0, -3, 0, 6, -4, -2, -2, 1, 3, -1],
    [-1, -2, -2, -1, -3, -1, -1, -2, -2, -3, -3, -1, -2, -4, 7, -1, -1, -4, -3, -2],
    [1, -1, 1, 0, -1, 0, 0, 0, -1, -2, -2, 0, -1, -2, -1, 4, 1, -3, -2, -2],
    [0, -1, 0, -1, -1, -1, -1, -2, -2, -1, -1, -1, -1, -2, -1, 1, 5, -2, -2, 0],
    [-3, -3, -4, -4, -2, -2, -3, -2, -2, -3, -2, -3, -1, 1, -4, -3, -2, 11, 2, -3],
    [-2, -2, -2, -3, -2, -1, -2, -3, 2, -1, -1, -2, -1, 3, -3, -2, -2, 2, 7, -1],
    [0, -3, -3, -3, -1, -2, -2, -3, -3, 3, 1, -2, 1, -1, -2, -2, 0, -3, -1, 4],
]

# Linear gap cost
const GAP_COST = -4

mutable struct SmithWaterman
    s1id::String
    s2id::String
    s1::String
    s2::String
    n::Int
    score::Matrix{Int}
    max_val::Int
    max_i::Int
    max_j::Int

    function SmithWaterman(s1id::String, s2id::String, s1::String, s2::String, n::Int, gap_cost = GAP_COST)
        sw = new(s1id, s2id, s1, s2, n, zeros(Int, length(s1) + 1, length(s2) + 1), 0, 0, 0)
        fill_score!(sw, gap_cost)
        optimize_alignment!(sw)
        return sw
    end
end

function fill_score!(sw::SmithWaterman, gap_cost)
    # Initialize first row and column with zeros
    sw.score[:, 1] .= 0
    sw.score[1, :] .= 0

    # Fill the scoring matrix
    for i in 2:size(sw.score, 1)
        for j in 2:size(sw.score, 2)
            options = [
                sw.score[i-1, j-1] + BLOSUM62[AMINO_TO_INDEX[sw.s1[i-1]]][AMINO_TO_INDEX[sw.s2[j-1]]],
                sw.score[i-1, j] + gap_cost,
                sw.score[i, j-1] + gap_cost,
                0,
            ]
            sw.score[i, j] = maximum(options)
        end
    end
end

function optimize_alignment!(sw::SmithWaterman)
    sw.max_val = 0
    sw.max_i = 0
    sw.max_j = 0

    # Find the maximum score and its position
    for i in 2:length(sw.s1)
        for j in 2:length(sw.s2)
            if sw.score[i, j] > sw.max_val
                sw.max_val = sw.score[i, j]
                sw.max_i = i
                sw.max_j = j
            end
        end
    end
end

# Return the score
function score(sw::SmithWaterman)
    return sw.max_val
end

# Compute p-value based on n iterations
function pval(sw::SmithWaterman)
    better = 0
    for _ in 1:sw.n
        # Shuffle s2
        s2chars = collect(sw.s2)
        shuffle!(s2chars)
        s2random = join(s2chars)
        sm = SmithWaterman("", "", sw.s1, s2random, 0)
        if score(sm) >= score(sw)
            better += 1
        end
    end
    return (better + 1) / (sw.n + 1)
end

# Print the alignment
function print_alignment(sw::SmithWaterman, gap_cost = GAP_COST)
    i = sw.max_i
    j = sw.max_j
    s1print = ""
    compare = ""
    s2print = ""

    # Begin by adding the last amino acid to the sequence
    s1print = sw.s1[i] * s1print
    s2print = sw.s2[j] * s2print

    # Compare the match
    if sw.s1[i] == sw.s2[j]
        compare = sw.s1[i] * compare
    elseif BLOSUM62[AMINO_TO_INDEX[sw.s1[i]]][AMINO_TO_INDEX[sw.s2[j]]] > 0
        compare = "+" * compare
    else
        compare = " " * compare
    end

    # Backtrack to construct alignment
    while sw.score[i, j] > 0
        if sw.score[i, j] - gap_cost == sw.score[i-1, j]
            i -= 1
            s1print = sw.s1[i] * s1print
            s2print = "-" * s2print
            compare = " " * compare
        elseif sw.score[i, j] - gap_cost == sw.score[i, j-1]
            j -= 1
            s1print = "-" * s1print
            s2print = sw.s2[j] * s2print
            compare = " " * compare
        else
            i -= 1
            j -= 1
            s1print = sw.s1[i] * s1print
            s2print = sw.s2[j] * s2print
            if sw.s1[i] == sw.s2[j]
                compare = sw.s1[i] * compare
            elseif BLOSUM62[AMINO_TO_INDEX[sw.s1[i]]][AMINO_TO_INDEX[sw.s2[j]]] > 0
                compare = "+" * compare
            else
                compare = " " * compare
            end
        end
    end

    # Print basics
    println("COMPARISON OF $(sw.s1id) AND $(sw.s2id)\n")
    println("Score: $(sw.max_val)\n")
    println("Alignment:")

    # Print sequence alignment, 60 characters per line
    a = "$(sw.s1id):\t$(i - 1)\t"
    b = "\t\t\t"
    c = "$(sw.s2id):\t$(j - 1)\t"
    for k in eachindex(s1print)
        if k > 1 && (k - 1) % 60 == 0
            println(a)
            println(b)
            println(c)
            println()
            a = "$(sw.s1id):\t$i\t"
            b = "\t\t\t"
            c = "$(sw.s2id):\t$j\t"
        end
        a *= s1print[k]
        b *= compare[k]
        c *= s2print[k]
        if s1print[k] != '-'
            i += 1
        end
        if s2print[k] != '-'
            j += 1
        end
    end
    println(a)
    println(b)
    println(c)

    # Print score matrix if both strings are less than 15 characters
    if length(sw.s1) < 15 && length(sw.s2) < 15
        println("\nScore Matrix:")
        for l in 1:size(sw.score, 1)
            println(sw.score[l, :])
        end
    end

    # Print p-value if n > 0
    if sw.n > 0
        println("\np-value: $(pval(sw))")
    end
end

const ACC_TO_SEQ = Dict(
    "O95363" =>
        "MVGSALRRGAHAYVYLVSKASHISRGHQHQAWGSRPPAAECATQRAPGSVVELLGKSYPQ" *
        "DDHSNLTRKVLTRVGRNLHNQQHHPLWLIKERVKEHFYKQYVGRFGTPLFSVYDNLSPVV" *
        "TTWQNFDSLLIPADHPSRKKGDNYYLNRTHMLRAHTSAHQWDLLHAGLDAFLVVGDVYRR" *
        "DQIDSQHYPIFHQLEAVRLFSKHELFAGIKDGESLQLFEQSSRSAHKQETHTMEAVKLVE" *
        "FDLKQTLTRLMAHLFGDELEIRWVDCYFPFTHPSFEMEINFHGEWLEVLGCGVMEQQLVN" *
        "SAGAQDRIGWAFGLGLERLAMILYDIPDIRLFWCEDERFLKQFCVSNINQKVKFQPLSKY" *
        "PAVINDISFWLPSENYAENDFYDLVRTIGGDLVEKVDLIDKFVHPKTHKTSHCYRITYRH" *
        "MERTLSQREVRHIHQALQEAAVQLLGVEGRF",
    "Q10574" =>
        "MSWEQYQMYVPQCHPSFMYQGSIQSTMTTPLQSPNFSLDSPNYPDSLSNGGGKDDKKKCR" *
        "RYKTPSPQLLRMRRSAANERERRRMNTLNVAYDELREVLPEIDSGKKLSKFETLQMAQKY" *
        "IECLSQILKQDSKNENLKSKSG",
    "P22816" =>
        "MTKYNSGSSEMPAAQTIKQEYHNGYGQPTHPGYGFSAYSQQNPIAHPGQNPHQTLQNFFS" *
        "RFNAVGDASAGNGGAASISANGSGSSCNYSHANHHPAELDKPLGMNMTPSPIYTTDYDDE" *
        "NSSLSSEEHVLAPLVCSSAQSSRPCLTWACKACKKKSVTVDRRKAATMRERRRLRKVNEA" *
        "FEILKRRTSSNPNQRLPKVEILRNAIEYIESLEDLLQESSTTRDGDNLAPSLSGKSCQSD" *
        "YLSSYAGAYLEDKLSFYNKHMEKYGQFTDFDGNANGSSLDCLNLIVQSINKSTTSPIQNK" *
        "ATPSASDTQSPPSSGATAPTSLHVNFKRKCST",
    "Q8IU24" =>
        "MEFVELSSCRFDATPTFCDRPAAPNATVLPGEHFPVPNGSYEDQGDGHVLAPGPSFHGPG" *
        "RCLLWACKACKKKTVPIDRRKAATMRERRRLVKVNEAFDILKKKSCANPNQRLPKVEILR" *
        "NAISYIEQLHKLLRDSKENSSGEVSDTSAPSPGSCSDGMAAHSPHSFCTDTSGNSSWEQG" *
        "DGQPGNGYENQSCGNTVSSLDCLSLIVQSISTIEGEENNNASNTPR",
    "Q90477" =>
        "MELSDIPFPIPSADDFYDDPCFNTNDMHFFEDLDPRLVHVSLLKPDEHHHIEDEHVRAPS" *
        "GHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNDAFETLKRCTSTNPNQRLP" *
        "KVEILRNAISYIESLQALLRSQEDNYYPVLEHYSGDSDASSPRSNCSDGMMDFMGPTCQT" *
        "RRRNSYDSSYFNDTPNADARNNKNSVVSSLDCLSSIVERISTETPACPVLSVPEGHEESP" *
        "CSPHEGSVLSDTGTTAPSPTSCPQQQAQETIYQVL",
    "P13904" =>
        "MELLPPPLRDMEVTEGSLCAFPTPDDFYDDPCFNTSDMSFFEDLDPRLVHVTLLKPEEPH" *
        "HNEDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAFETLKR" *
        "YTSTNPNQRLPKVEILRNAIRYIESLQALLHDQDEAFYPVLEHYSGDSDASSPRSNCSDG" *
        "MMDYNSPPCGSRRRNSYDSSFYSDSPNDSRLGKSSVISSLDCLSSIVERISTQSPSCPVP" *
        "TAVDSGSEGSPCSPLQGETLSERVITIPSPSNTCTQLSQDPSSTIYHVL",
    "P16075" =>
        "MDLLGPMEMTEGSLCSFTAADDFYDDPCFNTSDMHFFEDLDPRLVHVGGLLKPEEHPHTR" *
        "APPREPTEEEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAF" *
        "ETLKRCTSTNPNQRLPKVEILRNAIRYIESLQALLREQEDAYYPVLEHYSGESDASSPRS" *
        "NCSDGMMEYSGPPCSSRRRNSYDSSYYTESPNDPKHGKSSVVSSLDCLSSIVERISTDNS" *
        "TCPILPPAEAVAEGSPCSPQEGGNLSDSGAQIPSPTNCTPLPQESSSSSSSNPIYQVL",
    "P10085" =>
        "MELLSPPLRDIDLTGPDGSLCSFETADDFYDDPCFDSPDLRFFEDLDPRLVHMGALLKPE" *
        "EHAHFPTAVHPGPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" *
        "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAFYAP" *
        "GPLPPGRGSEHYSGDSDASSPRSNCSDGMMDYSGPPSGPRRQNGYDTAYYSEAARESRPG" *
        "KSAAVSSLDCLSSIVERISTDSPAAPALLLADAPPESPPGPPEGASLSDTEQGTQTPSPD" *
        "AAPQCPAGSNPNAIYQVL",
    "P17542" =>
        "MTERPPSEAARSDPQLEGRDAAEASMAPPHLVLLNGVAKETSRAAAAEPPVIELGARGGP" *
        "GGGPAGGGGAARDLKGRDAATAEARHRVPTTELCRPPGPAPAPAPASVTAELPGDGRMVQ" *
        "LSPPALAAPAAPGRALLYSLSQPLASLGSGFFGEPDAFPMFTTNNRVKRRPSPYEMEITD" *
        "GPHTKVVRRIFTNSRERWRQQNVNGAFAELRKLIPTHPPDKKLSKNEILRLAMKYINFLA" *
        "KLLNDQEEEGTQRAKTGKDPVVGAGGGGGGGGGGAPPDDLLQDVLSPNSSCGSSLDGAAS" *
        "PDSYTEEPAPKHTARSLHPAMLPAADGAGPR",
    "P15172" =>
        "MELLSPPLRDVDLTAPDGSLCSFATTDDFYDDPCFDSPDLRFFEDLDPRLMHVGALLKPE" *
        "EHSHFPAAVHPAPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" *
        "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAAFYA" *
        "PGPLPPGRGGEHYSGDSDASSPRSNCSDGMMDYSGPPSGARRRNCYEGAYYNEAPSEPRP" *
        "GKSAAVSSLDCLSSIVERISTESPAAPALLLADVPSESPPRRQEAAAPSEGESSGDPTQS" *
        "PDAAPQCPAGANPNPIYQVL",
)

const ACCESSIONS = ["P15172", "P17542", "P10085", "P16075", "P13904",
    "Q90477", "Q8IU24", "P22816", "Q10574", "O95363"]

# Part 1 of the test cases.
const sw = SmithWaterman("str001", "str002", "deadly", "ddgearlyk", 999)
print_alignment(sw)
println("\nScore: ", score(sw))
println("P-value: ", pval(sw))

# part 2 test cases are too verbose, skipped here

# Part 3 of the test cases.
const c1 = SmithWaterman("P15172", "Q10574", ACC_TO_SEQ["P15172"], ACC_TO_SEQ["Q10574"], 999)
const c2 = SmithWaterman("P15172", "Q10574", ACC_TO_SEQ["P15172"], ACC_TO_SEQ["O95363"], 999)
println("p-value for P15172 versus Q10574: $(pval(c1))")
println("p-value for P15172 versus O95363: $(pval(c2))")
