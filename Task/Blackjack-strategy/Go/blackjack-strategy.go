package main

import (
    "fmt"
    "math/rand"
    "time"
)

type Deck [11]int // 0:deck size, 1 to 10: number of cards of that denomination

type ActionGain struct {
    action string
    gain   float64
}

func NewDeck() Deck {
    return Deck{52, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16}
}

// Returns probabilities of dealer eventually getting:
// 0: 17, 1: 18, 2: 19, 3: 20, 4: 21 (non-blackjack), 5: blackjack (nil), 6: bust.
// It is assumed that the dealer has already checked for blackjack, that one deck is used
// and that the dealer stands on 'soft' 17.
func dealerProbs(upCard int, startDeck Deck) []float64 {
    res := make([]float64, 7)   // results
    decks := make([]Deck, 9)    // decks for each level
    scores := make([]int, 9)    // scores for each level
    elevens := make([]int, 9)   // number of aces for each level scored as 11
    probs := make([]float64, 9) // probs for each level
    decks[0] = startDeck
    scores[0] = upCard
    if upCard == 1 { // an ace
        scores[0] = 11
        elevens[0] = 1
    }
    probs[0] = 1.0
    var f func(lev int) // recursive closure
    f = func(lev int) {
        for c := 1; c < 11; c++ {
            if decks[lev][c] == 0 {
                continue // card no longer present in deck
            }
            // temporary variables for current level
            deck, score, eleven, prob := decks[lev], scores[lev], elevens[lev], probs[lev]
            score += c  // add card to score
            if c == 1 { // score all aces initially as 11
                score += 10
                eleven++
            }
            prob *= float64(deck[c]) / float64(deck[0])
            if score > 21 && eleven > 0 {
                score -= 10 // bust but can demote an ace
                eleven--
            }
            if lev == 0 && ((upCard == 1 && c == 10) || (upCard == 10 && c == 1)) {
                res[5] += prob // blackjack, allow for now
            } else if score >= 17 && score <= 21 {
                res[score-17] += prob // 17 to (non-blackjack) 21
            } else if score > 21 && eleven == 0 {
                res[6] += prob // bust
            } else {
                deck[c]-- // remove card from deck
                deck[0]-- // decrement deck size
                lev2 := lev + 1
                decks[lev2], scores[lev2], elevens[lev2], probs[lev2] = deck, score, eleven, prob
                f(lev2) // get another card
            }
        }
    }
    f(0)
    // but can't have blackjack, so adjust probabilities accordingly
    pnbj := 1 - res[5]
    for i := 0; i < 7; i++ {
        res[i] /= pnbj
    }
    res[5] = 0
    return res
}

// Prints chart of dealer probabilities (as a check against an external source).
func dealerChart() {
    fmt.Println("Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules")
    fmt.Println("Up Card     17        18        19        20        21       Bust")
    fmt.Println("-------------------------------------------------------------------")
    deck := NewDeck()
    deck[0] = 51
    for uc := 1; uc < 11; uc++ {
        deck2 := deck
        deck2[uc]--
        dp := dealerProbs(uc, deck2)
        if uc > 1 {
            fmt.Printf("%3d      ", uc)
        } else {
            fmt.Print("Ace      ")
        }
        fmt.Printf("%f  %f  %f  %f  %f  %f\n", dp[0], dp[1], dp[2], dp[3], dp[4], dp[6])
    }
}

// Returns player's expected gain per unit staked after hitting once and then standing.
func playerGain(card1, card2, uc int, startDeck Deck) float64 {
    eg := 0.0
    deck := startDeck
    score := card1 + card2
    eleven := false
    if card1 == 1 || card2 == 1 { // an ace
        score += 10
        eleven = true
    }
    for c := 1; c < 11; c++ { // get another card
        if deck[c] == 0 {
            continue // card no longer present in deck
        }
        // temporary variables for current card
        deck2, score2, eleven2 := deck, score, eleven
        score2 += c // add card to score
        if c == 1 { // score all aces initially as 11
            score2 += 10
            eleven2 = true
        }
        prob := float64(deck2[c]) / float64(deck2[0])
        deck2[c]-- // remove card from deck
        deck2[0]-- // decrement deck size
        if score2 > 21 && eleven2 {
            score2 -= 10 // bust but can demote an ace
        }
        if score2 <= 21 {
            dp := dealerProbs(uc, deck2)
            eg += calcGain(score2, dp) * prob
        } else { // bust
            eg -= prob
        }
    }
    return eg
}

