Longest_common_suffix(data){
  for num, v in StrSplit(data.1)
    for i, word in data
      if (SubStr(word, 1-num) <> SubStr(data.1, 1-num))
        return num=1 ? "" : SubStr(word, 2-num)
  return SubStr(word, 1-num)
}
