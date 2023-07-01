# Input: a string
# Output: a stream of sentence type indicators
def sentenceTypes:
  def trim: sub("^ +";"") | sub(" +$";"");
  def parse:
    capture("(?<s>[^?!.]*)(?<p>[?!.])(?<remainder>.*)" )
    // {p:"", remainder:""};
  def encode:
    if   . == "?" then "Q"
    elif . == "!" then "E"
    elif . == "." then "S"
    else "N"
    end;
  trim
  | select(length>0)
  | parse
  | (.p | encode), (.remainder | sentenceTypes);

def s: "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it";

s | sentenceTypes
