use Time; use BitOps; use CPtr;

type Prime = uint(64);
type PrimeNdx = int(64);
type BasePrime = uint(32);

config const LIMIT = 1000000000: Prime;

config const L1 = 16; // CPU L1 cache size in Kilobytes (1024);
assert (L1 == 16 || L1 == 32 || L1 == 64,
        "L1 cache size must be 16, 32, or 64 Kilobytes!");
config const L2 = 128; // CPU L2 cache size in Kilobytes (1024);
assert (L2 == 128 || L2 == 256 || L2 == 512,
        "L2 cache size must be 128, 256, or 512 Kilobytes!");
const CPUL1CACHE: int = L1 * 1024 * 8; // size in bits!
const CPUL2CACHE: int = L2 * 1024 * 8; // size in bits!
config const NUMTHRDS = here.maxTaskPar;
assert(NUMTHRDS >= 1, "NUMTHRDS must be at least one!");

const WHLPRMS = [ 2: Prime, 3: Prime, 5: Prime, 7: Prime,
                            11: Prime, 13: Prime, 17: Prime];
const FRSTSVPRM = 19: Prime; // past the pre-cull primes!
// 2 eliminated as even; 255255 in bytes...
const WHLPTRNSPN = 3 * 5 * 7 * 11 * 13 * 17;
// rounded up to next 64-bit boundary plus a 16 Kilobyte buffer for overflow...
const WHLPTRNBTSZ = ((WHLPTRNSPN * 8 + 63) & (-64)) + 131072;

// number of base primes within small span!
const SZBPSTRTS = 6542 - WHLPRMS.size + 1; // extra one for marker!
// number of base primes for CPU L1 cache buffer!
const SZMNSTRTS = (if L1 == 16 then 12251 else
                     if L1 == 32 then 23000 else 43390)
                       - WHLPRMS.size + 1; // extra one for marker!

// using this Look Up Table faster than bit twiddling...
const bitmsk = for i in 0 .. 7 do 1:uint(8) << i;

var WHLPTRN: SieveBuffer = new SieveBuffer(WHLPTRNBTSZ); fillWHLPTRN(WHLPTRN);
proc fillWHLPTRN(ref wp: SieveBuffer) {
  const hi = WHLPRMS.size - 1;
  const rng = 0 .. hi; var whlhd = new shared BasePrimeArr({rng});
  // contains wheel pattern primes skipping the small wheel prime (2)!...
  // never advances past the first base prime arr as it ends with a huge!...
  for i in rng do whlhd.bparr[i] = (if i != hi then WHLPRMS[i + 1] // skip 2!
                                    else 0x7FFFFFFF): BasePrime; // last huge!
  var whlbpas = new shared BasePrimeArrs(whlhd);
  var whlstrts = new StrtsArr({rng});
  wp.cull(0, WHLPTRNBTSZ, whlbpas, whlstrts);
  // eliminate wheel primes from the WHLPTRN buffer!...
  wp.cmpsts[0] = 0xFF: uint(8);
}

// the following two must be classes for compability with sync...
class PrimeArr { var dom = { 0 .. -1 }; var prmarr: [dom] Prime; }
class BasePrimeArr { var dom = { 0 .. -1 }; var bparr: [dom] BasePrime; }
record StrtsArr { var dom = { 0 .. -1 }; var strtsarr: [dom] int(32); }
record SieveBuffer {
  var dom = { 0 .. -1 }; var cmpsts: [dom] uint(8) = 0;
  proc init() {}
  proc init(btsz: int) { dom = { 0 .. btsz / 8 - 1 }; }
  proc deinit() { dom = { 0 .. -1 }; }

  proc fill(lwi: PrimeNdx) { // fill from the WHLPTRN stamp...
    const sz = cmpsts.size; const mvsz = min(sz, 16384);
    var mdlo = ((lwi / 8) % (WHLPTRNSPN: PrimeNdx)): int;
    for i in 0 .. sz - 1 by 16384 {
      c_memcpy(c_ptrTo(cmpsts[i]): c_void_ptr,
               c_ptrTo(WHLPTRN.cmpsts[mdlo]): c_void_ptr, mvsz);
      mdlo += 16384; if mdlo >= WHLPTRNSPN then mdlo -= WHLPTRNSPN;
    }
  }

