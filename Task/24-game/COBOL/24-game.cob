        >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCobol 2.0
identification division.
program-id. twentyfour.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  p pic 999.
01  p1 pic 999.
01  p-max pic 999 value 38.
01  program-syntax pic x(494) value
*>statement = expression;
        '001 001 000 n'
    &   '002 000 004 ='
    &   '003 005 000 n'
    &   '004 000 002 ;'
*>expression = term, {('+'|'-') term,};
    &   '005 005 000 n'
    &   '006 000 016 ='
    &   '007 017 000 n'
    &   '008 000 015 {'
    &   '009 011 013 ('
    &   '010 001 000 t'
    &   '011 013 000 |'
    &   '012 002 000 t'
    &   '013 000 009 )'
    &   '014 017 000 n'
    &   '015 000 008 }'
    &   '016 000 006 ;'
*>term = factor, {('*'|'/') factor,};
    &   '017 017 000 n'
    &   '018 000 028 ='
    &   '019 029 000 n'
    &   '020 000 027 {'
    &   '021 023 025 ('
    &   '022 003 000 t'
    &   '023 025 000 |'
    &   '024 004 000 t'
    &   '025 000 021 )'
    &   '026 029 000 n'
    &   '027 000 020 }'
    &   '028 000 018 ;'
*>factor = ('(' expression, ')' | digit,);
    &   '029 029 000 n'
    &   '030 000 038 ='
    &   '031 035 037 ('
    &   '032 005 000 t'
    &   '033 005 000 n'
    &   '034 006 000 t'
    &   '035 037 000 |'
    &   '036 000 000 n'
    &   '037 000 031 )'
    &   '038 000 030 ;'.
01  filler redefines program-syntax.
    03  p-entry occurs 038.
        05  p-address pic 999.
        05  filler pic x.
        05  p-definition pic 999.
        05  p-alternate redefines p-definition pic 999.
        05  filler pic x.
        05  p-matching pic 999.
        05  filler pic x.
        05  p-symbol pic x.

01  t pic 999.
01  t-len pic 99 value 6.
01  terminal-symbols
    pic x(210) value
        '01 +                               '
    &   '01 -                               '
    &   '01 *                               '
    &   '01 /                               '
    &   '01 (                               '
    &   '01 )                               '.
01  filler redefines terminal-symbols.
    03  terminal-symbol-entry occurs 6.
        05  terminal-symbol-len pic 99.
        05  filler pic x.
        05  terminal-symbol pic x(32).

01  nt pic 999.
01  nt-lim pic 99 value 5.
01  nonterminal-statements pic x(294) value
        "000 ....,....,....,....,....,....,....,....,....,"
    &   "001 statement = expression;                      "
    &   "005 expression = term, {('+'|'-') term,};        "
    &   "017 term = factor, {('*'|'/') factor,};          "
    &   "029 factor = ('(' expression, ')' | digit,);     "
    &   "036 digit;                                       ".
01  filler redefines nonterminal-statements.
    03  nonterminal-statement-entry occurs 5.
        05  nonterminal-statement-number pic 999.
        05  filler pic x.
        05  nonterminal-statement pic x(45).

01  indent pic x(64) value all '|  '.
01  interpreter-stack.
    03  r pic 99. *> previous top of stack
    03  s pic 99. *> current top of stack
    03  s-max pic 99 value 32.
    03  s-entry occurs 32.
        05  filler pic x(2) value 'p='.
        05  s-p pic 999. *> callers return address
        05  filler pic x(4) value ' sc='.
        05  s-start-control pic 999. *> sequence start address
        05  filler pic x(4) value ' ec='.
        05  s-end-control pic 999. *> sequence end address
        05  filler pic x(4) value ' al='.
        05  s-alternate pic 999. *> the next alternate
        05  filler pic x(3) value ' r='.
        05  s-result pic x. *> S success, F failure, N no result
        05  filler pic x(3) value ' c='.
        05  s-count pic 99. *> successes in a sequence
        05  filler pic x(3) value ' x='.
        05  s-repeat pic 99. *> repeats in a {} sequence
        05  filler pic x(4) value ' nt='.
        05  s-nt pic 99. *> current nonterminal

