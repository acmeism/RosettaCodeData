PROGRAM Playing_Cards

  USE Cards

  CALL Init_deck
  CALL Shuffle_deck
  CALL Deal_hand(5)
  CALL Print_hand
  CALL Print_deck

END PROGRAM
