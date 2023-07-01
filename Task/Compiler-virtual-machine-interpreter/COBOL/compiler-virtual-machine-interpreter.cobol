        >>SOURCE FORMAT IS FREE
identification division.
*> this code is dedicated to the public domain
*> (GnuCOBOL) 2.3-dev.0
program-id. vminterpreter.
environment division.
configuration section.
repository.  function all intrinsic.
input-output section.
file-control.
    select input-file assign using input-name
        status is input-status
        organization is line sequential.
data division.

file section.
fd  input-file.
01  input-record pic x(64).

working-storage section.
01  program-name pic x(32).
01  input-name pic x(32).
01  input-status pic xx.

01  error-record pic x(64) value spaces global.

01  v-max pic 99.
01  parameters.
    03  offset pic 999.
    03  opcode pic x(8).
    03  parm0 pic x(16).
    03  parm1 pic x(16).
    03  parm2 pic x(16).

01  opcodes.
    03  opFETCH pic x value x'00'.
    03  opSTORE pic x value x'01'.
    03  opPUSH  pic x value x'02'.
    03  opADD   pic x value x'03'.
    03  opSUB   pic x value x'04'.
    03  opMUL   pic x value x'05'.
    03  opDIV   pic x value x'06'.
    03  opMOD   pic x value x'07'.
    03  opLT    pic x value x'08'.
    03  opGT    pic x value x'09'.
    03  opLE    pic x value x'0A'.
    03  opGE    pic x value x'0B'.
    03  opEQ    pic x value x'0C'.
    03  opNE    pic x value x'0D'.
    03  opAND   pic x value x'0E'.
    03  opOR    pic x value x'0F'.
    03  opNEG   pic x value x'10'.
    03  opNOT   pic x value x'11'.
    03  opJMP   pic x value x'13'.
    03  opJZ    pic x value x'14'.
    03  opPRTC  pic x value x'15'.
    03  opPRTS  pic x value x'16'.
    03  opPRTI  pic x value x'17'.
    03  opHALT  pic x value x'18'.

01  filler.
    03  s pic 99.
    03  s-max pic 99 value 0.
    03  s-lim pic 99 value 16.
    03  filler occurs 16.
        05  string-length pic 99.
        05  string-entry pic x(48).

01  filler.
    03  v pic 99.
    03  v-lim pic 99 value 16.
    03  variables occurs 16 usage binary-int.

01  generated-code global.
    03  c  pic 999 value 1.
    03  pc pic 999.
    03  c-lim pic 999 value 512.
    03  kode pic x(512).

01  filler.
    03  stack1 pic 999 value 2.
    03  stack2 pic 999 value 1.
    03  stack-lim pic 999 value 998.
    03  stack occurs 998 usage binary-int.

01  display-definitions global.
    03  ascii-character.
        05  numeric-value usage binary-char.
    03  display-integer pic -(9)9.
    03  word-x.
        05  word usage binary-int.
    03  word-length pic 9.
    03  string1 pic 99.
    03  length1 pic 99.
    03  count1 pic 99.
    03  display-pending pic x.

procedure division.
start-vminterpreter.
    display 1 upon command-line *> get arg(1)
    accept program-name from argument-value
    move length(word) to word-length
    perform load-code
    perform run-code
    stop run
    .