01  language-area.
    03  l pic 99.
    03  l-lim pic 99.
    03  l-len pic 99 value 1.
    03  nd pic 9.
    03  number-definitions.
        05  n occurs 4 pic 9.
    03  nu pic 9.
    03  number-use.
        05  u occurs 4 pic x.
    03  statement.
        05  c occurs 32.
            07  c9 pic 9.

01  number-validation.
    03  p4 pic 99.
    03  p4-lim pic 99 value 24.
    03  permutations-4 pic x(96) value
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
     03  filler redefines permutations-4.
         05  permutation-4 occurs 24 pic x(4).
     03  current-permutation-4 pic x(4).
     03  cpx pic 9.
     03  od1 pic 9.
     03  od2 pic 9.
     03  odx pic 9.
     03  od-lim pic 9 value 4.
     03  operator-definitions pic x(4) value '+-*/'.
     03  current-operators pic x(3).
     03  co3 pic 9.
     03  rpx pic 9.
     03  rpx-lim pic 9 value 4.
     03  valid-rpn-forms pic x(28) value
          'nnonono'
        & 'nnnonoo'
        & 'nnnoono'
        & 'nnnnooo'.
    03  filler redefines valid-rpn-forms.
        05  rpn-form occurs 4 pic x(7).
    03  current-rpn-form pic x(7).

01  calculation-area.
    03  osx pic 99.
    03  operator-stack pic x(32).
    03  oqx pic 99.
    03  oqx1 pic 99.
    03  output-queue pic x(32).
    03  work-number pic s9999.
    03  top-numerator pic s9999 sign leading separate.
    03  top-denominator pic s9999 sign leading separate.
    03  rsx pic 9.
    03  result-stack occurs 8.
        05  numerator pic s9999.
        05  denominator pic s9999.

01  error-found pic x.
01  divide-by-zero-error pic x.

*>  diagnostics
01  NL pic x value x'0A'.
01  NL-flag pic x value space.
01  display-level pic x value '0'.
01  loop-lim pic 9999 value 1500.
01  loop-count pic 9999 value 0.
01  message-area value spaces.
    03  message-level pic x.
    03  message-value pic x(128).

*>  input and examples
01  instruction pic x(32) value spaces.
01  tsx pic 99.
01  tsx-lim pic 99 value 14.
01  test-statements.
    03  filler pic x(32) value '1234;1 + 2 + 3 + 4'.
    03  filler pic x(32) value '1234;1 * 2 * 3 * 4'.
    03  filler pic x(32) value '1234;((1)) * (((2 * 3))) * 4'.
    03  filler pic x(32) value '1234;((1)) * ((2 * 3))) * 4'.
    03  filler pic x(32) value '1234;(1 + 2 + 3 + 4'.
    03  filler pic x(32) value '1234;)1 + 2 + 3 + 4'.
    03  filler pic x(32) value '1234;1 * * 2 * 3 * 4'.
    03  filler pic x(32) value '5679;6 - (5 - 7) * 9'.
    03  filler pic x(32) value '1268;((1 * (8 * 6) / 2))'.
    03  filler pic x(32) value '4583;-5-3+(8*4)'.
    03  filler pic x(32) value '4583;8 * 4 - 5 - 3'.
    03  filler pic x(32) value '4583;8 * 4 - (5 + 3)'.
    03  filler pic x(32) value '1223;1 * 3 / (2 - 2)'.
    03  filler pic x(32) value '2468;(6 * 8) / 4 / 2'.
01  filler redefines test-statements.
    03  filler occurs 14.
        05  test-numbers pic x(4).
        05  filler pic x.
        05  test-statement pic x(27).

procedure division.
start-twentyfour.
    display 'start twentyfour'
    perform generate-numbers
    display 'type h <enter> to see instructions'
    accept instruction
    perform until instruction = spaces or 'q'
        evaluate true
        when instruction = 'h'
            perform display-instructions
        when instruction = 'n'
            perform generate-numbers
        when instruction(1:1) = 'm'
            move instruction(2:4) to number-definitions
            perform validate-number
            if divide-by-zero-error = space
            and 24 * top-denominator = top-numerator
                display number-definitions ' is solved by ' output-queue(1:oqx)
            else
                display number-definitions ' is not solvable'
            end-if
        when instruction = 'd0' or 'd1' or 'd2' or 'd3'
            move instruction(2:1) to display-level
        when instruction = 'e'
            display 'examples:'
            perform varying tsx from 1 by 1
            until tsx > tsx-lim
                move spaces to statement
                move test-numbers(tsx) to number-definitions
                move test-statement(tsx) to statement
                perform evaluate-statement
                perform show-result
            end-perform
        when other
            move instruction to statement
            perform evaluate-statement
            perform show-result
        end-evaluate
        move spaces to instruction
        display 'instruction? ' with no advancing
        accept instruction
    end-perform

    display 'exit twentyfour'
    stop run
    .
