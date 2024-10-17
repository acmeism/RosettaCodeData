dnabases = ['A', 'C', 'G', 'T']
randpos(seq) = rand(1:length(seq))                                      # 1
mutateat(pos, seq) = (s = seq[:]; s[pos] = rand(dnabases); s)           # 2-1
deleteat(pos, seq) = [seq[1:pos-1]; seq[pos+1:end]]                     # 2-2
randinsertat(pos, seq) = [seq[1:pos]; rand(dnabases); seq[pos+1:end]]   # 2-3

function weightedmutation(seq, pos, weights=[1, 1, 1], verbose=true)    # Extra credit
    p, r = weights ./ sum(weights), rand()
    f = (r <= p[1]) ? mutateat : (r < p[1] + p[2]) ? deleteat : randinsertat
    verbose && print("Mutate by ", f == mutateat ? "swap" :
                                   f == deleteat ? "delete" : "insert")
    return f(pos, seq)
end

function weightedrandomsitemutation(seq, weights=[1, 1, 1], verbose=true)
    position = randpos(seq)
    newseq = weightedmutation(seq, position, weights, verbose)
    verbose && println(" at position $position")
    return newseq
end

randdnasequence(n) = rand(dnabases, n)                                  # 3

function dnasequenceprettyprint(seq, colsize=50)                        # 4
    println(length(seq), "nt DNA sequence:\n")
    rows = [seq[i:min(length(seq), i + colsize - 1)] for i in 1:colsize:length(seq)]
    for (i, r) in enumerate(rows)
        println(lpad(colsize * (i - 1), 5), "   ", String(r))
    end
    bases = [[c, 0] for c in dnabases]
    for c in seq, base in bases
        if c == base[1]
            base[2] += 1
        end
    end
    println("\nNucleotide counts:\n")
    for base in bases
        println(lpad(base[1], 10), lpad(string(base[2]), 12))
    end
    println(lpad("Other", 10), lpad(string(length(seq) - sum(x[2] for x in bases)), 12))
    println("     _________________\n", lpad("Total", 10), lpad(string(length(seq)), 12))
end

function testbioseq()
    sequence = randdnasequence(500)
    dnasequenceprettyprint(sequence)
    for _ in 1:10                                                       # 5
        sequence = weightedrandomsitemutation(sequence)
    end
    println("\n Mutated:"); dnasequenceprettyprint(sequence)            # 6
end

testbioseq()
