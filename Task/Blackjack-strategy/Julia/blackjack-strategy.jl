using Random
using Printf

""" Deck: siz is size of deck, card counts 1 to 10 """
mutable struct Deck
    siz::Int
    cards::Vector{Int}
    Deck(siz = 52, cards = [4, 4, 4, 4, 4, 4, 4, 4, 4, 16]) = new(siz, cards)
end
""" Constructor to copy a deck producing a new deck """
Deck(deck::Deck) = Deck(deck.siz, copy(deck.cards))

""" ActionGain struct for action and expected gain """
struct ActionGain
    action::String
    gain::Float64
end

# Strategy tables
const hTable = fill("", 15, 10)
const sTable = fill("", 8, 10)
const pTable = fill("", 10, 10)
const hTable2 = fill("", 18, 10)
const sTable2 = fill("", 10, 10)

""" Dealer probabilities: [17, 18, 19, 20, 21, blackjack, bust] """
function dealerprobs(upcard::Integer, startdeck::Deck)::Vector{Float64}
    res = zeros(7)
    decks = [Deck() for _ in 1:9]
    scores = zeros(Int, 9)
    elevens = zeros(Int, 9)
    probs = zeros(9)
    decks[begin] = Deck(startdeck)
    scores[begin] = upcard == 1 ? 11 : upcard
    elevens[begin] = upcard == 1 ? 1 : 0
    probs[begin] = 1

    function recurse(lev::Integer)
        for c in 1:10
            decks[lev].cards[c] == 0 && continue
            deck, score, eleven, prob = Deck(decks[lev]), scores[lev], elevens[lev], probs[lev]
            score += c == 1 ? 11 : c
            c == 1 && (eleven += 1)
            prob *= deck.cards[c] / deck.siz
            if score > 21 && eleven > 0
                score -= 10
                eleven -= 1
            end
            if lev == 1 && ((upcard == 1 && c == 10) || (upcard == 10 && c == 1))
                res[6] += prob
            elseif 17 <= score <= 21
                res[score-16] += prob
            elseif score > 21 && eleven == 0
                res[7] += prob
            else
                deck.cards[c] -= 1
                deck.siz -= 1
                lev2 = lev + 1
                decks[lev2], scores[lev2], elevens[lev2], probs[lev2] = deck, score, eleven, prob
                recurse(lev2)
            end
        end
    end

    recurse(1)
    # can't have blackjack, so adjust probabilities accordingly
    pnbj = 1 - res[6]
    res ./= pnbj
    res[6] = 0
    return res
end

""" Print dealer probabilities chart """
function dealerchart()
    println("Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules")
    println("Up Card     17        18        19        20        21       Bust")
    println("-"^67)
    deck = Deck()
    deck.siz = 51
    for uc in 1:10
        deck2 = Deck(deck)
        deck2.cards[uc] -= 1
        dp = dealerprobs(uc, deck2)
        print(uc == 1 ? "Ace      " : "$(lpad(uc, 3))      ")
        @printf("%.6f  %.6f  %.6f  %.6f  %.6f  %.6f\n", dp[1], dp[2], dp[3], dp[4], dp[5], dp[7])
    end
end

""" Player expected gain after hitting once and standing """
function playergain(card1::Integer, card2::Integer, uc::Integer, startdeck::Deck)::Float64
    eg, deck, score = 0.0, Deck(startdeck), card1 + card2
    eleven = card1 == 1 || card2 == 1
    eleven && (score += 10)
    for c in 1:10
        deck.cards[c] == 0 && continue
        deck2, score2, eleven2 = Deck(deck), score + c, eleven
        if c == 1
            score2 += 10
            eleven2 = true
        end
        prob = deck2.cards[c] / deck2.siz
        deck2.cards[c] -= 1
        deck2.siz -= 1
        if score2 > 21 && eleven2
            score2 -= 10
        end
        eg += (score2 <= 21 ? calcgain(score2, dealerprobs(uc, deck2)) : -1) * prob
    end
    return eg
end

