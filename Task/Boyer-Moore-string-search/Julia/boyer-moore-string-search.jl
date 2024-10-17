""" Rosetta Code task at rosettacode.org/mw/index.php?title=Boyer-Moore_string_search """

const ASCIIchars = String([Char(i) for i = 0:255]) # any standard or extended ASCII char
const NAChars = String(['A', 'C', 'G', 'T', 'U', 'N'])  # RNA and DNA bases
const lowercase_alphabet = "abcdefghijklmnopqrstuvwxyz " # a-z and space

""" Use Z algorithm to preprocess s """
function z_array(s)
    len = length(s)
    @assert len > 1
    z = [len; zeros(Int, len - 1)]
    # Initial comparison of s[1:] with prefix
    for i = 1:len-1
        if s[i+1] == s[i]
            z[2] += 1
        else
            break
        end
    end
    r, l = 0, 0
    if z[2] > 0
        r, l = z[2], 1
    end
    for k = 2:len-1
        @assert z[k+1] == 0
        if k > r
            # Case 1
            for i = k:len-1
                if s[i+1] == s[i-k+1]
                    z[k+1] += 1
                else
                    break
                end
            end
            r, l = k + z[k+1] - 1, k
        else
            # Case 2
            # Calculate length of beta
            nbeta = r - k + 1
            zkp = z[k-l+1]
            if nbeta > zkp
                # Case 2a: Zkp wins
                z[k+1] = zkp
            else
                # Case 2b: Compare characters just past r
                nmatch = 0
                for i = r+1:len-1
                    if s[i+1] == s[i-k+1]
                        nmatch += 1
                    else
                        break
                    end
                end
                l, r = k, r + nmatch
                z[k+1] = r - k + 1
            end
        end
    end
    return z
end

""" Compile the N array (Gusfield theorem 2.2.2) from the Z array """
function n_array(s)
    return reverse(z_array(reverse(s)))
end

"""
Compile L' array (Gusfield theorem 2.2.2) using p and N array.
L'[i] = largest index j less than n such that N[j] = |P[i:]|
"""
function big_l_prime_array(p, n)
    len = length(p)
    lp = zeros(Int, len)
    for j = 1:len-1
        i = len - n[j]
        if i < len
            lp[i+1] = j + 1
        end
    end
    return lp
end

"""
Compile L array (Gusfield theorem 2.2.2) using p and L' array.
L[i] = largest index j less than n such that N[j] >= |P[i:]|
"""
function big_l_array(p, lp)
    l = zeros(Int, length(p))
    l[2] = lp[2]
    for i = 3:length(p)
        l[i] = max(l[i-1], lp[i])
    end
    return l
end

""" Compile lp' array (Gusfield theorem 2.2.4) using N array. """
function small_l_prime_array(narray)
    len = length(narray)
    small_lp = zeros(Int, len)
    for i in eachindex(narray)
        if narray[i] == i  # prefix matching a suffix
            small_lp[len-i+1] = i
        end
    end
    for i = len-1:-1:1  # "smear" them out to the left
        if small_lp[i] == 0
            small_lp[i] = small_lp[i+1]
        end
    end
    return small_lp
end

""" Return tables needed to apply good suffix rule. """
function good_suffix_table(p)
    n = n_array(p)
    lp = big_l_prime_array(p, n)
    return lp, big_l_array(p, lp), small_l_prime_array(n)
end

"""
Given a mismatch at offset i, and given L/L' and l' arrays,
return amount to shift as determined by good suffix rule.
"""
function good_suffix_mismatch(i, big_l_prime, small_l_prime)
    len = length(big_l_prime)
    @assert i < len
    if i == len - 1
        return 0
    end
    i += 1  # i points to leftmost matching position of P
    if big_l_prime[i] > 0
        return len - big_l_prime[i]
    end
    return len - small_l_prime[i]
end

""" Given a full match of P to T, return amount to shift as determined by good suffix rule. """
good_suffix_match(small_l_prime) = length(small_l_prime) - small_l_prime[2]

"""
Given pattern string and list with ordered alphabet characters, create and return
a dense bad character table.  Table is indexed by offset then by character position in alphabet.
"""
function dense_bad_char_tab(p, amap)
    tab = Vector{Int}[]
    nxt = zeros(Int, length(amap))
    for i in eachindex(p)
        c = p[i]
        @assert haskey(amap, c)
        push!(tab, nxt[:])
        nxt[amap[c]] = i
    end
    return tab
end

""" Encapsulates pattern and associated Boyer-Moore preprocessing. """
struct BoyerMoore
    pat::String
    alphabet::String
    amap::Dict{Char,Int}
    bad_char::Vector{Vector{Int}}
    big_l::Vector{Int}
    small_l_prime::Vector{Int}
end

function BoyerMoore(p, alphabet = "ACGT")
    # Create map from alphabet characters to integers
    amap = Dict(alphabet[i] => i for i in eachindex(alphabet))
    # Make bad character rule table
    bad_char = dense_bad_char_tab(p, amap)
    # Create good suffix rule table
    _, big_l, small_l_prime = good_suffix_table(p)
    return BoyerMoore(p, alphabet, amap, bad_char, big_l, small_l_prime)
