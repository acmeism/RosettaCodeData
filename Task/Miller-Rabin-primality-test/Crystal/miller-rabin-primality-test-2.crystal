# For crystal >= 0.31.x, compile without overflow check, as either
# crystal build miller-rabin.cr -Ddisable_overflow --release
# crystal build -Ddisable_overflow miller-rabin.cr --release

require "big"

module Primes
  module MillerRabin

    # Returns true if +self+ is a prime number, else returns false.
    def primemr?(k = 10)
      primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47}
      return primes.includes? self if self <= primes.last
      modp47 = 614_889_782_588_491_410.to_big_i      # => primes.product, largest < 2^64
      return false if modp47.gcd(self.to_big_i) != 1 # eliminates 86.2% of all integers
      # Choose input witness bases: wits = [range, [wit_bases]] or nil
      wits = WITNESS_RANGES.find { |range, wits| range > self }
      witnesses = wits && wits[1] || k.times.map{ 2 + rand(self - 4) }
      miller_rabin_test(witnesses)
    end

    # Returns true if +self+ passes Miller-Rabin Test on witnesses +b+
    private def miller_rabin_test(witnesses) # list of witnesses for testing
      neg_one_mod = n = d = self - 1 # these are even as self is always odd
      d >>= d.trailing_zeros_count   # shift out factors of 2 to make d odd
      witnesses.each do |b|          # do M-R test with each witness base
        next if (b % self) == 0      # **skip base if a multiple of input**
        y = powmod(b, d, self)       # y = (b**d) mod self
        s = d
        until y == 1 || y == neg_one_mod || s == n
          y = (y * y) % self         # y = (y**2) mod self
          s <<= 1
        end
        return false unless y == neg_one_mod || s.odd?
      end
      true
    end

    # Best known deterministic witnesses for given range and set of bases
    # https://miller-rabin.appspot.com/
    # https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
    private WITNESS_RANGES = {
      341_531 => {9345883071009581737},
      1_050_535_501 => {336781006125, 9639812373923155},
      350_269_456_337 => {4230279247111683200, 14694767155120705706, 16641139526367750375},
      55_245_642_489_451 => {2, 141889084524735, 1199124725622454117, 11096072698276303650},
      7_999_252_175_582_851 => {2, 4130806001517, 149795463772692060, 186635894390467037,
                                3967304179347715805},
      585_226_005_592_931_977 => {2, 123635709730000, 9233062284813009, 43835965440333360,
                                  761179012939631437, 1263739024124850375},
      18_446_744_073_709_551_615 => {2, 325, 9375, 28178, 450775, 9780504, 1795265022},
      "318665857834031151167461".to_big_i  => {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37},
      "3317044064679887385961981".to_big_i => {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41}
    }

    # Compute b**e mod m
    private def powmod(b, e, m)
      r, b = 1, b.to_big_i
      while e > 0
        r = (b * r) % m if e.odd?
        b = (b * b) % m
        e >>= 1
      end
      r
    end
  end
end

struct Int; include Primes::MillerRabin end

def tm; t = Time.monotonic; yield; (Time.monotonic - t).total_seconds.round(6) end

# 10 digit prime
n = 2147483647
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 18 digit non-prime
n = 844674407370955389
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 19 digit prime
n = 9241386435364257883.to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 20 digit prime; largest < 2^64
n = 18446744073709551533.to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 58 digit prime
n = "4547337172376300111955330758342147474062293202868155909489".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 58 digit non-prime
n = "4547337172376300111955330758342147474062293202868155909393".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 81 digit prime
n = "100000000000000000000000000000000000000000000000000000000000000000000000001309503".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 81 digit non-prime
n = "100000000000000000000000000000000000000000000000000000000000000000000000001309509".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

# 308 digit prime
n = "94366396730334173383107353049414959521528815310548187030165936229578960209523421808912459795329035203510284576187160076386643700441216547732914250578934261891510827140267043592007225160798348913639472564715055445201512461359359488795427875530231001298552452230535485049737222714000227878890892901228389026881".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "138028649176899647846076023812164793645371887571371559091892986639999096471811910222267538577825033963552683101137782650479906670021895135954212738694784814783986671046107023185842481502719762055887490765764329237651328922972514308635045190654896041748716218441926626988737664133219271115413563418353821396401".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "123301261697053560451930527879636974557474268923771832437126939266601921428796348203611050423256894847735769138870460373141723679005090549101566289920247264982095246187318303659027201708559916949810035265951104246512008259674244307851578647894027803356820480862664695522389066327012330793517771435385653616841".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "119432521682023078841121052226157857003721669633106050345198988740042219728400958282159638484144822421840470442893056822510584029066504295892189315912923804894933736660559950053226576719285711831138657839435060908151231090715952576998400120335346005544083959311246562842277496260598128781581003807229557518839".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "132082885240291678440073580124226578272473600569147812319294626601995619845059779715619475871419551319029519794232989255381829366374647864619189704922722431776563860747714706040922215308646535910589305924065089149684429555813953571007126408164577035854428632242206880193165045777949624510896312005014225526731".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "153410708946188157980279532372610756837706984448408515364579602515073276538040155990230789600191915021209039203172105094957316552912585741177975853552299222501069267567888742458519569317286299134843250075228359900070009684517875782331709619287588451883575354340318132216817231993558066067063143257425853927599".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "103130593592068072608023213244858971741946977638988649427937324034014356815504971087381663169829571046157738503075005527471064224791270584831779395959349442093395294980019731027051356344056416276026592333932610954020105156667883269888206386119513058400355612571198438511950152690467372712488391425876725831041".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts

n = "94366396730334173383107353049414959521528815310548187030165936229578960209523421808912459795329035203510284576187160076386643700441216547732914250578934261891510827140267043592007225160798348913639472564715055445201512461359359488795427875530231001298552452230535485049737222714000227878890892901228389026881".to_big_i
print "\n number = #{n} is prime? "; print " in ", tm{ print n.primemr? }, " secs"
puts
