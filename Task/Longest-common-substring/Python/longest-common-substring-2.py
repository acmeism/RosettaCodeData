def _set_of_substrings(s:str) -> set:
    "_set_of_substrings('ABBA') == {'A', 'AB', 'ABB', 'ABBA', 'B', 'BA', 'BB', 'BBA'}"
    len_s = len(s)
    return {s[m: n] for m in range(len_s) for n in range(m+1, len_s +1)}

def _set_of_common_substrings(s:str, common: set) -> set:
    "Substrings of s that are also in common"
    len_s = len(s)
    return {this for m in range(len_s) for n in range(m+1, len_s +1)
            if (this := s[m:n]) in common}

def lcs_ss(*strings):
    "longest of the common substrings of all substrings of each string"
    strings_iter  = (s for s in strings)
    common = _set_of_substrings(next(strings_iter)) # First string substrings
    for s in strings_iter:
        if not common:
            break
        common = _set_of_common_substrings(s, common) # Accumulate the common

    return max(common, key= lambda x: len(x)) if common else ''


s0 = "thisisatest_stinger"
s1 = "testing123testingthing"
s2 = "thisis"

ans = lcs_ss(s0, s1)
print(f"\n{repr(s0)}, {repr(s1)} ->> {repr(ans)}")
ans = lcs_ss(s0, s2)
print(f"\n{repr(s0)}, {repr(s2)} ->> {repr(ans)}")
ans = lcs_ss(s1, s2)
print(f"\n{repr(s1)}, {repr(s2)} ->> {repr(ans)}")
ans = lcs_ss(s0, s1, s2)
print(f"\n{repr(s0)}, {repr(s1)}, {repr(s2)} ->> {repr(ans)}")
