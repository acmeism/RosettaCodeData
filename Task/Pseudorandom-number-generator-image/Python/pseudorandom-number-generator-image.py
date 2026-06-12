# pseudorandom number image generator by Xing216
from random import randbytes
from PIL import Image

size = 1500
x = bytes.fromhex(" ".join([randbytes(3).hex() for x in range(size*size)]))
img = Image.frombuffer('RGB', (size, size), x, 'raw', 'RGB', 0, 1)
img.show()
