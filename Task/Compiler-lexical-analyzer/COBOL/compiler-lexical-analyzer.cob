        >>SOURCE FORMAT IS FREE
*> this code is dedicated to the public domain
*> (GnuCOBOL) 2.3-dev.0
identification division.
program-id. lexer.
environment division.
configuration section.
repository. function all intrinsic.
input-output section.
file-control.
    select input-file assign using input-name
        status input-status
        organization line sequential.
data division.

file section.
fd  input-file.
01  input-record pic x(98).

working-storage section.
01  input-name pic x(32).
01  input-status pic xx.
01  input-length pic 99.

01  output-name pic x(32) value spaces.
01  output-status pic xx.
01  output-record pic x(64).

01  line-no pic 999 value 0.
01  col-no pic 99.
01  col-no-max pic 99.
01  col-increment pic 9 value 1.
01  start-col pic 99.
01  outx pic 99.
01  out-lim pic 99 value 48.

01  output-line value spaces.
    03  out-line pic zzzz9.
    03  out-column pic zzzzzz9.
    03  message-area.
        05  filler pic xxx.
        05  token pic x(16).
        05  out-value pic x(48).
        05  out-integer redefines out-value pic zzzzz9.
        05  out-integer1 redefines out-value pic zzzzzz9. *> to match the python lexer

01  error-record.
    03  error-line pic zzzz9 value 0.
    03  error-col pic zzzzzz9 value 0.
    03  error-message pic x(68) value spaces.

01  scan-state pic x(16) value spaces.
01  current-character pic x.
01  previous-character pic x.

