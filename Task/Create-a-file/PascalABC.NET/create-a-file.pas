##
var f: textfile;
assignFile(f, '/output.txt');
rewrite(f);
close(f);
createdir('/docs');
assignFile(f, '/docs/output.txt');
rewrite(f);
close(f);
