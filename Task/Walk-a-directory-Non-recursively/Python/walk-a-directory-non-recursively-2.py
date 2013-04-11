import os
for filename in os.listdir('/foo/bar'):
    if filename.endswith('.mp3'):
        print filename
