import "random"    for Random
import "./array"   for Array, ArrayType
import "./dynamic" for Struct
import "./fmt"     for Fmt
import "./iterate"   for Indexed

var Rand = Random.new()

// 0: deck size, 1 to 10: number of cards of that denomination
var Deck = ArrayType.create("Deck", 11, 0)

var ActionGain = Struct.create("ActionGain", ["action", "gain"])

var NewDeck = Fn.new { Deck.fit([52, 4, 4, 4, 4, 4, 4, 4, 4, 4, 16]) }

// Computed strategy tables
var HTable  = List.filled(15, null)  // hard strategy table (round 1)
var STable  = List.filled( 8, null)  // soft strategy table (round 1)
var PTable  = List.filled(10, null)  // pairs strategy table (round 1)
var HTable2 = List.filled(18, null)  // hard strategy table (round >= 2, no doubling)
var STable2 = List.filled(10, null)  // soft strategy table (round >= 2, no doubling)

for (i in 0..14) HTable[i]  = List.filled(10, null)
for (i in 0..7)  STable[i]  = List.filled(10, null)
for (i in 0..9)  PTable[i]  = List.filled(10, null)
for (i in 0..17) HTable2[i] = List.filled(10, null)
for (i in 0..9)  STable2[i] = List.filled(10, null)

class Blackjack {
    // Returns probabilities of dealer eventually getting:
    // 0: 17, 1: 18, 2: 19, 3: 20, 4: 21 (non-blackjack), 5: blackjack (nil), 6: bust.
    // It is assumed that the dealer has already checked for blackjack, that one deck is used
    // and that the dealer stands on 'soft' 17.
    static dealerProbs(upCard, startDeck) {
        var res     = List.filled(7, 0)     // results
        var decks   = List.filled(9, null)  // decks for each level
        var scores  = List.filled(9, 0)     // scores for each level
        var elevens = List.filled(9, 0)     // number of aces for each level scored as 11
        var probs   = List.filled(9, 0)     // probs for each level
        decks[0]    = startDeck.toList
        scores[0]   = upCard
        if (upCard == 1) {  // an ace
            scores[0] = 11
            elevens[0] = 1
        }
        probs[0] = 1
        var f  // recursive closure
        f = Fn.new { |lev|
            for (c in 1..10) {
                if (decks[lev][c] == 0) continue  // card no longer present in deck
                // temporary variables for current level
                var deck   = decks[lev].toList
                var score  = scores[lev]
                var eleven = elevens[lev]
                var prob   = probs[lev]
                score = score + c  // add card to score
                if (c == 1) {  // score all aces initially as 11
                    score = score + 10
                    eleven = eleven + 1
                }
                prob = prob * deck[c] / deck[0]
                if (score > 21 && eleven > 0) {
                    score = score - 10  // bust but can demote an ace
                    eleven = eleven - 1
                }
                if (lev == 0 && ((upCard == 1 && c == 10) || (upCard == 10 && c == 1))) {
                    res[5] = res[5] + prob  // blackjack, allow for now
                } else if (score >= 17 && score <= 21) {
                    res[score-17] = res[score-17] + prob  // 17 to (non-blackjack) 21
                } else if (score > 21 && eleven == 0) {
                    res[6] = res[6] + prob  // bust
                } else {
                    deck[c] = deck[c] - 1  // remove card from deck
                    deck[0] = deck[0] - 1  // decrement deck size
                    var lev2 = lev + 1
                    decks[lev2]   = deck
                    scores[lev2]  = score
                    elevens[lev2] = eleven
                    probs[lev2]   = prob
                    f.call(lev2)  // get another card
                }
            }
        }
        f.call(0)
        // but can't have blackjack, so adjust probabilities accordingly
        var pnbj = 1 - res[5]
        for (i in 0..6) res[i] = res[i] / pnbj
        res[5] = 0
        return res
    }

