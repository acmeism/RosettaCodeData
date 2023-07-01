        >>SOURCE FORMAT IS FREE
identification division.
*> this code is dedicated to the public domain
*> (GnuCOBOL) 2.3-dev.0
*> for extra credit, generate this program directly from the EBNF
program-id. parser.
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
fd  input-file global.
01  input-record global.
    03  input-line pic zzzz9.
    03  input-column pic zzzzzz9.
    03  filler pic x(3).
    03  input-token pic x(16).
    03  input-value pic x(48).

working-storage section.
01  program-name pic x(32) value spaces global.
01  input-name pic x(32) value spaces global.
01  input-status pic xx global.

01  line-no pic 999 value 0.
01  col-no pic 99 value 0.

01  error-record global.
    03  error-line-no pic zzzz9.
    03  error-col-no pic zzzzzz9.
    03  filler pic x value space.
    03  error-message pic x(64) value spaces.

01  token global.
    03  token-type pic x(16).
    03  token-line pic 999.
    03  token-column pic 99.
    03  token-value pic x(48).

01  parse-stack global.
    03  p pic 999 value 0.
    03  p-lim pic 999 value 200.
    03  p-zero pic 999 value 0.
    03  parse-entry occurs 200.
        05  parse-name pic x(24).
        05  parse-token pic x(16).
        05  parse-left pic 999.
        05  parse-right pic 999.
        05  parse-work pic 999.
        05  parse-work1 pic 999.

01  abstract-syntax-tree global.
    03  t pic 999 value 0.
    03  t1 pic 999.
    03  t-lim pic 999 value 998.
    03  filler occurs 998.
        05  leaf.
            07  leaf-type pic x(14).
            07  leaf-value pic x(48).
        05  node redefines leaf.
            07  node-type pic x(14).
            07  node-left pic 999.
            07  node-right pic 999.

01  indent pic x(200) value all '|   ' global.

procedure division chaining program-name.
start-parser.
    if program-name <> spaces
        string program-name delimited by space '.lex' into input-name
        open input input-file
        if input-status <> '00'
            string 'in parser ' trim(input-name) ' open status ' input-status
                into error-message
            call 'reporterror'
        end-if
    end-if
    call 'gettoken'
    call 'stmt_list'
    if input-name <> spaces
        close input-file
    end-if

    call 'printast' using t

    >>d perform dump-ast

    stop run
    .
dump-ast.
    display '==========' upon syserr
    display 'ast:' upon syserr
    display 't=' t upon syserr
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
program-id. stmt_list common recursive.
data division.
procedure division.
start-stmt_list.
    call 'push' using module-id
    move p-zero to parse-left(p)
    perform forever
        call 'stmt'
        move return-code to parse-right(p)
        call 'makenode' using 'Sequence' parse-left(p) parse-right(p)
        move return-code to parse-left(p)
        if parse-right(p) = 0
        or token-type = 'End_of_input'
            exit perform
        end-if
    end-perform
    call 'pop'
    .
end program stmt_list.

