use File::Find;

.say for find(dir => '.').grep(/foo/);
