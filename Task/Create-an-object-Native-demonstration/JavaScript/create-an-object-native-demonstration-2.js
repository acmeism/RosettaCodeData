const BR = "<BR>\n"

var pl = function(s) {
    document.write(s + BR) ;
} ;

pl("<pre>") ;

var o = { foo:101, bar:102 } ;

var h = new FixedKeyDict(o) ;
pl("Fixed Key Dict Created") ;
pl("toString   : " + h.toStr()) ;
pl("get an item: " + h.getItem("foo")) ;
pl("check a key: " + h.hasKey("boo")) ;
pl("ditto      : " + h.hasKey("bar")) ;
h.setItem("bar", 999) ;
pl("set an item: " + h.toStr()) ;
pl("Test iterator (or whatever)") ;
for(k in h.iterator())
    pl("  " + k + " => " + h.getItem(k)) ;
var g = h.clone() ;
pl("Clone a dict") ;
pl("  clone    : " + g.toStr()) ;
pl("  original : " + h.toStr()) ;
h.clear() ;
pl("clear or reset the dict") ;
pl("           : " + h.toStr()) ;
try {
    h.setItem("NoNewKey", 666 ) ;
} catch(e) {
    pl("error test : " + e.message) ;
}