identification division.
program-id. stmt common recursive.
procedure division.
start-stmt.
    call 'push' using module-id
    move p-zero to parse-left(p)
    evaluate token-type
    when 'Semicolon'
        call 'gettoken'
    when 'Identifier'
        *>Identifier '=' expr ';'
        call 'makeleaf' using 'Identifier' token-value
        move return-code to parse-left(p)
        call 'gettoken'
        call 'expect' using 'Op_assign'
        call 'expr'
        move return-code to parse-right(p)
        call 'expect' using 'Semicolon'
        call 'makenode' using 'Assign' parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    when 'Keyword_while'
        *>'while' paren_expr '{' stmt '}'
        call 'gettoken'
        call 'paren_expr'
        move return-code to parse-work(p)
        call 'stmt'
        move return-code to parse-right(p)
        call 'makenode' using 'While' parse-work(p) parse-right(p)
        move return-code to parse-left(p)
    when 'Keyword_if'
        *>'if' paren_expr stmt ['else' stmt]
        call 'gettoken'
        call 'paren_expr'
        move return-code to parse-left(p)
        call 'stmt'
        move return-code to parse-work(p)
        move p-zero to parse-work1(p)
        if token-type = 'Keyword_else'
            call 'gettoken'
            call 'stmt'
            move return-code to parse-work1(p)
        end-if
        call 'makenode' using 'If' parse-work(p) parse-work1(p)
        move return-code to parse-right(p)
        call 'makenode' using 'If' parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    when 'Keyword_print'
        *>'print' '(' prt_list ')' ';'
        call 'gettoken'
        call 'expect' using 'LeftParen'
        call 'prt_list'
        move return-code to parse-left(p)
        call 'expect' using 'RightParen'
        call 'expect' using 'Semicolon'
    when 'Keyword_putc'
        *>'putc' paren_expr ';'
        call 'gettoken'
        call 'paren_expr'
        move return-code to parse-left(p)
        call 'makenode' using 'Prtc' parse-left(p) p-zero
        move return-code to parse-left(p)
        call 'expect' using 'Semicolon'
    when 'LeftBrace'
        *>'{' stmt '}'
        call 'gettoken'
        move p-zero to parse-left(p)
        perform until token-type = 'RightBrace' or 'End_of_input'
            call 'stmt'
            move return-code to parse-right(p)
            call 'makenode' using 'Sequence' parse-left(p) parse-right(p)
            move return-code to parse-left(p)
        end-perform
        if token-type <> 'End_of_input'
            call 'gettoken'
        end-if
    when other
        move 0 to parse-left(p)
    end-evaluate
    move parse-left(p) to return-code
    call 'pop'
    .
end program stmt.

identification division.
program-id. paren_expr common recursive.
procedure division.
start-paren_expr.
    *>'(' expr ')' ;
    call 'push' using module-id
    call 'expect' using 'LeftParen'
    call 'expr'
    call 'expect' using 'RightParen'
    call 'pop'
    .
end program paren_expr.

identification division.
program-id. prt_list common.
procedure division.
start-prt_list.
    *>(string | expr) {',' (String | expr)} ;
    call 'push' using module-id
    move p-zero to parse-work(p)
    perform prt_entry
    perform until token-type <> 'Comma'
        call 'gettoken'
        perform prt_entry
    end-perform
    call 'pop'
    exit program
    .
prt_entry.
    if token-type = 'String'
        call 'makeleaf' using token-type token-value
        move return-code to parse-left(p)
        call 'makenode' using 'Prts' parse-left(p) p-zero
        call 'gettoken'
    else
        call 'expr'
        move return-code to parse-left(p)
        call 'makenode' using 'Prti' parse-left(p) p-zero
    end-if
    move return-code to parse-right(p)
    call 'makenode' using 'Sequence' parse-work(p) parse-right(p)
    move return-code to parse-work(p)
    .
end program prt_list.

identification division.
program-id. expr common recursive.
procedure division.
start-expr.
    *>and_expr {'||' and_expr} ;
    call 'push' using module-id
    call 'and_expr'
    move return-code to parse-left(p)
    perform forever
       if token-type <> 'Op_or'
           exit perform
       end-if
       call 'gettoken'
       call 'and_expr'
       move return-code to parse-right(p)
       call 'makenode' using 'Or' parse-left(p) parse-right(p)
       move return-code to parse-left(p)
    end-perform
    move parse-left(p) to return-code
    call 'pop'
    .
end program expr.

identification division.
program-id. and_expr common recursive.
procedure division.
start-and_expr.
    *>equality_expr {'&&' equality_expr} ;
    call 'push' using module-id
    call 'equality_expr'
    move return-code to parse-left(p)
    perform forever
        if token-type <> 'Op_and'
            exit perform
        end-if
        call 'gettoken'
        call 'equality_expr'
        move return-code to parse-right(p)
        call 'makenode' using 'And' parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    end-perform
    call 'pop'
    .
