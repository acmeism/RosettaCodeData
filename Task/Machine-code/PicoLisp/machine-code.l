(setq P
   (struct (native "@" "malloc" 'N 39) 'N
      # Align
      144                  # nop
      144                  # nop

      # Prepare stack
      106 12               # pushq $12
      184 7 0 0 0          # mov $7, %eax
      72 193 224 32        # shl $32, %rax
      80                   # pushq %rax

      # Rosetta task code
      139 68 36 4 3 68 36 8

      # Get result
      76 137 227           # mov %r12, %rbx
      137 195              # mov %eax, %ebx
      72 193 227 4         # shl $4, %rbx
      128 203 2            # orb $2, %bl

      # Clean up stack
      72 131 196 16        # add $16, %rsp

      # Return
      195 )                # ret
   foo (>> 4 P) )

# Execute
(println (foo))

# Free memory
(native "@" "free" NIL P)
