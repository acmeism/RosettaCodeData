        >>SOURCE FORMAT IS FREE
identification division.
*> this code is dedicated to the public domain
*> (GnuCOBOL) 2.3-dev.0
program-id. generator.
environment division.
configuration section.
repository.  function all intrinsic.
data division.
working-storage section.
01  program-name pic x(32) value spaces global.
01  input-name pic x(32) value spaces global.
01  input-status pic xx global.

01  ast-record global.
    03  ast-type pic x(14).
    03  ast-value pic x(48).
    03  filler redefines ast-value.
        05  asl-left pic 999.
        05  asl-right pic 999.

01  error-record pic x(64) value spaces global.

01  loadstack global.
    03  l pic 99 value 0.
    03  l-lim pic 99 value 64.
    03  load-entry occurs 64.
        05  l-node pic x(14).
        05  l-left pic 999.
        05  l-right pic 999.
        05  l-link pic 999.

01  abstract-syntax-tree global.
    03  t pic 999 value 0.
    03  t1 pic 999.
    03  t-lim pic 999 value 998.
    03  filler occurs 998.
        05  p1 pic 999.
        05  p2 pic 999.
        05  p3 pic 999.
        05  n1 pic 999.
        05  leaf.
            07  leaf-type pic x(14).
            07  leaf-value pic x(48).
        05  node redefines leaf.
            07  node-type pic x(14).
            07  node-left pic 999.
            07  node-right pic 999.

01  opcodes global.
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

01  variables global.
    03  v pic 99.
    03  v-max pic 99 value 0.
    03  v-lim pic 99 value 16.
    03  variable-entry occurs 16 pic x(48).

01  strings global.
    03  s pic 99.
    03  s-max pic 99 value 0.
    03  s-lim pic 99 value 16.
    03  string-entry occurs 16 pic x(48).

01  generated-code global.
    03  c  pic 999 value 1.
    03  c1 pic 999.
    03  c-lim pic 999 value 512.
    03  kode pic x(512).

procedure division chaining program-name.
start-generator.
    call 'loadast'
    if program-name <> spaces
        call 'readinput' *> close input-file
    end-if
    >>d perform print-ast
    call 'codegen' using t
    call 'emitbyte' using opHALT
    >>d call 'showhex' using kode c
    call 'listcode'
    stop run
    .
print-ast.
    call 'printast' using t
    display 'ast:' upon syserr
    display 't=' t
    perform varying t1 from 1 by 1 until t1 > t
        if leaf-type(t1) = 'Identifier' or 'Integer' or 'String'
            display t1 space trim(leaf-type(t1)) space trim(leaf-value(t1)) upon syserr
        else
            display t1 space node-left(t1) space node-right(t1) space trim(node-type(t1))
                upon syserr
        end-if
    end-perform
    .
