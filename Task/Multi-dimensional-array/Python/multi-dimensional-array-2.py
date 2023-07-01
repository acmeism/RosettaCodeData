import numpy as np
a = np.array([[1, 2], [3, 4]], order="C")
b = np.array([[1, 2], [3, 4]], order="F")
np.reshape(a, (4,))             # [1, 2, 3, 4]
np.reshape(b, (4,))             # [1, 2, 3, 4]
np.reshape(b, (4,), order="A")  # [1, 3, 2, 4]
