/* Rexx */
Do
  alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  key   = 'LEMON'

  pt = 'Attack at dawn!'
  Call test key, pt

  key = 'N'
  Call test key, pt

  key = 'B'
  Call test key, pt

  pt = alpha
  key = 'A'
  Call test key, pt

  pt = sampledata()
  key = 'Hamlet; Prince of Denmark'
  Call test key, pt

  Return
End
Exit

vigenere:
Procedure Expose alpha
Do
  Parse upper Arg meth, key, text

  Select
    When 'ENCIPHER'~abbrev(meth, 1) = 1 then df = 1
    When 'DECIPHER'~abbrev(meth, 1) = 1 then df = -1
    Otherwise Do
      Say meth 'invalid.  Must be "ENCIPHER" or "DECIPHER"'
      Exit
      End
    End

  text = stringscrubber(text)
  key  = stringscrubber(key)
  code = ''

  Do l_ = 1 to text~length()
    M = alpha~pos(text~substr(l_, 1)) - 1
    k_ = (l_ - 1) // key~length()
    K = alpha~pos(key~substr(k_ + 1, 1)) - 1
    C = mod((M + K * df), alpha~length())
    C = alpha~substr(C + 1, 1)
    code = code || C
    End l_

  Return code

  Return
End
Exit

vigenere_encipher:
Procedure Expose alpha
Do
  Parse upper Arg key, plaintext

  Return vigenere('ENCIPHER', key, plaintext)
End
Exit

vigenere_decipher:
Procedure Expose alpha
Do
  Parse upper Arg key, ciphertext

  Return vigenere('DECIPHER', key, ciphertext)
End
Exit

mod:
Procedure
Do
  Parse Arg N, D

  Return (D + (N // D)) // D
End
Exit

stringscrubber:
Procedure Expose alpha
Do
  Parse upper Arg cleanup

  cleanup = cleanup~space(0)
  Do label f_ forever
    x_ = cleanup~verify(alpha)
    If x_ = 0 then Leave f_
    cleanup = cleanup~changestr(cleanup~substr(x_, 1), '')
    end f_

  Return cleanup
End
Exit

test:
Procedure Expose alpha
Do
  Parse Arg key, pt

  ct = vigenere_encipher(key, pt)
  Call display ct
  dt = vigenere_decipher(key, ct)
  Call display dt

  Return
End
Exit

display:
Procedure
Do
  Parse Arg text

  line = ''
  o_ = 0
  Do c_ = 1 to text~length()
    b_ = o_ // 5
    o_ = o_ + 1
    If b_ = 0 then line = line' '
    line = line || text~substr(c_, 1)
    End c_

  Say '....+....|'~copies(8)
  Do label l_ forever
    Parse Var line w1 w2 w3 w4 w5 w6 W7 w8 w9 w10 w11 w12 line
    pline = w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12
    Say pline~strip()
    If line~strip()~length() = 0 then Leave l_
    End l_
  Say

  Return
End
Exit

sampledata:
Procedure
Do

  NL = '0a'x
  X = 0
  antic_disposition. = ''
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "To be, or not to be--that is the question:"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Whether 'tis nobler in the mind to suffer"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The slings and arrows of outrageous fortune"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Or to take arms against a sea of troubles"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "And by opposing end them. To die, to sleep--"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "No more--and by a sleep to say we end"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The heartache, and the thousand natural shocks"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "That flesh is heir to. 'Tis a consummation"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Devoutly to be wished. To die, to sleep--"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "To sleep--perchance to dream: ay, there's the rub,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "For in that sleep of death what dreams may come"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "When we have shuffled off this mortal coil,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Must give us pause. There's the respect"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "That makes calamity of so long life."
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "For who would bear the whips and scorns of time,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Th' oppressor's wrong, the proud man's contumely"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The pangs of despised love, the law's delay,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The insolence of office, and the spurns"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "That patient merit of th' unworthy takes,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "When he himself might his quietus make"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "With a bare bodkin? Who would fardels bear,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "To grunt and sweat under a weary life,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "But that the dread of something after death,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The undiscovered country, from whose bourn"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "No traveller returns, puzzles the will,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "And makes us rather bear those ills we have"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Than fly to others that we know not of?"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Thus conscience does make cowards of us all,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "And thus the native hue of resolution"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Is sicklied o'er with the pale cast of thought,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "And enterprise of great pith and moment"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "With this regard their currents turn awry"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "And lose the name of action. -- Soft you now,"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "The fair Ophelia! -- Nymph, in thy orisons"
  X = X + 1; antic_disposition.0 = X; antic_disposition.X = "Be all my sins remembered."

  melancholy_dane = ''
  Do l_ = 1 for antic_disposition.0
    melancholy_dane = melancholy_dane || antic_disposition.l_ || NL
    End l_

  Return melancholy_dane
End
Exit
