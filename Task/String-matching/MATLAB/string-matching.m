   % 1. Determining if the first string starts with second string
	strcmp(str1,str2,length(str2))
   % 2. Determining if the first string contains the second string at any location
	~isempty(strfind(s1,s2))
   % 3. Determining if the first string ends with the second string
	( (length(str1)>=length(str2)) && strcmp(str1(end+[1-length(str2):0]),str2) )

   % 1. Print the location of the match for part 2
	disp(strfind(s1,s2))
   % 2. Handle multiple occurrences of a string for part 2.
	ix = strfind(s1,s2);   % ix is a vector containing the starting positions of s2 within s1