// Returns player's expected gain per unit staked after hitting once and then continuing in accordance
// with the tables for rounds >= 2.
func playerGain2(card1, card2, uc int, startDeck Deck) float64 {
    eg := 0.0                   // result
    decks := make([]Deck, 9)    // decks for each level
    scores := make([]int, 9)    // scores for each level
    elevens := make([]int, 9)   // number of aces for each level scored as 11
    probs := make([]float64, 9) // probs for each level
    decks[0] = startDeck
    scores[0] = card1 + card2
    if card1 == 1 || card2 == 1 { // an ace
        scores[0] += 10
        elevens[0] = 1
    }
    probs[0] = 1.0
    var f func(lev int) // recursive closure
    f = func(lev int) {
        for c := 1; c < 11; c++ {
            if decks[lev][c] == 0 {
                continue // card no longer present in deck
            }
            // temporary variables for current level
            deck, score, eleven, prob := decks[lev], scores[lev], elevens[lev], probs[lev]
            score += c  // add card to score
            if c == 1 { // score all aces initially as 11
                score += 10
                eleven++
            }
            prob *= float64(deck[c]) / float64(deck[0])
            if score > 21 && eleven > 0 {
                score -= 10 // bust but can demote an ace
                eleven--
            }
            deck[c]-- // remove card from deck
            deck[0]-- // decrement deck size
            if (eleven == 0 && (score >= 17 || (score >= 13 && uc < 7)) ||
                (eleven == 0 && score == 12 && uc >= 4 && uc <= 6) ||
                (eleven > 0 && score == 18 && uc != 9 && uc != 10) ||
                (eleven > 0 && score >= 19)) && score <= 21 {
                dp := dealerProbs(uc, deck)
                eg += calcGain(score, dp) * prob
            } else if score > 21 && eleven == 0 { // bust
                eg -= prob
            } else {
                lev2 := lev + 1
                decks[lev2], scores[lev2], elevens[lev2], probs[lev2] = deck, score, eleven, prob
                f(lev2) // get another card
            }
        }
    }
    f(0)
    return eg
}

// Calculates gain per unit staked for a given scenario (helper function).
func calcGain(pscore int, dp []float64) float64 {
    eg := 0.0
    switch pscore {
    case 17:
        eg += dp[6]                         // dealer is bust
        eg -= dp[1] + dp[2] + dp[3] + dp[4] // dealer has 18 to 21
    case 18:
        eg += dp[0] + dp[6]         // dealer has 17 or is bust
        eg -= dp[2] + dp[3] + dp[4] // dealer has 19 to 21
    case 19:
        eg += dp[0] + dp[1] + dp[6] // dealer has 17, 18 or is bust
        eg -= dp[3] + dp[4]         // dealer has 20 or 21
    case 20:
        eg += dp[0] + dp[1] + dp[2] + dp[6] // dealer has 17 to 19 or is bust
        eg -= dp[4]                         // dealer has (non-blackjack) 21
    case 21:
        eg += dp[0] + dp[1] + dp[2] + dp[3] + dp[6] // dealer has 17 to 20 or is bust
    case 22: // notional
        eg += 1.5 // player blackjack
    case 23: // notional
        eg -= 1 // player bust, loses stake irrespective of what dealer has
    default: // player has less than 17
        eg += dp[6]       // dealer is bust
        eg -= (1 - dp[6]) // dealer isn't bust
    }
    return eg
}

// Returns player's expected gains per unit staked, for each dealer up-card, after standing.
func stand(card1, card2 int) [10]float64 {
    deck := NewDeck()
    deck[card1]--
    deck[card2]--
    deck[0] = 50
    pscore := card1 + card2 // player score
    if card1 == 1 || card2 == 1 {
        pscore += 10
    }
    var egs [10]float64          // results
    for uc := 1; uc < 11; uc++ { // dealer's up-card
        deck2 := deck
        deck2[uc]--
        deck2[0]--
        dp := dealerProbs(uc, deck2)
        eg := calcGain(pscore, dp) // expected gain for this up-card
        if uc > 1 {
            egs[uc-2] = eg
        } else { // dealer has Ace
            egs[9] = eg // ace comes last in tables
        }
    }
    return egs
}