""" Player expected gain after hitting once and continuing per strategy """
function playergain2(card1::Integer, card2::Integer, uc::Integer, startdeck::Deck)::Float64
    eg = 0.0
    decks = [Deck() for _ in 1:9]
    scores = zeros(Int, 9)
    elevens = zeros(Int, 9)
    probs = zeros(9)
    decks[begin] = startdeck
    scores[begin] = card1 + card2
    if card1 == 1 || card2 == 1
        scores[begin] += 10
        elevens[begin] = 1
    end
    probs[1] = 1

    function recurse(lev::Integer)
        for c in 2:10
            decks[lev].cards[c] == 0 && continue
            deck, score, eleven, prob = Deck(decks[lev]), scores[lev], elevens[lev], probs[lev]
            score += c == 1 ? 11 : c
            c == 1 && (eleven += 1)
            prob *= deck.cards[c] / deck.siz
            if score > 21 && eleven > 0
                score -= 10
                eleven -= 1
            end
            deck.cards[c] -= 1
            deck.siz -= 1
            if (
                eleven == 0 && (score >= 17 || (score >= 13 && uc < 7) || (score == 12 && 4 <= uc <= 6)) ||
                (eleven > 0 && score == 18 && uc != 9 && uc != 10) ||
                (eleven > 0 && score >= 19)
            ) && score <= 21
                eg += calcgain(score, dealerprobs(uc, deck)) * prob
            elseif score > 21 && eleven == 0
                eg -= prob
            else
                lev2 = lev + 1
                decks[lev2], scores[lev2], elevens[lev2], probs[lev2] = deck, score, eleven, prob
                recurse(lev2)
            end
        end
    end

    recurse(1)
    return eg
end

""" Calculate gain for a given player score """
function calcgain(pscore::Integer, dp::Vector{Float64})::Float64
    eg = 0.0
    if pscore == 17
        eg += dp[7] - (dp[2] + dp[3] + dp[4] + dp[5])
    elseif pscore == 18
        eg += dp[1] + dp[7] - (dp[3] + dp[4] + dp[5])
    elseif pscore == 19
        eg += dp[1] + dp[2] + dp[7] - (dp[4] + dp[5])
    elseif pscore == 20
        eg += dp[1] + dp[2] + dp[3] + dp[7] - dp[5]
    elseif pscore == 21
        eg += dp[1] + dp[2] + dp[3] + dp[4] + dp[7]
    elseif pscore == 22
        eg = 1.5
    elseif pscore == 23
        eg = -1
    else # player has less than 17
        eg += dp[7] + dp[7] - 1
    end
    return eg
end

""" Expected gains for standing """
function stand(card1::Integer, card2::Integer)
    deck = Deck()
    deck.cards[card1] -= 1
    deck.cards[card2] -= 1
    deck.siz = 50
    pscore = card1 + card2 + (card1 == 1 || card2 == 1 ? 10 : 0)
    egs = zeros(10)
    for uc in 1:10
        deck2 = Deck(deck)
        deck2.cards[uc] -= 1
        deck2.siz -= 1
        dp = dealerprobs(uc, deck2)
        eg = calcgain(pscore, dp)
        egs[uc == 1 ? 10 : uc-1] = eg
    end
    return egs
end

""" Expected gains for hitting """
function hit(card1::Integer, card2::Integer, once::Bool)
    deck = Deck()
    deck.cards[card1] -= 1
    deck.cards[card2] -= 1
    deck.siz = 50
    egs = zeros(10)
    for uc in 1:10
        deck2 = Deck(deck)
        deck2.cards[uc] -= 1
        deck2.siz = 49
        peg = once ? playergain(card1, card2, uc, deck2) : playergain2(card1, card2, uc, deck2)
        egs[uc == 1 ? 10 : uc-1] = peg
    end
    return egs
end

""" Expected gains for doubling """
double(card1::Integer, card2::Integer) = 2 .* hit(card1, card2, true)

