d1 = dir('input.txt');
d2 = dir('/input.txt');
fprintf('Size of input.txt is %d bytes\n', d1.bytes)
fprintf('Size of /input.txt is %d bytes\n', d2.bytes)
