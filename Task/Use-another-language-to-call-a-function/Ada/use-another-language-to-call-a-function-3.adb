gcc -c main.c
gnatmake -c exported.adb
gnatbind -n exported.ali
gnatlink exported.ali main.o -o main
