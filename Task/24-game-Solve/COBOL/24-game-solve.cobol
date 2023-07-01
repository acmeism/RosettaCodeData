        >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCobol 2.0
identification division.
program-id. twentyfoursolve.
environment division.
configuration section.
repository. function all intrinsic.
input-output section.
file-control.
    select count-file
        assign to count-file-name
        file status count-file-status
        organization line sequential.
data division.
file section.
fd  count-file.
01  count-record pic x(7).

working-storage section.
01  count-file-name pic x(64) value 'solutioncounts'.
01  count-file-status pic xx.

01  command-area.
    03  nd pic 9.
    03  number-definition.
        05  n occurs 4 pic 9.
    03  number-definition-9 redefines number-definition
        pic 9(4).
    03  command-input pic x(16).
    03  command pic x(5).
    03  number-count pic 9999.
    03  l1 pic 99.
    03  l2 pic 99.
    03  expressions pic zzz,zzz,zz9.

01  number-validation.
    03  px pic 99.
    03  permutations value
          '1234'
        & '1243'
        & '1324'
        & '1342'
        & '1423'
        & '1432'

        & '2134'
        & '2143'
        & '2314'
        & '2341'
        & '2413'
        & '2431'

        & '3124'
        & '3142'
        & '3214'
        & '3241'
        & '3423'
        & '3432'

        & '4123'
        & '4132'
        & '4213'
        & '4231'
        & '4312'
        & '4321'.
        05  permutation occurs 24 pic x(4).
    03  cpx pic 9.
    03  current-permutation pic x(4).
    03  od1 pic 9.
    03  od2 pic 9.
    03  od3 pic 9.
    03  operator-definitions pic x(4) value '+-*/'.
    03  cox pic 9.
    03  current-operators pic x(3).
    03  rpn-forms value
          'nnonono'
        & 'nnonnoo'
        & 'nnnonoo'
        & 'nnnoono'
        & 'nnnnooo'.
        05  rpn-form occurs 5 pic x(7).
    03  rpx pic 9.
    03  current-rpn-form pic x(7).

01  calculation-area.
    03  oqx pic 99.
    03  output-queue pic x(7).
    03  work-number pic s9999.
    03  top-numerator pic s9999 sign leading separate.
    03  top-denominator pic s9999 sign leading separate.
    03  rsx pic 9.
    03  result-stack occurs 8.
        05  numerator pic s9999.
        05  denominator pic s9999.
    03  divide-by-zero-error pic x.

01  totals.
    03  s pic 999.
    03  s-lim pic 999 value 600.
    03  s-max pic 999 value 0.
    03  solution occurs 600 pic x(7).
    03  sc pic 999.
    03  sc1 pic 999.
    03  sc2 pic 9.
    03  sc-max pic 999 value 0.
    03  sc-lim pic 999 value 600.
    03  solution-counts value zeros.
        05  solution-count occurs 600 pic 999.
    03  ns pic 9999.
    03  ns-max pic 9999 value 0.
    03  ns-lim pic 9999 value 6561.
    03  number-solutions occurs 6561.
        05 ns-number pic x(4).
        05 ns-count pic 999.
    03  record-counts pic 9999.
    03  total-solutions pic 9999.

01  infix-area.
    03  i pic 9.
    03  i-s pic 9.
    03  i-s1 pic 9.
    03  i-work pic x(16).
    03  i-stack occurs 7 pic x(13).

procedure division.
start-twentyfoursolve.
    display 'start twentyfoursolve'
    perform display-instructions
    perform get-command
    perform until command-input = spaces
        display space
        initialize command number-count
        unstring command-input delimited by all space
            into command number-count
        move command-input to number-definition
        move spaces to command-input
        evaluate command
        when 'h'
        when 'help'
            perform display-instructions
        when 'list'
            if ns-max = 0
                perform load-solution-counts
            end-if
            perform list-counts
        when 'show'
            if ns-max = 0
                perform load-solution-counts
            end-if
            perform show-numbers
        when other
            if number-definition-9 not numeric
                display 'invalid number'
            else
                perform get-solutions
                perform display-solutions
            end-if
        end-evaluate
        if command-input = spaces
            perform get-command
        end-if
    end-perform
    display 'exit twentyfoursolve'
    stop run
    .
display-instructions.
    display space
    display 'enter a number <n> as four integers from 1-9 to see its solutions'
    display 'enter list to see counts of solutions for all numbers'
    display 'enter show <n> to see numbers having <n> solutions'
    display '<enter> ends the program'
    .
