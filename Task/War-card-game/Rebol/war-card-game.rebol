Rebol [
    title: "Rosetta code: War card game"
    file:  %War_card_game.r3
    url:   https://rosettacode.org/wiki/War_card_game
]

war-card-game: function/with [
    "Play a game of War"
][
    ;; shuffle and deal alternating cards to each player
    deck: fisher-yates-shuffle copy ordered-deck
    clear deck1
    clear deck2
    foreach [a b] deck [
        append deck1 a
        append deck2 b
    ]
    ;; play turns until someone runs out of cards
    pending: copy []
    n: 1
    while [not any [empty? deck1 empty? deck2]][
        ;; flip top card from each deck
        r1: rank? c1: take deck1
        r2: rank? c2: take deck2
        prin format [5 5 5] reduce [++ n c1 c2]
        case [
            r1 > r2 [
                ;; player 1 wins: takes both cards plus any pending
                print as-yellow "Player 1 takes the cards."
                repend deck1 [c1 c2]
                append deck1 take/all pending
            ]
            r1 < r2 [
                ;; player 2 wins: takes both cards plus any pending
                print as-blue "Player 2 takes the cards."
                repend deck2 [c2 c1]
                append deck2 take/all pending
            ]
            true [
                ;; tie: hold cards face-down, continue to next turn
                print as-red "This is a war!"
                if any [empty? deck1 empty? deck2][ break ]
                c3: take deck1
                c4: take deck2
                printf [5 5 5 "Cards are face down."] reduce [++ n #"?" #"?"]
                repend pending [c1 c2 c3 c4]
            ]
        ]
        ;wait-for-key
    ]
    ;; announce winner
    print "========================================"
    print case [
        all [empty? deck1  empty? deck2] ["Game ends as a tie."]
        empty? deck2                     ["Player 1 wins the game."]
        true                             ["Player 2 wins the game."]
    ]
    exit
][
    deck: none
    deck1: [] deck2: [] ordered-deck: []
    ;; build ordered deck: suits vary fastest, ranks slowest
    foreach s "♣♦♥♠" [ foreach r "23456789TJQKA" [ append ordered-deck ajoin [r s] ] ]
    probe ordered-deck
    ;; rank lookup
    rank-modifiers: #[
        #"A" 130 #"K" 120 #"Q" 110 #"J" 100 #"T" 90
        #"9" 80  #"8" 70  #"7" 60  #"6" 50  #"5" 40
        #"4" 30  #"3" 20  #"2" 10
    ]
    rank?: func [card] [ rank-modifiers/(card/1) ]
    ;; standard Fisher-Yates in-place shuffle
    fisher-yates-shuffle: function [list [block!]] [
        len: length? list
        repeat i len [ swap at list i at list (i + random (len - i)) ]
        list
    ]
]

war-card-game
