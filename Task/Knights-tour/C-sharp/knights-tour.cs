using System;
using System.Collections.Generic;

namespace prog
{
	class MainClass
	{	
		const int N = 8;
		
		readonly static int[,] moves = { {+1,-2},{+2,-1},{+2,+1},{+1,+2},
			                         {-1,+2},{-2,+1},{-2,-1},{-1,-2} };
		struct ListMoves
		{
			public int x, y;			
			public ListMoves( int _x, int _y ) { x = _x; y = _y; }
		}		
		
		public static void Main (string[] args)
		{
			int[,] board = new int[N,N];
			board.Initialize();
			
			int x = 0,						// starting position
			    y = 0;
			
			List<ListMoves> list = new List<ListMoves>(N*N);
			list.Add( new ListMoves(x,y) );
						
			do
			{								
				if ( Move_Possible( board, x, y ) )
				{										
					int move = board[x,y];					
					board[x,y]++;
					x += moves[move,0];
					y += moves[move,1];			
					list.Add( new ListMoves(x,y) );							
				}
				else
				{					
					if ( board[x,y] >= 8 )
					{						
						board[x,y] = 0;																
						list.RemoveAt(list.Count-1);						
						if ( list.Count == 0 )
						{
							Console.WriteLine( "No solution found." );
							return;
						}		
						x = list[list.Count-1].x;
						y = list[list.Count-1].y;						
					}
					board[x,y]++;
				}				
			}
			while( list.Count < N*N );
			
			int last_x = list[0].x,
			    last_y = list[0].y;
			string letters = "ABCDEFGH";
			for( int i=1; i<list.Count; i++ )
			{				
				Console.WriteLine( string.Format("{0,2}:  ", i) + letters[last_x] + (last_y+1) + " - " + letters[list[i].x] + (list[i].y+1) );
				
				last_x = list[i].x;
				last_y = list[i].y;
			}
		}
		
		static bool Move_Possible( int[,] board, int cur_x, int cur_y )
		{			
			if ( board[cur_x,cur_y] >= 8 )
				return false;
			
			int new_x = cur_x + moves[board[cur_x,cur_y],0],
			    new_y = cur_y + moves[board[cur_x,cur_y],1];
			
			if ( new_x >= 0 && new_x < N && new_y >= 0 && new_y < N && board[new_x,new_y] == 0 )
				return true;
			
			return false;
		}
	}
}
