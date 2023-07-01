# usage: gawk -f Idiomatically_determine_all_the_characters_that_can_be_used_for_symbols.awk

function is_valid_identifier(id,  rc) {
    fn = "is_valid_identifier.awk"
    printf("function unused(%s) { arr[%s] = 1 }\n", id, id, id) >fn
	printf("BEGIN { exit(0) }\n") >>fn
    close(fn)

    rc = system("gawk -f is_valid_identifier.awk 2>errors")
    return rc == 0
}

BEGIN {
    for (i = 0; i <= 255; i++) {
        c = sprintf("%c", i)

        if (is_valid_identifier(c))
            good1 = good1 c;
        else
            bad1 = bad1 c

        if (is_valid_identifier("_" c "_"))
            good2 = good2 c;
        else
            bad2 = bad2 c;
    }

    printf("1st character: %d bad, %d ok: %s\n",
        length(bad1), length(good1), good1)
    printf("2nd..nth char: %d bad, %d ok: %s\n",
        length(bad2), length(good2), good2)
    exit(0)
}