procedure division chaining input-name.
start-lexer.
    if input-name <> spaces
        open input input-file
        if input-status = '35'
            string 'in lexer ' trim(input-name) ' not found' into error-message
            perform report-error
        end-if
    end-if
    perform read-input-file
    perform until input-status <> '00'
        add 1 to line-no
        move line-no to out-line
        move length(trim(input-record,trailing)) to col-no-max
        move 1 to col-no
        move space to previous-character
        perform until col-no > col-no-max
            move col-no to out-column
            move input-record(col-no:1) to current-character
            evaluate scan-state

            when 'identifier'
                if current-character >= 'A' and <= 'Z'
                or (current-character >= 'a' and <= 'z')
                or (current-character >= '0' and <= '9')
                or current-character = '_'
                    perform increment-outx
                    move current-character to out-value(outx:1)
                    if col-no = col-no-max
                        perform process-identifier
                    end-if
                else
                    perform process-identifier
                    if current-character <> space
                        move 0 to col-increment
                    end-if
                end-if

            when 'integer'
                evaluate true
                when current-character >= '0' and <= '9'
                    perform increment-outx
                    move current-character to out-value(outx:1)
                    if col-no = col-no-max
                        move numval(out-value) to out-integer
                        move 'Integer' to token
                    end-if
                when current-character >= 'A' and <= 'Z'
                when current-character >= 'a' and <= 'z'
                    move 'in lexer invalid integer' to error-message
                    perform report-error
                when other
                    if outx > 5
                        move numval(out-value) to out-integer1 *> to match the python lexer
                    else
                        move numval(out-value) to out-integer
                    end-if
                    move 'Integer' to token
                    if current-character <> space
                        move 0 to col-increment
                    end-if
                end-evaluate

            when 'comment'
                if previous-character = '*' and current-character = '/'
                    move 'comment' to token
                end-if

            when 'quote'
                evaluate current-character also outx
                when '"' also 0
                    string 'in lexer empty string' into error-message
                    perform report-error
                when '"' also any
                    perform increment-outx
                    move current-character to out-value(outx:1)
                    move 'String' to token
                when other
                    if col-no = col-no-max
                        string 'in lexer missing close quote' into error-message
                        perform report-error
                    else
                        perform increment-outx
                        move current-character to out-value(outx:1)
                    end-if
                end-evaluate

            when 'character'
                evaluate current-character also outx
                when "'" also 0
                    string 'in lexer empty character constant' into error-message
                    perform report-error
                when "'" also 1
                    subtract 1 from ord(out-value(1:1)) giving out-integer
                    move 'Integer' to token
                when "'" also 2
                    evaluate true
                    when out-value(1:2) = '\n'
                        move 10 to out-integer
                    when out-value(1:2) = '\\'
                        subtract 1 from ord('\') giving out-integer      *> ' (workaround a Rosetta Code highlighter problem)
                    when other
                        string 'in lexer unknown escape sequence ' out-value(1:2)
                            into error-message
                        perform report-error
                    end-evaluate
                    move 'Integer' to token
                when "'" also any
                    string 'in lexer multicharacter constant' into error-message
                    perform report-error
                when other
                    if col-no = col-no-max
                        string 'in lexer missing close quote' into error-message
                        perform report-error
                    end-if
                    perform increment-outx
                    move current-character to out-value(outx:1)
                end-evaluate

            when 'and'
                evaluate previous-character also current-character
                when '&' also '&'
                    move 'Op_and' to token
                when other
                    string 'in lexer AND error' into error-message
                    perform report-error
                end-evaluate

            when 'or'
                evaluate previous-character also current-character
                when '|' also '|'
                    move 'Op_or' to token
                when other
                    string 'in lexer OR error' into error-message
                    perform report-error
                end-evaluate

            when 'ambiguous'
                evaluate previous-character also current-character
                when '/' also '*'
                    move 'comment' to scan-state
                    subtract 1 from col-no giving start-col
                when '/' also any
                    move 'Op_divide' to token
                    move 0 to col-increment

                when '=' also '='
                    move 'Op_equal' to token
                when '=' also any
                    move 'Op_assign' to token
                    move 0 to col-increment

                when '<' also '='
                    move 'Op_lessequal' to token
                when '<' also any
                    move 'Op_less' to token
                    move 0 to col-increment

                when '>' also '='
                    move 'Op_greaterequal' to token
                when '>'also any
                    move 'Op_greater' to token
                    move 0 to col-increment

                when '!' also '='
                    move 'Op_notequal' to token
                when '!' also any
                    move 'Op_not' to token
                    move 0 to col-increment

                when other
                    display input-record
                    string 'in lexer ' trim(scan-state)
                        ' unknown character "' current-character '"'
                        ' with previous character "' previous-character '"'
                        into error-message
                    perform report-error
                end-evaluate

            when other
                move col-no to start-col
                evaluate current-character
                when space
                    continue
                when >= 'A' and <= 'Z'
                when >= 'a' and <= 'z'
                    move 'identifier' to scan-state
                    move 1 to outx
                    move current-character to out-value
                when >= '0' and <= '9'
                    move 'integer' to scan-state
                    move 1 to outx
                    move current-character to out-value
                when '&'
                    move 'and' to scan-state
                when '|'
                    move 'or' to scan-state
                when '"'
                    move 'quote' to scan-state
                    move 1 to outx
                    move current-character to out-value
                when "'"
                    move 'character' to scan-state
                    move 0 to outx
                when '{'
                    move 'LeftBrace' to token
                when '}'
                    move 'RightBrace' to token
                when '('
                    move 'LeftParen' to token
                when ')'
                    move 'RightParen' to token
                when '+'
                    move 'Op_add' to token
                when '-'
                    move 'Op_subtract' to token
                when '*'
                    move 'Op_multiply' to token
                when '%'
                    move 'Op_mod' to token
                when ';'
                    move 'Semicolon' to token
                when ','
                    move 'Comma' to token
                when '/'
                when '<'
                when '>'
                when '='
                when '='
                when '<'
                when '>'
                when '!'
                    move 'ambiguous' to scan-state
                when other
                    string 'in lexer unknown character "' current-character '"'
                        into error-message
                    perform report-error
                end-evaluate
            end-evaluate

            if token <> spaces
                perform process-token
            end-if

            move current-character to previous-character
            add col-increment to col-no
            move 1 to col-increment
        end-perform
        if scan-state = 'ambiguous'
            evaluate previous-character
            when '/'
                move 'Op_divide' to token
                perform process-token

            when '='
                move 'Op_assign' to token
                perform process-token

            when '<'
                move 'Op_less' to token
                perform process-token

            when '>'
                move 'Op_greater' to token
                perform process-token

            when '!'
                move 'Op_not' to token
                perform process-token

            when other
                string 'in lexer unresolved ambiguous
                    "' previous-character '" at end of line'
                into error-message
                perform report-error
            end-evaluate
        end-if
        perform read-input-file
    end-perform

    evaluate true
    when input-status <> '10'
        string 'in lexer ' trim(input-name) ' invalid input status ' input-status
            into error-message
        perform report-error
    when scan-state = 'comment'
        string 'in lexer unclosed comment at end of input' into error-message
        perform report-error
     end-evaluate

    move 'End_of_input' to token
    move 1 to out-column
    move 1 to start-col
    add 1 to line-no
    perform process-token

    close input-file
    stop run
    .
process-identifier.
    evaluate true
    when out-value = 'print'
        move 'Keyword_print' to token
        move spaces to out-value
    when out-value = 'while'
        move 'Keyword_while' to token
        move spaces to out-value
    when out-value = 'if'
        move 'Keyword_if' to token
        move spaces to out-value
    when out-value = 'else'
        move 'Keyword_else' to token
        move spaces to out-value
    when out-value = 'putc'
        move 'Keyword_putc' to token
        move spaces to out-value
    when other
        move 'Identifier' to token
    end-evaluate
    .
increment-outx.
    if outx >= out-lim
        string 'in lexer token value length exceeds ' out-lim into error-message
        perform report-error
    end-if
    add 1 to outx
    .
process-token.
    if token <> 'comment'
        move start-col to out-column
        move line-no to out-line
        display output-line
    end-if
    move 0 to start-col
    move spaces to scan-state message-area
    .
report-error.
    move line-no to error-line
    move start-col to error-col
    display error-record
    close input-file
    stop run with error status -1
    .
read-input-file.
    if input-name = spaces
        move '00' to input-status
        accept input-record on exception move '10' to input-status end-accept
    else
        read input-file
    end-if
    .
end program lexer.
