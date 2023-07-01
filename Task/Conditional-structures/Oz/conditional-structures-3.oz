fun {Fac X}
   case X of 0 then 1
   [] _ then X * {Fac X-1}
   end
end
