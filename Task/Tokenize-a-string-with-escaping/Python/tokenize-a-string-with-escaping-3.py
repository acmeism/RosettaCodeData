import re

STRING = 'one^|uno||three^^^^|four^^^|^cuatro|'

def tokenize(string=STRING, escape='^', separator='|'):

    escape, separator = map(re.escape, (escape, separator))

    tokens = ['']

    def start_new_token(scanner, substring):
        tokens.append('')

    def add_escaped_char(scanner, substring):
        char = substring[1]
        tokens[-1] += char

    def add_substring(scanner, substring):
        tokens[-1] += substring

    re.Scanner([
        # an escape followed by a character produces that character
        (fr'{escape}.', add_escaped_char),

        # when encountering a separator not preceded by an escape,
        # start a new token
        (fr'{separator}', start_new_token),

        # a sequence of regular characters (i.e. not escape or separator)
        # is just appended to the token
        (fr'[^{escape}{separator}]+', add_substring),
    ]).scan(string)

    return tokens


if __name__ == '__main__':
    print(list(tokenize()))
