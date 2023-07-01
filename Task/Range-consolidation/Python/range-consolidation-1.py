def normalize(s):
    return sorted(sorted(bounds) for bounds in s if bounds)

def consolidate(ranges):
    norm = normalize(ranges)
    for i, r1 in enumerate(norm):
        if r1:
            for r2 in norm[i+1:]:
                if r2 and r1[-1] >= r2[0]:     # intersect?
                    r1[:] = [r1[0], max(r1[-1], r2[-1])]
                    r2.clear()
    return [rnge for rnge in norm if rnge]

if __name__ == '__main__':
    for s in [
            [[1.1, 2.2]],
            [[6.1, 7.2], [7.2, 8.3]],
            [[4, 3], [2, 1]],
            [[4, 3], [2, 1], [-1, -2], [3.9, 10]],
            [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]],
            ]:
        print(f"{str(s)[1:-1]} => {str(consolidate(s))[1:-1]}")
