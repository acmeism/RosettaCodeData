int main(int argc, array argv)
{
    call_out(write, random(1.0), "Enjoy\n");
    call_out(write, random(1.0), "Rosetta\n");
    call_out(write, random(1.0), "Code\n");
    call_out(exit, 1, 0);
    return -1; // return -1 starts the backend which makes Pike run until exit() is called.
}
