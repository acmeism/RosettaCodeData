void number_reversal_game()
{
    printf("Number Reversal Game. Type a number to flip the first n numbers.");
    printf("Win by sorting the numbers in ascending order.\n");
    printf("Anything besides numbers are ignored.\n");
    printf("\t  |1__2__3__4__5__6__7__8__9|\n");
    int list[9] = {1,2,3,4,5,6,7,8,9};
    shuffle_list(list,9);

    int tries=0;
    unsigned int i;
    int input;

    while(!check_array(list, 9))
    {
        ((tries<10) ? printf("Round %d :  ", tries) : printf("Round %d : ", tries));
        for(i=0;i<9;i++)printf("%d  ",list[i]);
        printf("  Gimme that number:");
        while(1)
        {
            //Just keep asking for proper input
            scanf("%d", &input);
            if(input>1&&input<10)
                break;

            printf("\n%d - Please enter a number between 2 and 9:", (int)input);
        }
        tries++;
        do_flip(list, 9, input);
    }
    printf("Hurray! You solved it in %d moves!\n", tries);
}
