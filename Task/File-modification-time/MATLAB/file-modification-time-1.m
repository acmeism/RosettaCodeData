   f = dir('output.txt');  % struct f contains file information
   f.date     % is string containing modification time
   f.datenum  % numerical format (number of days)
   datestr(f.datenum)   % is the same as f.date	
   % see also: stat, lstat
