import strutils

proc commonprefix(paths: openarray[string], sep = "/"): string =
  if paths.len == 0: return ""
  block outer:
    for i in 0 ..< paths[0].len:
      result = paths[0][0 .. i]
      for path in paths:
        if not path.startsWith(result):
          break outer
  result = result[0 .. result.rfind(sep)]

echo commonprefix(@["/home/user1/tmp/coverage/test", "/home/user1/tmp/covert/operator", "/home/user1/tmp/coven/members"])
