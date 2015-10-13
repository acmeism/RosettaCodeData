obj  = new Proxy({},
        { get : function(target, prop)
            {
                if(target[prop] === undefined)
                    return function()  {
                        console.log('an otherwise undefined function!!');
                    };
                else
                    return target[prop];
            }
        });
obj.f()        ///'an otherwise undefined function!!'
obj.l = function() {console.log(45);};
obj.l();       ///45
