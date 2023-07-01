import psyco

nsolutions = 0

def search(sequences, ord_minc, curr_word, current_path,
           current_path_len, longest_path):
    global nsolutions

    current_path[current_path_len] = curr_word
    current_path_len += 1

    if current_path_len == len(longest_path):
        nsolutions += 1
    elif current_path_len > len(longest_path):
        nsolutions = 1
        longest_path[:] = current_path[:current_path_len]

    # recursive search
    last_char_index = ord(curr_word[-1]) - ord_minc
    if last_char_index >= 0 and last_char_index < len(sequences):
        for pair in sequences[last_char_index]:
            if not pair[1]:
                pair[1] = True
                search(sequences, ord_minc, pair[0], current_path,
                       current_path_len, longest_path)
                pair[1] = False


def find_longest_chain(words):
    ord_minc = ord(min(word[0] for word in words))
    ord_maxc = ord(max(word[0] for word in words))
    sequences = [[] for _ in xrange(ord_maxc - ord_minc + 1)]
    for word in words:
        sequences[ord(word[0]) - ord_minc].append([word, False])

    current_path = [None] * len(words)
    longest_path = []

    # try each item as possible start
    for seq in sequences:
        for pair in seq:
            pair[1] = True
            search(sequences, ord_minc, pair[0],
                   current_path, 0, longest_path)
            pair[1] = False

    return longest_path


def main():
    global nsolutions

    pokemon = """audino bagon baltoy banette bidoof braviary
bronzor carracosta charmeleon cresselia croagunk darmanitan deino
emboar emolga exeggcute gabite girafarig gulpin haxorus heatmor
heatran ivysaur jellicent jumpluff kangaskhan kricketune landorus
ledyba loudred lumineon lunatone machamp magnezone mamoswine nosepass
petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede
scrafty seaking sealeo silcoon simisear snivy snorlax spoink starly
tirtouga trapinch treecko tyrogue vigoroth vulpix wailord wartortle
whismur wingull yamask""".lower().split()

    # remove duplicates
    pokemon = sorted(set(pokemon))

    sol = find_longest_chain(pokemon)
    print "Maximum path length:", len(sol)
    print "Paths of that length:", nsolutions
    print "Example path of that length:"
    for i in xrange(0, len(sol), 7):
        print " ", " ".join(sol[i : i+7])

psyco.full()
main()
