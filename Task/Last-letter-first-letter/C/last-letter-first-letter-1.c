#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <inttypes.h>

typedef struct {
    uint16_t index;
    char last_char, first_char;
} Ref;

Ref* longest_path_refs;
size_t longest_path_refs_len;

Ref* refs;
size_t refs_len;

size_t n_solutions;

const char** longest_path;
size_t longest_path_len;


/// tally statistics
void search(size_t curr_len) {
    if (curr_len == longest_path_refs_len) {
        n_solutions++;
    } else if (curr_len > longest_path_refs_len) {
        n_solutions = 1;
        longest_path_refs_len = curr_len;
        memcpy(longest_path_refs, refs, curr_len * sizeof(Ref));
    }

    // recursive search
    intptr_t last_char = refs[curr_len - 1].last_char;
    for (size_t i = curr_len; i < refs_len; i++)
        if (refs[i].first_char == last_char) {
            Ref aux = refs[curr_len];
            refs[curr_len] = refs[i];
            refs[i] = aux;
            search(curr_len + 1);
            refs[i] = refs[curr_len];
            refs[curr_len] = aux;
        }
}

void find_longest_chain(const char* items[],
                        size_t items_len) {
    refs_len = items_len;
    refs = calloc(refs_len, sizeof(Ref));

    // enough space for all items
    longest_path_refs_len = 0;
    longest_path_refs = calloc(refs_len, sizeof(Ref));

    for (size_t i = 0; i < items_len; i++) {
        size_t itemsi_len = strlen(items[i]);
        if (itemsi_len <= 1)
            exit(1);
        refs[i].index = (uint16_t)i;
        refs[i].last_char = items[i][itemsi_len - 1];
        refs[i].first_char = items[i][0];
    }

    // try each item as possible start
    for (size_t i = 0; i < items_len; i++) {
        Ref aux = refs[0];
        refs[0] = refs[i];
        refs[i] = aux;
        search(1);
        refs[i] = refs[0];
        refs[0] = aux;
    }

    longest_path_len = longest_path_refs_len;
    longest_path = calloc(longest_path_len, sizeof(const char*));
    for (size_t i = 0; i < longest_path_len; i++)
        longest_path[i] = items[longest_path_refs[i].index];

    free(longest_path_refs);
    free(refs);
}

int main() {
    const char* pokemon[] = {"audino", "bagon", "baltoy", "banette",
    "bidoof", "braviary", "bronzor", "carracosta", "charmeleon",
    "cresselia", "croagunk", "darmanitan", "deino", "emboar",
    "emolga", "exeggcute", "gabite", "girafarig", "gulpin",
    "haxorus", "heatmor", "heatran", "ivysaur", "jellicent",
    "jumpluff", "kangaskhan", "kricketune", "landorus", "ledyba",
    "loudred", "lumineon", "lunatone", "machamp", "magnezone",
    "mamoswine", "nosepass", "petilil", "pidgeotto", "pikachu",
    "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz",
    "registeel", "relicanth", "remoraid", "rufflet", "sableye",
    "scolipede", "scrafty", "seaking", "sealeo", "silcoon",
    "simisear", "snivy", "snorlax", "spoink", "starly", "tirtouga",
    "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix",
    "wailord", "wartortle", "whismur", "wingull", "yamask"};
    size_t pokemon_len = sizeof(pokemon) / sizeof(pokemon[0]);

    find_longest_chain(pokemon, pokemon_len);
    printf("Maximum path length: %u\n", longest_path_len);
    printf("Paths of that length: %u\n", n_solutions);
    printf("Example path of that length:\n");
    for (size_t i = 0; i < longest_path_len; i += 7) {
        printf("  ");
        for (size_t j = i; j < (i+7) && j < longest_path_len; j++)
            printf("%s ", longest_path[j]);
        printf("\n");
    }

    free(longest_path);

    return 0;
}
