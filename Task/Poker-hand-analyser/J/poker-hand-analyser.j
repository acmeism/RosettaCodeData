parseHand=: ' ' cut 7&u:      NB. hand must be well formed
Suits=: <"> 7 u: '♥♦♣♦'       NB. or Suits=: 'hdcs'
Faces=: <;._1 ' 2 3 4 5 6 7 8 9 10 j q k a'

suits=: {:&.>
faces=: }:&.>
flush=: 1 =&#&~. suits
straight=: 1 = (i.#Faces) +/@E.~ Faces /:~@i. faces
kinds=: #/.~ @:faces
five=: 5 e. kinds NB. jokers or other cheat
four=: 4 e. kinds
three=: 3 e. kinds
two=: 2 e. kinds
twoPair=: 2 = 2 +/ .= kinds
highcard=: 5 = 1 +/ .= kinds

IF=: 2 :'(,&(<m) ^: v)"1'
Or=: 2 :'u ^:(5 e. $) @: v'

Deck=: ,Faces,&.>/Suits
Joker=: <'joker'
joke=: [: ,/^:(#@$ - 2:) (({. ,"1 Deck ,"0 1 }.@}.)^:(5>[)~ i.&Joker)"1^:2@,:
punchLine=: {:@-.&a:@,@|:
rateHand=: [:;:inv [: (, [: punchLine -1 :(0 :0-.LF)@joke) parseHand
 ('invalid' IF 1:) Or
 ('high-card' IF highcard) Or
 ('one-pair' IF two) Or
 ('two-pair' IF twoPair) Or
 ('three-of-a-kind' IF three) Or
 ('straight' IF straight) Or
 ('flush' IF flush) Or
 ('full-house' IF (two * three)) Or
 ('four-of-a-kind' IF four) Or
 ('straight-flush' IF (straight * flush)) Or
 ('five-of-a-kind' IF five)
)

Hands=: <@deb;._2 {{)n
 2♥ 2♦ 2♣ k♣ q♦
 2♥ 5♥ 7♦ 8♣ 9♠
 a♥ 2♦ 3♣ 4♣ 5♦
 2♥ 3♥ 2♦ 3♣ 3♦
 2♥ 7♥ 2♦ 3♣ 3♦
 2♥ 7♥ 7♦ 7♣ 7♠
 10♥ j♥ q♥ k♥ a♥
 4♥ 4♠ k♠ 5♦ 10♠
 q♣ 10♣ 7♣ 6♣ 4♣
}}
