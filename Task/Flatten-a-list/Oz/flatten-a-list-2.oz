fun {Flatten2 Xs}
   case Xs of nil then nil
   [] X|Xr then
      {Append {Flatten2 X} {Flatten2 Xr}}
   else [Xs]
   end
end