  proc count(btlmt: int) { // count by 64 bits using CPU popcount...
    const lstwrd = btlmt / 64; const lstmsk = (-2):uint(64) << (btlmt & 63);
    const cmpstsp = c_ptrTo(cmpsts: [dom] uint(8)): c_ptr(uint(64));
    var i = 0; var cnt = (lstwrd * 64 + 64): int;
    while i < lstwrd { cnt -= popcount(cmpstsp[i]): int; i += 1; }
    return cnt - popcount(cmpstsp[lstwrd] | lstmsk): int;
  }

  // most of the time is spent doing culling operations as follows!...
  proc cull(lwi: PrimeNdx, bsbtsz: int, bpas: BasePrimeArrs,
                                        ref strts: StrtsArr) {
    const btlmt = cmpsts.size * 8 - 1; const bplmt = bsbtsz / 32;
    const ndxlmt = lwi: Prime + btlmt: Prime; // can't overflow!
    const strtssz = strts.strtsarr.size;
    // C pointer for speed magic!...
    const cmpstsp = c_ptrTo(cmpsts[0]);
    const strtsp = c_ptrTo(strts.strtsarr);

    // first fill the strts array with pre-calculated start addresses...
    var i = 0; for bp in bpas {
      // calculate page start address for the given base prime...
      const bpi = bp: int; const bbp = bp: Prime; const ndx0 = (bbp - 3) / 2;
      const s0 = (ndx0 + ndx0) * (ndx0 + 3) + 3; // can't overflow!
      if s0 > ndxlmt then {
        if i < strtssz then strtsp[i] = -1: int(32); break; }
      var s = 0: int;
      if s0 >= lwi: Prime then s = (s0 - lwi: Prime): int;
      else { const r = (lwi: Prime - s0) % bbp;
            if r == 0 then s = 0: int; else s = (bbp - r): int; };
      if i < strtssz - 1 { strtsp[i] = s: int(32); i += 1; continue; }
      if i < strtssz { strtsp[i] = -1; i = strtssz; }
      // cull the full buffer for this given base prime as usual...
      // only works up to limit of int(32)**2!!!!!!!!
      while s <= btlmt { cmpstsp[s >> 3] |= bitmsk[s & 7]; s += bpi; }
    }

    // cull the smaller sub buffers according to the strts array...
    for sbtlmt in bsbtsz - 1 .. btlmt by bsbtsz {
      i = 0; for bp in bpas { // bp never bigger than uint(32)!
        // cull the sub buffer for this given base prime...
        var s = strtsp[i]: int; if s < 0 then break;
        var bpi = bp: int; var nxt = 0x7FFFFFFFFFFFFFFF;
        if bpi <= bplmt { // use loop "unpeeling" for a small improvement...
          const slmt = s + bpi * 8 - 1;
          while s <= slmt {
            const bmi = s & 7; const msk = bitmsk[bmi];
            var c = s >> 3; const clmt = sbtlmt >> 3;
            while c <= clmt { cmpstsp[c] |= msk; c += bpi; }
            nxt = min(nxt, (c << 3): int(64) | bmi: int(64)); s += bpi;
          }
          strtsp[i] = nxt: int(32); i += 1;
        }
        else { while s <= sbtlmt { // standard cull loop...
                 cmpstsp[s >> 3] |= bitmsk[s & 7]; s += bpi; }
               strtsp[i] = s: int(32); i += 1; }
      }
    }
  }
}