""" Expected gains for splitting """
function split(card::Integer)
    deck = Deck()
    deck.cards[card] -= 2
    deck.siz = 50
    egs = zeros(10)
    score, eleven = card == 1 ? (11, 1) : (card, 0)
    for uc in 1:10
        deck.cards[uc] == 0 && continue
        deck2 = Deck(deck)
        deck2.cards[uc] -= 1
        deck2.siz -= 1
        ix = uc == 1 ? 10 : uc-1
        peg = 0.0
        for c in 1:10
            deck2.cards[c] == 0 && continue
            prob = deck2.cards[c] / deck2.siz
            deck3 = Deck(deck2)
            deck3.cards[c] -= 1
            deck3.siz -= 1
            score2 = score + c
            eleven2 = eleven
            if c == 1
                score2 += 10
                eleven2 += 1
            end
            if score2 == 21
                peg += 1.5 * prob
                continue
            end
            if score2 > 21 && eleven2 > 0
                score2 -= 10
                eleven2 -= 1
            end
            action = eleven2 > 0 ? sTable2[score2-11, ix] : hTable2[score2-3, ix]
            peg2 = action == "S" ? calcgain(score2, dealerprobs(uc, deck3)) : playergain2(card, c, uc, deck3)
            peg += peg2 * prob
        end
        egs[ix] = peg * 2
    end
    return egs
end

""" Best action based on expected gains """
function bestaction(ags::Vector{ActionGain})
    maxgain, maxidx = ags[1].gain, 1
    for i in 2:length(ags)
        if ags[i].gain > maxgain
            maxgain = ags[i].gain
            maxidx = i
        end
    end
    return ags[maxidx].action
end

""" Print chart header """
function printheader(title::AbstractString)
    println(title)
    println("P/D     2      3      4      5      6      7      8      9      T      A")
    println("-"^74)
end

""" Print paired notation, aces A, tens T """
function printpair(c::Integer)
    ch = c == 1 ? "A" : (c == 10 ? "T" : string(c))
    print(ch, ch, "   ")
end

""" Simulate blackjack games """
function simulate(perday, days)
    windays, losedays, evendays = 0, 0, 0
    bigwin, bigloss, totalgain, totalstake = 0.0, 0.0, 0.0, 0.0
    for _ in 1:days
        dailygain, dailystake = 0.0, 0.0
        for _ in 1:perday
            gain, stake = playerplay()
            dailygain += gain
            dailystake += stake
        end
        dailygain > 0 ? (windays += 1) : dailygain < 0 ? (losedays += 1) : (evendays += 1)
        bigwin = max(bigwin, dailygain)
        bigloss = max(bigloss, -dailygain)
        totalgain += dailygain
        totalstake += dailystake
    end
    println("\nAfter playing $perday times a day for $days days:")
    println("Winning days   : $windays")
    println("Losing days    : $losedays")
    println("Breakeven days : $evendays")
    println("Biggest win    : $bigwin")
    println("Biggest loss   : $bigloss")
    if totalgain < 0
        println("Total loss     : $(-totalgain)")
        println("Total staked   : $totalstake")
        @printf("Loss %% staked  : %.3f\n", -totalgain/totalstake*100)
    else
        println("Total win      : $totalgain")
        println("Total staked   : $totalstake")
        @printf("Win %% staked   : %.3f\n", totalgain/totalstake*100)
    end
end

""" Dealer play simulation """
function dealerplay(pscore, next, cards, d)
    dscore, aces = d[1] + d[2], 0
    if d[1] == 1 || d[2] == 1
        dscore += 10
        aces += 1
    end
    while true
        if dscore > 21 && aces > 0
            dscore -= 10
            aces -= 1
        end
        dscore > 21 && return 1
        if dscore >= 17
            return dscore > pscore ? -1 : dscore == pscore ? 0 : 1
        end
        nc = cards[next[]]
        next[] += 1
        dscore += nc == 1 ? 11 : nc
        nc == 1 && (aces += 1)
    end
    return 0
end

