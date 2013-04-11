MODULE Cards

IMPLICIT NONE

  TYPE Card
    CHARACTER(5) :: value
    CHARACTER(8) :: suit
  END TYPE Card

  TYPE(Card) :: deck(52), hand(52)
  TYPE(Card) :: temp

  CHARACTER(5) :: pip(13) = (/"Two  ", "Three", "Four ", "Five ", "Six  ", "Seven", "Eight", "Nine ", "Ten  ", &
                              "Jack ", "Queen", "King ", "Ace  "/)
  CHARACTER(8) :: suits(4) = (/"Clubs   ", "Diamonds", "Hearts  ", "Spades  "/)
  INTEGER :: i, j, n, rand, dealt = 0
  REAL :: x

CONTAINS

  SUBROUTINE Init_deck
  ! Create deck
    DO i = 1, 4
      DO j = 1, 13
        deck((i-1)*13+j) = Card(pip(j), suits(i))
      END DO
    END DO
  END SUBROUTINE Init_deck

  SUBROUTINE Shuffle_deck
  ! Shuffle deck using Fisher-Yates algorithm
    DO i = 52-dealt, 1, -1
      CALL RANDOM_NUMBER(x)
      rand = INT(x * i) + 1
      temp = deck(rand)
      deck(rand) = deck(i)
      deck(i) = temp
    END DO
  END SUBROUTINE Shuffle_deck

  SUBROUTINE Deal_hand(number)
  ! Deal from deck to hand
    INTEGER :: number
    DO i = 1, number
      hand(i) = deck(dealt+1)
      dealt = dealt + 1
    END DO
  END SUBROUTINE

  SUBROUTINE Print_hand
  ! Print cards in hand
    DO i = 1, dealt
      WRITE (*, "(3A)") TRIM(deck(i)%value), " of ", TRIM(deck(i)%suit)
    END DO
    WRITE(*,*)
  END SUBROUTINE Print_hand

  SUBROUTINE Print_deck
  ! Print cards in deck
    DO i = dealt+1, 52
      WRITE (*, "(3A)") TRIM(deck(i)%value), " of ", TRIM(deck(i)%suit)
    END DO
    WRITE(*,*)
  END SUBROUTINE Print_deck

END MODULE Cards
