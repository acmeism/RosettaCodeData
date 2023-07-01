function str = stripblockcomment(str,startmarker,endmarker)
   while(1)
      ix1 = strfind(str, startmarker);
      if isempty(ix1) return; end;
      ix2 = strfind(str(ix1+length(startmarker):end),endmarker);
      if isempty(ix2)
         str = str(1:ix1(1)-1);
         return;
      else
         str = [str(1:ix1(1)-1),str(ix1(1)+ix2(1)+length(endmarker)+1:end)];
      end;
   end;	
end;
