var keyError = new Error("Invalid Key Error (FixedKeyDict)") ;

function FixedKeyDict(obj)
{
    var myDefault = new Object() ;
    var myData    = new Object() ;
    for(k in obj) {
        myDefault[k] = obj[k] ;
        myData[k]    = obj[k] ;
    }

    var gotKey = function(k) {
        for(kk in myDefault) {
            if(kk == k) return true ;
        }
        return false ;
    } ;

    this.hasKey = gotKey ;

    var checkKey = function(k) {
        if(!gotKey(k))
            throw keyError ;
    } ;

    this.getItem = function(k) {
        checkKey(k) ;
        return myData[k];
    } ;

    this.setItem = function(k, v) {
        checkKey(k) ;
        myData[k] = v ;
    } ;

    this.resetItem = function(k) {
        checkKey(k) ;
        myData[k] = myDefault[k] ;
    } ;

    this.delItem = this.resetItem ;

    this.clear   = function() {
        for(k in myDefault)
            myData[k] = myDefault[k] ;
    } ;

    this.iterator = function() {
        for(k in myDefault)
            yield (k);
    } ;

    this.clone    = function() {
        return new FixedKeyDict(myDefault) ;
    }

    this.toStr = function() {
        var s = "" ;
        for(key in myData)
            s = s + key + " => " + myData[key] + ", " ;
        return "FixedKeyDict{" + s + "}" ;
    } ;
}
