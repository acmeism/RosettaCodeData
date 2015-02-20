package src ;
import haxe.Int32;
import haxe.macro.Expr;
import haxe.ds.Vector;

typedef Ub4 = Int32;

enum Ciphermode {
	mEncipher;
	mDecipher;
	mNone;
}

class Isaac
{
	public var randrsl = new Vector<Ub4>(256);
	public var randcnt:Ub4;
	
	var mm = new Vector<Ub4>(256);
	var aa:Ub4 = 0;
	var bb:Ub4 = 0;
	var cc:Ub4 = 0;
	
	public function isaac():Void {
		var x, y;
		cc++;
		bb += cc;
		for (i in 0...256) {
			x = mm[i];
			aa ^= switch (i % 4) {//Haxe unification
				case 0: aa << 13;
				case 1: aa >>> 6;
				case 2: aa << 2;
				case 3: aa >>> 16;
				default: 0;//never happens
			}
			aa              = mm[(i + 128) % 256] + aa;
			mm[i]      = y  = mm[(x >>> 2) % 256] + aa + bb;
			randrsl[i] = bb = mm[(y >>> 10) % 256] + x;
		}
	}
	
	macro static function mix(a:ExprOf<Ub4>, b:ExprOf<Ub4>, c:ExprOf<Ub4>, d:ExprOf<Ub4>,
	                          e:ExprOf<Ub4>, f:ExprOf<Ub4>, g:ExprOf<Ub4>, h:ExprOf<Ub4>) {
		return macro {
			$a ^= $b << 11; $d += $a; $b += $c;
			$b ^= $c >>> 2; $e += $b; $c += $d;
			$c ^= $d << 8; $f += $c; $d += $e;
			$d ^= $e >>> 16; $g += $d; $e += $f;
			$e ^= $f << 10; $h += $e; $f += $g;
			$f ^= $g >>> 4; $a += $f; $g += $h;
			$g ^= $h << 8; $b += $g; $h += $a;
			$h ^= $a >>> 9; $c += $h; $a += $b;
		};
	}
	
	public function randinit(flag:Bool):Void {
		var a, b, c, d, e, f, g, h, i;
		aa = bb = cc = (0:Ub4);
		a = b = c = d = e = f = g = h = (0x9e3779b9:Ub4); /* the golden ratio */
		for (i in 0...4) mix(a, b, c, d, e, f, g, h); /* scramble it */
		i = 0;
		while (i < 256) { /* fill in mm[] with messy stuff */
			if (flag) { /* use all the information in the seed */
				a += randrsl[i]; b += randrsl[i + 1];
				c += randrsl[i + 2]; d += randrsl[i + 3];
				e += randrsl[i + 4]; f += randrsl[i + 5];
				g += randrsl[i + 6]; h += randrsl[i + 7];
			}
			mix(a, b, c, d, e, f, g, h);
			mm[i] = a; mm[i + 1] = b; mm[i + 2] = c; mm[i + 3] = d;
			mm[i + 4] = e; mm[i + 5] = f; mm[i + 6] = g; mm[i + 7] = h;
			i += 8;
		}
		if (flag) { /* do a second pass to make all of the seed affect all of mm */
			i = 0;
			while (i<256) {
				a += mm[i]; b += mm[i + 1]; c += mm[i + 2]; d += mm[i + 3];
				e += mm[i + 4]; f += mm[i + 5]; g += mm[i + 6]; h += mm[i + 7];
				mix(a, b, c, d, e, f, g, h);
				mm[i] = a; mm[i + 1] = b; mm[i + 2] = c; mm[i + 3] = d;
				mm[i + 4] = e; mm[i + 5] = f; mm[i + 6] = g; mm[i + 7] = h;
				i += 8;
			}
		}
		isaac();
		randcnt = 0;
	}
	
	public function iRandom():Ub4 {
		var r = randrsl[randcnt];
		++randcnt;
		if (randcnt > 255) {
			isaac();
			randcnt = 0;
		}
		return r;
	}
	
	public function iRandA():Int32 {
		return cast(cast(iRandom(),UInt) % 95 + 32,Int32);
	}
	
	public function iSeed(seed:String, flag:Bool):Void {
		var m=seed.length-1;
		for (i in 0...256) mm[i] = 0;
		for (i in 0...256) if (i > m) randrsl[i] = 0; else randrsl[i] = seed.charCodeAt(i);
		randinit(flag);
	}
	
	inline static var modC = 95;
	inline static var startC = 32;
	
	public function vernam (msg:String):String {
		var v="";
		for (i in 0...msg.length) v += String.fromCharCode(iRandA() ^ msg.charCodeAt(i));
		return v;
	}
	
	public function caesar(m:Ciphermode, ch:Int32, shift:Int32,
	                       modulo:Int32, start:Int32):String {
		var n:Int32;
		if (m == mDecipher) n = ch - start - cast(shift,Int32);
		else n = ch - start + cast(shift,Int32);
		n %= modulo;
		if (n < 0) n += modulo;
		return String.fromCharCode(start + cast(n,Ub4));
	}
	
	public function caesarStr(m:Ciphermode, msg:String, modulo:Int32, start:Int32):String {
		var c = "";
		for (i in 0...msg.length)
			c += caesar(m,msg.charCodeAt(i),iRandA(),modulo,start);
		return c;
	}
	
	static public function main():Void {
		var msg = "a Top Secret secret";
		var key = "this is my secret key";
		var cIsaac = new Isaac();
		var vctx, vptx, cctx, cptx;
		cIsaac.iSeed(key, true);
		vctx = cIsaac.vernam(msg);
		cctx = cIsaac.caesarStr(mEncipher, msg, modC, startC);
		
		cIsaac.iSeed(key, true);
		vptx = cIsaac.vernam(vctx);
		cptx = cIsaac.caesarStr(mDecipher, cctx, modC, startC);
		
		Sys.println("Message: " + msg);
		Sys.println("Key    : " + key);
		var hex = "";
		for (i in 0...vctx.length) hex += StringTools.hex(vctx.charCodeAt(i), 2);
		Sys.println("XOR    : " + hex);
		Sys.println("XOR dcr: " + vptx);
		hex = "";
		for (i in 0...cctx.length) hex += StringTools.hex(cctx.charCodeAt(i), 2);
		Sys.println("MOD    : " + hex);
		Sys.println("MOD dcr: " + cptx);
	}
}