identification division.
program-id. codegen common recursive.
data division.
working-storage section.
01  r pic ---9.
linkage section.
01  n pic 999.
procedure division using n.
start-codegen.
    if n = 0
        exit program
    end-if
    >>d display 'at 'c ' node=' space n space node-type(n) upon syserr
    evaluate node-type(n)
    when 'Identifier'
        call 'emitbyte' using opFetch
        call 'variableoffset' using leaf-value(n)
        call 'emitword' using v '0'
    when 'Integer'
        call 'emitbyte' using opPUSH
        call 'emitword' using leaf-value(n) '0'
    when 'String'
        call 'emitbyte' using opPUSH
        call 'stringoffset' using leaf-value(n)
        call 'emitword' using s '0'
    when 'Assign'
        call 'codegen' using node-right(n)
        call 'emitbyte' using opSTORE
        move node-left(n) to n1(n)
        call 'variableoffset' using leaf-value(n1(n))
        call 'emitword' using v '0'
    when 'If'
        call 'codegen' using node-left(n)          *> conditional expr
        call 'emitbyte' using opJZ                 *> jump to false path or exit
        move c to p1(n)
        call 'emitword' using '0' '0'
        move node-right(n) to n1(n)                *> true path
        call 'codegen' using node-left(n1(n))
        if node-right(n1(n)) <> 0                  *> there is a false path
            call 'emitbyte' using opJMP            *> jump past false path
            move c to p2(n)
            call 'emitword' using '0' '0'
            compute r = c - p1(n)                  *> fill in jump to false path
            call 'emitword' using r p1(n)
            call 'codegen' using node-right(n1(n)) *> false path
            compute r = c - p2(n)                  *> fill in jump to exit
            call 'emitword' using r p2(n)
        else
            compute r = c - p1(n)
            call 'emitword' using r p1(n)          *> fill in jump to exit
        end-if
    when 'While'
        move c to p3(n)                            *> save address of while start
        call 'codegen' using node-left(n)          *> conditional expr
        call 'emitbyte' using opJZ                 *> jump to exit
        move c to p2(n)
        call 'emitword' using '0' '0'
        call 'codegen' using node-right(n)         *> while body
        call 'emitbyte' using opJMP                *> jump to while start
        compute r = p3(n) - c
        call 'emitword' using r '0'
        compute r = c - p2(n)                      *> fill in jump to exit
        call 'emitword' using r p2(n)
    when 'Sequence'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
    when 'Prtc'
        call 'codegen' using node-left(n)
        call 'emitbyte' using opPRTC
    when 'Prti'
        call 'codegen' using node-left(n)
        call 'emitbyte' using opPRTI
    when 'Prts'
        call 'codegen' using node-left(n)
        call 'emitbyte' using opPRTS
    when 'Less'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opLT
    when 'Greater'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opGT
    when 'LessEqual'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opLE
    when 'GreaterEqual'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opGE
    when 'Equal'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opEQ
    when 'NotEqual'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opNE
    when 'And'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opAND
    when 'Or'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opOR
    when 'Subtract'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opSUB
    when 'Add'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opADD
    when 'Divide'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opDIV
    when 'Multiply'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opMUL
    when 'Mod'
        call 'codegen' using node-left(n)
        call 'codegen' using node-right(n)
        call 'emitbyte' using opMOD
    when 'Negate'
       call 'codegen' using node-left(n)
       call 'emitbyte' using opNEG
    when 'Not'
        call 'codegen' using node-left(n)
        call 'emitbyte' using opNOT
    when other
        string 'in generator unknown node type: ' node-type(n) into error-record
        call 'reporterror'
    end-evaluate
    .
end program codegen.

identification division.
program-id. variableoffset common.
data division.
linkage section.
01  variable-value pic x(48).
procedure division using variable-value.
start-variableoffset.
    perform varying v from 1 by 1
    until v > v-max
    or variable-entry(v) = variable-value
        continue
    end-perform
    if v > v-lim
        string 'in generator variable offset v exceeds ' v-lim into error-record
        call 'reporterror'
    end-if
    if v > v-max
        move v to v-max
        move variable-value to variable-entry(v)
    end-if
    .
end program variableoffset.

identification division.
program-id. stringoffset common.
data division.
linkage section.
01  string-value pic x(48).
procedure division using string-value.
start-stringoffset.
    perform varying s from 1 by 1
    until s > s-max
    or string-entry(s) = string-value
        continue
    end-perform
    if s > s-lim
        string ' generator stringoffset s exceeds ' s-lim into error-record
        call 'reporterror'
    end-if
    if s > s-max
        move s to s-max
        move string-value to string-entry(s)
    end-if
    subtract 1 from s *> convert index to offset
    .
end program stringoffset.

identification division.
program-id. emitbyte common.
data division.
linkage section.
01  opcode pic x.
procedure division using opcode.
start-emitbyte.
    if c >= c-lim
        string 'in generator emitbyte c exceeds ' c-lim into error-record
        call 'reporterror'
    end-if
    move opcode to kode(c:1)
    add 1 to c
    .
end program emitbyte.

identification division.
program-id. emitword common.
data division.
working-storage section.
01  word-x.
    03  word usage binary-int.
01  loc pic 999.
linkage section.
01  word-value any length.
01  loc-value any length.
procedure division using word-value loc-value.
start-emitword.
    if c + length(word) > c-lim
        string 'in generator emitword exceeds ' c-lim into error-record
        call 'reporterror'
    end-if
    move numval(word-value) to word
    move numval(loc-value) to loc
    if loc = 0
        move word-x to kode(c:length(word))
        add length(word) to c
    else
        move word-x to kode(loc:length(word))
    end-if
    .
end program emitword.

