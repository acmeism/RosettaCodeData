def longest_substring(s = "xyzyab"):
    substr = [s[x:y] for x in range(len(s)) for y in range(x+1, len(s) + 1)]
    no_reps = []
    for sub in substr:
        if len(sub) == len(set(sub)) and sub not in no_reps:
            no_reps.append(sub)
    max_len = max(len(sub) for sub in no_reps) if no_reps else 0
    max_subs = [sub for sub in no_reps if len(sub) == max_len]
    return max_subs

if __name__ == '__main__':
    for s in ["xyzyabcybdfd", "xyzyab", "zzzzz", "a", "α⊆϶α϶", "",
              [1, 2, 3, 4, 1, 2, 5, 6, 1, 7, 8, 1, 0]]:
        print(f"{s} => {longest_substring(s)}")
