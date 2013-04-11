import std.stdio ;
import std.perf ;
private import std.md5 ;
private import zmd5 ;
private import md5asm ;

void main() {
	writefln("digest(\"\")  = %s", std.md5.getDigestString("")) ;
	writefln("digest(\"\")  = %s", zmd5.getDigestString("")) ;

	const MBytes = 512 ;
	float[] MSG = new float[](MBytes * 0x40000 + 13) ;
	auto pf = new PerformanceCounter ;

	writefln("\nTest performance / message size %dMBytes", MBytes) ;
	pf.start() ; writefln("digest(MSG) = %s", std.md5.getDigestString(MSG)) ;
        pf.stop() ; auto time = pf.milliseconds/1000.0 ;
	writefln("std.md5 : %8.2f M/sec  ( %8.2fsecs)", MBytes/time, time) ;

	pf.start() ; writefln("digest(MSG) = %s", zmd5.getDigestString(MSG)) ;
	pf.stop() ; time = pf.milliseconds/1000.0 ;
	writefln("zmd5    : %8.2f M/sec  ( %8.2fsecs)", MBytes/time, time) ;	
}