generate-numbers.
    perform with test after until divide-by-zero-error = space
    and 24 * top-denominator = top-numerator
        compute n(1) = random(seconds-past-midnight) * 10 *> seed
        perform varying nd from 1 by 1 until nd > 4
            compute n(nd) = random() * 10
            perform until n(nd) <> 0
                compute n(nd) = random() * 10
            end-perform
        end-perform
        perform validate-number
    end-perform
    display NL 'numbers:' with no advancing
    perform varying nd from 1 by 1 until nd > 4
        display space n(nd) with no advancing
    end-perform
    display space
    .
validate-number.
    perform varying p4 from 1 by 1 until p4 > p4-lim
        move permutation-4(p4) to current-permutation-4
        perform varying od1 from 1 by 1 until od1 > od-lim
            move operator-definitions(od1:1) to current-operators(1:1)
            perform varying od2 from 1 by 1 until od2 > od-lim
                move operator-definitions(od2:1) to current-operators(2:1)
                perform varying odx from 1 by 1 until odx > od-lim
                    move operator-definitions(odx:1) to current-operators(3:1)
                    perform varying rpx from 1 by 1 until rpx > rpx-lim
                        move rpn-form(rpx) to current-rpn-form
                        move 0 to cpx co3
                        move spaces to output-queue
                        move 7 to oqx
                        perform varying oqx1 from 1 by 1 until oqx1 > oqx
                            if current-rpn-form(oqx1:1) = 'n'
                                add 1 to cpx
                                move current-permutation-4(cpx:1) to nd
                                move n(nd) to output-queue(oqx1:1)
                            else
                                add 1 to co3
                                move current-operators(co3:1) to output-queue(oqx1:1)
                            end-if
                        end-perform
                    end-perform
                    perform evaluate-rpn
                    if divide-by-zero-error = space
                    and 24 * top-denominator = top-numerator
                        exit paragraph
                    end-if
                end-perform
            end-perform
        end-perform
    end-perform
    .
display-instructions.
    display '1)  Type h <enter> to repeat these instructions.'
    display '2)  The program will display four randomly-generated'
    display '    single-digit numbers and will then prompt you to enter'
    display '    an arithmetic expression followed by <enter> to sum'
    display '    the given numbers to 24.'
    display '    The four numbers may contain duplicates and the entered'
    display '    expression must reference all the generated numbers and duplicates.'
    display '    Warning:  the program converts the entered infix expression'
    display '    to a reverse polish notation (rpn) expression'
    display '    which is then interpreted from RIGHT to LEFT.'
    display '    So, for instance, 8*4 - 5 - 3 will not sum to 24.'
    display '3)  Type n <enter> to generate a new set of four numbers.'
    display '    The program will ensure the generated numbers are solvable.'
    display '4)  Type m#### <enter> (e.g. m1234) to create a fixed set of numbers'
    display '    for testing purposes.'
    display '    The program will test the solvability of the entered numbers.'
    display '    For example, m1234 is solvable and m9999 is not solvable.'
    display '5)  Type d0, d1, d2 or d3 followed by <enter> to display none or'
    display '    increasingly detailed diagnostic information as the program evaluates'
    display '    the entered expression.'
    display '6)  Type e <enter> to see a list of example expressions and results'
    display '7)  Type <enter> or q <enter> to exit the program'
    .
show-result.
    if error-found = 'y'
    or divide-by-zero-error = 'y'
        exit paragraph
    end-if
    display 'statement in RPN is' space output-queue
    evaluate true
    when top-numerator = 0
    when top-denominator = 0
    when 24 * top-denominator <> top-numerator
        display 'result (' top-numerator '/' top-denominator ') is not 24'
    when other
        display 'result is 24'
    end-evaluate
    .
