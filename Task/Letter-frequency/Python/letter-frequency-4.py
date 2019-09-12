...
from collections import defaultdict
def countletters(file_handle):
    """Count occurences of letters and return a dictionary of them
    """
    results = defaultdict(int)
    for line in file_handle:
        for char in line:
            if char.lower() in letters:
                c = char.lower()
                results[c] += 1
    return results