end

""" Return # skips given by bad character rule at offset i """
function bad_character_rule(bm, i, c)
    @assert haskey(bm.amap, c)
    ci = bm.amap[c]
    @assert i > bm.bad_char[i+1][ci] - 1
    return i - (bm.bad_char[i+1][ci] - 1)
end

""" Given a mismatch at offset i, return amount to shift per (weak) good suffix rule. """
function good_suffix_rule(bm, i)
    len = length(bm.big_l)
    @assert i < len
    if i == len - 1
        return 0
    end
    i += 1  # i points to leftmost matching position of P
    if bm.big_l[i+1] > 0
        return len - bm.big_l[i+1]
    end
    return len - bm.small_l_prime[i+1]
end

""" Return amount to shift in case where P matches T """
match_skip(bm) = length(bm.small_l_prime) - bm.small_l_prime[2]

#Let's make sure our rules give the expected results.
# GCTAGCTCTACGAGTCTA
p = "TCAA"
p_bm = BoyerMoore(p, "ACGT")
@show p_bm.amap, p_bm.bad_char
@show bad_character_rule(p_bm, 2, 'T') # 2

# GCTAGCTCTACGAGTCTA
# ACTA
p = "ACTA"
p_bm = BoyerMoore(p, "ACGT")
@show good_suffix_rule(p_bm, 0) # 3

# ACACGCTCTACGAGTCTA
# ACAC
p = "ACAC"
p_bm = BoyerMoore(p, "ACGT")
@show match_skip(p_bm) # 2

""" Do Boyer-Moore matching """
function boyer_moore(p, p_bm, t)
    i = 0
    occurrences = Int[]
    while i < length(t) - length(p) + 1
        shift = 1
        mismatched = false
        for j = length(p)-1:-1:0
            if p[j+1] != t[i+j+1]
                skip_bc = bad_character_rule(p_bm, j, t[i+j+1])
                skip_gs = good_suffix_rule(p_bm, j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = true
                break
            end
        end
        if !mismatched
            push!(occurrences, i)
            skip_gs = match_skip(p_bm)
            shift = max(shift, skip_gs)
        end
        i += shift
    end
    return occurrences
end

""" Do Boyer-Moore matching counts """
function boyer_moore_with_counts(p, p_bm, t)
    i = 0
    occurrences = Int[]
    alignments_tried, comparison_count = 0, 0
    while i < length(t) - length(p) + 1
        alignments_tried += 1
        shift = 1
        mismatched = false
        for j = length(p)-1:-1:0
            comparison_count += 1
            if p[j+1] != t[i+j+1]
                skip_bc = bad_character_rule(p_bm, j, t[i+j+1])
                skip_gs = good_suffix_rule(p_bm, j)
                shift = max(shift, skip_bc, skip_gs)
                mismatched = true
                break
            end
        end
        if !mismatched
            push!(occurrences, i)
            skip_gs = match_skip(p_bm)
            shift = max(shift, skip_gs)
        end
        i += shift
    end
    return occurrences, alignments_tried, comparison_count
end

const t1 = "GCTAGCTCTACGAGTCTA"
const p1 = "TCTA"
const p_bm1 = BoyerMoore(p1, "ACGT")
@show boyer_moore(p1, p_bm1, t1)

const t2 = "GGCTATAATGCGTA"
const p2 = "TAATAAA"
const p_bm2 = BoyerMoore(p2, "ACGT")
@show bad_character_rule(p_bm2, 1, 'T')

const p3 = "word"
const t3 = "there would have been a time for such a word"
const p_bm3 = BoyerMoore(p3, lowercase_alphabet)
occurrences, num_alignments, num_character_comparisons = boyer_moore_with_counts(p3, p_bm3, t3)
@show occurrences, num_alignments, num_character_comparisons

const p4 = "needle"
const t4 = "needle need noodle needle"
const p_bm4 = BoyerMoore(p4, lowercase_alphabet)
occurrences, num_alignments, num_character_comparisons = boyer_moore_with_counts(p4, p_bm4, t4)
@show occurrences, num_alignments, num_character_comparisons

const p5 = "put"
const t5 = "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented"
const p_bm5 = BoyerMoore(p5, ASCIIchars)
occurrences, num_alignments, num_character_comparisons = boyer_moore_with_counts(p5, p_bm5, t5)
@show occurrences, num_alignments, num_character_comparisons

p6 = "and"
p_bm6 = BoyerMoore(p6, ASCIIchars)
occurrences, num_alignments, num_character_comparisons = boyer_moore_with_counts(p6, p_bm6, t5)
@show occurrences, num_alignments, num_character_comparisons

p7 = "alfalfa"
t7 = "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
p_bm7 = BoyerMoore(p7, ASCIIchars)
occurrences, num_alignments, num_character_comparisons = boyer_moore_with_counts(p7, p_bm7, t7)
@show occurrences, num_alignments, num_character_comparisons
