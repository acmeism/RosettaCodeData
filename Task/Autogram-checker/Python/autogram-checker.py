import re
import string

INT_TO_WORD = {
    '0': 'zero', '1': 'one', '2': 'two', '3': 'three', '4': 'four',
    '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', '9': 'nine',
    '10': 'ten', '11': 'eleven', '12': 'twelve', '13': 'thirteen',
    '14': 'fourteen', '15': 'fifteen', '16': 'sixteen',
    '17': 'seventeen', '18': 'eighteen', '19': 'nineteen',
    '20': 'twenty', '30': 'thirty', '40': 'forty', '50': 'fifty',
    '60': 'sixty', '70': 'seventy', '80': 'eighty', '90': 'ninety',
    }

WORD_TO_INT = {
    'zero': 0, 'single': 1, 'one': 1, 'two': 2, 'three': 3,
    'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8,
    'nine': 9, 'ten': 10, 'eleven': 11, 'twelve': 12,
    'thirteen': 13, 'fourteen': 14, 'fifteen': 15, 'sixteen': 16,
    'seventeen': 17, 'eighteen': 18, 'nineteen': 19, 'twenty': 20,
    'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60,
    'seventy': 70, 'eighty': 80, 'ninety': 90,
}


def words_2_num(words: str) -> int:
    word_list = [w.lower() for w in re.split(r'[-\s]+', words)]
    if len(word_list) > 2:
        raise NotImplementedError(
            f'Cannot yet parse number words of greater than 2 words.'
            f' {word_list} is too long.'
        )
    num = 0
    for w in word_list:
        num += WORD_TO_INT[w]
    return num


LETTER_CHARS = string.ascii_lowercase
PUNCTUATION_CHARS = ',-\'.!'
CHAR_TO_WORD = {letter: letter for letter in LETTER_CHARS}
CHAR_TO_WORD.update({
    ',': 'comma',
    '-': 'hyphen',
    '\'': 'apostrophe',
    '.': 'period',
    # below inconsistent with above but used to validate Sallow's autogram
    # with punctuation from Hofstadter's 1982 "Metamagical Themas"
    '!': '!',
})
WORD_TO_CHAR = {letter: letter for letter in LETTER_CHARS}
WORD_TO_CHAR.update({
    'comma': ',',
    'hyphen': '-',
    'apostrophe': '\'',
    'period': '.',
    '!': '!',
})


def find_counts_and_chars(
        sentence: str,
        include_punctuation: bool = False,
) -> list[tuple[str, str]]:
    """Uses regex to match descriptions of a number of characters.
    E.g. "Twenty-two t's", "five b", "thirty one s"
    Only works for numbers < 100
    """
    # number words that can stand on their own.
    # e.g. 'two', 'thirteen', 'thirty', ...
    single_word_numbers = [word for word in WORD_TO_INT]
    # number words that come before others. e.g. 'twenty', 'fifty', ...
    leading_word_numbers = [
        word for word in WORD_TO_INT
        if WORD_TO_INT[word] >= 20
    ]
    leading_word_or = '|'.join(leading_word_numbers)
    single_word_or = '|'.join(single_word_numbers)

    # 0 or 1 of (leading word followed by a '-' or whitespace),
    # followed by one single word
    number_re = fr'(?P<number>(?:(?:{leading_word_or})[-\s]?)?(?:{single_word_or}))'

    punctuation_re = ''
    if include_punctuation:
        punctuation_or = '|'.join([
            punct_word for punct_word in WORD_TO_CHAR
            if punct_word not in string.ascii_lowercase
        ])
        punctuation_re = punctuation_or + '|'
    # one char from a-z, followed by 0 or 1 of "'" only if that's
    # followed by an 's', followed by 0 or 1 's'
    char_re = fr'(?P<character>(?:{punctuation_re}[a-z])' + '{1}' + fr")'?(?=s)?s?"

    # find a word break, followed by a number word match,
    # followed by whitespace, followed by a character match
    number_char_re = fr'\b{number_re}\s{char_re}'

    p = re.compile(number_char_re)
    return p.findall(sentence.lower())


