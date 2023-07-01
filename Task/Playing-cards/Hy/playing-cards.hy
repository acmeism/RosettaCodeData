(import [random [shuffle]])
(setv pips (.split "2 3 4 5 6 7 8 9 10 J Q K A"))
(setv suits (.split "♥ ♦ ♣ ♠"))
(setv cards_per_hand 5)

(defn make_deck [pips suits]
    (lfor
        x pips
        y suits
        (+ x y)))

(defn deal_hand [num_cards deck]
    (setv delt (cut deck None num_cards))
    (setv new_deck (lfor
                       x deck
                       :if (not (in x delt))
                       x))
    [delt new_deck])


(if (= __name__ "__main__")
    (do
    (setv deck (make_deck pips suits))
    (shuffle deck)
    (setv [first_hand deck] (deal_hand cards_per_hand deck))
    (setv [second_hand deck] (deal_hand cards_per_hand deck))
    (print "\nThe first hand delt was:" (.join " " (map str first_hand)))
    (print "\nThe second hand delt was:" (.join " " (map str second_hand)))
    (print "\nThe remaining cards in the deck are...\n" (.join " " (map str deck)))))