    // Prints chart of dealer probabilities (as a check against an external source).
    static dealerChart() {
        System.print("Dealer Probabilities, Stands on Soft 17, 1 Deck, U.S Rules")
        System.print("Up Card     17        18        19        20        21       Bust")
        System.print("-------------------------------------------------------------------")
        var deck = NewDeck.call()
        deck[0] = 51
        for (uc in 1..10) {
            var deck2 = deck.toList
            deck2[uc] = deck2[uc] - 1
            var dp = dealerProbs(uc, deck2)
            if (uc > 1) {
                Fmt.write("$3d      ", uc)
            } else {
               System.write("Ace      ")
            }
            Fmt.lprint("$f  $f  $f  $f  $f  $f", [dp[0], dp[1], dp[2], dp[3], dp[4], dp[6]])
        }
    }

    // Returns player's expected gain per unit staked after hitting once and then standing.
    static playerGain(card1, card2, uc, startDeck) {
        var eg = 0
        var deck = startDeck.toList
        var score = card1 + card2
        var eleven = false
        if (card1 == 1 || card2 == 1) {  // an ace
            score = score + 10
            eleven = true
        }
        for (c in 1..10) {  // get another card
            if (deck[c] == 0) continue  // card no longer present in deck
            // temporary variables for current card
            var deck2   = deck.toList
            var score2  = score
            var eleven2 = eleven
            score2 = score2 + c  // add card to score
            if (c == 1) {  // score all aces initially as 11
                score2 = score2 + 10
                eleven2 = true
            }
            var prob = deck2[c] / deck2[0]
            deck2[c] = deck2[c] - 1  // remove card from deck
            deck2[0] = deck2[0] - 1  // decrement deck size
            if (score2 > 21 && eleven2) {
                score2 = score2 - 10  // bust but can demote an ace
            }
            if (score2 <= 21) {
                var dp = dealerProbs(uc, deck2)
                eg = eg + calcGain(score2, dp) * prob
            } else {  // bust
                eg = eg - prob
            }
        }
        return eg
    }

    // Returns player's expected gain per unit staked after hitting once and then continuing
    // in accordance with the tables for rounds >= 2.
    static playerGain2(card1, card2, uc, startDeck) {
        var eg      = 0                     // result
        var decks   = List.filled(9, null)  // decks for each level
        var scores  = List.filled(9, 0)     // scores for each level
        var elevens = List.filled(9, 0)     // number of aces for each level scored as 11
        var probs   = List.filled(9, 0)     // probs for each level
        decks[0]    = startDeck.toList
        scores[0]   = card1 + card2
        if (card1 == 1 || card2 == 1) {  // an ace
            scores[0] = scores[0] + 10
            elevens[0] = 1
        }
        probs[0] = 1
        var f  // recursive closure
        f = Fn.new { |lev|
            for (c in 1..10) {
                if (decks[lev][c] == 0) continue  // card no longer present in deck
                // temporary variables for current level
                var deck   = decks[lev].toList
                var score  = scores[lev]
                var eleven = elevens[lev]
                var prob   = probs[lev]
                score = score + c  // add card to score
                if (c == 1) {  // score all aces initially as 11
                    score = score + 10
                    eleven = eleven + 1
                }
                prob = prob * deck[c] / deck[0]
                if (score > 21 && eleven > 0) {
                    score = score - 10  // bust but can demote an ace
                    eleven = eleven - 1
                }
                deck[c] = deck[c] - 1  // remove card from deck
                deck[0] = deck[0] - 1  // decrement deck size
                if ((eleven == 0 && (score >= 17 || (score >= 13 && uc < 7)) ||
                    (eleven == 0 && score == 12 && uc >= 4 && uc <= 6) ||
                    (eleven > 0 && score == 18 && uc != 9 && uc != 10) ||
                    (eleven > 0 && score >= 19)) && score <= 21) {
                        var dp = dealerProbs(uc, deck)
                        eg = eg + calcGain(score, dp) * prob
                } else if (score > 21 && eleven == 0) {  // bust
                    eg = eg - prob
                } else {
                    var lev2 = lev + 1
                    decks[lev2]   = deck
                    scores[lev2]  = score
                    elevens[lev2] = eleven
                    probs[lev2]   = prob
                    f.call(lev2)  // get another card
                }
            }
        }
        f.call(0)
        return eg
    }