evaluate-statement.
    compute l-lim = length(trim(statement))

    display NL 'numbers:' space n(1) space n(2) space n(3) space n(4)
    move number-definitions to number-use
    display 'statement is' space statement

    move 1 to l
    move 0 to loop-count
    move space to error-found

    move 0 to osx oqx
    move spaces to output-queue

    move 1 to p
    move 1 to nt
    move 0 to s
    perform increment-s
    perform display-start-nonterminal
    perform increment-p

    *>===================================
    *> interpret ebnf
    *>===================================
    perform until s = 0
    or error-found = 'y'

        evaluate true

        when p-symbol(p) = 'n'
        and p-definition(p) = 000 *> a variable
           perform test-variable
       if s-result(s) = 'S'
               perform increment-l
           end-if
           perform increment-p

       when p-symbol(p) = 'n'
       and p-address(p) <> p-definition(p) *> nonterminal reference
           move p to s-p(s)
           move p-definition(p) to p

       when p-symbol(p) = 'n'
       and p-address(p) = p-definition(p) *> nonterminal definition
           perform increment-s
           perform display-start-nonterminal
           perform increment-p

        when p-symbol(p) = '=' *> nonterminal control
            move p to s-start-control(s)
            move p-matching(p) to s-end-control(s)
            perform increment-p

        when p-symbol(p) = ';' *> end nonterminal
            perform display-end-control
            perform display-end-nonterminal
            perform decrement-s
            if s > 0
                evaluate true
                when s-result(r) = 'S'
                    perform set-success
                when s-result(r) = 'F'
                    perform set-failure
                end-evaluate
                move s-p(s) to p
                perform increment-p
                perform display-continue-nonterminal
            end-if

    when p-symbol(p) = '{' *> start repeat sequence
            perform increment-s
            perform display-start-control
            move p to s-start-control(s)
            move p-alternate(p) to s-alternate(s)
            move p-matching(p) to s-end-control(s)
            move 0 to s-count(s)
            perform increment-p

        when p-symbol(p) = '}' *> end repeat sequence
            perform display-end-control
            evaluate true
            when s-result(s) = 'S' *> repeat the sequence
                perform display-repeat-control
                perform set-nothing
                add 1 to s-repeat(s)
                move s-start-control(s) to p
                perform increment-p
           when other
               perform decrement-s
               evaluate true
               when s-result(r) = 'N'
               and s-repeat(r) = 0 *> no result
                   perform increment-p
               when s-result(r) = 'N'
               and s-repeat(r) > 0 *> no result after success
                   perform set-success
                   perform increment-p
               when other *> fail the sequence
                   perform increment-p
               end-evaluate
           end-evaluate

        when p-symbol(p) = '(' *> start sequence
            perform increment-s
            perform display-start-control
            move p to s-start-control(s)
            move p-alternate(p) to s-alternate(s)
            move p-matching(p) to s-end-control(s)
            move 0 to s-count(s)
            perform increment-p

       when p-symbol(p) = ')' *> end sequence
           perform display-end-control
           perform decrement-s
           evaluate true
           when s-result(r) = 'S' *> success
               perform set-success
               perform increment-p
           when s-result(r) = 'N' *> no result
               perform set-failure
               perform increment-p
            when other *> fail the sequence
               perform set-failure
               perform increment-p
           end-evaluate

        when p-symbol(p) = '|' *> alternate
            evaluate true
            when s-result(s) = 'S' *> exit the sequence
                perform display-skip-alternate
                move s-end-control(s) to p
            when other
                perform display-take-alternate
                move p-alternate(p) to s-alternate(s) *> the next alternate
                perform increment-p
                perform set-nothing
            end-evaluate

        when p-symbol(p) = 't' *> terminal
            move p-definition(p) to t
            move terminal-symbol-len(t) to t-len
            perform display-terminal
            evaluate true
            when statement(l:t-len) = terminal-symbol(t)(1:t-len) *> successful match
               perform set-success
               perform display-recognize-terminal
               perform process-token
               move t-len to l-len
               perform increment-l
               perform increment-p
            when s-alternate(s) <> 000 *> we are in an alternate sequence
               move s-alternate(s) to p
            when other *> fail the sequence
               perform set-failure
               move s-end-control(s) to p
            end-evaluate

        when other *> end control
            perform display-control-failure *> shouldnt happen

        end-evaluate

     end-perform

     evaluate true *> at end of evaluation
     when error-found = 'y'
         continue
     when l <= l-lim *> not all tokens parsed
         display 'error: invalid statement'
         perform statement-error
     when number-use <> spaces
         display 'error:  not all numbers were used: ' number-use
         move 'y' to error-found
     end-evaluate
    .
