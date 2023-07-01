#include <MaxMatrix.h>

int DIN = 11;   // DIN pin of MAX7219 module
int CS = 12;    // CS pin of MAX7219 module
int CLK = 13;   // CLK pin of MAX7219 module
int DIN2 = 8;   // DIN pin of MAX7219 module
int CS2 = 9;    // CS pin of MAX7219 module
int CLK2 = 10;   // CLK pin of MAX7219 module
int maxInUse = 1;

//setup two screens
MaxMatrix m(DIN, CS, CLK, maxInUse);
MaxMatrix m2(DIN2, CS2, CLK2, maxInUse);

void setup() {
  randomSeed(analogRead(0));
  m.init(); // MAX7219 initialization
  m.setIntensity(0); // initial led matrix intensity, 0-15
  m.clear(); // Clears the display
  m2.init(); // MAX7219 initialization
  m2.setIntensity(0); // initial led matrix intensity, 0-15
  m2.clear(); // Clears the display
}

void loop() {
  game(16,8);//w,h
}

void setDot(int x,int y,bool isOn){
  if(x<8){
    m.setDot(x,y,isOn);
  }else{
    m2.setDot(x-8,y,isOn);
  }
}

void show(void *u, int w, int h){
  int (*univ)[w] = u;
  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++){
      bool sh=(univ[y][x]==1);
      setDot(x,y,sh);
    }
  }
}

void evolve(void *u, int w, int h){
  unsigned (*univ)[w] = u;
  unsigned newar[h][w];

  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++){
      int n = 0;
      for (int y1 = y - 1; y1 <= y + 1; y1++)
        for (int x1 = x - 1; x1 <= x + 1; x1++)
          if (univ[(y1 + h) % h][(x1 + w) % w])
            n++;

      if (univ[y][x]) n--;
      newar[y][x] = (n == 3 || (n == 2 && univ[y][x]));

    }
  }

  for (int y = 0; y < h; y++){
    for (int x = 0; x < w; x++){
      univ[y][x] = newar[y][x];
    }
  }
}

void game(int w, int h) {
  unsigned univ[h][w];
  for (int x = 0; x < w; x++){
    for (int y = 0; y < h; y++){
      univ[y][x] = random(0, 100)>65 ? 1 : 0;
    }
  }
  int sc=0;
  while (1) {
    show(univ, w, h);
    evolve(univ, w, h);
    delay(150);
    sc++;if(sc>150)break;
  }
}
