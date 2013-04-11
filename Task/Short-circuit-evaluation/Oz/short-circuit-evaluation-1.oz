declare
  fun {A Answer}
     AnswerS = {Value.toVirtualString Answer 1 1}
  in
     {System.showInfo "  % Called function {A "#AnswerS#"} -> "#AnswerS}
     Answer
  end

  fun {B Answer}
     AnswerS = {Value.toVirtualString Answer 1 1}
  in
     {System.showInfo "  % Called function {B "#AnswerS#"} -> "#AnswerS}
     Answer
  end
in
  for I in [false true] do
     for J in [false true] do
        X Y
     in
        {System.showInfo "\nCalculating: X = {A I} andthen {B J}"}
        X = {A I} andthen {B J}
        {System.showInfo "Calculating: Y = {A I} orelse {B J}"}
        Y = {A I} orelse {B J}
     end
  end
