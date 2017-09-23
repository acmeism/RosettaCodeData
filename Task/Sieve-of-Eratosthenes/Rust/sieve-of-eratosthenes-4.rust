use std::iter::{empty, once};
use std::rc::Rc;
use std::cell::RefCell;
use std::time::Instant;

const RANGE: u64 = 1000000000;
const SZ_PAGE_BTS: u64 = (1 << 14) * 8; // this should be the size of the CPU L1 cache
const SZ_BASE_BTS: u64 = (1 << 7) * 8;
static CLUT: [u8; 256] = [
	8, 7, 7, 6, 7, 6, 6, 5, 7, 6, 6, 5, 6, 5, 5, 4, 7, 6, 6, 5, 6, 5, 5, 4, 6, 5, 5, 4, 5, 4, 4, 3,
	7, 6, 6, 5, 6, 5, 5, 4, 6, 5, 5, 4, 5, 4, 4, 3, 6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2,
	7, 6, 6, 5, 6, 5, 5, 4, 6, 5, 5, 4, 5, 4, 4, 3, 6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2,
	6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2, 5, 4, 4, 3, 4, 3, 3, 2, 4, 3, 3, 2, 3, 2, 2, 1,
	7, 6, 6, 5, 6, 5, 5, 4, 6, 5, 5, 4, 5, 4, 4, 3, 6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2,
	6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2, 5, 4, 4, 3, 4, 3, 3, 2, 4, 3, 3, 2, 3, 2, 2, 1,
	6, 5, 5, 4, 5, 4, 4, 3, 5, 4, 4, 3, 4, 3, 3, 2, 5, 4, 4, 3, 4, 3, 3, 2, 4, 3, 3, 2, 3, 2, 2, 1,
	5, 4, 4, 3, 4, 3, 3, 2, 4, 3, 3, 2, 3, 2, 2, 1, 4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0 ];

fn count_page(lmti: usize, pg: &[u32]) -> i64 {
	let pgsz = pg.len(); let pgbts = pgsz * 32;
	let (lmt, icnt) = if lmti >= pgbts { (pgsz, 0) } else {
		let lstw = lmti / 32;
		let msk = 0xFFFFFFFEu32 << (lmti & 31);
		let v = (msk | pg[lstw]) as usize;
		(lstw, (CLUT[v & 0xFF] + CLUT[(v >> 8) & 0xFF]
			+ CLUT[(v >> 16) & 0xFF] + CLUT[v >> 24]) as u32)
	};
	let mut count = 0u32;
	for i in 0 .. lmt {
		let v = pg[i] as usize;
		count += (CLUT[v & 0xFF] + CLUT[(v >> 8) & 0xFF]
					+ CLUT[(v >> 16) & 0xFF] + CLUT[v >> 24]) as u32;
	}
	(icnt + count) as i64
}