// Returns player's expected gains per unit staked, for each dealer up-card, after hitting once and
// then either standing (once == true) or continuing as per the round >= 2 tables (once == false).
func hit(card1, card2 int, once bool) [10]float64 {
    deck := NewDeck()
    deck[card1]--
    deck[card2]--
    deck[0] = 50
    var egs [10]float64          // results
    for uc := 1; uc < 11; uc++ { // dealer's up-card
        deck2 := deck
        deck2[uc]--
        deck2[0] = 49
        var peg float64 // player's expected gain for this up-card
        if once {
            peg = playerGain(card1, card2, uc, deck2)
        } else {
            peg = playerGain2(card1, card2, uc, deck2)
        }
        if uc > 1 {
            egs[uc-2] = peg
        } else { // dealer has Ace
            egs[9] = peg
        }
    }
    return egs
}

// Returns player's expected gains per unit oiginally staked, for each dealer up-card, after
// doubling i.e. hitting once and then standing with a doubled stake.
func double(card1, card2 int) [10]float64 {
    egs := hit(card1, card2, true) // hit once and then stand
    for i := 0; i < 10; i++ {
        egs[i] *= 2
    }
    return egs
}

// Returns player's expected gains per unit originally staked, for each dealer up-card, after
// splitting a pair and doubling the stake, getting a second card for each hand  and then continuing
// in accordace with the rounds >= 2 tables. It is assumed that a player cannot double or re-split
// following a split. It is also assumed (in the interests of simplicity) that the expected gains
// for each split hand (after calculating the gains for the first hand as though the second hand
// is not completed) are exactly the same.
func split(card int) [10]float64 {
    deck := NewDeck()
    deck[card] -= 2 // must be a pair
    deck[0] = 50
    var egs [10]float64 // overall results

    // now play a single hand
    score := card
    eleven := 0
    if card == 1 { // an ace
        score = 11
        eleven = 1
    }
    for uc := 1; uc < 11; uc++ { // collect results for each dealer up-card
        if deck[uc] == 0 {
            continue // card no longer present in deck
        }
        deck2 := deck
        deck2[uc]--
        deck2[0]--
        ix := uc - 2
        if ix == -1 {
            ix = 9 // in tables ace comes last
        }
        var peg float64 // player expected gain for this up-card
        // get second player card
        for c := 1; c < 11; c++ {
            if deck2[c] == 0 {
                continue // card no longer present in deck
            }
            prob := float64(deck2[c]) / float64(deck2[0])
            deck3 := deck2
            deck3[c]--
            deck3[0]--
            score2 := score + c
            eleven2 := eleven
            if c == 1 { // score all aces initially as 11
                score2 += 10
                eleven2++
            }
            if score2 == 21 { // player has blackjack & we know dealer hasn't
                peg += 1.5 * prob
                continue
            }
            if score2 > 21 && eleven2 > 0 {
                score2 -= 10 // bust but can demote an ace
                eleven2--
            }
            var action string
            if eleven2 > 0 {
                action = sTable2[score2-12][ix] // use soft strategy table, no doubling
            } else { // including pairs as no re-splitting
                action = hTable2[score2-4][ix] // use hard strategy table, no doubling
            }
            var peg2 float64
            if action == "S" {
                dp := dealerProbs(uc, deck3)
                peg2 = calcGain(score2, dp)
            } else {
                peg2 = playerGain2(card, c, uc, deck3)
            }
            peg += peg2 * prob
        }
        if uc > 1 {
            egs[uc-2] = peg * 2 // allow for both hands in overall results
        } else {
            egs[9] = peg * 2 // ditto
        }
    }
    return egs
}

// Returns the action with the highest expected gain.
func bestAction(ags []ActionGain) string {
    max := ags[0].gain
    maxi := 0
    for i := 1; i < len(ags); i++ {
        if ags[i].gain > max {
            max = ags[i].gain
            maxi = i
        }
    }
    return ags[maxi].action
}

