type hole = int;
param A : hole = 1;
param B : hole = A+1;
param C : hole = B+1;
param D : hole = C+1;
param E : hole = D+1;
param F : hole = E+1;
param G : hole = F+1;
param H : hole = G+1;
param starting : int = 0;
const holes : domain(hole) = { A,B,C,D,E,F,G,H };
const graph : [holes] domain(hole) = [  A => { C,D,E },
                                        B => { D,E,F },
                                        C => { A,D,G },
                                        D => { A,B,C,E,G,H },
                                        E => { A,B,D,F,G,H },
                                        F => { B,E,H },
                                        G => { C,D,E },
                                        H => { D,E,F }
                                      ];

proc check( configuration : [] int, idx : hole ) : bool {
  var good = true;
  for adj in graph[idx] {
    if adj >= idx then continue;
    if abs( configuration[idx] - configuration[adj] ) <= 1 {
      good = false;
      break;
    }
  }

  return good;
}

proc solve( configuration : [] int, pegs : domain(int), idx : hole = A ) : bool {
  for value in pegs {
    configuration[idx] = value;
    if check( configuration, idx ) {
      if idx < holes.size {
        var prePegs = pegs;
        if solve( configuration, prePegs - value, idx + 1 ){
          return true;
        }
      } else {
        return true;
      }
    }
  }
  configuration[idx] = starting;
  return false;
}

proc printBoard( configuration : [] int ){
return
"\n       " + configuration[A] + "   " + configuration[B]+ "\n" +
"      /|\\ /|\\ \n"+
"     / | X | \\ \n"+
"    /  |/ \\|  \\ \n"+
"   " + configuration[C] +" - " + configuration[D] + " - " + configuration[E] + " - " + configuration[F] + " \n"+
"    \\  |\\ /|  / \n"+
"     \\ | X | / \n"+
"      \\|/ \\|/ \n"+
"       " + configuration[G] + "   " + configuration[H]+ "\n";

}



proc main(){
  var configuration : [holes] int;
  for idx in holes do configuration[idx] = starting;

  var pegs : domain(int) = {1,2,3,4,5,6,7,8};
  solve( configuration, pegs );

  writeln( printBoard( configuration ) );

}
