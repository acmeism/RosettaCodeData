(de trimLeft (Str)
   (pack (flip (trim (flip (chop Str))))) )

(de trimRight (Str)
   (pack (trim (chop Str))) )

(de trimBoth (Str)
   (pack (clip (chop Str))) )
