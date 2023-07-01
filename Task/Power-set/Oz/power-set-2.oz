fun {Powerset2 Set}
   case Set of nil then [nil]
   [] H|T thens
      Acc = {Powerset2 T}
   in
      {Append Acc {Map Acc fun {$ A} H|A end}}
   end
end
