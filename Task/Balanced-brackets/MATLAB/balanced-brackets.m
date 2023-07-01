function x = isbb(s)
   t = cumsum((s=='[') - (s==']'));
   x = all(t>=0) && (t(end)==0);
end;
