gcd:
  # a0 and a1 are the two integer parameters
  # return value is in v0
  move $t0, $a0
  move $t1, $a1
loop:
  beq $t1, $0, done
  div $t0, $t1
  move $t0, $t1
  mfhi $t1
  j loop
done:
  move $v0, $t0
  jr $ra
