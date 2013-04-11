def maxsum(sequence):
    """Return maximum sum."""
    maxsofar, maxendinghere = 0, 0
    for x in sequence:
        # invariant: ``maxendinghere`` and ``maxsofar`` are accurate for ``x[0..i-1]``
        maxendinghere = max(maxendinghere + x, 0)
        maxsofar = max(maxsofar, maxendinghere)
    return maxsofar
