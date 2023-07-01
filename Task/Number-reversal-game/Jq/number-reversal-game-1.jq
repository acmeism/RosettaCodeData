# Input: the initial array
def play:
  def sorted: . == sort;

  def reverse(n):  (.[0:n] | reverse)  + .[n:];

  def prompt: "List: \(.list)\nEnter a pivot number: ";

  def report: "Great! Your score is \(.score)";

  {list: ., score: 0}
  | (if .list | sorted then "List was sorted to begin with."
     else
     prompt,
     ( label $done
     | foreach inputs as $n (.;
         .list |= reverse($n) | .score +=1;
         if .list | sorted then report, break $done else prompt end ))
     end);