// a generic record that contains a page result generating function;
// allows manual iteration through the use of the next() method;
// multi-threaded through the use of a thread pool...
class PagedResults {
  const cnvrtrclsr; // output converter closure emulator, (lwi, sba) => output
  var lwi: PrimeNdx; var bsbtsz: int;
  var bpas: shared BasePrimeArrs? = nil: shared BasePrimeArrs?;
  var sbs: [ 0 .. NUMTHRDS - 1 ] SieveBuffer = new SieveBuffer();
  var strts: [ 0 .. NUMTHRDS - 1 ] StrtsArr = new StrtsArr();
  var qi: int = 0;
  var wrkq$: [ 0 .. NUMTHRDS - 1 ] sync PrimeNdx;
  var rsltsq$: [ 0 .. NUMTHRDS - 1 ] sync cnvrtrclsr(lwi, sbs(0)).type;

  proc init(cvclsr, li: PrimeNdx, bsz: int) {
    cnvrtrclsr = cvclsr; lwi = li; bsbtsz = bsz; }

  proc deinit() { // kill the thread pool when out of scope...
    if bpas == nil then return; // no thread pool!
    for i in wrkq$.domain {
      wrkq$[i].writeEF(-1); while true { const r = rsltsq$[i].readFE();
        if r == nil then break; }
    }
  }

  proc next(): cnvrtrclsr(lwi, sbs(0)).type {
    proc dowrk(ri: int) { // used internally!...
      while true {
        const li = wrkq$[ri].readFE(); // following to kill thread!
        if li < 0 { rsltsq$[ri].writeEF(nil: cnvrtrclsr(li, sbs(ri)).type); break; }
        sbs[ri].fill(li);
        sbs[ri].cull(li, bsbtsz, bpas!, strts[ri]);
        rsltsq$[ri].writeEF(cnvrtrclsr(li, sbs[ri]));
      }
    }
    if this.bpas == nil { // init on first use; avoids data race!
      this.bpas = new BasePrimeArrs();
      if this.bsbtsz < CPUL1CACHE {
        this.sbs = new SieveBuffer(bsbtsz);
        this.strts = new StrtsArr({0 .. SZBPSTRTS - 1});
      }
      else {
        this.sbs = new SieveBuffer(CPUL2CACHE);
        this.strts = new StrtsArr({0 .. SZMNSTRTS - 1});
      }
      // start threadpool and give it inital work...
      for i in rsltsq$.domain {
        begin with (const in i) dowrk(i);
        this.wrkq$[i].writeEF(this.lwi); this.lwi += this.sbs[i].cmpsts.size * 8;
      }
    }
    const rslt = this.rsltsq$[qi].readFE();
    this.wrkq$[qi].writeEF(this.lwi);
    this.lwi += this.sbs[qi].cmpsts.size * 8;
    this.qi = if qi >= NUMTHRDS - 1 then 0 else qi + 1;
    return rslt;
  }

  iter these() { while lwi >= 0 do yield next(); }
}

// the sieve buffer to base prime array converter closure...
record SB2BPArr {
  proc this(lwi: PrimeNdx, sb: SieveBuffer): shared BasePrimeArr? {
    const bsprm = (lwi + lwi + 3): BasePrime;
    const szlmt = sb.cmpsts.size * 8 - 1; var i, j = 0;
    var arr = new shared BasePrimeArr({ 0 .. sb.count(szlmt) - 1 });
    while i <= szlmt { if sb.cmpsts[i >> 3] & bitmsk[i & 7] == 0 {
                        arr.bparr[j] = bsprm + (i + i): BasePrime; j += 1; }
                      i += 1; }
    return arr;
  }
}

// a memoizing lazy list of BasePrimeArr's...
class BasePrimeArrs {
  var head: shared BasePrimeArr;
  var tail: shared BasePrimeArrs? = nil: shared BasePrimeArrs?;
  var lock$: sync bool = true;
  var feed: shared PagedResults(SB2BPArr) =
    new shared PagedResults(new SB2BPArr(), 65536, 65536);

  proc init() { // make our own first array to break data race!
    var sb = new SieveBuffer(256); sb.fill(0);
    const sb2 = new SB2BPArr();
    head = sb2(0, sb): shared BasePrimeArr;
    this.complete(); // fake base primes!
    sb = new SieveBuffer(65536); sb.fill(0);
    // use (completed) self as source of base primes!
    var strts = new StrtsArr({ 0 .. 256 });
    sb.cull(0, 65536, this, strts);
    // replace head with new larger version culled using fake base primes!...
    head = sb2(0, sb): shared BasePrimeArr;
  }

