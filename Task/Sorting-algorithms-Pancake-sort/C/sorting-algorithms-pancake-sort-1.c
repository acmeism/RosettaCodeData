int pancake_sort(int *list, unsigned int length)
{
    //If it's less than 2 long, just return it as sorting isn't really needed...
    if(length<2)
        return 0;

    int i,a,max_num_pos,moves;
    moves=0;

    for(i=length;i>1;i--)
    {
        //Find position of the max number in pos(0) to pos(i)
        max_num_pos=0;
        for(a=0;a<i;a++)
        {
            if(list[a]>list[max_num_pos])
                max_num_pos=a;
        }

        if(max_num_pos==i-1)
            //It's where it need to be, skip
            continue;


        //Get the found max number to the beginning of the list (unless it already is)
        if(max_num_pos)
        {
            moves++;
            do_flip(list, length, max_num_pos+1);
        }


        //And then move it to the end of the range we're working with (pos(0) to pos(i))
        moves++;
        do_flip(list, length, i);

        //Then everything above list[i-1] is sorted and don't need to be touched

    }

    return moves;
}
