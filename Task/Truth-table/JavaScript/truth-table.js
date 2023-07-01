<!DOCTYPE html><html><head><title>Truth table</title><script>
var elem,expr,vars;
function isboolop(chr){return "&|!^".indexOf(chr)!=-1;}
function varsindexof(chr){
    var i;
    for(i=0;i<vars.length;i++){if(vars[i][0]==chr)return i;}
    return -1;
}
function printtruthtable(){
    var i,str;
    elem=document.createElement("pre");
    expr=prompt("Boolean expression:\nAccepts single-character variables (except for \"T\" and \"F\", which specify explicit true or false values), postfix, with \"&|!^\" for and, or, not, xor, respectively; optionally seperated by whitespace.").replace(/\s/g,"");
    vars=[];
    for(i=0;i<expr.length;i++)if(!isboolop(expr[i])&&expr[i]!="T"&&expr[i]!="F"&&varsindexof(expr[i])==-1)vars.push([expr[i],-1]);
    if(vars.length==0)return;
    str="";
    for(i=0;i<vars.length;i++)str+=vars[i][0]+" ";
    elem.innerHTML="<b>"+str+expr+"</b>\n";
    vars[0][1]=false;
    truthpartfor(1);
    vars[0][1]=true;
    truthpartfor(1);
    vars[0][1]=-1;
    document.body.appendChild(elem);
}
function truthpartfor(index){
    if(index==vars.length){
        var str,i;
        str="";
        for(i=0;i<index;i++)str+=(vars[i][1]?"<b>T</b>":"F")+" ";
        elem.innerHTML+=str+(parsebool()?"<b>T</b>":"F")+"\n";
        return;
    }
    vars[index][1]=false;
    truthpartfor(index+1);
    vars[index][1]=true;
    truthpartfor(index+1);
    vars[index][1]=-1;
}
function parsebool(){
    var stack,i,idx;
    console.log(vars);
    stack=[];
    for(i=0;i<expr.length;i++){
        if(expr[i]=="T")stack.push(true);
        else if(expr[i]=="F")stack.push(false);
        else if((idx=varsindexof(expr[i]))!=-1)stack.push(vars[idx][1]);
        else if(isboolop(expr[i])){
            switch(expr[i]){
                case "&":stack.push(stack.pop()&stack.pop());break;
                case "|":stack.push(stack.pop()|stack.pop());break;
                case "!":stack.push(!stack.pop());break;
                case "^":stack.push(stack.pop()^stack.pop());break;
            }
        } else alert("Non-conformant character "+expr[i]+" in expression. Should not be possible.");
        console.log(stack);
    }
    return stack[0];
}
</script></head><body onload="printtruthtable()"></body></html>
