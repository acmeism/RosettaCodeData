import algorithm
import os
import strformat
import strutils
import tables
import std/sha1
import times

type

  # Mapping "size" -> "list of paths".
  PathsFromSizes = Table[BiggestInt, seq[string]]

  # Mapping "hash" -> "list fo paths".
  PathsFromHashes = Table[string, seq[string]]

  # Information data.
  Info = tuple[size: BiggestInt; paths: seq[string]]


#---------------------------------------------------------------------------------------------------

proc processCmdLine(): tuple[dirpath: string; minsize: Natural] =
  ## Process the command line. Extra parameters are ignored.

  if paramCount() == 0:
    quit fmt"Usage: {getAppFileName().splitPath()[1]} folder minsize"

  result.dirpath = paramStr(1)
  if not result.dirpath.dirExists():
    quit fmt"Wrong directory path: {result.dirpath}"

  if paramCount() >= 2:
    try:
      result.minsize = parseInt(paramStr(2))
    except ValueError:
      quit fmt"Wrong minimum size: {paramStr(2)}"

#---------------------------------------------------------------------------------------------------

proc initPathsFromSize(dirpath: string; minsize: Natural): PathsFromSizes =
  ## Retrieve the files in directory "dirpath" with minimal size "minsize"
  ## and build the mapping from size to paths.

  for path in dirpath.walkDirRec():
    if not path.fileExists():
      continue    # Not a regular file.
    let size = path.getFileSize()
    if size >= minSize:
      # Store path in "size to paths" table.
      result.mgetOrPut(size, @[]).add(path)

#---------------------------------------------------------------------------------------------------

proc initPathsFromHashes(pathsFromSizes: PathsFromSizes): PathsFromHashes =
  ## Compute hashes for files whose size is not unique and build the mapping
  ## from hash to paths.

  for size, paths in pathsFromSizes.pairs:
    if paths.len > 1:
      for path in paths:
        # Store path in "digest to paths" table.
        result.mgetOrPut($path.secureHashFile(), @[]).add(path)

#---------------------------------------------------------------------------------------------------

proc cmp(x, y: Info): int =
  ## Compare two information tuples. Used to sort the list of duplicates files.

  result = cmp(x.size, y.size)
  if result == 0:
    # Same size. Compare the first paths (we are sure that they are different).
    result = cmp(x.paths[0], y.paths[0])

#---------------------------------------------------------------------------------------------------

proc displayDuplicates(dirpath: string; pathsFromHashes: PathsFromHashes) =
  ## Display duplicates files in directory "dirpath".

  echo "Files with same size and same SHA1 hash value in directory: ", dirpath
  echo ""

  # Build list of duplicates.
  var duplicates: seq[Info]
  for paths in pathsFromHashes.values:
    if paths.len > 1:
      duplicates.add((paths[0].getFileSize(), sorted(paths)))
  if duplicates.len == 0:
    echo "No files"
    return
  duplicates.sort(cmp, Descending)

  # Display duplicates.
  echo fmt"""{"Size":>10}     {"Last date modified":^19}   {"Inode":>8}    HL    File name"""
  echo repeat('=', 80)
  for (size, paths) in duplicates:
    echo ""
    for path in paths:
      let mtime = path.getLastModificationTime().format("YYYY-MM-dd HH:mm:ss")
      let info = path.getFileInfo()
      let inode = info.id.file
      let hardlink = if info.linkCount == 1: " " else: "*"
      echo fmt"{size:>10} {mtime:>23} {inode:>12}  {hardlink:<5} {path.relativePath(dirpath)}"


#———————————————————————————————————————————————————————————————————————————————————————————————————

let (dirpath, minsize) = processCmdLine()
let pathsFromSizes = initPathsFromSize(dirpath, minsize)
let pathsFromHashes = initPathsFromHashes(pathsFromSizes)
dirpath.displayDuplicates(pathsFromHashes)
