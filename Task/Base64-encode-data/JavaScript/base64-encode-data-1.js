(function(){//ECMAScript doesn't have an internal base64 function or method, so we have to do it ourselves, isn't that exciting?
    function stringToArrayUnicode(str){for(var i=0,l=str.length,n=[];i<l;i++)n.push(str.charCodeAt(i));return n;}
    function generateOnesByLength(n){//Attempts to generate a binary number full of ones given a length.. they don't redefine each other that much.
        var x=0;
        for(var i=0;i<n;i++){
            x<<=1;x|=1;//I don't know if this is performant faster than Math.pow but seriously I don't think I'll need Math.pow, do I?
        }
        return x;
    }
    function paf(_offset,_offsetlength,_number){//I don't have any name for this function at ALL, but I will explain what it does, it takes an offset, a number and returns the base64 number and the offset of the next number.
        //the next function will be used to extract the offset of the number..
        var a=6-_offsetlength,b=8-a;//Oh god, 8 is HARDCODED! Because 8 is the number of bits in a byte!!!
        //And 6 is the mini-byte used by wikipedia base64 article... at least on 2013.
        //I imagine this code being read in 2432 or something, that probably won't happen..
        return [_number&generateOnesByLength(b),b,(_offset<<a)|(_number>>b)];//offset & offsetlength & number
    }
    function toBase64(uint8array){//of bits, each value may not have more than 255 bits... //a normal "array" should work fine too..
        //From 0x29 to 0x5a plus from 0x61 to 0x7A AND from 0x30 to 0x39
        //Will not report errors if an array index has a value bigger than 255.. it will likely fail.
        var a=[],i,output=[];
        for(i=0x41;i<=0x5a;i++){//A-Z
            a.push(String.fromCharCode(i));
        }
        for(i=0x61;i<=0x7A;i++){//a-z
            a.push(String.fromCharCode(i));
        }
        for(i=0x30;i<=0x39;i++){//0-9
            a.push(String.fromCharCode(i));
        }
        a.push('+','/');
        var offset=0,offsetLength=0,x;
        for(var i=0,l=uint8array.length;i<l;i++){
            if(offsetLength==6){//if offsetlength is 6 that means that a whole offset is occupying the space of a byte, can you believe it.
                offsetLength=0;
                output.push(a[offset]);
                offset=0;
                i--;
                continue;
            }
            x=paf(offset,offsetLength,uint8array[i]);
            offset=x[0];
            offsetLength=x[1];
            output.push(a[x[2]]);
        }
        if(offsetLength){
            if(offsetLength==6){
                output.push(a[offset]);
            }else{
                var y=(6-offsetLength)/2;
                x=paf(offset,offsetLength,0);
                offset=x[0];
                output.push(a[x[2]]);
                switch (y){
                    case 2:output.push('=');//This thingy right here, you know.. the offsets also, no break statement;
                    case 1:output.push('=');break;
                }
            }
        }
        return output.join('');//You can change it so the result is an array instead!!!!
    }

    //Usage

    return toBase64(stringToArrayUnicode("Nothing seems hard to the people who don't know what they're talking about."))
}())