get-command.
    display space
    move spaces to command-input
    display '(h for help)?' with no advancing
    accept command-input
    .
ask-for-more.
    display space
    move 0 to l1
    add 1 to l2
    if l2 = 10
        display 'more (<enter>)?' with no advancing
        accept command-input
        move 0 to l2
    end-if
    .
list-counts.
    add 1 to sc-max giving sc
    display 'there are ' sc ' solution counts'
    display space
    display 'solutions/numbers'
    move 0 to l1
    move 0 to l2
    perform varying sc from 1 by 1 until sc > sc-max
    or command-input <> spaces
        if solution-count(sc) > 0
            subtract 1 from sc giving sc1 *> offset to capture zero counts
            display sc1 '/' solution-count(sc) space with no advancing
            add 1 to l1
            if l1 = 8
                perform ask-for-more
            end-if
        end-if
    end-perform
    if l1 > 0
        display space
    end-if
    .
show-numbers. *> with number-count solutions
    add 1 to number-count giving sc1 *> offset for zero count
    evaluate true
    when number-count >= sc-max
        display 'no number has ' number-count ' solutions'
        exit paragraph
    when solution-count(sc1) = 1 and number-count = 1
        display '1 number has 1 solution'
    when solution-count(sc1) = 1
        display '1 number has ' number-count ' solutions'
    when number-count = 1
        display solution-count(sc1) ' numbers have 1 solution'
    when other
        display solution-count(sc1) ' numbers have ' number-count ' solutions'
    end-evaluate
    display space
    move 0 to l1
    move 0 to l2
    perform varying ns from 1 by 1 until ns > ns-max
    or command-input <> spaces
        if ns-count(ns) = number-count
            display ns-number(ns) space with no advancing
            add 1 to l1
            if l1 = 14
                perform ask-for-more
            end-if
        end-if
    end-perform
    if l1 > 0
        display space
    end-if
    .
display-solutions.
    evaluate s-max
    when 0 display number-definition ' has no solutions'
    when 1 display number-definition ' has 1 solution'
    when other display number-definition ' has ' s-max ' solutions'
    end-evaluate
    display space
    move 0 to l1
    move 0 to l2
    perform varying s from 1 by 1 until s > s-max
    or command-input <> spaces
        *> convert rpn solution(s) to infix
        move 0 to i-s
        perform varying i from 1 by 1 until i > 7
            if solution(s)(i:1) >= '1' and <= '9'
                add 1 to i-s
                move solution(s)(i:1) to i-stack(i-s)
            else
                subtract 1 from i-s giving i-s1
                move spaces to i-work
                string '(' i-stack(i-s1) solution(s)(i:1) i-stack(i-s) ')'
                    delimited by space into i-work
                move i-work to i-stack(i-s1)
                subtract 1 from i-s
            end-if
        end-perform
        display solution(s) space i-stack(1) space space with no advancing
        add 1 to l1
        if l1 = 3
            perform ask-for-more
        end-if
    end-perform
    if l1 > 0
        display space
    end-if
    .
load-solution-counts.
    move 0 to ns-max *> numbers and their solution count
    move 0 to sc-max *> solution counts
    move spaces to count-file-status
    open input count-file
    if count-file-status <> '00'
        perform create-count-file
        move 0 to ns-max *> numbers and their solution count
        move 0 to sc-max *> solution counts
        open input count-file
    end-if
    read count-file
    move 0 to record-counts
    move zeros to solution-counts
    perform until count-file-status <> '00'
        add 1 to record-counts
        perform increment-ns-max
        move count-record to number-solutions(ns-max)
        add 1 to ns-count(ns-max) giving sc *> offset 1 for zero counts
        if sc > sc-lim
            display 'sc ' sc ' exceeds sc-lim ' sc-lim
            stop run
        end-if
        if sc > sc-max
            move sc to sc-max
        end-if
        add 1 to solution-count(sc)
        read count-file
    end-perform
    close count-file
    .