// Prints title and header for a given chart.
func printHeader(title string) {
    fmt.Println(title)
    fmt.Println("P/D     2      3      4      5      6      7      8      9      T      A")
    fmt.Println("--------------------------------------------------------------------------")
}

// Prints header for a pair of cards.
func printPair(c int) {
    if c == 1 {
        fmt.Print("AA   ")
    } else if c == 10 {
        fmt.Print("TT   ")
    } else {
        fmt.Printf("%d%d   ", c, c)
    }
}

// Computed strategy tables.
var (
    hTable  = [15][10]string{} // hard strategy table (round 1)
    sTable  = [8][10]string{}  // soft strategy table (round 1)
    pTable  = [10][10]string{} // pairs strategy table (round 1)
    hTable2 = [18][10]string{} // hard strategy table (round >= 2, no doubling)
    sTable2 = [10][10]string{} // soft strategy table (round >= 2, no doubling)
)

// Simulates 'perDay' blackjack games for 'days' days.
func simulate(perDay, days int) {
    winDays, loseDays, evenDays := 0, 0, 0
    bigWin, bigLoss := 0.0, 0.0
    totalGain, totalStake := 0.0, 0.0
    for d := 1; d <= days; d++ {
        dailyGain, dailyStake := 0.0, 0.0
        for p := 1; p <= perDay; p++ {
            gain, stake := playerPlay()
            dailyGain += gain
            dailyStake += stake
        }
        if dailyGain > 0 {
            winDays++
        } else if dailyGain < 0 {
            loseDays++
        } else {
            evenDays++
        }
        if dailyGain > bigWin {
            bigWin = dailyGain
        } else if -dailyGain > bigLoss {
            bigLoss = -dailyGain
        }
        totalGain += dailyGain
        totalStake += dailyStake
    }
    fmt.Printf("\nAfter playing %d times a day for %d days:\n", perDay, days)
    fmt.Println("Winning days   :", winDays)
    fmt.Println("Losing days    :", loseDays)
    fmt.Println("Breakeven days :", evenDays)
    fmt.Println("Biggest win    :", bigWin)
    fmt.Println("Biggest loss   :", bigLoss)
    if totalGain < 0 {
        fmt.Println("Total loss     :", -totalGain)
        fmt.Println("Total staked   :", totalStake)
        fmt.Printf("Loss %% staked  : %0.3f\n", -totalGain/totalStake*100)
    } else {
        fmt.Println("Total win      :", totalGain)
        fmt.Println("Total staked   :", totalStake)
        fmt.Printf("Win %% staked   : %0.3f\n", totalGain/totalStake*100)
    }
}

// Simulates a dealer's play for a given player's hand and state of deck.
// Returns the player's gain (positive or negative) per unit staked.
func dealerPlay(pscore int, next *int, cards, d []int) float64 {
    dscore := d[0] + d[1]
    aces := 0
    if d[0] == 1 || d[1] == 1 { // dealer has an ace
        dscore += 10
        aces++
    }
    for {
        if dscore > 21 && aces > 0 {
            dscore -= 10 // bust but we can demote an ace
            aces--
        }
        if dscore > 21 {
            return 1 // dealer is bust and player gains stake
        }
        if dscore >= 17 { // dealer must stick on 17 or above, hard or not
            if dscore > pscore {
                return -1 // dealer wins and player loses stake
            } else if dscore == pscore {
                break // player breaks even
            } else {
                return 1 // dealer loses and player gains stake
            }
        }
        nc := cards[*next] // get new card from pack
        *next++
        dscore += nc
        if nc == 1 { // count aces initially as 11
            dscore += 10
            aces++
        }
    }
    return 0
}