def validate(
        sentence: str,
        include_punctuation: bool = False,
        verbose: bool = False,
) -> bool:
    """Returns True if sentence is an autogram"""
    sentence_lower = sentence.lower()
    countable_chars = LETTER_CHARS
    if include_punctuation:
        countable_chars += PUNCTUATION_CHARS

    counts = {
        char: sentence_lower.count(char)
        for char in countable_chars
        if sentence_lower.count(char) > 0
    }

    # find sentence char counts
    counts_and_chars = find_counts_and_chars(
        sentence_lower,
        include_punctuation=include_punctuation
    )

    # create dictionary of character counts as described by sentence
    sentence_counts = {}
    for match in counts_and_chars:
        num_match = match[0]
        char_match = match[1]
        sentence_counts[WORD_TO_CHAR[char_match]] = words_2_num(num_match)

    if verbose:
        print(f'Regex matches: {counts_and_chars}')
        print(f'Parsed sentence counts: {sentence_counts}')
        print(f'Function counts: {counts}')

    # compare function counts to sentence counts
    valid = True
    for char in counts:
        if char in sentence_counts:
            sc = sentence_counts.pop(char)
            if counts[char] == sc:
                if verbose: print(f'{char}: {sc} verified')
            else:
                valid = False
                print(f'{char}: INVALID. True count: {counts[char]}, '
                      f'Sentence says: {sc}.')
        else:
            valid = False
            print(f'{char}: Missing from sentence. '
                  f'True count: {counts[char]}.')

    # any remaining characters that were mentioned by the sentence
    # but somehow not found in the function counts mean the function
    # didn't pick up on something it should've
    if sentence_counts:
        raise RuntimeError(
            f'Sentence mentions {len(sentence_counts)} chars '
            f'that were not found by validate().\n'
            f'{sentence_counts}'
        )

    return valid


def run_validation_tests():
    # first element is sentence, second is whether punctuation is counted
    sentences: list[tuple[str, bool]] = [
        # 1
        ("""This sentence employs two a's, two c's, two d's, twenty-eight e's,
        five f's, three g's, eight h's, eleven i's, three l's, two m's,
        thirteen n's, nine o's, two p's, five r's, twenty-five s's,
        twenty-three t's, six v's, ten w's, two x's, five y's, and one z. """,
         False),
        # 2
        ("""This sentence employs two a's, two c's, two d's, twenty eight e's,
        five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's,
        nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's,
        ten w's, two x's, five y's, and one z. """,
         False),
        # 3
        ("""Only the fool would take trouble to verify that his sentence was
        composed of ten a's, three b's, four c's, four d's, forty-six e's,
        sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's,
        four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's,
        forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's,
        eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens
        and, last but not least, a single ! """,
         True),
        # 4
        ("""This pangram contains four as, one b, two cs, one d, thirty es, six fs,
        five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns,
        fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us,
        seven vs, eight ws, two xs, three ys, & one z. """,
         False),
        # 5
        ("""This sentence contains one hundred and ninety-seven letters: four a's,
        one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's,
        twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's,
        nineteen t's, six u's, seven v's, four w's, four x's, five y's,
        and one z. """,
         False),
        # 6
        ("""Thirteen e's, five f's, two g's, five h's, eight i's, two l's,
        three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's,
        six w's, four x's, two y's. """,
         False),
        # 7
        ("""Fifteen e's, seven f's, four g's, six h's, eight i's, four n's,
        five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's,
        three x's. """,
         True),
        # 8
        ("""Sixteen e's, five f's, three g's, six h's, nine i's, five n's,
        four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's,
        four z's. """,
         False),
    ]
    for i, sentence in enumerate(sentences):
        print(f'\n----------------- sentence {i + 1} -----------------')
        # print(sentence[0])
        is_valid = validate(
            sentence[0],
            include_punctuation=sentence[1],
            verbose=False,
        )
        print('Valid!' if is_valid else 'Invalid!')


if __name__ == '__main__':
    run_validation_tests()