    // Calculates gain per unit staked for a given scenario (helper function).
    static calcGain(pscore, dp) {
        var eg = 0
        if (pscore == 17) {
            eg = eg + dp[6]                         // dealer is bust
            eg = eg - dp[1] - dp[2] - dp[3] - dp[4] // dealer has 18 to 21
        } else if (pscore == 18) {
            eg = eg + dp[0] + dp[6]          // dealer has 17 or is bust
            eg = eg - dp[2] - dp[3] - dp[4]  // dealer has 19 to 21
        } else if (pscore == 19) {
            eg = eg + dp[0] + dp[1] + dp[6]  // dealer has 17, 18 or is bust
            eg = eg - dp[3] - dp[4]          // dealer has 20 or 21
        } else if (pscore == 20) {
            eg = eg + dp[0] + dp[1] + dp[2] + dp[6]  // dealer has 17 to 19 or is bust
            eg = eg - dp[4]                          // dealer has (non-blackjack) 21
        } else if (pscore == 21) {
            eg = eg + dp[0] + dp[1] + dp[2] + dp[3] + dp[6]  // dealer has 17 to 20 or is bust
        } else if (pscore == 22) {  // notional
            eg = eg + 1.5  // player blackjack
        } else if (pscore == 23) {  // notional
            eg = eg - 1  // player bust, loses stake irrespective of what dealer has
        } else {  // player has less than 17
            eg = eg + dp[6]        // dealer is bust
            eg = eg - (1 - dp[6])  // dealer isn't bust
        }
        return eg
    }

    // Returns player's expected gains per unit staked, for each dealer up-card, after standing.
    static stand(card1, card2) {
        var deck = NewDeck.call()
        deck[card1] = deck[card1] - 1
        deck[card2] = deck[card2] - 1
        deck[0] = 50
        var pscore = card1 + card2  // player score
        if (card1 == 1 || card2 == 1) pscore = pscore + 10
        var egs = List.filled(10, 0)  // results
        for (uc in 1..10) {         // dealer's up-card
            var deck2 = deck.toList
            deck2[uc] = deck2[uc] - 1
            deck2[0] = deck2[0] - 1
            var dp = dealerProbs(uc, deck2)
            var eg = calcGain(pscore, dp)  // expected gain for this up-card
            if (uc > 1) {
                egs[uc-2] = eg
            } else {  // dealer has Ace
                egs[9] = eg  // ace comes last in tables
            }
        }
        return egs
    }

    // Returns player's expected gains per unit staked, for each dealer up-card, after
    // hitting once and then either standing (once == true) or continuing
    // as per the round >= 2 tables (once == false).
    static hit(card1, card2, once) {
        var deck = NewDeck.call()
        deck[card1] = deck[card1] - 1
        deck[card2] = deck[card2] - 1
        deck[0] = 50
        var egs = List.filled(10, 0)  // results
        for (uc in 1..10) {           // dealer's up-card
            var deck2 = deck.toList
            deck2[uc] = deck2[uc] - 1
            deck2[0] = 49
            var peg = once ? playerGain (card1, card2, uc, deck2) :
                             playerGain2(card1, card2, uc, deck2)
            if (uc > 1) {
                egs[uc-2] = peg
            } else {  // dealer has Ace
                egs[9] = peg
            }
        }
        return egs
    }

    // Returns player's expected gains per unit oiginally staked, for each dealer up-card,
    // after doubling i.e. hitting once and then standing with a doubled stake.
    static double(card1, card2) {
        var egs = hit(card1, card2, true)  // hit once and then stand
        for (i in 0..9) egs[i] = egs[i] * 2
        return egs
    }

