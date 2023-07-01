void number_reversal_game()
{
	cout << "Number Reversal Game. Type a number to flip the first n numbers.";
	cout << "You win by sorting the numbers in ascending order.";
	cout << "Anything besides numbers are ignored.\n";
	cout << "\t  |1__2__3__4__5__6__7__8__9|\n";
	int list[9] = {1,2,3,4,5,6,7,8,9};
        do
        {
	  shuffle_list(list,9);
        } while(check_array(list, 9));

	int tries=0;
	unsigned int i;
	int input;

	while(!check_array(list, 9))
	{
		cout << "Round " << tries << ((tries<10) ? " :  " : " : ");
		for(i=0;i<9;i++)cout << list[i] << "  ";
		cout << "  Gimme that number:";
		while(1)
		{
			cin >> input;
			if(input>1&&input<10)
				break;

			cout << "\nPlease enter a number between 2 and 9:";
		}
		tries++;
		do_flip(list, 9, input);
	}
	cout << "Hurray! You solved it in %d moves!\n";
}