run-code.
    move 1 to pc
    perform until pc >= c
        evaluate kode(pc:1)
        when opFETCH
            perform push-stack
            move kode(pc + 1:word-length) to word-x
            add 1 to word *> convert offset to subscript
            move variables(word) to stack(stack1)
            add word-length to pc
        when opPUSH
            perform push-stack
            move kode(pc + 1:word-length) to word-x
            move word to stack(stack1)
            add word-length to pc
        when opNEG
            compute stack(stack1) = -stack(stack1)
        when opNOT
            if stack(stack1) = 0
                move 1 to stack(stack1)
            else
                move 0 to stack(stack1)
            end-if
        when opJMP
            move kode(pc + 1:word-length) to word-x
            move word to pc
        when opHALT
            if display-pending = 'Y'
                display space
            end-if
            exit perform
        when opJZ
            if stack(stack1) = 0
                move kode(pc + 1:word-length) to word-x
                move word to pc
            else
                add word-length to pc
            end-if
            perform pop-stack
        when opSTORE
            move kode(pc + 1:word-length) to word-x
            add 1 to word *> convert offset to subscript
            move stack(stack1) to variables(word)
            add word-length to pc
            perform pop-stack
        when opADD
            add stack(stack1) to stack(stack2)
            perform pop-stack
        when opSUB
            subtract stack(stack1) from stack(stack2)
            perform pop-stack
        when opMUL
            multiply stack(stack1) by stack(stack2)
                *>rounded mode nearest-toward-zero *> doesn't match python
            perform pop-stack
        when opDIV
            divide stack(stack1) into stack(stack2)
                *>rounded mode nearest-toward-zero *> doesn't match python
            perform pop-stack
        when opMOD
            move mod(stack(stack2),stack(stack1)) to stack(stack2)
            perform pop-stack
        when opLT
            if stack(stack2) <  stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opGT
            if stack(stack2) >  stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opLE
            if stack(stack2) <= stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opGE
            if stack(stack2) >= stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opEQ
            if stack(stack2) = stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opNE
            if stack(stack2) <> stack(stack1)
                move 1 to stack(stack2)
            else
                move 0 to stack(stack2)
            end-if
            perform pop-stack
        when opAND
            call "CBL_AND" using stack(stack1) stack(stack2) by value word-length
            perform pop-stack
        when opOR
            call "CBL_OR" using stack(stack1) stack(stack2) by value word-length
            perform pop-stack
        when opPRTC
            move stack(stack1) to numeric-value
            if numeric-value = 10
                display space
                move 'N' to display-pending
            else
                display ascii-character with no advancing
                move 'Y' to display-pending
            end-if
            perform pop-stack
        when opPRTS
            add 1 to word *> convert offset to subscript
            move 1 to string1
            move string-length(word) to length1
            perform until string1 > string-length(word)
                move 0 to count1
                inspect string-entry(word)(string1:length1)
                    tallying count1 for characters before initial '\'   *> ' workaround code highlighter problem
                evaluate true
                when string-entry(word)(string1 + count1 + 1:1) = 'n' *> \n
                    display string-entry(word)(string1:count1)
                    move 'N' to display-pending
                    compute string1 = string1 + 2 + count1
                    compute length1 = length1 - 2 - count1
                when string-entry(word)(string1 + count1 + 1:1) = '\' *> ' \\
                    display string-entry(word)(string1:count1 + 1) with no advancing
                    move 'Y' to display-pending
                    compute string1 = string1 + 2 + count1
                    compute length1 = length1 - 2 - count1
                when other
                    display string-entry(word)(string1:count1) with no advancing
                    move 'Y' to display-pending
                    add count1 to string1
                    subtract count1 from length1
                end-evaluate
            end-perform
            perform pop-stack
        when opPRTI
            move stack(stack1) to display-integer
            display trim(display-integer) with no advancing
            move 'Y' to display-pending
            perform pop-stack
        end-evaluate
        add 1 to pc
    end-perform
    .
push-stack.
    if stack1 >= stack-lim
        string 'in vminterpreter at ' pc ' stack overflow at ' stack-lim into error-record
        perform report-error
    end-if
    add 1 to stack1 stack2
    >>d display ' push at ' pc space stack1 space stack2
    .
pop-stack.
    if stack1 < 2
        string 'in vminterpreter at ' pc ' stack underflow' into error-record
        perform report-error
    end-if
    >>d display ' pop at ' pc space stack1 space stack2
    subtract 1 from stack1 stack2
    .