increment-l.
    evaluate true
    when l > l-lim *> end of statement
        continue
    when other
        add l-len to l
        perform varying l from l by 1
        until c(l) <> space
        or l > l-lim
            continue
        end-perform
        move 1 to l-len
        if l > l-lim
            perform end-tokens
        end-if
    end-evaluate
    .
increment-p.
    evaluate true
    when p >= p-max
        display 'at' space p ' parse overflow'
            space 's=<' s space s-entry(s) '>'
        move 'y' to error-found
    when other
        add 1 to p
        perform display-statement
    end-evaluate
    .
increment-s.
    evaluate true
    when s >= s-max
        display 'at' space p ' stack overflow '
            space 's=<' s space s-entry(s) '>'
        move 'y' to error-found
    when other
        move s to r
        add 1 to s
        initialize s-entry(s)
        move 'N' to s-result(s)
        move p to s-p(s)
        move nt to s-nt(s)
    end-evaluate
    .
decrement-s.
    if s > 0
        move s to r
        subtract 1 from s
        if s > 0
            move s-nt(s) to nt
        end-if
    end-if
    .
set-failure.
    move 'F' to s-result(s)
    if s-count(s) > 0
        display 'sequential parse failure'
        perform statement-error
    end-if
    .
set-success.
    move 'S' to s-result(s)
    add 1 to s-count(s)
    .
set-nothing.
    move 'N' to s-result(s)
    move 0 to s-count(s)
    .
statement-error.
    display statement
    move spaces to statement
    move '^ syntax error' to statement(l:)
    display statement
    move 'y' to error-found
    .
*>=====================
*> twentyfour semantics
*>=====================
test-variable.
    *> check validity
    perform varying nd from 1 by 1 until nd > 4
    or c(l) = n(nd)
        continue
    end-perform
    *> check usage
    perform varying nu from 1 by 1 until nu > 4
    or c(l) = u(nu)
        continue
    end-perform
    evaluate true
    when l > l-lim
        perform set-failure
    when c9(l) not numeric
        perform set-failure
    when nd > 4
        display 'invalid number'
        perform statement-error
    when nu > 4
        display 'number already used'
        perform statement-error
    when other
        move space to u(nu)
        perform set-success
        add 1 to oqx
        move c(l) to output-queue(oqx:1)
    end-evaluate
    .
*> ==================================
*> Dijkstra Shunting-Yard Algorithm
*> to convert infix to rpn
*> ==================================
process-token.
    evaluate true
    when c(l) = '('
        add 1 to osx
        move c(l) to operator-stack(osx:1)
    when c(l) = ')'
        perform varying osx from osx by -1 until osx < 1
        or operator-stack(osx:1) = '('
            add 1 to oqx
            move operator-stack(osx:1) to output-queue(oqx:1)
        end-perform
        if osx < 1
            display 'parenthesis error'
            perform statement-error
            exit paragraph
        end-if
        subtract 1 from osx
    when (c(l) = '+' or '-') and (operator-stack(osx:1) = '*' or '/')
        *> lesser operator precedence
        add 1 to oqx
        move operator-stack(osx:1) to output-queue(oqx:1)
        move c(l) to operator-stack(osx:1)
    when other
        *> greater operator precedence
        add 1 to osx
        move c(l) to operator-stack(osx:1)
    end-evaluate
    .
end-tokens.
    *> 1) copy stacked operators to the output-queue
    perform varying osx from osx by -1 until osx < 1
    or operator-stack(osx:1) = '('
        add 1 to oqx
        move operator-stack(osx:1) to output-queue(oqx:1)
    end-perform
    if osx > 0
        display 'parenthesis error'
        perform statement-error
        exit paragraph
    end-if
    *> 2) evaluate the rpn statement
    perform evaluate-rpn
    if divide-by-zero-error = 'y'
        display 'divide by zero error'
    end-if
    .
