List arrayList = new ArrayList();
arrayList.add(new Integer(0));
// alternative with primitive autoboxed to an Integer object automatically
arrayList.add(0);

//other features of ArrayList
//define the type in the arraylist, you can substitute a proprietary class in the "<>"
List<Integer> myarrlist = new ArrayList<Integer>();

//add several values to the arraylist to be summed later
int sum;
for(int i = 0; i < 10; i++) {
    myarrlist.add(i);
}