create-count-file.
    open output count-file
    display 'Counting solutions for all numbers'
    display 'We will examine 9*9*9*9 numbers'
    display 'For each number we will examine 4! permutations of the digits'
    display 'For each permutation we will examine 4*4*4 combinations of operators'
    display 'For each permutation and combination we will examine 5 rpn forms'
    display 'We will count the number of unique solutions for the given number'
    display 'Each number and its counts will be written to file ' trim(count-file-name)
    compute expressions = 9*9*9*9*factorial(4)*4*4*4*5
    display 'So we will evaluate ' trim(expressions) ' statements'
    display 'This will take a few minutes'
    display 'In the future if ' trim(count-file-name) ' exists, this step will be bypassed'
    move 0 to record-counts
    move 0 to total-solutions
    perform varying n(1) from 1 by 1 until n(1) = 0
        perform varying n(2) from 1 by 1 until n(2) = 0
            display n(1) n(2) '..' *> show progress
            perform varying n(3) from 1 by 1 until n(3) = 0
                perform varying n(4) from 1 by 1 until n(4) = 0
                    perform get-solutions
                    perform increment-ns-max
                    move number-definition to ns-number(ns-max)
                    move s-max to ns-count(ns-max)
                    move number-solutions(ns-max) to count-record
                    write count-record
                    add s-max to total-solutions
                    add 1 to record-counts
                    add 1 to ns-count(ns-max) giving sc *> offset by 1 for zero counts
                    if sc > sc-lim
                        display 'error: ' sc ' solution count exceeds ' sc-lim
                        stop run
                    end-if
                    add 1 to solution-count(sc)
                end-perform
            end-perform
        end-perform
    end-perform
    close count-file
    display record-counts ' numbers and counts written to ' trim(count-file-name)
    display total-solutions ' total solutions'
    display space
    .
increment-ns-max.
    if ns-max >= ns-lim
        display 'error: numbers exceeds ' ns-lim
        stop run
    end-if
    add 1 to ns-max
    .
get-solutions.
    move 0 to s-max
    perform varying px from 1 by 1 until px > 24
        move permutation(px) to current-permutation
        perform varying od1 from 1 by 1 until od1 > 4
            move operator-definitions(od1:1) to current-operators(1:1)
            perform varying od2 from 1 by 1 until od2 > 4
                move operator-definitions(od2:1) to current-operators(2:1)
                perform varying od3 from 1 by 1 until od3 > 4
                    move operator-definitions(od3:1) to current-operators(3:1)
                    perform varying rpx from 1 by 1 until rpx > 5
                        move rpn-form(rpx) to current-rpn-form
                        move 0 to cpx cox
                        move spaces to output-queue
                        perform varying oqx from 1 by 1 until oqx > 7
                            if current-rpn-form(oqx:1) = 'n'
                                add 1 to cpx
                                move current-permutation(cpx:1) to nd
                                move n(nd) to output-queue(oqx:1)
                            else
                                add 1 to cox
                                move current-operators(cox:1) to output-queue(oqx:1)
                            end-if
                        end-perform
                        perform evaluate-rpn
                        if divide-by-zero-error = space
                        and 24 * top-denominator = top-numerator
                            perform varying s from 1 by 1 until s > s-max
                            or solution(s) = output-queue
                                continue
                            end-perform
                            if s > s-max
                                if s >= s-lim
                                    display 'error: solutions ' s ' for ' number-definition ' exceeds ' s-lim
                                    stop run
                                end-if
                                move s to s-max
                                move output-queue to solution(s-max)
                            end-if
                        end-if
                    end-perform
                end-perform
            end-perform
        end-perform
    end-perform
    .
evaluate-rpn.
    move space to divide-by-zero-error
    move 0 to rsx *> stack depth
    perform varying oqx from 1 by 1 until oqx > 7
        if output-queue(oqx:1) >= '1' and <= '9'
            *> push the digit onto the stack
            add 1 to rsx
            move top-numerator to numerator(rsx)
            move top-denominator to denominator(rsx)
            move output-queue(oqx:1) to top-numerator
            move 1 to top-denominator
        else
            *> apply the operation
            evaluate output-queue(oqx:1)
            when '+'
                compute top-numerator = top-numerator * denominator(rsx)
                    + top-denominator * numerator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when '-'
                compute top-numerator = top-denominator * numerator(rsx)
                    - top-numerator * denominator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when '*'
                compute top-numerator = top-numerator * numerator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when '/'
                compute work-number = numerator(rsx) * top-denominator
                compute top-denominator = denominator(rsx) * top-numerator
                if top-denominator = 0
                    move 'y' to divide-by-zero-error
                    exit paragraph
                end-if
                move work-number to top-numerator
            end-evaluate
            *> pop the stack
            subtract 1 from rsx
        end-if
    end-perform
    .
end program twentyfoursolve.
