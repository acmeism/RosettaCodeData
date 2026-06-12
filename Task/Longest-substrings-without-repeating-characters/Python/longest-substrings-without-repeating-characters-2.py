def longest_substring2(s = "xyzyab"):
    max_subs, mx = [], 0
    for x in range(len(s)):
        for y in range(x+1, len(s) + 1):
            sub = s[x:y]
            if y - x >= mx and len(sub) == len(set(sub)):
                if y - x == mx and sub not in max_subs:
                    max_subs.append(sub)
                else:
                    max_subs, mx = [sub], y - x
    return max_subs
