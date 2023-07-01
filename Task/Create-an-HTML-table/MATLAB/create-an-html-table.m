function htmltable(fid,table,Label)
   fprintf(fid,'<table>\n  <thead align = "right">\n');
   if nargin<3,
       fprintf(fid,'    <tr><th></th><td>X</td><td>Y</td><td>Z</td></tr>\n  </thead>\n  <tbody align = "right">\n');
   else
       fprintf(fid,'    <tr><th></th>');
       fprintf(fid,'<td>%s</td>',Label{:});
       fprintf(fid,'</tr>\n  </thead>\n  <tbody align = "right">\n');
   end;
   fprintf(fid,'    <tr><td>%2i</td><td>%5i</td><td>%5i</td><td>%5i</td></tr>\n', [1:size(table,1);table']);
   fprintf(fid,'  </tbody>\n</table>\n');
end
