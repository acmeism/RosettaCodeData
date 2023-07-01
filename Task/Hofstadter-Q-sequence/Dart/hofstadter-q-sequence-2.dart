class Q {
  Map<int,int> _table;

  Q() {
    _table=new Map<int,int>();
    _table[1]=1;
    _table[2]=1;
  }

  int q(int n) {
    // if the cache is not filled until n-1, fill it starting with the lowest entries first
    // this avoids doing a recursion from n to 2 (e.g. if you call q(1000000) first)
    // this doesn't happen in the  tasks calls since the cache is filled ascending
    if(_table[n-1]==null) {
      for(int i=_table.length;i<n;i++) {
		q(i);
	  }
    }
    if(_table[n]==null) {
      _table[n]=q(n-q(n-1))+q(n-q(n-2));
    }

    return _table[n];
  }
}

main() {
  Q q=new Q();

  for(int i=1;i<=10;i++) {
    print("Q($i)=${q.q(i)}");
  }
  print("Q(1000)=${q.q(1000)}");

  int count=0;
  for(int i=2;i<=100000;i++) {
    if(q.q(i)<q.q(i-1)) {
      count++;
    }
  }
  print("value is smaller than previous $count times");
}
