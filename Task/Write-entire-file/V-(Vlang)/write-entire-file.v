import os

os.write_file('./hello_text.txt', 'Hello there!') or {println('Error: failed to write.') exit(1)}