load-code.
    perform read-input
    if input-status <> '00'
        string 'in vminterpreter no input data' into error-record
        perform report-error
    end-if

    unstring input-record delimited by all spaces into parm1 v-max parm2 s-max
    if v-max > v-lim
        string 'in vminterpreter datasize exceeds ' v-lim into error-record
        perform report-error
    end-if
    if s-max > s-lim
        string 'in vminterpreter number of strings exceeds ' s-lim into error-record
        perform report-error
    end-if

    perform read-input
    perform varying s from 1 by 1 until s > s-max
    or input-status <> '00'
        compute string-length(s) string-length(word) = length(trim(input-record)) - 2
        move input-record(2:string-length(word)) to string-entry(s)
        perform read-input
    end-perform
    if s <= s-max
        string 'in vminterpreter not all strings found' into error-record
        perform report-error
    end-if

    perform until input-status <> '00'
        initialize parameters
        unstring input-record delimited by all spaces into
            parm0 offset opcode parm1 parm2
        evaluate opcode
        when 'fetch'
            call 'emitbyte' using opFETCH
            call 'emitword' using parm1
        when 'store'
            call 'emitbyte' using opSTORE
            call 'emitword' using parm1
        when 'push'
            call 'emitbyte' using opPUSH
            call 'emitword' using parm1
        when 'add' call 'emitbyte' using opADD
        when 'sub' call 'emitbyte' using opSUB
        when 'mul' call 'emitbyte' using opMUL
        when 'div' call 'emitbyte' using opDIV
        when 'mod' call 'emitbyte' using opMOD
        when 'lt'  call 'emitbyte' using opLT
        when 'gt'  call 'emitbyte' using opGT
        when 'le'  call 'emitbyte' using opLE
        when 'ge'  call 'emitbyte' using opGE
        when 'eq'  call 'emitbyte' using opEQ
        when 'ne'  call 'emitbyte' using opNE
        when 'and' call 'emitbyte' using opAND
        when 'or'  call 'emitbyte' using opOR
        when 'not' call 'emitbyte' using opNOT
        when 'neg' call 'emitbyte' using opNEG
        when 'jmp'
             call 'emitbyte' using opJMP
             call 'emitword' using parm2
        when 'jz'
             call 'emitbyte' using opJZ
             call 'emitword' using parm2
        when 'prtc' call 'emitbyte' using opPRTC
        when 'prts' call 'emitbyte' using opPRTS
        when 'prti' call 'emitbyte' using opPRTI
        when 'halt' call 'emitbyte' using opHALT
        when other
            string 'in vminterpreter unknown opcode ' trim(opcode) ' at ' offset into error-record
            perform report-error
        end-evaluate
        perform read-input
    end-perform
    .
read-input.
    if program-name = spaces
        move '00' to input-status
        accept input-record on exception move '10' to input-status end-accept
        exit paragraph
    end-if
    if input-name = spaces
        string program-name delimited by space '.gen' into input-name
        open input input-file
        if input-status <> '00'
            string 'in vminterpreter ' trim(input-name) ' file open status ' input-status
                into error-record
            perform report-error
        end-if
    end-if
    read input-file into input-record
    evaluate input-status
    when '00'
        continue
    when '10'
        close input-file
    when other
        string 'in vminterpreter unexpected input-status: ' input-status into error-record
        perform report-error
    end-evaluate
    .
report-error.
    display error-record upon syserr
    stop run with error status -1
    .
identification division.
program-id. emitbyte.
data division.
linkage section.
01  opcode pic x.
procedure division using opcode.
start-emitbyte.
    if c >= c-lim
        string 'in vminterpreter emitbyte c exceeds ' c-lim into error-record
        call 'reporterror'
    end-if
    move opcode to kode(c:1)
    add 1 to c
    .
end program emitbyte.

identification division.
program-id. emitword.
data division.
working-storage section.
01  word-temp pic x(8).
linkage section.
01  word-value any length.
procedure division using word-value.
start-emitword.
    if c + word-length >= c-lim
        string 'in vminterpreter emitword c exceeds ' c-lim into error-record
        call 'reporterror'
    end-if
    move word-value to word-temp
    inspect word-temp converting '[' to ' '
    inspect word-temp converting ']' to ' '
    move numval(trim(word-temp)) to word
    move word-x to kode(c:word-length)
    add word-length to c
    .
end program emitword.

end program vminterpreter.