// Simulates the playing of a random player's hand according to the strategy tables.
// Returns both the gain (positive or negative) and the stake (1 or 2).
func playerPlay() (float64, float64) {
    perm := rand.Perm(52) // randomizes integers from 0 to 51 inclusive
    cards := make([]int, 52)
    for i, r := range perm {
        card := r/4 + 1
        if card > 10 {
            card = 10
        }
        cards[i] = card
    }
    var p, d []int // player and dealer hands
    // initial deal
    for i, card := range cards[0:4] {
        if i < 2 {
            p = append(p, card)
        } else {
            d = append(d, card)
        }
    }
    next := 4 // index of next card to be dealt

    // check if dealer and/or player have blackjack
    dbj := (d[0] == 1 && d[1] == 10) || (d[0] == 10 && d[1] == 1)
    pbj := (p[0] == 1 && p[1] == 10) || (p[0] == 10 && p[1] == 1)
    if dbj {
        if pbj {
            return 0.0, 1.0 // player neither wins nor loses
        }
        return -1.0, 1.0 // player loses stake
    }
    if pbj {
        return 1.5, 1.0 // player wins 1.5 x stake
    }

    uc := d[0] // dealer's up-card for accessing tables
    if uc == 0 {
        uc = 9 // move ace to last place
    } else {
        uc-- // move others down 1
    }
    stake := 1.0       // player's initial stake
    var fscores [2]int // final player scores (one or, after split, two hands)
    var action string
    var score, aces int

    h := func(hand int) { // processes a 'hit'
        for {
            nc := cards[next] // get new card from pack
            next++
            score += nc
            if nc == 1 { // count aces initially as 11
                score += 10
                aces++
            }
            if score > 21 && aces > 0 {
                score -= 10 // bust but we can demote an ace
                aces--
            }
            if score > 21 {
                fscores[hand] = 22 // player is bust and loses stake
                return
            }
            if action == "D" {
                fscores[hand] = score
                return
            }
            // get further strategy and act accordingly
            if aces == 0 {
                action = hTable2[score-4][uc]
            } else {
                action = sTable2[score-12][uc]
            }
            if action == "S" { // stand
                fscores[hand] = score
                return
            }
        }
    }

    score = p[0] + p[1]
    // get kind of player hand: hard, soft, pair
    var kind string
    if p[0] == p[1] {
        kind = "pair"
    } else if p[0] == 1 || p[1] == 1 {
        kind = "soft"
    } else {
        kind = "hard"
    }
    switch kind {
    case "hard":
        action = hTable[score-5][uc]
    case "soft": // includes one ace
        otherCard := p[0]
        if otherCard == 1 {
            otherCard = p[1]
        }
        score += 10
        aces = 1
        action = sTable[otherCard-2][uc]
    case "pair":
        if p[0] == 1 { // pair of aces
            score += 10
            aces = 2
        }
        action = pTable[p[0]-1][uc]
    }
    switch action {
    case "S": // stand
        fscores[0] = score
    case "H": // hit
        h(0)
    case "D": // double
        h(0)
        stake = 2
    case "P": // split
        for hand := 0; hand < 2; hand++ {
            score = p[0]
            aces = 0
            if score == 1 { // count aces initially as 11
                score = 11
                aces++
            }
            h(hand)
        }
    }
    sum := 0.0
    if fscores[0] < 22 {
        sum += dealerPlay(fscores[0], &next, cards, d) * stake
    } else {
        sum -= 1 * stake // this hand is bust
    }
    if fscores[1] > 0 { // pair
        if fscores[1] < 22 {
            sum += dealerPlay(fscores[1], &next, cards, d)
        } else {
            sum -= 1 // this hand is bust
        }
        stake = 2
    }
    return sum, stake
}

