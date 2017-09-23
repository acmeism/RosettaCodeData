# A ⊆ B iff string_subset(A;B)
def stringset_subset(A;B):
  reduce (A|keys)[] as $k
    (true; . and (B|has($k)));
