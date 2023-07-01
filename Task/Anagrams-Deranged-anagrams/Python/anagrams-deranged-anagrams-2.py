def most_deranged_ana(anagrams):
    ordered_anagrams = sorted(anagrams.items(),
                              key=lambda x:(-len(x[0]), x[0]))
    many_anagrams = [anas for _, anas in ordered_anagrams if len(anas) > 2]
    d_of_anas = [is_deranged(ana_group) for ana_group in many_anagrams]
    d_of_anas = [d_group for d_group in d_of_anas if d_group]
    d_of_anas.sort(key=lambda d_group:(-len(d_group), -len(d_group[0])))
    mx = len(d_of_anas[0])
    most = [sorted(d_group) for d_group in d_of_anas if len(d_group) == mx]
    return most

if __name__ == '__main__':
    most = most_deranged_ana(anagrams)
    print(f"\nThere are {len(most)} groups of anagrams all containing"
          f" a max {len(most[0])} deranged word-pairs:")
    for pairs in most:
        print()
        print('  ' + '\n  '.join(', '.join(p) for p in pairs))
