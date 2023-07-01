import java.util.ArrayList;
...//class definition, etc.
public static void genPyrN(int rows){
	if(rows < 0) return;
	//save the last row here
	ArrayList<Integer> last = new ArrayList<Integer>();
	last.add(1);
	System.out.println(last);
	for(int i= 1;i <= rows;++i){
		//work on the next row
		ArrayList<Integer> thisRow= new ArrayList<Integer>();
		thisRow.add(last.get(0)); //beginning
		for(int j= 1;j < i;++j){//loop the number of elements in this row
			//sum from the last row
			thisRow.add(last.get(j - 1) + last.get(j));
		}
		thisRow.add(last.get(0)); //end
		last= thisRow;//save this row
		System.out.println(thisRow);
	}
}
