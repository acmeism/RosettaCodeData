import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Hashtable;

public class TicTacToe
{
	public static void main(String[] args)
	{
		TicTacToe now=new TicTacToe();
		now.startMatch();
	}
	
	private int[][] marks;
	private int[][] wins;
	private int[] weights;
	private char[][] grid;
	private final int knotcount=3;
	private final int crosscount=4;
	private final int totalcount=5;
	private final int playerid=0;
	private final int compid=1;
	private final int truceid=2;
	private final int playingid=3;
	private String movesPlayer;
	private byte override;
	private char[][] overridegrid={{'o','o','o'},{'o','o','o'},{'o','o','o'}};
	private char[][] numpad={{'7','8','9'},{'4','5','6'},{'1','2','3'}};
	private Hashtable<Integer,Integer> crossbank;
	private Hashtable<Integer,Integer> knotbank;
	
	public void startMatch()
	{
		BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
		System.out.print("Start?(y/n):");
		char choice='y';
		try
		{
			choice=br.readLine().charAt(0);
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		if(choice=='n'||choice=='N')
		{
			return;
		}
		
		System.out.println("Use a standard numpad as an entry grid, as so:\n ");
		display(numpad);
		System.out.println("Begin");
		int playerscore=0;
		int compscore=0;
		do
		{
			int result=startGame();
			if(result==playerid)
				playerscore++;
			else if(result==compid)
				compscore++;
			System.out.println("Score: Player-"+playerscore+" AI-"+compscore);
			System.out.print("Another?(y/n):");
			try
			{
				choice=br.readLine().charAt(0);
			}
			catch(Exception e)
			{
				System.out.println(e.getMessage());
			}
			
		}while(choice!='n'||choice=='N');
		
		System.out.println("Game over.");
	}
	private void put(int cell,int player)
	{
		int i=-1,j=-1;;
		switch(cell)
		{
		case 1:i=2;j=0;break;
		case 2:i=2;j=1;break;
		case 3:i=2;j=2;break;
		case 4:i=1;j=0;break;
		case 5:i=1;j=1;break;
		case 6:i=1;j=2;break;
		case 7:i=0;j=0;break;
		case 8:i=0;j=1;break;
		case 9:i=0;j=2;break;
		default:display(overridegrid);return;
		}
		char mark='x';
		if(player==0)
			mark='o';
		grid[i][j]=mark;
		display(grid);
	}
	private int startGame()
	{
		init();
		display(grid);
		int status=playingid;
		while(status==playingid)
		{
			put(playerMove(),0);
			if(override==1)
			{
				System.out.println("O wins.");
				return playerid;
			}
			status=checkForWin();
			if(status!=playingid)
				break;
			try{Thread.sleep(1000);}catch(Exception e){System.out.print(e.getMessage());}
			put(compMove(),1);
			status=checkForWin();
		}
		return status;
	}
	private void init()
	{
		movesPlayer="";
		override=0;
		marks=new int[8][6];
		wins=new int[][]	//new int[8][3];
		{	
				{7,8,9},
				{4,5,6},
				{1,2,3},
				{7,4,1},
				{8,5,2},
				{9,6,3},
				{7,5,3},
				{9,5,1}
		};
		weights=new int[]{3,2,3,2,4,2,3,2,3};
		grid=new char[][]{{' ',' ',' '},{' ',' ',' '},{' ',' ',' '}};
		crossbank=new Hashtable<Integer,Integer>();
		knotbank=new Hashtable<Integer,Integer>();
	}
	private void mark(int m,int player)
	{
		for(int i=0;i<wins.length;i++)
			for(int j=0;j<wins[i].length;j++)
				if(wins[i][j]==m)
				{
					marks[i][j]=1;
					if(player==playerid)
						marks[i][knotcount]++;
					else
						marks[i][crosscount]++;
					marks[i][totalcount]++;
				}
	}
	private void fixWeights()
	{
		for(int i=0;i<3;i++)
			for(int j=0;j<3;j++)
				if(marks[i][j]==1)
					if(weights[wins[i][j]-1]!=Integer.MIN_VALUE)
						weights[wins[i][j]-1]=Integer.MIN_VALUE;
		
		for(int i=0;i<8;i++)
		{
			if(marks[i][totalcount]!=2)
				continue;
			if(marks[i][crosscount]==2)
			{
				int p=i,q=-1;
				if(marks[i][0]==0)
					q=0;
				else if(marks[i][1]==0)
					q=1;
				else if(marks[i][2]==0)
					q=2;
				
				if(weights[wins[p][q]-1]!=Integer.MIN_VALUE)
				{
					weights[wins[p][q]-1]=6;
				}
			}
			if(marks[i][knotcount]==2)
			{
				int p=i,q=-1;
				if(marks[i][0]==0)
					q=0;
				else if(marks[i][1]==0)
					q=1;
				else if(marks[i][2]==0)
					q=2;
				
				if(weights[wins[p][q]-1]!=Integer.MIN_VALUE)
				{
					weights[wins[p][q]-1]=5;
				}
			}
		}
	}
	private int compMove()
	{
		int cell=move();
		System.out.println("Computer plays: "+cell);
		//weights[cell-1]=Integer.MIN_VALUE;
		return cell;
	}
	private int move()
	{
		int max=Integer.MIN_VALUE;
		int cell=0;
		for(int i=0;i<weights.length;i++)
			if(weights[i]>max)
			{
				max=weights[i];
				cell=i+1;
			}
		
		//This section ensures the computer never loses
		//Remove it for a fair match
		//Dirty kluge
		if(movesPlayer.equals("76")||movesPlayer.equals("67"))
			cell=9;
		else if(movesPlayer.equals("92")||movesPlayer.equals("29"))
			cell=3;
		else if (movesPlayer.equals("18")||movesPlayer.equals("81"))
			cell=7;
		else if(movesPlayer.equals("73")||movesPlayer.equals("37"))
			cell=4*((int)(Math.random()*2)+1);
		else if(movesPlayer.equals("19")||movesPlayer.equals("91"))
			cell=4+2*(int)(Math.pow(-1, (int)(Math.random()*2)));
		
		mark(cell,1);
		fixWeights();
		crossbank.put(cell, 0);
		return cell;
	}
	private int playerMove()
	{
		System.out.print("What's your move?: ");
		BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
		int cell=0;
		int okay=0;
		while(okay==0)
		{
			try
			{
				cell=Integer.parseInt(br.readLine());
			}
			catch(Exception e)
			{
				System.out.println(e.getMessage());
			}
			if(cell==7494)
			{
				override=1;
				return -1;
			}
			if((cell<1||cell>9)||weights[cell-1]==Integer.MIN_VALUE)
				System.out.print("Invalid move. Try again:");
			else
				okay=1;
		}
		playerMoved(cell);
		System.out.println();
		return cell;
	}
	private void playerMoved(int cell)
	{
		movesPlayer+=cell;
		mark(cell,0);
		fixWeights();
		knotbank.put(cell, 0);
	}
	private int checkForWin()
	{
		int crossflag=0,knotflag=0;
		for(int i=0;i<wins.length;i++)
		{
			if(crossbank.containsKey(wins[i][0]))
				if(crossbank.containsKey(wins[i][1]))
					if(crossbank.containsKey(wins[i][2]))
					{
						crossflag=1;
						break;
					}
			if(knotbank.containsKey(wins[i][0]))
				if(knotbank.containsKey(wins[i][1]))
					if(knotbank.containsKey(wins[i][2]))
					{
						knotflag=1;
						break;
					}
		}
		if(knotflag==1)
		{
			display(grid);
			System.out.println("O wins.");
			return playerid;
		}
		else if(crossflag==1)
		{
			display(grid);
			System.out.println("X wins.");
			return compid;
		}
		
		for(int i=0;i<weights.length;i++)
			if(weights[i]!=Integer.MIN_VALUE)
				return playingid;
		System.out.println("Truce");
		
		return truceid;
	}
	private void display(char[][] grid)
	{
		for(int i=0;i<3;i++)
		{
			System.out.println("\n-------");
			System.out.print("|");
			for(int j=0;j<3;j++)
				System.out.print(grid[i][j]+"|");
		}
		System.out.println("\n-------");
	}
}
