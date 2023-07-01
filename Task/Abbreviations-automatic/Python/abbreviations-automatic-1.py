def shortest_abbreviation_length(line, list_size):
    words = line.split()
    word_count = len(words)
    # Can't give true answer with unexpected number of entries
    if word_count != list_size:
        raise ValueError(f'Not enough entries, expected {list_size} found {word_count}')

    # Find the small slice length that gives list_size unique values
    abbreviation_length = 1
    abbreviations = set()
    while(True):
        abbreviations = {word[:abbreviation_length] for word in words}
        if len(abbreviations) == list_size:
            return abbreviation_length
        abbreviation_length += 1
        abbreviations.clear()

def automatic_abbreviations(filename, words_per_line):
    with open(filename) as file:
        for line in file:
            line = line.rstrip()
            if len(line) > 0:
                length = shortest_abbreviation_length(line, words_per_line)
                print(f'{length:2} {line}')
            else:
                print()

automatic_abbreviations('daysOfWeek.txt', 7)