fn primes_pages() -> Box<Iterator<Item = (u64, Vec<u32>)>> {
	// a memoized iterable enclosing a Vec that grows as needed from an Iterator...
	type Bpasi = Box<Iterator<Item = (u64, Vec<u32>)>>; // (lwi, base cmpsts page)
	type Bpas = Rc<(RefCell<Bpasi>, RefCell<Vec<Vec<u32>>>)>; // interior mutables
	struct Bps(Bpas); // iterable wrapper for base primes array state
	struct Bpsi<'a>(usize, &'a Bpas); // iterator with current pos, state ref's
	impl<'a> Iterator for Bpsi<'a> {
		type Item = &'a Vec<u32>;
		fn next(&mut self) -> Option<Self::Item> {
			let n = self.0; let bpas = self.1;
			while n >= bpas.1.borrow().len() { // not thread safe
				let nbpg = match bpas.0.borrow_mut().next() {
								Some(v) => v, _ => (0, vec!()) };
				if nbpg.1.is_empty() { return None } // end if no source iter
				bpas.1.borrow_mut().push(cnvrt2bppg(nbpg));
			}
			self.0 += 1; // unsafe pointer extends interior -> exterior lifetime
			// multi-threading might drop following Vec while reading - protect
			let ptr = &bpas.1.borrow()[n] as *const Vec<u32>;
			unsafe { Some(&(*ptr)) }
		}
	}
	impl<'a> IntoIterator for &'a Bps {
		type Item = &'a Vec<u32>;
		type IntoIter = Bpsi<'a>;
		fn into_iter(self) -> Self::IntoIter {
			Bpsi(0, &self.0)
		}
	}
	fn make_page(lwi: u64, szbts: u64, bppgs: &Bpas)
			-> (u64, Vec<u32>) {
		let nxti = lwi + szbts;
		let pbts = szbts as usize;
		let mut cmpsts = vec!(0u32; pbts / 32);
		'outer: for bpg in Bps(bppgs.clone()).into_iter() { // in the inner tight loop...
			let pgsz = bpg.len();
			for i in 0 .. pgsz {
				let p = bpg[i] as u64; let pc = p as usize;
				let s = (p * p - 3) / 2;
				if s >= nxti { break 'outer; } else { // page start address:
					let mut cp = if s >= lwi { (s - lwi) as usize } else {
						let r = ((lwi - s) % p) as usize;
						if r == 0 { 0 } else { pc - r }
					};
					while cp < pbts {
						unsafe { // avoids array bounds check, which is already done above
							let cptr = cmpsts.get_unchecked_mut(cp >> 5);
							*cptr |= 1u32 << (cp & 31); // about as fast as it gets...
						}
//						cmpsts[cp >> 5] |= 1u32 << (cp & 31);
						cp += pc;
					}
				}
			}
		}
		(lwi, cmpsts)
	}
	fn pages_from(lwi: u64, szbts: u64, bpas: Bpas)
			-> Box<Iterator<Item = (u64, Vec<u32>)>> {
		struct Gen(u64,  u64);
		impl Iterator for Gen {
			type Item = (u64, u64);
			#[inline]
			fn next(&mut self) -> Option<(u64, u64)> {
				let v = self.0; let inc = self.1; // calculate variable size here
				self.0 = v + inc;
				Some((v, inc))
			}
		}
		Box::new(Gen(lwi, szbts)
					.map(move |(lwi, szbts)| make_page(lwi, szbts, &bpas)))
	}
	fn cnvrt2bppg(cmpsts: (u64, Vec<u32>)) -> Vec<u32> {
		let (lwi, pg) = cmpsts;
		let pgbts = pg.len() * 32;
		let cnt = count_page(pgbts, &pg) as usize;
		let mut bpv = vec!(0u32; cnt);
		let mut j = 0; let bsp = (lwi + lwi + 3) as usize;
		for i in 0 .. pgbts {
			if (pg[i >> 5] & (1u32 << (i & 0x1F))) == 0u32 {
				bpv[j] = (bsp + i + i) as u32; j += 1;
			}
		}
		bpv
	}
	// recursive Rc/RefCell variable bpas - used only for init, then fixed ...
	// start with just enough base primes to init the first base primes page...
	let base_base_prms = vec!(3u32,5u32,7u32);
	let rcvv = RefCell::new(vec!(base_base_prms));
	let bpas: Bpas = Rc::new((RefCell::new(Box::new(empty())), rcvv));
	let initpg = make_page(0, 32, &bpas); // small base primes page for SZ_BASE_BTS = 2^7 * 8
	*bpas.1.borrow_mut() = vec!(cnvrt2bppg(initpg)); // use for first page
	let frstpg = make_page(0, SZ_BASE_BTS, &bpas); // init bpas for first base prime page
	*bpas.0.borrow_mut() = pages_from(SZ_BASE_BTS, SZ_BASE_BTS, bpas.clone()); // recurse bpas
	*bpas.1.borrow_mut() = vec!(cnvrt2bppg(frstpg)); // fixed for subsequent pages
	pages_from(0, SZ_PAGE_BTS, bpas) // and bpas also used here for main pages
}

fn primes_paged() -> Box<Iterator<Item = u64>> {
	fn list_paged_primes(cmpstpgs: Box<Iterator<Item = (u64, Vec<u32>)>>)
			-> Box<Iterator<Item = u64>> {
		Box::new(cmpstpgs.flat_map(move |(lwi, cmpsts)| {
			let pgbts = (cmpsts.len() * 32) as usize;
			(0..pgbts).filter_map(move |i| {
				if cmpsts[i >> 5] & (1u32 << (i & 31)) == 0 {
					Some((lwi + i as u64) * 2 + 3) } else { None } }) }))
	}
	Box::new(once(2u64).chain(list_paged_primes(primes_pages())))
}

fn count_primes_paged(top: u64) -> i64 {
	if top < 3 { if top < 2 { return 0i64 } else { return 1i64 } }
	let topi = (top - 3u64) / 2;
	primes_pages().take_while(|&(lwi, _)| lwi <= topi)
		.map(|(lwi, pg)| { count_page((topi - lwi) as usize, &pg) })
		.sum::<i64>() + 1
}

fn main() {
	let n = 262146;
	let vrslt = primes_paged()
			.take_while(|&p| p <= 100)
			.collect::<Vec<_>>();
	println!("{:?}", vrslt);

	let strt = Instant::now();

//	let count = primes_paged().take_while(|&p| p <= RANGE).count(); // slow way to count
	let count = count_primes_paged(RANGE); // fast way to count

	let elpsd = strt.elapsed();

	println!("{}", count);

	let secs = elpsd.as_secs();
	let millis = (elpsd.subsec_nanos() / 1000000) as u64;
	let dur = secs * 1000 + millis;
	println!("Culling composites took {} milliseconds.", dur);
}
