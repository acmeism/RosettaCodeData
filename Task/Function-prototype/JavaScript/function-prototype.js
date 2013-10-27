var randomFunction=function(a){this.someNumber=a;}; //Doesn't matter when the function uses parameters, named arguments, no arguments, or if it doesn't return nothing at all.
randomFunction.prototype.getSomeNumber=function(){return this.someNumber;}
randomFunction.prototype.setSomeNumber=function(a){return this.someNumber=a;}//editing prototype explicitly
(new randomFunction(7)).getSomeNumber();//7
