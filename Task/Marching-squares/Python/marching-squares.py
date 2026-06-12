from numpy import array, round
from skimage import measure

example = array([
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0]
])

# Find contours at a constant value of 0.1 and extract the first one found
contours = round(measure.find_contours(example, 0.1))[0]
print('[', ', '.join([str((p[1], 5 - p[0])) for p in contours]), ']')
