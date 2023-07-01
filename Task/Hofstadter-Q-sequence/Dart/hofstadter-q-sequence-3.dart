main() {
  List<int> q=new List<int>(100001);
  q[1]=q[2]=1;

  int count=0;
  for(int i=3;i<q.length;i++) {
    q[i]=q[i-q[i-1]]+q[i-q[i-2]];
    if(q[i]<q[i-1]) {
      count++;
    }
  }
  for(int i=1;i<=10;i++) {
    print("Q($i)=${q[i]}");
  }
  print("Q(1000)=${q[1000]}");
  print("value is smaller than previous $count times");
}