    // Returns player's expected gains per unit originally staked, for each dealer up-card,
    // after splitting a pair and doubling the stake, getting a second card for each hand
    // and then continuing in accordance with the rounds >= 2 tables. It is assumed that a
    // player cannot double or re-split following a split. It is also assumed
    // (in the interests of simplicity) that the expected gains for each split hand (after
    // calculating the gains for the first hand as though the second hand is not completed)
    // are exactly the same.
    static split(card) {
        var deck = NewDeck.call()
        deck[card] = deck[card] - 2  // must be a pair
        deck[0] = 50
        var egs = List.filled(10, 0)  // overall results

        // now play a single hand
        var score = card
        var eleven = 0
        if (card == 1) {  // an ace
            score = 11
            eleven = 1
        }
        for (uc in 1..10) {  // collect results for each dealer up-card
            if (deck[uc] == 0) continue  // card no longer present in deck
            var deck2 = deck.toList
            deck2[uc] = deck2[uc] - 1
            deck2[0]  = deck2[0] - 1
            var ix = uc - 2
            if (ix  == -1) ix = 9  // in tables ace comes last
            var peg = 0  // player expected gain for this up-card
            // get second player card
            for (c in 1..10) {
                if (deck2[c] == 0) continue  // card no longer present in deck
                var prob = deck2[c] / deck2[0]
                var deck3 = deck2.toList
                deck3[c] = deck3[c] - 1
                deck3[0] = deck3[0] - 1
                var score2 = score + c
                var eleven2 = eleven
                if (c == 1) {  // score all aces initially as 11
                    score2 = score2 + 10
                    eleven2 = eleven2 + 1
                }
                if (score2 == 21) {  // player has blackjack & we know dealer hasn't
                    peg = peg + 1.5 * prob
                    continue
                }
                if (score2 > 21 && eleven2 > 0) {
                    score2 = score2 - 10  // bust but can demote an ace
                    eleven2 = eleven2 - 1
                }
                var action
                if (eleven2 > 0) {
                    action = STable2[score2-12][ix]  // use soft strategy table, no doubling
                } else {  // including pairs as no re-splitting
                    action = HTable2[score2-4][ix]   // use hard strategy table, no doubling
                }
                var peg2
                if (action == "S") {
                    var dp = dealerProbs(uc, deck3)
                    peg2 = calcGain(score2, dp)
                } else {
                    peg2 = playerGain2(card, c, uc, deck3)
                }
                peg = peg + peg2 * prob
            }
            if (uc > 1) {
                egs[uc-2] = peg * 2 // allow for both hands in overall results
            } else {
                egs[9] = peg * 2    // ditto
            }
        }
        return egs
    }

    // Returns the action with the highest expected gain.
    static bestAction(ags) {
        var max = ags[0].gain
        var maxi = 0
        for (i in 1...ags.count) {
            if (ags[i].gain > max) {
                max = ags[i].gain
                maxi = i
            }
        }
        return ags[maxi].action
    }

    // Prints title and header for a given chart.
    static printHeader(title) {
        System.print(title)
        System.print("P/D     2      3      4      5      6      7      8      9      T      A")
        System.print("--------------------------------------------------------------------------")
    }

    // Prints header for a pair of cards.
    static printPair(c) {
        if (c == 1) {
            System.write("AA   ")
        } else if (c == 10) {
            System.write("TT   ")
        } else {
            Fmt.write("$d$d   ", c, c)
        }
    }

    // Simulates 'perDay' blackjack games for 'days' days.
    static simulate(perDay, days) {
        var winDays  = 0
        var loseDays = 0
        var evenDays = 0
        var bigWin   = 0
        var bigLoss  = 0
        var totGain  = 0
        var totStake = 0
        for (d in 1..days) {
            var dailyGain  = 0
            var dailyStake = 0
            for (p in 1..perDay) {
                var gs = playerPlay()
                dailyGain  = dailyGain + gs[0]
                dailyStake = dailyStake + gs[1]
            }
            if (dailyGain > 0) {
                winDays = winDays + 1
            } else if (dailyGain < 0) {
                loseDays = loseDays + 1
            } else {
                evenDays = evenDays + 1
            }
            if (dailyGain > bigWin) {
                bigWin = dailyGain
            } else if (-dailyGain > bigLoss) {
                bigLoss = -dailyGain
            }
            totGain  = totGain + dailyGain
            totStake = totStake + dailyStake
        }
        Fmt.print("\nAfter playing $d times a day for $d days:", perDay, days)
        Fmt.print("Winning days   : $d", winDays)
        Fmt.print("Losing days    : $d", loseDays)
        Fmt.print("Breakeven days : $d", evenDays)
        Fmt.print("Biggest win    : $h", bigWin)
        Fmt.print("Biggest loss   : $h", bigLoss)
        if (totGain < 0) {
            Fmt.print("Total loss     : $h", -totGain)
            Fmt.print("Total staked   : $h", totStake)
            Fmt.print("Loss \% staked  : $0.3f", -totGain/totStake*100)
        } else {
            Fmt.print("Total win      : $h", totGain)
            Fmt.print("Total staked   : $h", totStake)
            Fmt.print("Win \% staked   : $0.3f", totGain/totStake*100)
        }
    }