evaluate-rpn.
    move space to divide-by-zero-error
    move 0 to rsx *> stack depth
    perform varying oqx1 from 1 by 1 until oqx1 > oqx
        if output-queue(oqx1:1) >= '1' and <= '9'
            *> push current data onto the stack
            add 1 to rsx
            move top-numerator to numerator(rsx)
            move top-denominator to denominator(rsx)
            move output-queue(oqx1:1) to top-numerator
            move 1 to top-denominator
        else
            *> apply the operation
            evaluate true
            when output-queue(oqx1:1) = '+'
                compute top-numerator = top-numerator * denominator(rsx)
                    + top-denominator * numerator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when output-queue(oqx1:1) = '-'
                compute top-numerator = top-denominator * numerator(rsx)
                    - top-numerator * denominator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when output-queue(oqx1:1) = '*'
                compute top-numerator = top-numerator * numerator(rsx)
                compute top-denominator = top-denominator * denominator(rsx)
            when output-queue(oqx1:1) = '/'
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
*>====================
*> diagnostic displays
*>====================
display-start-nonterminal.
    perform varying nt from nt-lim by -1 until nt < 1
    or p-definition(p) = nonterminal-statement-number(nt)
        continue
    end-perform
    if nt > 0
        move '1' to NL-flag
        string '1' indent(1:s + s) 'at ' s space p ' start ' trim(nonterminal-statement(nt))
            into message-area perform display-message
        move nt to s-nt(s)
    end-if
    .
display-continue-nonterminal.
    move s-nt(s) to nt
    string '1' indent(1:s + s) 'at ' s space p space p-symbol(p) ' continue ' trim(nonterminal-statement(nt)) ' with result ' s-result(s)
            into message-area perform display-message
    .
display-end-nonterminal.
    move s-nt(s) to nt
    move '2' to NL-flag
    string '1' indent(1:s + s) 'at ' s space p ' end ' trim(nonterminal-statement(nt)) ' with result ' s-result(s)
            into message-area perform display-message
    .
display-start-control.
    string '2' indent(1:s + s) 'at ' s space p ' start ' p-symbol(p) ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-repeat-control.
    string '2' indent(1:s + s) 'at ' s space p ' repeat ' p-symbol(p) ' in ' trim(nonterminal-statement(nt))  ' with result ' s-result(s)
        into message-area perform display-message
    .
display-end-control.
    string '2' indent(1:s + s) 'at ' s space p ' end ' p-symbol(p)  ' in ' trim(nonterminal-statement(nt)) ' with result ' s-result(s)
        into message-area perform display-message
    .
display-take-alternate.
    string '2' indent(1:s + s) 'at ' s space p ' take alternate' ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-skip-alternate.
    string '2' indent(1:s + s) 'at ' s space p ' skip alternate' ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-terminal.
    string '1' indent(1:s + s) 'at ' s space p
        ' compare ' statement(l:t-len) ' to ' terminal-symbol(t)(1:t-len)
        ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-recognize-terminal.
    string '1' indent(1:s + s) 'at ' s space p ' recognize terminal: ' c(l) ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-recognize-variable.
    string '1' indent(1:s + s) 'at ' s space p ' recognize digit: ' c(l) ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-statement.
    compute p1 = p - s-start-control(s)
    string '3' indent(1:s + s) 'at ' s space p
        ' statement: ' s-start-control(s) '/' p1
        space p-symbol(p) space s-result(s)
        ' in ' trim(nonterminal-statement(nt))
        into message-area perform display-message
    .
display-control-failure.
    display loop-count space indent(1:s + s) 'at' space p ' control failure' ' in ' trim(nonterminal-statement(nt))
    display loop-count space indent(1:s + s) '   ' 'p=<' p p-entry(p) '>'
    display loop-count space indent(1:s + s) '   ' 's=<' s space s-entry(s) '>'
    display loop-count space indent(1:s + s) '   ' 'l=<' l space c(l)'>'
    perform statement-error
    .
display-message.
    if display-level = 1
        move space to NL-flag
    end-if
    evaluate true
    when loop-count > loop-lim *> loop control
        display 'display count exceeds ' loop-lim
        stop run
    when message-level <= display-level
        evaluate true
        when NL-flag = '1'
             display NL loop-count space trim(message-value)
        when NL-flag = '2'
             display loop-count space trim(message-value) NL
        when other
             display loop-count space trim(message-value)
        end-evaluate
    end-evaluate
    add 1 to loop-count
    move spaces to message-area
    move space to NL-flag
    .
end program twentyfour.
