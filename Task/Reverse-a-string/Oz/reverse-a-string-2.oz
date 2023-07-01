local
   fun {DoReverse Xs Ys}
      case Xs of nil then Ys
      [] X|Xr then {DoReverse Xr X|Ys}
      end
   end
in
   fun {Reverse Xs} {DoReverse Xs nil} end
end
