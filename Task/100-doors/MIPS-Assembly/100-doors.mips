.data
  doors:     .space 100
  num_str:   .asciiz "Number "
  comma_gap: .asciiz " is "
  newline:   .asciiz "\n"

.text
main:
# Clear all the cells to zero
  li $t1, 100
  la $t2, doors
clear_loop:
  sb $0, ($t2)
  add $t2, $t2, 1
  sub $t1, $t1, 1
  bnez $t1, clear_loop

# Now start the loops
  li $t0, 1         # This will the the step size
  li $t4, 1         # just an arbitrary 1
loop1:
  move $t1, $t0      # Counter
  la $t2, doors      # Current pointer
  add $t2, $t2, $t0
  addi $t2, $t2, -1
loop2:
  lb $t3, ($t2)
  sub $t3, $t4, $t3
  sb $t3, ($t2)
  add $t1, $t1, $t0
  add $t2, $t2, $t0
  ble $t1, 100, loop2

  addi $t0, $t0, 1
  ble $t0, 100, loop1

  # Now display everything
  la $t0, doors
  li $t1, 1
loop3:
  li $v0, 4
  la $a0, num_str
  syscall

  li $v0, 1
  move $a0, $t1
  syscall

  li $v0, 4
  la $a0, comma_gap
  syscall

  li $v0, 1
  lb $a0, ($t0)
  syscall

  li $v0, 4,
  la $a0, newline
  syscall

  addi $t0, $t0, 1
  addi $t1, $t1, 1
  bne $t1, 101 loop3
