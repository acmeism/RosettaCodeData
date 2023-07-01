inputString = fileread(csvFileName);
   % using multiple regular expressions to clear up special chars
htmlFriendly = regexprep(regexprep(regexprep(regexprep(inputString,...
      '&','&amp;'),...
      '"','&quot;'),...
      '<','&lt;'),...
      '>','&gt;');
   % split string into cell array
tableValues = regexp(regexp(htmlFriendly,'(\r\n|\r|\n)','split')',',','split');
   %%% print in html format %%%
   % <Extra Credit> first line gets treated as header
fprintf(1,['<table>\n\t<tr>'  sprintf('\n\t\t<th>%s</th>',tableValues{1,:}{:})])
   % print remaining lines of csv as html table (rows 2:end in cell array of csv values)
cellfun(@(x)fprintf(1,['\n\t<tr>'  sprintf('\n\t\t<td>%s</td>',x{:}) '\n\t</tr>']),tableValues(2:end))
fprintf(1,'\n</table>')
