       >>SOURCE FORMAT FREE
identification division.
program-id. 'tokenizewithescaping'.
environment division.
configuration section.
repository.
    function all intrinsic.
data division.
working-storage section.

01 escape-char pic x value '^'.
01 separator-char pic x value '|'.
01 reference-string pic x(64) value
   'one^|uno||three^^^^|four^^^|^cuatro|'.

01 input-string pic x(64).
01 c pic 99.
01 escaped pic x.

01 t pic 99.
01 t-max pic 99.
01 t-lim pic 99 value 32.
01 token-entry occurs 32.
   03  token-len pic 99.
   03  token pic x(16).

01 l pic 99.
01 l-lim pic 99 value 16.

01 error-found pic x.

procedure division.
start-tokenize-with-escaping.

    move reference-string to input-string
    perform tokenize

    move 'token' to input-string
    perform tokenize

    move '^^^^^^^^' to input-string
    perform tokenize

    move '||||||||' to input-string
    perform tokenize

    move all 'token' to input-string
    perform tokenize

    move all 't|' to input-string
    perform tokenize

    move spaces to input-string
    perform tokenize

    display space

    stop run
    .
tokenize.
    display space
    display 'string:'
    display input-string

    move 'N' to escaped error-found
    move 1 to t-max
    initialize token-entry(t-max)
    move 0 to l

    perform varying c from 1 by 1 until
    c > length(input-string)
    or input-string(c:) = spaces

        evaluate escaped also input-string(c:1)
        when 'N' also escape-char
            move 'Y' to escaped
        when 'N' also separator-char
            perform increment-t-max
            if error-found = 'Y'
                exit paragraph
            end-if
        when 'N' also any
            perform move-c
            if error-found = 'Y'
                exit paragraph
            end-if
        when 'Y' also any
            perform move-c
            if error-found = 'Y'
                exit paragraph
            end-if
            move 'N' to escaped
        end-evaluate

    end-perform
    if l > 0
        move l to token-len(t-max)
    end-if

    if c = 1
        display 'no tokens'
    else
        display 'tokens:'
        perform varying t from 1 by 1 until t > t-max
            if token-len(t) > 0
                display t ': ' token-len(t) space token(t)
            else
                display t ': ' token-len(t)
            end-if
        end-perform
    end-if
    .
increment-t-max.
    if t-max >= t-lim
        display 'error: at ' c ' number of tokens exceeds ' t-lim
        move 'Y' to error-found
    else
        move l to token-len(t-max)
        add 1 to t-max
        initialize token-entry(t-max)
        move 0 to l
        move 'N' to error-found
    end-if
    .
move-c.
    if l >= l-lim
        display 'error: at ' c ' token length exceeds ' l-lim
        move 'Y' to error-found
    else
        add 1 to l
        move input-string(c:1) to token(t-max)(l:1)
        move 'N' to error-found
    end-if
    .
end program 'tokenizewithescaping'.
