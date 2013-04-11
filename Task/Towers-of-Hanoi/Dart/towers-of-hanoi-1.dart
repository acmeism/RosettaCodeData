main() {
  moveit(from,to) {
    print("move ${from} ---> ${to}");
  }

  hanoi(height,toPole,fromPole,usePole) {
    if (height>0) {
      hanoi(height-1,usePole,fromPole,toPole);
      moveit(fromPole,toPole);
      hanoi(height-1,toPole,usePole,fromPole);
    }
  }

  hanoi(3,3,1,2);
}