    // Simulates a dealer's play for a given player's hand and state of deck.
    // Returns the player's gain (positive or negative) per unit staked.
    static dealerPlay(pscore, next, cards, d) {
        var dscore = d[0] + d[1]
        var aces = 0
        if (d[0] == 1 || d[1] == 1) { // dealer has an ace
            dscore = dscore + 10
            aces = aces + 1
        }
        while (true) {
            if (dscore > 21 && aces > 0) {
                dscore = dscore - 10  // bust but we can demote an ace
                aces = aces - 1
            }
            if (dscore > 21) {
                return [1, next]  // dealer is bust and player gains stake
            }
            if (dscore >= 17) {  // dealer must stick on 17 or above, hard or not
                if (dscore > pscore) {
                    return [-1, next]  // dealer wins and player loses stake
                } else if (dscore == pscore) {
                    break  // player breaks even
                } else {
                    return [1, next]  // dealer loses and player gains stake
                }
            }
            var nc = cards[next] // get new card from pack
            next = next + 1
            dscore = dscore + nc
            if (nc == 1) {  // count aces initially as 11
                dscore = dscore + 10
                aces = aces + 1
            }
        }
        return [0, next]
    }

    // Simulates the playing of a random player's hand according to the strategy tables.
    // Returns both the gain (positive or negative) and the stake (1 or 2).
    static playerPlay() {
        var perm = (0..51).toList
        Rand.shuffle(perm) // randomizes integers from 0 to 51 inclusive
        var cards = List.filled(52, 0)
        for (se in Indexed.new(perm)) {
            var card = (se.value/4).floor + 1
            if (card > 10) card = 10
            cards[se.index] = card
        }
        var p = []  // player hand
        var d = []  // dealer hand
        // initial deal
        for (se in Indexed.new(cards[0..3])) {
            if (se.index < 2) {
                p.add(se.value)
            } else {
                d.add(se.value)
            }
        }
        var next = 4  // index of next card to be dealt

        // check if dealer and/or player have blackjack
        var dbj = (d[0] == 1 && d[1] == 10) || (d[0] == 10 && d[1] == 1)
        var pbj = (p[0] == 1 && p[1] == 10) || (p[0] == 10 && p[1] == 1)
        if (dbj) {
            if (pbj) return [0, 1]  // player neither wins nor loses
            return [-1, 1]  // player loses stake
        }
        if (pbj) return [1.5, 1]  // player wins 1.5 x stake
        var uc = d[0]  // dealer's up-card for accessing tables
        if (uc == 0) {
            uc = 9  // move ace to last place
        } else {
            uc = uc - 1  // move others down 1
        }
        var stake = 1      // player's initial stake
        var fscores = List.filled(2, 0)  // final player scores (one or, after split, two hands)
        var action = ""
        var score = 0
        var aces  = 0

        var h = Fn.new { |hand|  // processes a 'hit'
            while (true) {
                var nc = cards[next]  // get new card from pack
                next = next + 1
                score = score + nc
                if (nc == 1) {  // count aces initially as 11
                    score = score + 10
                    aces= aces + 1
                }
                if (score > 21 && aces > 0) {
                    score = score - 10  // bust but we can demote an ace
                    aces = aces - 1
                }
                if (score > 21) {
                    fscores[hand] = 22 // player is bust and loses stake
                    return
                }
                if (action == "D") {
                    fscores[hand] = score
                    return
                }
                // get further strategy and act accordingly
                if (aces == 0) {
                    action = HTable2[score-4][uc]
                } else {
                    action = STable2[score-12][uc]
                }
                if (action == "S") {  // stand
                    fscores[hand] = score
                    return
                }
            }
        }

        score = p[0] + p[1]
        // get kind of player hand: hard, soft, pair
        var kind
        if (p[0] == p[1]) {
            kind = "pair"
        } else if (p[0] == 1 || p[1] == 1) {
            kind = "soft"
        } else {
            kind = "hard"
        }
        if (kind == "hard") {
            action = HTable[score-5][uc]
        } else if (kind == "soft") {  // includes one ace
            var otherCard = p[0]
            if (otherCard == 1) otherCard = p[1]
            score = score + 10
            aces = 1
            action = STable[otherCard-2][uc]
        } else if (kind == "pair") {
            if (p[0] == 1) {  // pair of aces
                score = score + 10
                aces = 2
            }
            action = PTable[p[0]-1][uc]
        }
        if (action == "S") {  // stand
            fscores[0] = score
        } else if (action == "H") {  // hit
            h.call(0)
        } else if (action == "D") {  // double
            h.call(0)
            stake = 2
        } else if (action == "P") {  // split
            for (hand in 0..1) {
                score = p[0]
                aces = 0
                if (score == 1) {  // count aces initially as 11
                    score = 11
                    aces = aces + 1
                }
                h.call(hand)
            }
        }
        var sum = 0
        if (fscores[0] < 22) {
            var res = dealerPlay(fscores[0], next, cards, d)
            sum = sum + res[0] * stake
            next = res[1]
        } else {
            sum = sum - stake  // this hand is bust
        }
        if (fscores[1] > 0) {  // pair
            if (fscores[1] < 22) {
                var res = dealerPlay(fscores[1], next, cards, d)
                sum = sum + res[0]
                next = res[1]
            } else {
                sum = sum - 1 // this hand is bust
            }
            stake = 2
        }
        return [sum, stake]
    }

