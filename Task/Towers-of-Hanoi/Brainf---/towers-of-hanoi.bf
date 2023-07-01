[
This implementation is recursive and uses
a stack, consisting of frames that are 8
bytes long. The layout is as follows:

Byte   Description
   0   recursion flag
       (the program stops if the flag is
        zero)
   1   the step which is currently
       executed
       4 means a call to
               move(a, c, b, n - 1)
       3 means a call to
               move(a, b, c, 1)
       2 means a call to
               move(b, a, c, n - 1)
       1 prints the source and dest pile
   2   flag to check whether the current
       step has already been done or if
       it still must be executed
   3   the step which will be executed
       in the next loop
   4   the source pile
   5   the helper pile
   6   the destination pile
   7   the number of disks to move

The first stack frame (0 0 0 0 0 0 0 0)
is used to abort the recursion.
]

>>>>>>>>

These are the parameters for the program
(1 4 1 0 'a 'b 'c 5)
+>++++>+>>
>>>>++++++++[<++++++++++++>-]<
[<<<+>+>+>-]<<<+>++>+++>+++++>
<<<<<<<<

[> while (recurse)
  [- if (step gt 0)
    >[-]+< todo = 1
    [- if (step gt 1)
      [- if (step gt 2)
        [- if (step gt 3)
          >>+++<< next = 3
          >-< todo = 0
          >>>>>>[>+>+<<-]>[<+>-]> n dup
          -
          [[-] if (sub(n 1) gt 0)
            <+>>>++++> push (1 0 0 4)

            copy and push a
            <<<<<<<<[>>>>>>>>+>+
            <<<<<<<<<-]>>>>>>>>
            >[<<<<<<<<<+>>>>>>>>>-]< >

            copy and push c
            <<<<<<<[>>>>>>>+>+
            <<<<<<<<-]>>>>>>>
            >[<<<<<<<<+>>>>>>>>-]< >

            copy and push b
            <<<<<<<<<[>>>>>>>>>+>+
            <<<<<<<<<<-]>>>>>>>>>
            >[<<<<<<<<<<+>>>>>>>>>>-]< >

            copy n and push sub(n 1)
            <<<<<<<<[>>>>>>>>+>+
            <<<<<<<<<-]>>>>>>>>
            >[<<<<<<<<<+>>>>>>>>>-]< -
            >>
          ]
          <<<<<<<<
        ]
        >[-< if ((step gt 2) and todo)
          >>++<< next = 2
          >>>>>>>
          +>>>+> push 1 0 0 1 a b c 1
          <<<<<<<<[>>>>>>>>+>+
          <<<<<<<<<-]>>>>>>>>
          >[<<<<<<<<<+>>>>>>>>>-]< > a
          <<<<<<<<[>>>>>>>>+>+
          <<<<<<<<<-]>>>>>>>>
          >[<<<<<<<<<+>>>>>>>>>-]< > b
          <<<<<<<<[>>>>>>>>+>+
          <<<<<<<<<-]>>>>>>>>
          >[<<<<<<<<<+>>>>>>>>>-]< > c
          + >>
        >]<
      ]
      >[-< if ((step gt 1) and todo)
        >>>>>>[>+>+<<-]>[<+>-]> n dup
        -
        [[-] if (n sub 1 gt 0)
          <+>>>++++> push (1 0 0 4)

          copy and push b
          <<<<<<<[>>>>>>>+
          <<<<<<<-]>>>>>>>
          >[<<<<<<<<+>>>>>>>>-]< >

          copy and push a
          <<<<<<<<<[>>>>>>>>>+
          <<<<<<<<<-]>>>>>>>>>
          >[<<<<<<<<<<+>>>>>>>>>>-]< >

          copy and push c
          <<<<<<<<[>>>>>>>>+
          <<<<<<<<-]>>>>>>>>
          >[<<<<<<<<<+>>>>>>>>>-]< >

          copy n and push sub(n 1)
          <<<<<<<<[>>>>>>>>+>+
          <<<<<<<<<-]>>>>>>>>
          >[<<<<<<<<<+>>>>>>>>>-]< -
          >>
        ]
        <<<<<<<<
      >]<
    ]
    >[-< if ((step gt 0) and todo)
      >>>>>>>
      >++++[<++++++++>-]<
      >>++++++++[<+++++++++>-]<++++
      >>++++++++[<++++++++++++>-]<+++++
      >>+++++++++[<++++++++++++>-]<+++
      <<<
      >.+++++++>.++.--.<<.
      >>-.+++++.----.<<.
      >>>.<---.+++.>+++.+.+.<.<<.
      >.>--.+++++.---.++++.
        -------.+++.<<.
      >>>++.-------.-.<<<.
      >+.>>+++++++.---.-----.<<<.
      <<<<.>>>>.
      >>----.>++++++++.<+++++.<<.
      >.>>.---.-----.<<<.
      <<.>>++++++++++++++.
      >>>[-]<[-]<[-]<[-]
      +++++++++++++.---.[-]
      <<<<<<<
    >]<
    >>[<<+>>-]<< step = next
  ]
  return with clear stack frame
  <[-]>[-]>[-]>[-]>[-]>[-]>[-]>[-]<<<<<<
  <<<<<<<<
  >>[<<+>>-]<< step = next
  <
]
