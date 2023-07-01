/* REXX */
Call mk_a "It is certain", "It is decidedly so", "Without a doubt",,
          "Yes, definitely", "You may rely on it", "As I see it, yes",,
          "Most likely", "Outlook good", "Signs point to yes", "Yes",,
          "Reply hazy, try again", "Ask again later",,
          "Better not tell you now", "Cannot predict now",,
          "Concentrate and ask again", "Don't bet on it",,
          "My reply is no", "My sources say no", "Outlook not so good",,
          "Very doubtful"
Do Forever
  Say 'your question:'
  Parse Pull q
  If q='' Then Leave
  z=random(1,a.0)
  Say a.z
  Say ''
  End
Exit
mk_a:
a.0=arg()
Do i=1 To a.0
  a.i=arg(i)
  End
Return
