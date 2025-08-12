# Save this section as compile.sh and run it in a terminal with all files in same directory
gcc -shared -fPIC -o libquery.so query_wrapper.c -I$JULIA_DIR/include/julia -L$JULIA_DIR/lib -ljulia -Wl,-rpath,$JULIA_DIR/lib
if [ $? -ne 0 ]; then
    echo "Error: Compilation of libquery.so failed."
    exit 1
fi
echo "libquery.so compiled successfully."

gcc -o main main.c -L. -lquery
if [ $? -ne 0 ]; then
    echo "Error: Compilation of main failed."
    exit 1
fi
echo "main compiled successfully."

export LD_LIBRARY_PATH=.:$JULIA_DIR/lib:$LD_LIBRARY_PATH
./main

echo "Script finished."
