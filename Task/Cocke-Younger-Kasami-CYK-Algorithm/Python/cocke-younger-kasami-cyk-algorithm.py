def cykParse(w: list[str], r: dict[str, tuple | list[tuple]]):
    n = len(w)
    table = [[set() for _ in range(n)] for _ in range(n)]

    norm = {}
    for lhs, rules in r.items():
        if isinstance(rules, tuple):
            norm[lhs] = [rules]
        else:
            norm[lhs] = list(rules)

    for i in range(n):
        for lhs, rules in norm.items():
            for rule in rules:
                if len(rule) == 1 and rule[0] == w[i]:
                    table[i][i].add(lhs)

    for l in range(2, n+1):
        for i in range(0, n-l+1):
            j = i + l - 1
            for k in range(i, j):
                for lhs, rules in norm.items():
                    for rule in rules:
                        if len(rule) == 2:
                            B, C = rule
                            if B in table[i][k] and C in table[k+1][j]:
                                table[i][j].add(lhs)

    return "NP" in table[0][n-1]

rules = {
    "NP": ("Det", "Nom"),
    "Nom": [
        ("AP", "Nom"),
        ("book",),
        ("orange",),
        ("man",),
    ],
    "AP": [
        ("Adv", "A"),
        ("heavy",),
        ("orange",),
        ("tall",),
    ],
    "Det": ("a",),
    "Adv": [
        ("very",),
        ("extremely",)
    ],
    "A": [
        ("heavy",),
        ("orange",),
        ("tall",),
        ("muscular",)
    ]
}

if __name__ == "__main__":
    w = "a very heavy orange book".split()
    print(cykParse(w, rules))