identification division.
program-id. listcode common.
data division.
working-storage section.
01  word-x.
    03  word usage binary-int.
01  address-display pic ---9.
01  address-absolute pic zzz9.
01  data-display pic -(9)9.
01  v-display pic z9.
01  s-display pic z9.
01  c-display pic zzz9.
procedure division.
start-listcode.
    move v-max to v-display
    move s-max to s-display
    display 'Datasize: ' trim(v-display) space 'Strings: ' trim(s-display)

    perform varying s from 1 by 1
    until s > s-max
        display string-entry(s)
    end-perform

    move 1 to c1
    perform until c1 >= c
        compute c-display = c1 - 1
        display c-display space with no advancing
        evaluate kode(c1:1)
        when opFETCH
            add 1 to c1
            move kode(c1:4) to word-x
            compute address-display = word - 1
            display 'fetch [' trim(address-display) ']'
            add 3 to c1
        when opSTORE
            add 1 to c1
            move kode(c1:4) to word-x
            compute address-display = word - 1
            display 'store [' trim(address-display) ']'
            add 3 to c1
        when opPUSH
            add 1 to c1
            move kode(c1:4) to word-x
            move word to data-display
            display 'push  ' trim(data-display)
            add 3 to c1
        when opADD   display 'add'
        when opSUB   display 'sub'
        when opMUL   display 'mul'
        when opDIV   display 'div'
        when opMOD   display 'mod'
        when opLT    display 'lt'
        when opGT    display 'gt'
        when opLE    display 'le'
        when opGE    display 'ge'
        when opEQ    display 'eq'
        when opNE    display 'ne'
        when opAND   display 'and'
        when opOR    display 'or'
        when opNEG   display 'neg'
        when opNOT   display 'not'
        when opJMP
            move kode(c1 + 1:length(word)) to word-x
            move word to address-display
            compute address-absolute = c1 + word
            display 'jmp    (' trim(address-display) ') ' trim(address-absolute)
            add length(word) to c1
        when opJZ
            move kode(c1 + 1:length(word)) to word-x
            move word to address-display
            compute address-absolute = c1 + word
            display 'jz     (' trim(address-display) ') ' trim(address-absolute)
            add length(word) to c1
        when opPRTC  display 'prtc'
        when opPRTI  display 'prti'
        when opPRTS  display 'prts'
        when opHALT  display 'halt'
        when other
            string 'in generator unknown opcode ' kode(c1:1) into error-record
            call 'reporterror'
        end-evaluate
        add 1 to c1
    end-perform
    .
end program listcode.

identification division.
program-id. loadast common recursive.
procedure division.
start-loadast.
    if l >= l-lim
        string 'in generator loadast l exceeds ' l-lim into error-record
        call 'reporterror'
    end-if
    add 1 to l
    call 'readinput'
    evaluate true
    when ast-record = ';'
    when input-status = '10'
        move 0 to return-code
    when ast-type = 'Identifier'
    when ast-type = 'Integer'
    when ast-type = 'String'
        call 'makeleaf' using ast-type ast-value
        move t to return-code
    when ast-type = 'Sequence'
        move ast-type to l-node(l)
        call 'loadast'
        move return-code to l-left(l)
        call 'loadast'
        move t to l-right(l)
        call 'makenode' using l-node(l) l-left(l) l-right(l)
        move t to return-code
    when other
        move ast-type to l-node(l)
        call 'loadast'
        move return-code to l-left(l)
        call 'loadast'
        move return-code to l-right(l)
        call 'makenode' using l-node(l) l-left(l) l-right(l)
        move t to return-code
    end-evaluate
    subtract 1 from l
    .
end program loadast.

identification division.
program-id. printast common recursive.
data division.
linkage section.
01  n pic 999.
procedure division using n.
start-printast.
    if n = 0
        display ';' upon syserr
        exit program
    end-if
    display leaf-type(n) upon syserr
    evaluate leaf-type(n)
    when 'Identifier'
    when 'Integer'
    when 'String'
        display leaf-type(n) space trim(leaf-value(n)) upon syserr
    when other
        display node-type(n) upon syserr
        call 'printast' using node-left(n)
        call 'printast' using node-right(n)
    end-evaluate
    .
end program printast.

