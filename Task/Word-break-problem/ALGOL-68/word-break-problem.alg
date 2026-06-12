# utility functions: #

PROC includes = ([]STRING row, STRING s) BOOL:
  # whether row includes s #
  BEGIN
    FOR i TO UPB row DO IF s = row[i] THEN true FI OD;
    FALSE EXIT
    true: TRUE
  END;

PRIO & = 6;
OP & = (STRING s, []STRING row) []STRING:
  # returns row with s prepended to it #
  BEGIN
    [UPB row + 1]STRING result;
    result[2 : UPB result] := row;
    result[1] := s;
    result
  END;

PROC add = (REF FLEX[]FLEX[]STRING rows, []STRING row) VOID:
  # adds row to the end of rows (in place) #
  BEGIN
    [UPB rows+1]FLEX[0]STRING tmp;
    tmp[:UPB rows] := rows;
    tmp[UPB tmp] := row;
    rows := tmp
  END;

# actual solution: #

PROC word breaks = ([]STRING dict, STRING word) [][]STRING:
  # build recursively the list of breaks for a word, using the given dictionary #
  BEGIN
    FLEX[0]FLEX[0]STRING result;
    FOR last TO UPB word - 1 DO
      STRING part1 := word[1 : last];
      IF includes(dict, part1) THEN
        STRING part2 := word[last + 1 : ];
        IF includes(dict, part2) THEN add(result, (part1, part2)) FI;
        [][]STRING sub results = word breaks(dict, part2);
        FOR i FROM LWB sub results TO UPB sub results DO
          add(result, part1 & sub results[i])
        OD
      FI
    OD;
    result
  END;

PROC break word = ([]STRING dict, STRING word) VOID:
  # find the ways to break a word and display the result #
  BEGIN
    print((word, ":", newline));
    [][]STRING word seqs = word breaks(dict, word);
    IF UPB word seqs = 0 THEN
      print(("    <no break possible>", newline))
    ELSE
      FOR i FROM LWB word seqs TO UPB word seqs DO
        []STRING seq = word seqs[i];
        print("   ");
        FOR j FROM LWB seq TO UPB seq DO
          print((" ", seq[j]))
        OD;
        print(newline)
      OD
    FI
  END;

[]STRING dict = ("a", "bc", "abc", "cd", "b");

[]STRING words = ("abcd", "abbc", "abcbcd", "acdbc", "abcdd");

FOR i TO UPB words DO
  break word(dict, words[i])
OD
