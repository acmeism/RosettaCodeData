MODE CARD = STRUCT(STRING pip, suit); # instance attributes #

# class members & attributes #
STRUCT(
  PROC(REF CARD, STRING, STRING)VOID init,
  FORMAT format,
  PROC(REF CARD)STRING repr,
  []STRING suits, pips
) class card = (
# PROC init = # (REF CARD self, STRING pip, suit)VOID:(
    pip OF self:=pip;
    suit OF self :=suit
  ),
# format = # $"("g" OF "g")"$,
# PROC repr = # (REF CARD self)STRING: (
    HEAP STRING out; putf(BOOK out,(format OF class card,self)); out
  ),
# suits = # ("Clubs","Hearts","Spades","Diamonds"),
# pips = # ("2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace")
);

MODE DECK = STRUCT(REF[]CARD deck); # instance attributes #

# class members & attributes #
STRUCT(
  PROC(REF DECK)VOID init, shuffle,
  PROC(REF DECK)STRING repr,
  PROC(REF DECK)CARD deal
) class deck = (

# PROC init = # (REF DECK self)VOID:(
    HEAP[ UPB suits OF class card * UPB pips OF class card ]CARD new;
    FOR suit TO UPB suits OF class card DO
      FOR pip TO UPB pips OF class card DO
        new[(suit-1)*UPB pips OF class card + pip] :=
           ((pips OF class card)[pip], (suits OF class card)[suit])
      OD
    OD;
    deck OF self := new
  ),

# PROC shuffle = # (REF DECK self)VOID:
    FOR card TO UPB deck OF self DO
      CARD this card = (deck OF self)[card];
      INT random card = random int(LWB deck OF self,UPB deck OF self);
      (deck OF self)[card] := (deck OF self)[random card];
      (deck OF self)[random card] := this card
    OD,

# PROC repr = # (REF DECK self)STRING: (
    FORMAT format = $"("n(UPB deck OF self-1)(f(format OF class card)", ")f(format OF class card)")"$;
    HEAP STRING out; putf(BOOK out,(format, deck OF self)); out
  ),

# PROC deal = # (REF DECK self)CARD: (
    (shuffle OF class deck)(self);
    (deck OF self)[UPB deck OF self]
  )
);

# associate a STRING with a FILE for easy text manipulation #
OP BOOK = (REF STRING string)REF FILE:(
  HEAP FILE book;
  associate(book, string);
  book
);

# Pick a random integer between from [lwb..upb] #
PROC random int = (INT lwb, upb)INT:
  ENTIER(random * (upb - lwb + 1) + lwb);

DECK deck;
(init OF class deck)(deck);
(shuffle OF class deck)(deck);
print (((repr OF class deck)(deck), new line))