identification division.
program-id. makenode common.
data division.
linkage section.
01  parm-type any length.
01  parm-l-left pic 999.
01  parm-l-right pic 999.
procedure division using parm-type parm-l-left parm-l-right.
start-makenode.
    if t >= t-lim
        string 'in generator makenode t exceeds ' t-lim into error-record
        call 'reporterror'
    end-if
    add 1 to t
    move parm-type to node-type(t)
    move parm-l-left to node-left(t)
    move parm-l-right to node-right(t)
    .
end program makenode.

identification division.
program-id. makeleaf common.
data division.
linkage section.
01  parm-type any length.
01  parm-value pic x(48).
procedure division using parm-type parm-value.
start-makeleaf.
    add 1 to t
    if t >= t-lim
        string 'in generator makeleaf t exceeds ' t-lim into error-record
        call 'reporterror'
    end-if
    move parm-type to leaf-type(t)
    move parm-value to leaf-value(t)
    .
end program makeleaf.

identification division.
program-id. readinput common.
environment division.
input-output section.
file-control.
    select input-file assign using input-name
        status is input-status
        organization is line sequential.
data division.
file section.
fd  input-file.
01  input-record pic x(64).
procedure division.
start-readinput.
    if program-name = spaces
        move '00' to input-status
        accept ast-record on exception move '10' to input-status end-accept
        exit program
    end-if
    if input-name = spaces
        string program-name delimited by space '.ast' into input-name
        open input input-file
        if input-status = '35'
            string 'in generator ' trim(input-name) ' not found' into error-record
            call 'reporterror'
        end-if
    end-if
    read input-file into ast-record
    evaluate input-status
    when '00'
        continue
    when '10'
        close input-file
    when other
        string 'in generator ' trim(input-name) ' unexpected input-status: ' input-status
            into error-record
        call 'reporterror'
    end-evaluate
    .
end program readinput.

program-id. reporterror common.
procedure division.
start-reporterror.
report-error.
    display error-record upon syserr
    stop run with error status -1
    .
end program reporterror.

identification division.
program-id. showhex common.

data division.
working-storage section.
01  hex.
    03  filler pic x(32) value '000102030405060708090A0B0C0D0E0F'.
    03  filler pic x(32) value '101112131415161718191A1B1C1D1E1F'.
    03  filler pic x(32) value '202122232425262728292A2B2C2D2E2F'.
    03  filler pic x(32) value '303132333435363738393A3B3C3D3E3F'.
    03  filler pic x(32) value '404142434445464748494A4B4C4D4E4F'.
    03  filler pic x(32) value '505152535455565758595A5B5C5D5E5F'.
    03  filler pic x(32) value '606162636465666768696A6B6C6D6E6F'.
    03  filler pic x(32) value '707172737475767778797A7B7C7D7E7F'.
    03  filler pic x(32) value '808182838485868788898A8B8C8D8E8F'.
    03  filler pic x(32) value '909192939495969798999A9B9C9D9E9F'.
    03  filler pic x(32) value 'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'.
    03  filler pic x(32) value 'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'.
    03  filler pic x(32) value 'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'.
    03  filler pic x(32) value 'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'.
    03  filler pic x(32) value 'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'.
    03  filler pic x(32) value 'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'.

01  cdx pic 9999.
01  bdx pic 999.
01  byte-count pic 9.
01  bytes-per-word pic 9 value 4.
01  word-count pic 9.
01  words-per-line pic 9 value 8.

linkage section.
01  data-field any length.
01  length-data-field pic 999.

procedure division using
    by reference data-field
    by reference length-data-field.
start-showhex.
    move 1 to byte-count
    move 1 to word-count
    perform varying cdx from 1 by 1
    until cdx > length-data-field
         compute bdx = 2 * ord(data-field(cdx:1)) - 1 end-compute
         display hex(bdx:2) with no advancing upon syserr
         add 1 to byte-count end-add
         if byte-count > bytes-per-word
             display ' ' with no advancing upon syserr
             move 1 to byte-count
             add 1 to word-count end-add
         end-if
         if word-count > words-per-line
             display ' ' upon syserr
             move 1 to word-count
         end-if
    end-perform
    if word-count <> 1
    or byte-count <> 1
        display ' ' upon syserr
    end-if
    display ' ' upon syserr
    goback
    .
end program showhex.
end program generator.
