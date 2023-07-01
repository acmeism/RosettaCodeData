// Reverse a string. Nigel Galloway: August 14th., 2019
let strRev α=let N=System.Globalization.StringInfo.GetTextElementEnumerator(α)
             List.unfold(fun n->if n then Some(N.GetTextElement(),N.MoveNext()) else None)(N.MoveNext())|>List.rev|>String.concat ""
