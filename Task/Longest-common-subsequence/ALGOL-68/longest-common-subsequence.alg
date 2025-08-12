BEGIN PROC lcs = (STRING s, t) STRING:
      IF LWB s > UPB s OR LWB t > UPB t
      THEN # Trivial case: empty strings have an empty LCS. #
           ""
      ELIF s[UPB s] = t[UPB t]
      THEN # If the last characters of 's' and 't' match, prepend the LCS of the preceeding strings #
           lcs (s[: UPB s - 1], t[: UPB t - 1]) + s[UPB s]
      ELSE # Find the longest LCS of these cases:
             (1) excluding the last character of 's' including the last of 't',
             (2) excluding the last character of 't' including the last of 's'. #
           STRING u = lcs (s[: UPB s - 1], t), v = lcs (s, t[: UPB t - 1]);
           (UPB u > UPB v | u | v)
      FI;

      print((lcs ("thisisatest", "testing123testing"), new line))
END
