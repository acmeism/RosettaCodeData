STRING hostname;
get(read OF execve child pipe("/bin/hostname","hostname",""), hostname);
print(("hostname: ", hostname, new line))
