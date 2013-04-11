int main(int argc, char **argv)
{
    //Just need some random numbers. I chose <100
    int list[9];
    int i;
    srand(time(NULL));
    for(i=0;i<9;i++)
        list[i]=rand()%100;


    //Print list, run code and print it again displaying number of moves
    printf("\nOriginal: ");
    print_array(list, 9);

    int moves = pancake_sort(list, 9, 1);

    printf("\nSorted: ");
    print_array(list, 9);
    printf("  - with a total of %d moves\n", moves);
}
