# This is not optimized, but tries to follow the pseudocode given the Wikipedia entry below.
# Reference: https://en.wikipedia.org/wiki/Stable_marriage_problem#Algorithm

const males = ["abe", "bob", "col", "dan", "ed", "fred", "gav", "hal", "ian", "jon"]
const females = ["abi", "bea", "cath", "dee", "eve", "fay", "gay", "hope", "ivy", "jan"]

const malepreferences = Dict(
  "abe" => ["abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"],
  "bob" => ["cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"],
  "col" => ["hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"],
  "dan" => ["ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"],
   "ed" => ["jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"],
 "fred" => ["bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"],
  "gav" => ["gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"],
  "hal" => ["abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"],
  "ian" => ["hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"],
  "jon" => ["abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"]
)

const femalepreferences = Dict(
  "abi"=> ["bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"],
  "bea"=> ["bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"],
 "cath"=> ["fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"],
  "dee"=> ["fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"],
  "eve"=> ["jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"],
  "fay"=> ["bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"],
  "gay"=> ["jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"],
 "hope"=> ["gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"],
  "ivy"=> ["ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"],
  "jan"=> ["ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"]
)

function pshuf(d)
    ret = Dict()
    for (k,v) in d
        ret[k] = shuffle(v)
    end
    ret
end

# helper functions for the verb: p1 "prefers" p2 over p3
pindexin(a, p) = ([i for i in 1:length(a) if a[i] == p])[1]
prefers(d, p1, p2, p3) = (pindexin(d[p1], p2) < pindexin(d[p1], p3))

function isstable(mmatchup, fmatchup, mpref, fpref)
    for (mmatch, fmatch) in mmatchup
        for f in mpref[mmatch]
            if(f != fmatch && prefers(mpref, mmatch, f, fmatch)
                           && prefers(fpref, f, mmatch, fmatchup[f]))
                println("$mmatch prefers $f and $f prefers $mmatch over their current partners.")
                return false
            end
        end
    end
    true
end

function galeshapley(men, women, malepref, femalepref)
    # Initialize all m ∈ M and w ∈ W to free
    mfree = Dict([(p, true) for p in men])
    wfree = Dict([(p, true) for p in women])
    mpairs = Dict()
    wpairs = Dict()
    while true                    # while ∃ free man m who still has a woman w to propose to
        bachelors = [p for p in keys(mfree) if mfree[p]]
        if(length(bachelors) == 0)
            return mpairs, wpairs
        end
        for m in bachelors
            for w in malepref[m]  # w = first woman on m’s list to whom m has not yet proposed
                if(wfree[w])      # if w is free (else some pair (m', w) already exists)
                    #println("Free match: $m, $w")
                    mpairs[m] = w # (m, w) become engaged
                    wpairs[w] = m # double entry bookeeping
                    mfree[m] = false
                    wfree[w] = false
                    break
                elseif(prefers(femalepref, w, m, wpairs[w])) # if w prefers m to m'
                    #println("Unmatch $(wpairs[w]), match: $m, $w")
                    mfree[wpairs[w]] = true # m' becomes free
                    mpairs[m] = w           # (m, w) become engaged
                    wpairs[w] = m
                    mfree[m] = false
                    break
                end                         # else (m', w) remain engaged, so continue
            end
        end
    end
end

function tableprint(txt, ans, stab)
    println(txt)
    println("   Man     Woman")
    println("   -----   -----")
    show(STDOUT, "text/plain", ans)
    if(stab)
        println("\n  ----STABLE----\n\n")
    else
        println("\n  ---UNSTABLE---\n\n")
    end
end

println("Use the Gale Shapley algorithm to find a stable set of engagements.")
answer = galeshapley(males, females, malepreferences, femalepreferences)
stabl = isstable(answer[1], answer[2], malepreferences, femalepreferences)
tableprint("Original Data Table", answer[1], stabl)

println("To check this is not a one-off solution, run the function on a randomized sample.")
newmpref = pshuf(malepreferences)
newfpref = pshuf(femalepreferences)
answer = galeshapley(males, females, newmpref, newfpref)
stabl = isstable(answer[1], answer[2], newmpref, newfpref)
tableprint("Shuffled Preferences", answer[1], stabl)

# trade abe with bob
println("Perturb this set of engagements to form an unstable set of engagements then check this new set for stability.")
answer = galeshapley(males, females, malepreferences, femalepreferences)
fia1 = (answer[1])["abe"]
fia2 = (answer[1])["bob"]
answer[1]["abe"] = fia2
answer[1]["bob"] = fia1
answer[2][fia1] = "bob"
answer[2][fia2] = "abe"
stabl = isstable(answer[1], answer[2], malepreferences, femalepreferences)
tableprint("Original Data With Bob and Abe Switched", answer[1], stabl)
