# Input: an array of codepoints
# 48 is the codepoint of "0"
def rmLeadingZeros:
  if .[0] == 48 then .[1:] | rmLeadingZeros else . end;

def reverseNumber: tostring | explode | reverse | rmLeadingZeros | implode | tonumber;
