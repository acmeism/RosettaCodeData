#!/usr/bin/awk -f

BEGIN {
    a = "kitten";
    b = "sitting";
    d = levenshteinDistance(a, b);
    p = d == 1 ? "" : "s";
    printf("%s -> %s after %d edit%s\n", a, b, d, p);
    exit;
}

function levenshteinDistance(s1, s2,
    s1First, s2First, s1Rest, s2Rest,
    distA, distB, distC, minDist) {

    # If either string is empty,
    # then distance is insertion of the other's characters.
    if (length(s1) == 0) return length(s2);
    if (length(s2) == 0) return length(s1);

    # Rest of process uses first characters
    # and remainder of each string.
    s1First = substr(s1, 1, 1);
    s2First = substr(s2, 1, 1);
    s1Rest = substr(s1, 2, length(s1));
    s2Rest = substr(s2, 2, length(s2));

    # If leading characters are the same,
    # then distance is that between the rest of the strings.
    if (s1First == s2First) {
        return levenshteinDistance(s1Rest, s2Rest);
    }

    # Find the distances between sub strings.
    distA = levenshteinDistance(s1Rest, s2);
    distB = levenshteinDistance(s1, s2Rest);
    distC = levenshteinDistance(s1Rest, s2Rest);

    # Return the minimum distance between substrings.
    minDist = distA;
    if (distB < minDist) minDist = distB;
    if (distC < minDist) minDist = distC;
    return minDist + 1; # Include change for the first character.
}
