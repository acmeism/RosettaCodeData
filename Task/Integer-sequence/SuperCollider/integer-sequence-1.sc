i = Routine { inf.do { |i| i.yield } }; // return all integers, represented by a 64 bit signed float.
fork { inf.do { i.next.postln; 0.01.wait } }; // this prints them incrementally
