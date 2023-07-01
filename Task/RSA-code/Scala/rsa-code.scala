object RSA_saket{
    val d = BigInt("5617843187844953170308463622230283376298685")
    val n = BigInt("9516311845790656153499716760847001433441357")
    val e = 65537
    val text = "Rosetta Code"
    val encode = (msg:BigInt) => pow_mod(msg,e,n)
    val decode = (msg:BigInt) => pow_mod(msg,d,n)
    val getmsg = (txt:String) => BigInt(txt.map(x => "%03d".format(x.toInt)).reduceLeft(_+_))
    def pow_mod(p:BigInt, q:BigInt, n:BigInt):BigInt = {
        if(q==0)            BigInt(1)
        else if(q==1)       p
        else if(q%2 == 1)   pow_mod(p,q-1,n)*p % n
        else                pow_mod(p*p % n,q/2,n)
    }
    def gettxt(num:String) = {
        if(num.size%3==2)
            ("0" + num).grouped(3).toList.foldLeft("")(_ + _.toInt.toChar)
        else
            num.grouped(3).toList.foldLeft("")(_ + _.toInt.toChar)
    }
    def main(args: Array[String]): Unit = {
        println(f"Original String \t: "+text)
        val msg = getmsg(text)
        println(f"Converted Signal \t: "+msg)
        val enc_sig = encode(msg)
        println("Encoded Signal \t\t: "+ enc_sig)
        val dec_sig = decode(enc_sig)
        println("Decoded String \t\t: "+ dec_sig)
        val rec_msg = gettxt(dec_sig.toString)
        println("Retrieved Signal \t: "+rec_msg)
    }
}
