class Runge_Kutta{
static void main(String[] args){
def y=1.0,t=0.0,counter=0;
def dy1,dy2,dy3,dy4;
def real;
while(t<=10)
{if(counter%10==0)
{real=(t*t+4)*(t*t+4)/16;
println("y("+t+")="+ y+ " Error:"+ (real-y));
}

dy1=dy(dery(y,t));
dy2=dy(dery(y+dy1/2,t+0.05));
dy3=dy(dery(y+dy2/2,t+0.05));
dy4=dy(dery(y+dy3,t+0.1));

y=y+(dy1+2*dy2+2*dy3+dy4)/6;
t=t+0.1;
counter++;
}
}
static def dery(def y,def t){return t*(Math.sqrt(y));}
static def dy(def x){return x*0.1;}
}
