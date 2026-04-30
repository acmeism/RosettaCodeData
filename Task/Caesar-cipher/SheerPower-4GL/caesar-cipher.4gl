declare string plaintext$, ciphertext$, decrypted$

plaintext$  = 'The Quick Brown Fox Jumps Over The Lazy Dog'

print 'Plaintext:  '; plaintext$

ciphertext$ = caesar$(plaintext$, 13)
print 'ROT13:      '; ciphertext$

decrypted$  = caesar$(ciphertext$, 13)
print 'Decrypted:  '; decrypted$

print
print 'Shift 3 example (classic Caesar):'
ciphertext$ = caesar$('Attack at dawn', 3)
print 'Encrypted:  '; ciphertext$
print 'Decrypted:  '; caesar$(ciphertext$, 23)

! =============================================================================
! Routine: caesar$(text$, shift%)
!
! Shift each letter in text$ by shift% positions.  A–Z and a–z wrap
! within their own ranges; all other characters are copied unchanged.
! =============================================================================
routine caesar$(text$, shift%)
  declare string result$, ch$
  declare integer i%, code%

  result$ = ''
  for i% = 1 to len(text$)
    ch$   = mid$(text$, i%, 1)
    code% = ord(ch$)

    if code% >= 65 and code% <= 90 then
      ! Uppercase A–Z: rotate within 65–90
      result$ = result$ + chr$((code% - 65 + shift%) mod 26 + 65)
    elseif code% >= 97 and code% <= 122 then
      ! Lowercase a–z: rotate within 97–122
      result$ = result$ + chr$((code% - 97 + shift%) mod 26 + 97)
    else
      ! Non-letter: pass through unchanged
      result$ = result$ + ch$
    end if
  next i%
  caesar$ = result$
end routine
