function line = stripcomment(line)
   e = min([find(line=='#',1),find(line==';',1)]);
   if ~isempty(e)
      e = e-1;
      while isspace(line(e)) e = e - 1; end; 		
      line = line(1:e);
   end; 	
end;
