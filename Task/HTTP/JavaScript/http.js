((function(url,callback,method,post,headers){//headers is an object like this {Connection:"keep-alive"}
function createXMLHttpRequest() {
  if (typeof XMLHttpRequest != "undefined") {
    return new XMLHttpRequest();
  } else if (typeof window.ActiveXObject != "undefined") {
    try {
      return new ActiveXObject("Msxml2.XMLHTTP.4.0");
    } catch (e) {
      try {
        return new ActiveXObject("MSXML2.XMLHTTP");
      } catch (e) {
        try {
          return new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {
          return null;
        }
      }
    }
  }
}
function looProp(object,callback){
var a;
for(a in object){
if(object.hasOwnProperty(a))callback.call(object,a,object[a]);
}
}
method=method||"GET";
var xhr=createXMLHttpRequest();
if(xhr){
xhr.open(method,url,true);
looProp(headers,function(a,b){xhr.setRequestHeader(a,b)})
xhr.onreadystatechange=function(){if(xhr.readyState==xhr.DONE){callback(xhr)}};
xhr.send(post);
return xhr;}else{return null;}
})('http://rosettacode.org',function(xhr){console.log(xhr.responseText)}))
