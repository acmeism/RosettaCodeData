def isExt(fileName, extensions):
  return True in map(fileName.lower().endswith, ("." + e.lower() for e in extensions))
