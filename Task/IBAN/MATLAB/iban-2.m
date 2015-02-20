tests = {'GB82 WEST 1234 5698 7654 32' ;
'GB82 TEST 1234 5698 7654 32' ;
'CH93 0076 2011 6238 5295 7' ;
'SA03 8000 0000 6080 1016 7519' ;
'SA03 1234 5678 9101 1121 3141' ;
'GB29 NWBK 6016 1331 9268 19' ;
'GB29' ;
'GR16 0110 1250 0000 0001 2300 695'};
for k = 1:length(tests)
fprintf('%s -> %svalid\n', tests{k}, char(~validateIBAN(tests{k}).*'in'))
end