end program and_expr.

identification division.
program-id. equality_expr common recursive.
procedure division.
start-equality_expr.
    *>relational_expr [('==' | '!=') relational_expr] ;
    call 'push' using module-id
    call 'relational_expr'
    move return-code to parse-left(p)
    evaluate token-type
    when 'Op_equal'
        move 'Equal' to parse-token(p)
    when 'Op_notequal'
        move 'NotEqual' to parse-token(p)
    end-evaluate
    if parse-token(p) <> spaces
        call 'gettoken'
        call 'relational_expr'
        move return-code to parse-right(p)
        call 'makenode' using parse-token(p) parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    end-if
    call 'pop'
    .
end program equality_expr.

identification division.
program-id. relational_expr common recursive.
procedure division.
start-relational_expr.
    *>addition_expr [('<' | '<=' | '>' | '>=') addition_expr] ;
    call 'push' using module-id
    call 'addition_expr'
    move return-code to parse-left(p)
    evaluate token-type
    when 'Op_less'
        move 'Less' to parse-token(p)
    when 'Op_lessequal'
        move 'LessEqual' to parse-token(p)
    when 'Op_greater'
        move 'Greater' to parse-token(p)
    when 'Op_greaterequal'
        move 'GreaterEqual' to parse-token(p)
    end-evaluate
    if parse-token(p) <> spaces
        call 'gettoken'
        call 'addition_expr'
        move return-code to parse-right(p)
        call 'makenode' using parse-token(p) parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    end-if
    call 'pop'
    .
end program relational_expr.

identification division.
program-id. addition_expr common recursive.
procedure division.
start-addition_expr.
    *>multiplication_expr {('+' | '-') multiplication_expr} ;
    call 'push' using module-id
    call 'multiplication_expr'
    move return-code to parse-left(p)
    perform forever
        evaluate token-type
        when 'Op_add'
            move 'Add' to parse-token(p)
        when 'Op_subtract'
            move 'Subtract' to parse-token(p)
        when other
            exit perform
        end-evaluate
        call 'gettoken'
        call 'multiplication_expr'
        move return-code to parse-right(p)
        call 'makenode' using parse-token(p) parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    end-perform
    call 'pop'
    .
end program addition_expr.

identification division.
program-id.  multiplication_expr common recursive.
procedure division.
start-multiplication_expr.
    *>primary {('*' | '/' | '%') primary } ;
    call 'push' using module-id
    call 'primary'
    move return-code to parse-left(p)
    perform forever
        evaluate token-type
        when 'Op_multiply'
            move 'Multiply' to parse-token(p)
        when 'Op_divide'
            move 'Divide' to parse-token(p)
        when 'Op_mod'
            move 'Mod' to parse-token(p)
        when other
            exit perform
        end-evaluate
        call 'gettoken'
        call 'primary'
        move return-code to parse-right(p)
        call 'makenode' using parse-token(p) parse-left(p) parse-right(p)
        move return-code to parse-left(p)
    end-perform
    call 'pop'
    .
end program multiplication_expr.

identification division.
program-id. primary common recursive.
procedure division.
start-primary.
    *>  Identifier
    *>| Integer
    *>| 'LeftParen' expr 'RightParen'
    *>| ('+' | '-' | '!') primary
    *>;
    call 'push' using module-id
    evaluate token-type
    when 'Identifier'
        call 'makeleaf' using 'Identifier' token-value
        call 'gettoken'
    when 'Integer'
        call 'makeleaf' using 'Integer' token-value
        call 'gettoken'
    when 'LeftParen'
        call 'gettoken'
        call 'expr'
        call 'expect' using 'RightParen'
        move t to return-code
    when 'Op_add'
        call 'gettoken'
        call 'primary'
    when 'Op_subtract'
        call 'gettoken'
        call 'primary'
        move return-code to parse-left(p)
        call 'makenode' using 'Negate' parse-left(p) p-zero
    when 'Op_not'
        call 'gettoken'
        call 'primary'
        move return-code to parse-left(p)
        call 'makenode' using 'Not' parse-left(p) p-zero
    when other
        move 0 to return-code
    end-evaluate
    call 'pop'
    .
