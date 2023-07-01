function [result,count] = word_frequency()
URL='https://www.gutenberg.org/files/135/135-0.txt';
text=webread(URL);
DELIMITER={' ', ',', ';', ':', '.', '/', '*', '!', '?', '<', '>', '(', ')', '[', ']','{', '}', '&','$','§','"','”','“','-','—','‘','\t','\n','\r'};
words  = sort(strsplit(lower(text),DELIMITER));
flag   = [find(~strcmp(words(1:end-1),words(2:end))),length(words)];
dwords = words(flag);   % get distinct words, and ...
count  = diff([0,flag]);  % ... the corresponding occurance frequency
[tmp,idx] = sort(-count);       % sort according to occurance
result = dwords(idx);
count  = count(idx);
for k  =  1:10,
        fprintf(1,'%d\t%s\n',count(k),result{k})
end