""" Player play simulation """
function playerplay()
    cards = [min(div(i-1, 4) + 1, 10) for i in shuffle(1:52)]
    p, d = cards[1:2], cards[3:4]
    next = Ref(5)
    dbj = (d[1] == 1 && d[2] == 10) || (d[1] == 10 && d[2] == 1)
    pbj = (p[1] == 1 && p[2] == 10) || (p[1] == 10 && p[2] == 1)
    dbj && return pbj ? (0.0, 1.0) : (-1.0, 1.0)
    pbj && return (1.5, 1.0)
    uc = d[1] == 1 ? 10 : d[1] - 1
    stake = 1.0
    fscores = zeros(Int, 2)
    score, aces = p[1] + p[2], 0
    kind = p[1] == p[2] ? "pair" : (p[1] == 1 || p[2] == 1) ? "soft" : "hard"
    action = if kind == "hard"
        hTable[score-4, uc]
    elseif kind == "soft"
        other = p[1] == 1 ? p[2] : p[1]
        score += 10
        aces = 1
        sTable[other-1, uc]
    elseif kind == "pair"
        if p[1] == 0
            score += 10
            aces = 2
        end
        pTable[p[1], uc]
    end

    function hit(hand::Int)
        while true
            nc = cards[next[]]
            next[] += 1
            score += nc == 1 ? 11 : nc
            nc == 1 && (aces += 1)
            if score > 21 && aces > 0
                score -= 10
                aces -= 1
            end
            score > 21 && (fscores[hand] = 22; return)
            if action == "D" || (aces == 0 && hTable2[score-4+1, uc] == "S") ||
               (aces > 0 && sTable2[score-12+1, uc] == "S")
                fscores[hand] = score
                return
            end
        end
    end

    if action == "S"
        fscores[1] = score
    elseif action == "H"
        hit(1)
    elseif action == "D"
        hit(1)
        stake = 2
    elseif action == "P"
        for hand in 1:2
            score = p[1]
            aces = p[1] == 1 ? 1 : 0
            score = p[1] == 1 ? 11 : p[1]
            hit(hand)
        end
    end
    sum = fscores[1] < 22 ? dealerplay(fscores[1], next, cards, d) * stake : -1 * stake
    if fscores[2] > 0
        sum += fscores[2] < 22 ? dealerplay(fscores[2], next, cards, d) : -1
        stake = 2
    end
    return (sum, stake)
end

