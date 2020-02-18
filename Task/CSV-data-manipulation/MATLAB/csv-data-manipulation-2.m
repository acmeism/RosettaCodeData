filename='data.csv';
data = readtable(filename);
data.SUM = sum([data{:,:}],2);
writetable(data,filename);
