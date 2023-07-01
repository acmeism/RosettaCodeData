#!/usr/bin/env pike

int main(int argc, array(string) argv)
{
        foreach(argv[1..], string value)
        {
                int v = (int)value;
                if(v<0)
                        continue;
                call_out(print, v, value);
        }
        return -1;
}

void print(string value)
{
        write("%s\n", value);
        if(find_call_out(print)==-1)
                exit(0);
        return;
}
