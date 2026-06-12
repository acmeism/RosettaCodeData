#!/bin/bash
#define foo foo /*
exec pike $0 hello world
*/

int main(int argc, array argv)
{
   write("%O\n", argv);
}
