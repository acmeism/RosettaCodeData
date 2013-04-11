from path import path

rootPath = '/'
pattern = '*.mp3'

d = path(rootPath)
for f in d.walkfiles(pattern):
  print f