  // for initializing for use by the fillWHLPTRN proc...
  proc init(hd: shared BasePrimeArr) {
    head = hd; feed = new shared PagedResults(new SB2BPArr(), 0, 0);
  }

  // for initializing lazily extended list as required...
  proc init(hd: shared BasePrimeArr, fd: PagedResults) { head = hd; feed = fd; }

  proc next(): shared BasePrimeArrs {
    if this.tail == nil { // in case other thread slipped through!
      if this.lock$.readFE() && this.tail == nil { // empty sync -> block others!
        const nhd = this.feed.next(): shared BasePrimeArr;
        this.tail = new shared BasePrimeArrs(nhd , this.feed);
      }
      this.lock$.writeEF(false); // fill the sync so other threads can do nothing!
    }
    return this.tail: shared BasePrimeArrs; // necessary cast!
  }

  iter these(): BasePrime {
    for bp in head.bparr do yield bp; var cur = next();
    while true {
      for bp in cur.head.bparr do yield bp; cur = cur.next(); }
  }
}

record SB2PrmArr {
  proc this(lwi: PrimeNdx, sb: SieveBuffer): shared PrimeArr? {
    const bsprm = (lwi + lwi + 3): Prime;
    const szlmt = sb.cmpsts.size * 8 - 1; var i, j = 0;
    var arr = new shared PrimeArr({0 .. sb.count(szlmt) - 1});
    while i <= szlmt { if sb.cmpsts[i >> 3] & bitmsk[i & 7] == 0 then {
                        arr.prmarr[j] = bsprm + (i + i): Prime; j += 1; }
                      i += 1; }
    return arr;
  }
}

iter primes(): Prime {
  for p in WHLPRMS do yield p: Prime;
  for pa in new shared PagedResults(new SB2PrmArr(), 0, CPUL1CACHE) do
    for p in pa!.prmarr do yield p;
}

// use a class so that it can be used as a generic sync value!...
class CntNxt { const cnt: int; const nxt: PrimeNdx; }

// a class that emulates a closure and a return value...
record SB2Cnt {
  const nxtlmt: PrimeNdx;
  proc this(lwi: PrimeNdx, sb: SieveBuffer): shared CntNxt? {
    const btszlmt = sb.cmpsts.size * 8 - 1; const lstndx = lwi + btszlmt: PrimeNdx;
    const btlmt = if lstndx > nxtlmt then max(0, (nxtlmt - lwi): int) else btszlmt;
    return new shared CntNxt(sb.count(btlmt), lstndx);
  }
}

// couut primes to limit, just like it says...
proc countPrimesTo(lmt: Prime): int(64) {
  const nxtlmt = ((lmt - 3) / 2): PrimeNdx; var count = 0: int(64);
  for p in WHLPRMS { if p > lmt then break; count += 1; }
  if lmt < FRSTSVPRM then return count;
  for cn in new shared PagedResults(new SB2Cnt(nxtlmt), 0, CPUL1CACHE) {
    count += cn!.cnt: int(64); if cn!.nxt >= nxtlmt then break;
  }
  return count;
}

// test it...
write("The first 25 primes are: "); var cnt = 0;
for p in primes() { if cnt >= 25 then break; cnt += 1; write(" ", p); }

cnt = 0; for p in primes() { if p > 1000000 then break; cnt += 1; }
writeln("\nThere are ", cnt, " primes up to a million.");

write("Sieving to ", LIMIT, " with ");
write("CPU L1/L2 cache sizes of ", L1, "/", L2, " KiloBytes ");
writeln("using ", NUMTHRDS, " threads.");

var timer: Timer; timer.start();
// the slow way!:
// var count = 0; for p in primes() { if p > LIMIT then break; count += 1; }
const count = countPrimesTo(LIMIT); // the fast way!
timer.stop();

write("Found ", count, " primes up to ", LIMIT);
writeln(" in ", timer.elapsed(TimeUnits.milliseconds), " milliseconds.");
