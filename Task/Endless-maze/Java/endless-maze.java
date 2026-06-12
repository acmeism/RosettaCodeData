package maze.pgm;

import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class runnable {

 static int areasize = 10;
 static Random r = new Random();
 static Scanner s = new Scanner(System.in);
 static ArrayList<Boolean> e = new ArrayList<Boolean>();
 static ArrayList<Integer> x = new ArrayList<Integer>();
 static ArrayList<Integer> y = new ArrayList<Integer>();
 static int a=0,xp=127,yp=127,f,na=0,d;
 static boolean ok;
 static String entry;

 public static void main(String[] args) {

  f=r.nextInt(4);

  while (true) {

   a=na;
   for (int n=0;n<na;n++) {
    if (x.get(n)==xp && y.get(n)==yp) {a=n; break;}
    }

   if (a==na) {
    na++;
    x.add(xp);
    y.add(yp);
    for (int n=0; n<4; n++) {e.add(r.nextBoolean());}
    for (int n=0; n<na; n++) {
 	      if ((x.get(n)==x.get(a)+1) && (y.get(n)==y.get(a)  )) {e.set(4*a  ,e.get(4*n+2));}
	 else if ((x.get(n)==x.get(a)  ) && (y.get(n)==y.get(a)+1)) {e.set(4*a+1,e.get(4*n+3));}
	 else if ((x.get(n)==x.get(a)-1) && (y.get(n)==y.get(a)  )) {e.set(4*a+2,e.get(4*n  ));}
	 else if ((x.get(n)==x.get(a)  ) && (y.get(n)==y.get(a)-1)) {e.set(4*a+3,e.get(4*n+1));}
     }
    }

   System.out.print("Paths: ");
   if (e.get(4*a+ f   %4)) {System.out.print(" ahead");}
   if (e.get(4*a+(f+1)%4)) {System.out.print(" right");}
   if (e.get(4*a+(f+2)%4)) {System.out.print(" back");}
   if (e.get(4*a+(f+3)%4)) {System.out.print(" left");}
   System.out.println();

   d=-1;
   System.out.print("> ");
   entry=s.nextLine();
   while (d<0) {
         if (entry.equals("ahead")) {d= f   %4;}
    else if (entry.equals("right")) {d=(f+1)%4;}
    else if (entry.equals("back")) {d=(f+2)%4;}
    else if (entry.equals("left")) {d=(f+3)%4;}
    else if (entry.equals("quit")) {s.next(); System.exit(0);}

    if (d<0) {
     System.out.println("Entry invalid.");
	 System.out.print("> ");
	 entry=s.nextLine();
	 }

    ok = false;
    switch(d) {
     case 0: if (e.get(4*a  )) {xp++; f=d; ok=true;} break;
     case 1: if (e.get(4*a+1)) {yp++; f=d; ok=true;} break;
     case 2: if (e.get(4*a+2)) {xp--; f=d; ok=true;} break;
     case 3: if (e.get(4*a+3)) {yp--; f=d; ok=true;} break;
     }

    if (d>=0 && !ok) {System.out.println("No path.");}

    }

   }

  }

 }
