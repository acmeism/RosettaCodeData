import std::io;
import std::collections::list;

fn void main()
{
    int[9] list1 = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    int[9] list2 = { 10, 11, 12, 13, 14, 15, 16, 17, 18 };
    int[9] list3 = { 19, 20, 21, 22, 23, 24, 25, 26, 27 };
    List(<String>) list;
    list.temp_init();
    for (int i = 0; i < 9; i++)
    {
        list.push(string::tformat("%d%d%d", list1[i], list2[i], list3[i]));
    }
    io::printn(list);
}
