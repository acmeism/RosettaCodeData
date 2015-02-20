function Arc(posX,posY,radius,startAngle,endAngle,color){//Angle in radians.
this.posX=posX;
this.posY=posY;
this.radius=radius;
this.startAngle=startAngle;
this.endAngle=endAngle;
this.color=color;
}
//0,0 is the top left of the screen
var YingYang=[
new Arc(0.5,0.5,1,0.5*Math.PI,1.5*Math.PI,"white"),//Half white semi-circle
new Arc(0.5,0.5,1,1.5*Math.PI,0.5*Math.PI,"black"),//Half black semi-circle
new Arc(0.5,0.25,.5,0,2*Math.PI,"black"),//black circle
new Arc(0.5,0.75,.5,0,2*Math.PI,"white"),//white circle
new Arc(0.5,0.25,1/6,0,2*Math.PI,"white"),//small white circle
new Arc(0.5,0.75,1/6,0,2*Math.PI,"black")//small black circle
]
//Ying Yang is DONE!
//Now we'll have to draw it.
//We'll draw it in a matrix that way we can get results graphically or by text!
function Array2D(width,height){
this.height=height;
this.width=width;
this.array2d=[];
for(var i=0;i<this.height;i++){
this.array2d.push(new Array(this.width));
}
}
Array2D.prototype.resize=function(width,height){//This is expensive
//nheight and nwidth is the difference of the new and old height
var nheight=height-this.height,nwidth=width-this.width;
if(nwidth>0){
for(var i=0;i<this.height;i++){
if(i<height)
Array.prototype.push.apply(this.array2d[i],new Array(nwidth));
}
}
else if(nwidth<0){
for(var i=0;i<this.height;i++){
if(i<height)
 this.array2d[i].splice(width,nwidth);
}
}
if(nheight>0){
 Array.prototype.push.apply(this.array2d,new Array(width));
}
else if(nheight<0){
 this.array2d.splice(height,nheight)
}
}
Array2D.prototype.loop=function(callback){
for(var i=0;i<this.height;i++)
 for(var i2=0;i2<this.width;i++)
   callback.call(this,this.array2d[i][i2],i,i2);

}
var mat=new Array2D(100,100);//this sounds fine;
YingYang[0];
//In construction.