func main() {
    // print dealer probabilities chart
    dealerChart()

    // for hard scores (i.e. different cards, no aces)
    tuples := [][2]int{
        {2, 3},
        {2, 4},
        {2, 5}, {3, 4},
        {2, 6}, {3, 5},
        {2, 7}, {3, 6}, {4, 5},
        {2, 8}, {3, 7}, {4, 6},
        {2, 9}, {3, 8}, {4, 7}, {5, 6},
        {2, 10}, {3, 9}, {4, 8}, {5, 7},
        {3, 10}, {4, 9}, {5, 8}, {6, 7},
        {4, 10}, {5, 9}, {6, 8},
        {5, 10}, {6, 9}, {7, 8},
        {6, 10}, {7, 9},
        {7, 10}, {8, 9},
        {8, 10},
        {9, 10},
    }
    // number of tuples for each player score from 5 to 19
    counts := [15]float64{1, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1}
    // expected gains for each player score & for each dealer up-card
    segs := [15][10]float64{} // if stands
    hegs := [15][10]float64{} // if hits
    degs := [15][10]float64{} // if doubles
    for _, tuple := range tuples {
        i := tuple[0] + tuple[1]
        sg := stand(tuple[0], tuple[1])
        hg := hit(tuple[0], tuple[1], false)
        dg := double(tuple[0], tuple[1])
        for j := 0; j < 10; j++ {
            segs[i-5][j] += sg[j]
            hegs[i-5][j] += hg[j]
            degs[i-5][j] += dg[j]
        }
    }
    // calculate the average per tuple for each score
    for i := 0; i < 15; i++ {
        for j := 0; j < 10; j++ {
            segs[i][j] /= counts[i]
            hegs[i][j] /= counts[i]
            degs[i][j] /= counts[i]
        }
    }

    printHeader("\nHard Chart - Player Expected Gains per unit (Stand)")
    for i := 5; i < 20; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", segs[i-5][j])
        }
        fmt.Println()
    }

    printHeader("\nHard Chart - Player Expected Gains per unit (Hit)")
    for i := 5; i < 20; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", hegs[i-5][j])
        }
        fmt.Println()
    }

    printHeader("\nHard Chart - Player Expected Gains per original unit (Double)")
    for i := 5; i < 20; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", degs[i-5][j])
        }
        fmt.Println()
    }

    printHeader("\nHard Chart - Player Strategy (Round 1)")
    for i := 5; i < 20; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            ags := []ActionGain{{"S", segs[i-5][j]}, {"H", hegs[i-5][j]}, {"D", degs[i-5][j]}}
            action := bestAction(ags)
            hTable[i-5][j] = action
            fmt.Printf("%4s   ", action)
        }
        fmt.Println()
    }

    // for hard scores (no aces) - after round 1 (no doubling or splitting)
    // based on hard table figures (round 1) with scores of 4, 20, and 21 added
    segs2 := [18][10]float64{} // expected gains if stands
    hegs2 := [18][10]float64{} // expected gains if hits
    for i := 5; i < 20; i++ {
        segs2[i-4] = segs[i-5]
        hegs2[i-4] = hegs[i-5]
    }
    sg4, hg4 := stand(2, 2), hit(2, 2, false)
    sg20, hg20 := stand(10, 10), hit(10, 10, false)
    sg21, hg21 := stand(1, 10), hit(1, 10, false)
    for j := 0; j < 10; j++ {
        segs2[0][j] += sg4[j]
        hegs2[0][j] += hg4[j]
        segs2[16][j] += sg20[j]
        hegs2[16][j] += hg20[j]
        segs2[17][j] += sg21[j]
        hegs2[17][j] += hg21[j]
    }

    printHeader("\nHard Chart - Player Strategy (Round >= 2, No Doubling)")
    for i := 4; i < 22; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            action := "S"
            if hegs2[i-4][j] > segs2[i-4][j] {
                action = "H"
            }
            hTable2[i-4][j] = action
            fmt.Printf("%4s   ", action)
        }
        fmt.Println()
    }

    // for soft scores (i.e. including exactly one ace)

    // expected gains for each player second card (2 to 9) & for each dealer up-card
    segs3 := [8][10]float64{} // if stands
    hegs3 := [8][10]float64{} // if hits
    degs3 := [8][10]float64{} // if doubles
    for c := 2; c < 10; c++ {
        sg := stand(1, c)
        hg := hit(1, c, false)
        dg := double(1, c)
        for j := 0; j < 10; j++ {
            segs3[c-2][j] += sg[j]
            hegs3[c-2][j] += hg[j]
            degs3[c-2][j] += dg[j]
        }
    }

    printHeader("\nSoft Chart - Player Expected Gains per unit (Stand)")
    for c := 2; c < 10; c++ {
        fmt.Printf("A%d   ", c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", segs3[c-2][j])
        }
        fmt.Println()
    }

    printHeader("\nSoft Chart - Player Expected Gains per unit (Hit)")
    for c := 2; c < 10; c++ {
        fmt.Printf("A%d   ", c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", hegs3[c-2][j])
        }
        fmt.Println()
    }

    printHeader("\nSoft Chart - Player Expected Gains per original unit (Double)")
    for c := 2; c < 10; c++ {
        fmt.Printf("A%d   ", c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", degs3[c-2][j])
        }
        fmt.Println()
    }

    printHeader("\nSoft Chart - Player Strategy (Round 1)")
    for c := 2; c < 10; c++ {
        fmt.Printf("A%d   ", c)
        for j := 0; j < 10; j++ {
            ags := []ActionGain{{"S", segs3[c-2][j]}, {"H", hegs3[c-2][j]}, {"D", degs3[c-2][j]}}
            action := bestAction(ags)
            sTable[c-2][j] = action
            fmt.Printf("%4s   ", action)
        }
        fmt.Println()
    }

    // for soft scores (at least one ace) - after round 1 (no doubling or splitting)
    // based on soft table figures (round 1) with scores of 12 and 21 added
    // assumes one ace counted as 11
    segs4 := [10][10]float64{} // expected gains if stands
    hegs4 := [10][10]float64{} // expected gains if hits
    for i := 1; i < 9; i++ {
        segs4[i] = segs3[i-1]
        hegs4[i] = hegs3[i-1]
    }
    sg12, hg12 := stand(1, 1), hit(1, 1, false)
    for j := 0; j < 10; j++ {
        segs4[0][j] += sg12[j]
        hegs4[0][j] += hg12[j]
        segs4[9][j] += sg21[j]
        hegs4[9][j] += hg21[j]
    }

    printHeader("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)")
    for i := 12; i < 22; i++ {
        fmt.Printf("%2d   ", i)
        for j := 0; j < 10; j++ {
            action := "S"
            if hegs4[i-12][j] > segs4[i-12][j] {
                action = "H"
            }
            sTable2[i-12][j] = action
            fmt.Printf("%4s   ", action)
        }
        fmt.Println()
    }

    // for pairs

    // expected gains for each pair (A to 10) & for each dealer up-card
    segs5 := [10][10]float64{} // if stands
    hegs5 := [10][10]float64{} // if hits
    degs5 := [10][10]float64{} // if doubles
    pegs5 := [10][10]float64{} // if splits
    for c := 1; c < 11; c++ {
        sg := stand(c, c)
        hg := hit(c, c, false)
        dg := double(c, c)
        pg := split(c)
        for j := 0; j < 10; j++ {
            segs5[c-1][j] += sg[j]
            hegs5[c-1][j] += hg[j]
            degs5[c-1][j] += dg[j]
            pegs5[c-1][j] += pg[j]
        }
    }

    printHeader("\nPairs Chart - Player Expected Gains per unit (Stand)")
    for c := 1; c < 11; c++ {
        printPair(c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", segs5[c-1][j])
        }
        fmt.Println()
    }

    printHeader("\nPairs Chart - Player Expected Gains per unit (Hit)")
    for c := 1; c < 11; c++ {
        printPair(c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", hegs5[c-1][j])
        }
        fmt.Println()
    }

    printHeader("\nPairs Chart - Player Expected Gains per original unit (Double)")
    for c := 1; c < 11; c++ {
        printPair(c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", degs5[c-1][j])
        }
        fmt.Println()
    }

    printHeader("\nPairs Chart - Player Expected Gains per original unit (Split)")
    for c := 1; c < 11; c++ {
        printPair(c)
        for j := 0; j < 10; j++ {
            fmt.Printf("% 0.3f ", pegs5[c-1][j])
        }
        fmt.Println()
    }

    printHeader("\nPairs Chart - Player Strategy (Round 1)")
    for c := 1; c < 11; c++ {
        printPair(c)
        for j := 0; j < 10; j++ {
            ags := []ActionGain{{"S", segs5[c-1][j]}, {"H", hegs5[c-1][j]}, {"D", degs5[c-1][j]},
                {"P", pegs5[c-1][j]}}
            action := bestAction(ags)
            pTable[c-1][j] = action
            fmt.Printf("%4s   ", action)
        }
        fmt.Println()
    }
    rand.Seed(time.Now().UnixNano())
    // do 10 years of simulations
    for i := 1; i <= 10; i++ {
        fmt.Printf("\nSimulation for Year %d:\n", i)
        simulate(50, 365)
    }
}
