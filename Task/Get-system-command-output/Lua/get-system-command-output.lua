local output = io.popen("echo Hurrah!")
print(output:read("*all"))