    static main() {
        // print dealer probabilities chart
        dealerChart()

        // for hard scores (i.e. different cards, no aces)
        var tuples = [
            [2,  3],
            [2,  4],
            [2,  5], [3, 4],
            [2,  6], [3, 5],
            [2,  7], [3, 6], [4, 5],
            [2,  8], [3, 7], [4, 6],
            [2,  9], [3, 8], [4, 7], [5, 6],
            [2, 10], [3, 9], [4, 8], [5, 7],
            [3, 10], [4, 9], [5, 8], [6, 7],
            [4, 10], [5, 9], [6, 8],
            [5, 10], [6, 9], [7, 8],
            [6, 10], [7, 9],
            [7, 10], [8, 9],
            [8, 10],
            [9, 10]
        ]

        // number of tuples for each player score from 5 to 19
        var counts = Array.from([1, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1])
        // expected gains for each player score & for each dealer up-card
        var segs = List.filled(15, null)  // if stands
        var hegs = List.filled(15, null)  // if hits
        var degs = List.filled(15, null)  // if doubles
        for (i in 0..14) {
            segs[i] = List.filled(10, 0)
            hegs[i] = List.filled(10, 0)
            degs[i] = List.filled(10, 0)
        }
        for (tuple in tuples) {
            var i  = tuple[0] + tuple[1]
            var sg = stand(tuple[0], tuple[1])
            var hg = hit(tuple[0], tuple[1], false)
            var dg = double(tuple[0], tuple[1])
            for (j in 0..9) {
                segs[i-5][j] = segs[i-5][j] + sg[j]
                hegs[i-5][j] = hegs[i-5][j] + hg[j]
                degs[i-5][j] = degs[i-5][j] + dg[j]
            }
        }

        // calculate the average per tuple for each score
        for (i in 0..14) {
            for (j in 0..9) {
                segs[i][j] = segs[i][j] / counts[i]
                hegs[i][j] = hegs[i][j] / counts[i]
                degs[i][j] = degs[i][j] / counts[i]
            }
        }

        printHeader("\nHard Chart - Player Expected Gains per unit (Stand)")
        for (i in 5..19) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) Fmt.write("$6.3f ", segs[i-5][j])
            System.print()
        }

        printHeader("\nHard Chart - Player Expected Gains per unit (Hit)")
        for (i in 5..19) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) Fmt.write("$6.3f ", hegs[i-5][j])
            System.print()
        }

        printHeader("\nHard Chart - Player Expected Gains per original unit (Double)")
        for (i in 5..19) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) Fmt.write("$6.3f ", degs[i-5][j])
            System.print()
        }

        printHeader("\nHard Chart - Player Strategy (Round 1)")
        for (i in 5..19) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) {
                var ags = [
                    ActionGain.new("S", segs[i-5][j]),
                    ActionGain.new("H", hegs[i-5][j]),
                    ActionGain.new("D", degs[i-5][j])
                ]
                var action = bestAction(ags)
                HTable[i-5][j] = action
                Fmt.write("$4s   ", action)
            }
            System.print()
        }

        // for hard scores (no aces) - after round 1 (no doubling or splitting)
        // based on hard table figures (round 1) with scores of 4, 20, and 21 added
        var segs2 = List.filled(18, null)  // expected gains if stands
        var hegs2 = List.filled(18, null)  // expected gains if hits
        for (i in 0..17) {
            segs2[i] = List.filled(10, 0)
            hegs2[i] = List.filled(10, 0)
        }
        for (i in 5..19) {
            segs2[i-4] = segs[i-5]
            hegs2[i-4] = hegs[i-5]
        }
        var sg4  = stand(2, 2)
        var hg4  = hit(2, 2, false)
        var sg20 = stand(10, 10)
        var hg20 = hit(10, 10, false)
        var sg21 = stand(1, 10)
        var hg21 = hit(1, 10, false)
        for (j in 0..9) {
            segs2[0][j]  = segs2[0][j]  + sg4[j]
            hegs2[0][j]  = hegs2[0][j]  + hg4[j]
            segs2[16][j] = segs2[16][j] + sg20[j]
            hegs2[16][j] = hegs2[16][j] + hg20[j]
            segs2[17][j] = segs2[17][j] + sg21[j]
            hegs2[17][j] = hegs2[17][j] + hg21[j]
        }

        printHeader("\nHard Chart - Player Strategy (Round >= 2, No Doubling)")
        for (i in 4..21) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) {
                var action = "S"
                if (hegs2[i-4][j] > segs2[i-4][j]) action = "H"
                HTable2[i-4][j] = action
                Fmt.write("$4s   ", action)
            }
            System.print()
        }

        /* for soft scores (i.e. including exactly one ace) */

        // expected gains for each player second card (2 to 9) & for each dealer up-card
        var segs3 = List.filled(8, null)  // if stands
        var hegs3 = List.filled(8, null)  // if hits
        var degs3 = List.filled(8, null)  // if doubles
        for (i in 0..7) {
            segs3[i] = List.filled(10, 0)
            hegs3[i] = List.filled(10, 0)
            degs3[i] = List.filled(10, 0)
        }
        for (c in 2..9) {
            var sg = stand(1, c)
            var hg = hit(1, c, false)
            var dg = double(1, c)
            for (j in 0..9) {
                segs3[c-2][j] = segs3[c-2][j] + sg[j]
                hegs3[c-2][j] = hegs3[c-2][j] + hg[j]
                degs3[c-2][j] = degs3[c-2][j] + dg[j]
            }
        }

        printHeader("\nSoft Chart - Player Expected Gains per unit (Stand)")
        for (c in 2..9) {
            Fmt.write("A$d   ", c)
            for (j in 0..9) Fmt.write("$6.3f ", segs3[c-2][j])
            System.print()
        }

        printHeader("\nSoft Chart - Player Expected Gains per unit (Hit)")
        for (c in 2..9) {
            Fmt.write("A$d   ", c)
            for (j in 0..9) Fmt.write("$6.3f ", hegs3[c-2][j])
            System.print()
        }

        printHeader("\nSoft Chart - Player Expected Gains per unit (Double)")
        for (c in 2..9) {
            Fmt.write("A$d   ", c)
            for (j in 0..9) Fmt.write("$6.3f ", degs3[c-2][j])
            System.print()
        }

        printHeader("\nSoft Chart - Player Strategy (Round 1)")
        for (c in 2..9) {
            Fmt.write("A$d   ", c)
            for (j in 0..9) {
                var ags = [
                    ActionGain.new("S", segs3[c-2][j]),
                    ActionGain.new("H", hegs3[c-2][j]),
                    ActionGain.new("D", degs3[c-2][j])
                ]
                var action = bestAction(ags)
                STable[c-2][j] = action
                Fmt.write("$4s   ", action)
            }
            System.print()
        }

        // for soft scores (at least one ace) - after round 1 (no doubling or splitting)
        // based on soft table figures (round 1) with scores of 12 and 21 added
        // assumes one ace counted as 11
        var segs4 = List.filled(10, null)  // expected gains if stands
        var hegs4 = List.filled(10, null)  // expected gains if hits
        for (i in 0..9) {
            segs4[i] = List.filled(10, 0)
            hegs4[i] = List.filled(10, 0)
        }
        for (i in 1..8) {
            segs4[i] = segs3[i-1]
            hegs4[i] = hegs3[i-1]
        }
        var sg12 = stand(1, 1)
        var hg12 = hit(1, 1, false)
        for (j in 0..9) {
            segs4[0][j] = segs4[0][j] + sg12[j]
            hegs4[0][j] = hegs4[0][j] + hg12[j]
            segs4[9][j] = segs4[9][j] + sg21[j]
            hegs4[9][j] = hegs4[9][j] + hg21[j]
        }

        printHeader("\nSoft Chart - Player Strategy (Round >= 2, No Doubling)")
        for (i in 12..21) {
            Fmt.write("$2d   ", i)
            for (j in 0..9) {
                var action = "S"
                if (hegs4[i-12][j] > segs4[i-12][j]) action = "H"
                STable2[i-12][j] = action
                Fmt.write("$4s   ", action)
            }
            System.print()
        }

        /* for pairs */

        // expected gains for each pair (A to 10) & for each dealer up-card
        var segs5 = List.filled(10, null)  // if stands
        var hegs5 = List.filled(10, null)  // if hits
        var degs5 = List.filled(10, null)  // if doubles
        var pegs5 = List.filled(10, null)  // if splits
        for (i in 0..9) {
            segs5[i] = List.filled(10, 0)
            hegs5[i] = List.filled(10, 0)
            degs5[i] = List.filled(10, 0)
            pegs5[i] = List.filled(10, 0)
        }
        for (c in 1..10) {
            var sg = stand(c, c)
            var hg = hit(c, c, false)
            var dg = double(c, c)
            var pg = split(c)
            for (j in 0..9) {
                segs5[c-1][j] = segs5[c-1][j] + sg[j]
                hegs5[c-1][j] = hegs5[c-1][j] + hg[j]
                degs5[c-1][j] = degs5[c-1][j] + dg[j]
                pegs5[c-1][j] = pegs5[c-1][j] + pg[j]
            }
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Stand)")
        for (c in 1..10) {
            printPair(c)
            for (j in 0..9) Fmt.write("$6.3f ", segs5[c-1][j])
            System.print()
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Hit)")
        for (c in 1..10) {
            printPair(c)
            for (j in 0..9) Fmt.write("$6.3f ", hegs5[c-1][j])
            System.print()
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Double)")
        for (c in 1..10) {
            printPair(c)
            for (j in 0..9) Fmt.write("$6.3f ", degs5[c-1][j])
            System.print()
        }

        printHeader("\nPairs Chart - Player Expected Gains per unit (Split)")
        for (c in 1..10) {
            printPair(c)
            for (j in 0..9) Fmt.write("$6.3f ", pegs5[c-1][j])
            System.print()
        }

        printHeader("\nPairs Chart - Player Strategy (Round 1)")
        for (c in 1..10) {
            printPair(c)
            for (j in 0..9) {
                var ags = [
                    ActionGain.new("S", segs5[c-1][j]),
                    ActionGain.new("H", hegs5[c-1][j]),
                    ActionGain.new("D", degs5[c-1][j]),
                    ActionGain.new("P", pegs5[c-1][j]),
                ]
                var action = bestAction(ags)
                PTable[c-1][j] = action
                Fmt.write("$4s   ", action)
            }
            System.print()
        }

        // do 10 years of simulations
        for (i in 1..10) {
            Fmt.print("\nSimulation for Year $d:", i)
            simulate(50, 365)
        }
    }
}

Blackjack.main()
