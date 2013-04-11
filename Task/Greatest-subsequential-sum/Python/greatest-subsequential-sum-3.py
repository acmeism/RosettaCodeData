def maxsumseq(sequence):
    start, end, sum_start = -1, -1, -1
    maxsum_, sum_ = 0, 0
    for i, x in enumerate(sequence):
        sum_ += x
        if maxsum_ < sum_: # found maximal subsequence so far
            maxsum_ = sum_
            start, end = sum_start, i
        elif sum_ < 0: # start new sequence
            sum_ = 0
            sum_start = i
    assert maxsum_ == maxsum(sequence)
    assert maxsum_ == sum(sequence[start + 1:end + 1])
    return sequence[start + 1:end + 1]
