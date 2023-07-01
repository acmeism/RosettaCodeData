use AppleScript version "2.5" -- OS X 10.11 (El Capitan) or later
use framework "Foundation"
use framework "GameplayKit" -- For randomising functions.

on cardTrick()
    (* Create a pack of "cards" and shuffle it. *)
    set suits to {"♥️", "♣️", "♦️", "♠️"}
    set cards to {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
    set deck to {}
    repeat with s from 1 to (count suits)
        set suit to item s of suits
        repeat with c from 1 to (count cards)
            set end of deck to item c of cards & suit
        end repeat
    end repeat
    set deck to (current application's class "GKRandomSource"'s new()'s arrayByShufflingObjectsInArray:(deck)) as list

    (* Perform the black pile/red pile/discard stuff. *)
    set {blackPile, redPile, discardPile} to {{}, {}, {}}
    repeat with c from 1 to (count deck) by 2
        set topCard to item c of deck
        if (character -1 of topCard is in "♣️♠️") then
            set end of blackPile to item (c + 1) of deck
        else
            set end of redPile to item (c + 1) of deck
        end if
        set end of discardPile to topCard
    end repeat
    -- When equal numbers of two possibilities are randomly paired, the number of pairs whose members are
    -- both one of the possibilities is the same as the number whose members are both the other. The cards
    -- in the red and black piles have effectively been paired with cards of the eponymous colours, so
    -- the number of reds in the red pile is already the same as the number of blacks in the black.

    (* Take a random number of random cards from one pile and swap them with an equal number from the other,
      religiously following the "red bunch"/"black bunch" ritual instead of simply swapping pairs of cards. *)
    -- Where swapped cards are the same colour, this will make no difference at all. Where the colours
    -- are different, both piles will either gain or lose a card of their relevant colour, maintaining
    -- the defining balance either way.
    set {redBunch, blackBunch} to {{}, {}}
    set {redPileCount, blackPileCount} to {(count redPile), (count blackPile)}
    set maxX to blackPileCount
    if (redPileCount < maxX) then set maxX to redPileCount
    set X to (current application's class "GKRandomDistribution"'s distributionForDieWithSideCount:(maxX))'s nextInt()
    set RNG to current application's class "GKShuffledDistribution"'s distributionForDieWithSideCount:(redPileCount)
    repeat X times
        set r to RNG's nextInt()
        set end of redBunch to item r of redPile
        set item r of redPile to missing value
    end repeat
    set RNG to current application's class "GKShuffledDistribution"'s distributionForDieWithSideCount:(blackPileCount)
    repeat X times
        set b to RNG's nextInt()
        set end of blackBunch to item b of blackPile
        set item b of blackPile to missing value
    end repeat
    set blackPile to (blackPile's text) & redBunch
    set redPile to (redPile's text) & blackBunch

    (* Count and compare the number of blacks in the black pile and the number of reds in the red. *)
    set blacksInBlackPile to 0
    repeat with card in blackPile
        if (character -1 of card is in "♣️♠️") then set blacksInBlackPile to blacksInBlackPile + 1
    end repeat
    set redsInRedPile to 0
    repeat with card in redPile
        if (character -1 of card is in "♥️♦️") then set redsInRedPile to redsInRedPile + 1
    end repeat

    return {truth:(blacksInBlackPile = redsInRedPile), reds:redPile, blacks:blackPile, discards:discardPile}
end cardTrick

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {}
    repeat with i from 1 to 5
        set {truth:truth, reds:reds, blacks:blacks, discards:discards} to cardTrick()
        set end of output to "Test " & i & ": Assertion is " & truth
        set end of output to "Red pile:   " & join(reds, ", ")
        set end of output to "Black pile: " & join(blacks, ", ")
        set end of output to "Discards:   " & join(items 1 thru 13 of discards, ", ")
        set end of output to "            " & (join(items 14 thru 26 of discards, ", ") & linefeed)
    end repeat
    return text 1 thru -2 of join(output, linefeed)
end task
return task()