end program primary.

program-id. reporterror common.
procedure division.
start-reporterror.
report-error.
    move token-line to error-line-no
    move token-column to error-col-no
    display error-record upon syserr
    stop run with error status -1
    .
end program reporterror.

identification division.
program-id. gettoken common.
procedure division.
start-gettoken.
    if program-name = spaces
        move '00' to input-status
        accept input-record on exception move '10' to input-status end-accept
    else
        read input-file
    end-if

    evaluate input-status
    when '00'
        move input-token to token-type
        move input-value to token-value
        move numval(input-line) to token-line
        move numval(input-column) to token-column
        >>d display indent(1:min(4 * p,length(indent))) 'new token: ' token-type upon syserr
    when '10'
        string 'in parser ' trim(input-name) ' unexpected end of input'
            into error-message
        call 'reporterror'
    when other
        string 'in parser ' trim(input-name) ' unexpected input-status ' input-status
            into error-message
        call 'reporterror'
    end-evaluate
    .
end program gettoken.

identification division.
program-id. expect common.
data division.
linkage section.
01  what any length.
procedure division using what.
start-expect.
    if token-type <> what
        string 'in parser expected ' what ' found ' token-type into error-message
        call 'reporterror'
    end-if
    >>d display indent(1:min(4 * p,length(indent))) 'match: ' token-type upon syserr
    call 'gettoken'
    .
end program expect.

identification division.
program-id. push common.
data division.
linkage section.
01  what any length.
procedure division using what.
start-push.
    >>d display indent(1:min(4 * p,length(indent))) 'push ' what upon syserr
    if p >= p-lim
        move 'in parser stack overflow' to error-message
        call 'reporterror'
    end-if
    add 1 to p
    initialize parse-entry(p)
    move what to parse-name(p)
    .
end program push.

identification division.
program-id. pop common.
procedure division.
start-pop.
    if p < 1
        move 'in parser stack underflow' to error-message
        call 'reporterror'
    end-if
    >>d display indent(1:4 * p - 4) 'pop ' parse-name(p) upon syserr
    subtract 1 from p
    .
end program pop.

identification division.
program-id. makenode common.
data division.
linkage section.
01  parm-type any length.
01  parm-left pic 999.
01  parm-right pic 999.
procedure division using parm-type parm-left parm-right.
start-makenode.
    if t >= t-lim
        string 'in parser makenode tree index t exceeds ' t-lim into error-message
        call 'reporterror'
    end-if
    add 1 to t
    move parm-type to node-type(t)
    move parm-left to node-left(t)
    move parm-right to node-right(t)
    move t to return-code
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
    if t >= t-lim
        string 'in parser makeleaf tree index t exceeds ' t-lim into error-message
        call 'reporterror'
    end-if
    add 1 to t
    move parm-type to leaf-type(t)
    move parm-value to leaf-value(t)
    move t to return-code
    .
end program makeleaf.

identification division.
program-id. printast recursive.
data division.
linkage section.
01  n pic 999.
procedure division using n.
start-printast.
    if n = 0
        display ';'
        exit program
    end-if
    evaluate leaf-type(n)
    when 'Identifier'
    when 'Integer'
    when 'String'
        display leaf-type(n) trim(leaf-value(n))
    when other
        display node-type(n)
        call 'printast' using node-left(n)
        call 'printast' using node-right(n)
    end-evaluate
    .
end program printast.
end program parser.