""" Play blackjack and generate charts of outcomes """
function main()
    dealerchart()
    tuples = [(i, j) for i in 2:9 for j in (i+1):10 if i + j <= 19]
    counts = [1, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1]
    segs, hegs, degs = zeros(15, 10), zeros(15, 10), zeros(15, 10)
    for (c1, c2) in tuples
        i = c1 + c2
        sg, hg, dg = stand(c1, c2), hit(c1, c2, false), double(c1, c2)
        segs[i-4, :] .+= sg
        hegs[i-4, :] .+= hg
        degs[i-4, :] .+= dg
    end
    for i in 1:15, j in 1:10
        segs[i, j] /= counts[i]
        hegs[i, j] /= counts[i]
        degs[i, j] /= counts[i]
    end

    printheader("\nHard Chart - Player Expected Gains per unit (Stand)")
    for i in 5:19
        @printf("%2d   ", i)
        for j in 1:10
            @printf("% 0.3f ", segs[i-4, j])
        end
        println()
    end

    printheader("\nHard Chart - Player Expected Gains per unit (Hit)")
    for i in 5:19
        @printf("%2d   ", i)
        for j in 1:10
            @printf("% 0.3f ", hegs[i-4, j])
        end
        println()
    end

    printheader("\nHard Chart - Player Expected Gains per original unit (Double)")
    for i in 5:19
        @printf("%2d   ", i)
        for j in 1:10
            @printf("% 0.3f ", degs[i-4, j])
        end
        println()
    end

    printheader("\nHard Chart - Player Strategy (Round 1)")
    for i in 5:19
        @printf("%2d   ", i)
        for j in 1:10
            ags = [ActionGain("S", segs[i-4, j]), ActionGain("H", hegs[i-4, j]), ActionGain("D", degs[i-4, j])]
            action = bestaction(ags)
            hTable[i-4, j] = action
            @printf("%4s   ", action)
        end
        println()
    end

    segs2, hegs2 = zeros(18, 10), zeros(18, 10)
    for i in 5:19
        segs2[i-4+1, :] = segs[i-4, :]
        hegs2[i-4+1, :] = hegs[i-4, :]
    end
    sg4, hg4 = stand(2, 2), hit(2, 2, false)
    sg20, hg20 = stand(10, 10), hit(10, 10, false)
    sg21, hg21 = stand(1, 10), hit(1, 10, false)
    segs2[1, :], hegs2[1, :] = sg4, hg4
    segs2[17, :], hegs2[17, :] = sg20, hg20
    segs2[18, :], hegs2[18, :] = sg21, hg21

    printheader("\nHard Chart - Player Strategy (Round >= 2, No Doubling)")
    for i in 4:21
        @printf("%2d   ", i)
        for j in 1:10
            action = hegs2[i-3, j] > segs2[i-3, j] ? "H" : "S"
            hTable2[i-3, j] = action
            @printf("%4s   ", action)
        end
        println()
    end

    segs3, hegs3, degs3 = zeros(8, 10), zeros(8, 10), zeros(8, 10)
    for c in 2:9
        sg, hg, dg = stand(1, c), hit(1, c, false), double(1, c)
        segs3[c-1, :], hegs3[c-1, :], degs3[c-1, :] = sg, hg, dg
    end

    printheader("\nSoft Chart - Player Expected Gains per unit (Stand)")
    for c in 2:9
        @printf("A%d   ", c)
        for j in 1:10
            @printf("% 0.3f ", segs3[c-1, j])
        end
        println()
    end

    printheader("\nSoft Chart - Player Expected Gains per unit (Hit)")
    for c in 2:9
        @printf("A%d   ", c)
        for j in 1:10
            @printf("% 0.3f ", hegs3[c-1, j])
        end
        println()
    end

    printheader("\nSoft Chart - Player Expected Gains per original unit (Double)")
    for c in 2:9
        @printf("A%d   ", c)
        for j in 1:10
            @printf("% 0.3f ", degs3[c-1, j])
        end
        println()
    end

    printheader("\nSoft Chart -/Player Strategy (Round 1)")
    for c in 2:9
        @printf("A%d   ", c)
        for j in 1:10
            ags = [ActionGain("S", segs3[c-1, j]), ActionGain("H", hegs3[c-1, j]), ActionGain("D", degs3[c-1, j])]
            action = bestaction(ags)
            sTable[c-1, j] = action
            @printf("%4s   ", action)
        end
        println()
    end

    segs4, hegs4 = zeros(10, 10), zeros(10, 10)
    for i in 1:8
        segs4[i, :], hegs4[i, :] = segs3[i, :], hegs3[i, :]
    end
    sg12, hg12 = stand(1, 1), hit(1, 1, false)
    segs4[1, :], hegs4[1, :], segs4[10, :], hegs4[10, :] = sg12, hg12, sg21, hg21

    printheader("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)")
    for i in 12:21
        @printf("%2d   ", i)
        for j in 1:10
            action = hegs4[i-11, j] > segs4[i-11, j] ? "H" : "S"
            sTable2[i-11, j] = action
            @printf("%4s   ", action)
        end
        println()
    end

    segs5, hegs5, degs5, pegs5 = zeros(10, 10), zeros(10, 10), zeros(10, 10), zeros(10, 10)
    for c in 1:10
        sg, hg, dg, pg = stand(c, c), hit(c, c, false), double(c, c), split(c)
        segs5[c, :], hegs5[c, :], degs5[c, :], pegs5[c, :] = sg, hg, dg, pg
    end

    printheader("\nPairs Chart - Player Expected Gains per unit (Stand)")
    for c in 1:10
        printpair(c)
        for j in 1:10
            @printf("% 0.3f ", segs5[c, j])
        end
        println()
    end

    printheader("\nPairs Chart - Player Expected Gains per unit (Hit)")
    for c in 1:10
        printpair(c)
        for j in 1:10
            @printf("% 0.3f ", hegs5[c, j])
        end
        println()
    end

    printheader("\nPairs Chart - Player Expected Gains per original unit (Double)")
    for c in 1:10
        printpair(c)
        for j in 1:10
            @printf("% 0.3f ", degs5[c, j])
        end
        println()
    end

    printheader("\nPairs Chart - Player Expected Gains per original unit (Split)")
    for c in 1:10
        printpair(c)
        for j in 1:10
            @printf("% 0.3f ", pegs5[c, j])
        end
        println()
    end

    printheader("\nPairs Chart - Player Strategy (Round 1)")
    for c in 1:10
        printpair(c)
        for j in 1:10
            ags = [
                ActionGain("S", segs5[c, j]),
                ActionGain("H", hegs5[c, j]),
                ActionGain("D", degs5[c, j]),
                ActionGain("P", pegs5[c, j]),
            ]
            action = bestaction(ags)
            pTable[c, j] = action
            @printf("%4s   ", action)
        end
        println()
    end

    Random.seed!(Int(time_ns()))
    for i in 1:10
        println("\nSimulation for Year $i:")
        simulate(50, 365)
    end
end

main()
