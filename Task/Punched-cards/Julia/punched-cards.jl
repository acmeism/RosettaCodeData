# IBM 360 type coding display of punched crads for a given text
# Punch codes: rows numbered 12, 11, 0, 1..9
# encoded as hex digits: c, b, a, 1..9 (a=0 to distinguish no-punch from row-0 punch)

const H_CODE = zeros(UInt16, 256)  # ASCII, but note that only 7-bit chars are defined as punchable

""" Return Hollerith code for a character as UInt, with 0 mapped to 10 (row 0 punch). """
hollerith(c) = c == 0 ? UInt16(10) : H_CODE[Int(c)+1]

""" Initialize the Hollerith codes for all characters. """
function initialize_hollerith_codes()
    # Digits
    for c in 0:9
        H_CODE[Int('0')+c+1] = UInt16(c + 1)
    end
    # Uppercase letters
    for c in Int('A'):Int('I')
        H_CODE[c+1] = 0xc0 | UInt16(c - Int('A') + 1)
    end
    for c in Int('J'):Int('R')
        H_CODE[c+1] = 0xb0 | UInt16(c - Int('J') + 1)
    end
    for c in Int('S'):Int('Z')
        H_CODE[c+1] = 0xa0 | UInt16(c - Int('S') + 2)
    end
    # Lowercase letters
    for c in Int('a'):Int('i')
        H_CODE[c+1] = 0xca0 | UInt16(c - Int('a') + 1)
    end
    for c in Int('j'):Int('r')
        H_CODE[c+1] = 0xcb0 | UInt16(c - Int('j') + 1)
    end
    for c in Int('s'):Int('z')
        H_CODE[c+1] = 0xba0 | UInt16(c - Int('s') + 2)
    end
    # Special characters
    for p in [
        ('&', 0x00c), ('-', 0x00b), ('[', 0x28c), ('.', 0x38c), ('<', 0x48c),
        ('(', 0x58c), ('+', 0x68c), ('!', 0x78c), (']', 0x28b), ('$', 0x38b),
        ('*', 0x48b), (')', 0x58b), (';', 0x68b), ('^', 0x78b), ('\\', 0x28a),
        (',', 0x38a), ('%', 0x48a), ('_', 0x58a), ('>', 0x68a), ('?', 0x78a),
        ('/', 0x01a), ('`', 0x018), (':', 0x028), ('#', 0x038), ('@', 0x048),
        ('\'', 0x058), ('=', 0x068), ('"', 0x078), ('|', 0x0cb), ('{', 0x0ca),
        ('}', 0x0ba)]
        H_CODE[Int(p[1])+1] = p[2]
    end
end
initialize_hollerith_codes()  # Initialize coding schema

mutable struct PunchedCard
    text::String
    punches::Matrix{Char}
    PunchedCard(text::String, punches::Matrix{Char}) = new(text, punches)
end
PunchedCard(text::AbstractString) = make_card(text)
function Base.show(io::IO, card::PunchedCard)
    for row in eachrow(card.punches)
        println(io, String(row))
    end
end

const PUNCHED_CHAR = '▓'  # char(178) equivalent, used to represent punched holes in the card
const PUNCHED_CARD_NCOLS = 84
const PUNCHED_CARD_NROWS = 16
const PUNCHED_CARD_TEXT_ROW = 2  # row index for text (1-based)
const PUNCHED_CARD_TEXT_MAX_COLS = PUNCHED_CARD_NCOLS - 4  # max columns for text (excluding borders)

""" Make a punched card representation of the given text, using the Hollerith codes. """
function make_card(text::AbstractString)
    card = fill(' ', (PUNCHED_CARD_NROWS, PUNCHED_CARD_NCOLS))
    card[begin, begin] = '/' # top-left corner
    card[begin, end] = '+'   # top-right corner
    card[end, [begin, end]] .= '+'   # bottom-left and bottom-right corners
    card[[begin, end], (begin+1):(end-1)] .= '-' # top and bottom borders
    card[(begin+1):(end-1), [begin, end]] .= '|' # right and left borders
    for n in '0':'9'
        card[Int(n-'0')+5, (begin+2):(end-2)] .= n # row labels for punches 0..9
    end

    textrow = rpad(text, PUNCHED_CARD_TEXT_MAX_COLS)[1:80]  # pad text to fit in card
    for (i, ch) in enumerate(textrow)
        col = i + 2  # skip left border
        card[PUNCHED_CARD_TEXT_ROW, col] = ch  # print text character in row 2
        punches = hollerith(ch)  # get Hollerith code (H_CODE) for character
        while punches > 0
            punches, remainder = divrem(punches, 16)
            if remainder > 9
                card[3+12-remainder, col] = PUNCHED_CHAR # rows 12, 11 (r=c=12, r=b=11)
            else
                card[5+remainder, col] = PUNCHED_CHAR # rows 0..9
            end
        end
    end

    return PunchedCard(textrow, card)
end

println(make_card("&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=\"[.<(+|]\$*);^\\,%_>?"))
println(make_card("print( ( \"Hello, World!\", newline ) )"))
