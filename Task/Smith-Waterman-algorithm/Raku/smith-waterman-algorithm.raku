# 20251101 Raku programming solution

my @AMINO = <A R N D C Q E G H I L K M F P S T W Y V>;
my @INDEX = ^20;
my %A2I   = [ |@AMINO, |@AMINO>>.lc ] Z=> |@INDEX xx 2 ;

my @BLOSUM62 = [
   <  4 -1 -2 -2  0 -1 -1  0 -2 -1 -1 -1 -1 -2 -1  1  0 -3 -2  0 >,
   < -1  5  0 -2 -3  1  0 -2  0 -3 -2  2 -1 -3 -2 -1 -1 -3 -2 -3 >,
   < -2  0  6  1 -3  0  0  0  1 -3 -3  0 -2 -3 -2  1  0 -4 -2 -3 >,
   < -2 -2  1  6 -3  0  2 -1 -1 -3 -4 -1 -3 -3 -1  0 -1 -4 -3 -3 >,
   <  0 -3 -3 -3  9 -3 -4 -3 -3 -1 -1 -3 -1 -2 -3 -1 -1 -2 -2 -1 >,
   < -1  1  0  0 -3  5  2 -2  0 -3 -2  1  0 -3 -1  0 -1 -2 -1 -2 >,
   < -1  0  0  2 -4  2  5 -2  0 -3 -3  1 -2 -3 -1  0 -1 -3 -2 -2 >,
   <  0 -2  0 -1 -3 -2 -2  6 -2 -4 -4 -2 -3 -3 -2  0 -2 -2 -3 -3 >,
   < -2  0  1 -1 -3  0  0 -2  8 -3 -3 -1 -2 -1 -2 -1 -2 -2  2 -3 >,
   < -1 -3 -3 -3 -1 -3 -3 -4 -3  4  2 -3  1  0 -3 -2 -1 -3 -1  3 >,
   < -1 -2 -3 -4 -1 -2 -3 -4 -3  2  4 -2  2  0 -3 -2 -1 -2 -1  1 >,
   < -1  2  0 -1 -3  1  1 -2 -1 -3 -2  5 -1 -3 -1  0 -1 -3 -2 -2 >,
   < -1 -1 -2 -3 -1  0 -2 -3 -2  1  2 -1  5  0 -2 -1 -1 -1 -1  1 >,
   < -2 -3 -3 -3 -2 -3 -3 -3 -1  0  0 -3  0  6 -4 -2 -2  1  3 -1 >,
   < -1 -2 -2 -1 -3 -1 -1 -2 -2 -3 -3 -1 -2 -4  7 -1 -1 -4 -3 -2 >,
   <  1 -1  1  0 -1  0  0  0 -1 -2 -2  0 -1 -2 -1  4  1 -3 -2 -2 >,
   <  0 -1  0 -1 -1 -1 -1 -2 -2 -1 -1 -1 -1 -2 -1  1  5 -2 -2  0 >,
   < -3 -3 -4 -4 -2 -2 -3 -2 -2 -3 -2 -3 -1  1 -4 -3 -2 11  2 -3 >,
   < -2 -2 -2 -3 -2 -1 -2 -3  2 -1 -1 -2 -1  3 -3 -2 -2  2  7 -1 >,
   <  0 -3 -3 -3 -1 -2 -2 -3 -3  3  1 -2  1 -1 -2 -2  0 -3 -1  4 >,
];

constant $GAP_COST = -4;

class SmithWaterman {
   has Str ( $.s1id, $.s2id, $.s1, $.s2 );
   has Int ( $.n, $!s1-elems, $!s2-elems, $!maxVal, $!maxI, $!maxJ );
   has     ( @!score, @!s1-comb, @!s2-comb );

   method new(Str $s1id, Str $s2id, Str $s1, Str $s2, Int $n) {
      self.bless(:$s1id, :$s2id, :$s1, :$s2, :$n);
   }

   submethod BUILD(:$!s1id, :$!s2id, :$!s1, :$!s2, :$!n) {
      ( $!s1-elems, $!s2-elems ) = ($!s1, $!s2)>>.chars;
      @!s1-comb = $!s1.comb;
      @!s2-comb = $!s2.comb;
      @!score = [0 xx ($!s2-elems + 1)] xx $!s1-elems + 1;

      for 1 .. $!s1-elems X 1 .. $!s2-elems -> (\i,\j) {
         @!score[i;j] = max
            @!score[i-1;j-1]+@BLOSUM62[%A2I{@!s1-comb[i-1]};%A2I{@!s2-comb[j-1]}],
            @!score[i-1;  j]+$GAP_COST,
            @!score[i  ;j-1]+$GAP_COST,
            0
      }
      ($!maxVal, $!maxI, $!maxJ) = 0 xx *;
      for 1 ..^ $!s1-elems X 1 ..^ $!s2-elems -> (\i,\j) {
         ($!maxVal, $!maxI, $!maxJ) = @!score[i;j], i, j if @!score[i;j] > $!maxVal
      }
   }

   method score { $!maxVal }

   method pval {
      my $better = 0;
      for ^$!n {
         my $sm = SmithWaterman.new("", "", $!s1, @!s2-comb.pick(*).join, 0);
         if $sm.score >= self.score { $better++ }
      }
      return ($better + 1) / ($!n + 1)
   }

   method printAlignment {
      my $i = $!maxI;
      my $j = $!maxJ;
      my $s1print = @!s1-comb[$i];
      my $s2print = @!s2-comb[$j];

      my $compare = do
         if    @!s1-comb[$i] eq @!s2-comb[$j]               { @!s1-comb[$i] }
         elsif @BLOSUM62[%A2I{@!s1-comb[$i]};%A2I{@!s2-comb[$j]}] > 0 { "+" }
         else                                                         { " " }

     while @!score[$i][$j] > 0 {
         ($s1print, $s2print, $compare) = do
            if @!score[$i][$j] - $GAP_COST == @!score[$i - 1][$j] {
               @!s1-comb[--$i], "-", " "
            } elsif @!score[$i][$j] - $GAP_COST == @!score[$i][$j - 1] {
               "-", @!s2-comb[--$j], " "
            } else {
               @!s1-comb[--$i], @!s2-comb[--$j], do
                  if    @!s1-comb[$i] eq @!s2-comb[$j]               { @!s1-comb[$i] }
                  elsif @BLOSUM62[%A2I{@!s1-comb[$i]};%A2I{@!s2-comb[$j]}] > 0 { "+" }
                  else                                                         { " " }
            } Z~ $s1print, $s2print, $compare
      }

      say "COMPARISON OF $!s1id AND $!s2id\n";
      say "Score: $!maxVal\n";
      say "Alignment:";
      my ($a, $b, $c) = "$!s1id:\t$i\t", "\t\t\t", "$!s2id:\t$j\t";
      for ^$s1print.chars -> $k {
         if $k != 0 and $k %% 60 {
            say "$a\n$b\n$c\n\n";
            ($a, $b, $c) = "$!s1id:\t$i\t", "\t\t\t", "$!s2id:\t$j\t";
         }
         ($a, $b, $c) Z~= ($s1print, $compare, $s2print)>>.substr($k, 1);
         if $s1print.substr($k, 1) ne "-" { $i++ }
         if $s2print.substr($k, 1) ne "-" { $j++ }
      }
      say "$a\n$b\n$c\n\nScore Matrix:\n";
      if ($!s1, $!s2)>>.chars.all < 15 { .say for @!score }
      if $!n > 0 { say "\np-value: {self.pval}" }
   }
}

my %ACC_TO_SEQ = (
    "O95363" => "MVGSALRRGAHAYVYLVSKASHISRGHQHQAWGSRPPAAECATQRAPGSVVELLGKSYPQ" ~
                "DDHSNLTRKVLTRVGRNLHNQQHHPLWLIKERVKEHFYKQYVGRFGTPLFSVYDNLSPVV" ~
                "TTWQNFDSLLIPADHPSRKKGDNYYLNRTHMLRAHTSAHQWDLLHAGLDAFLVVGDVYRR" ~
                "DQIDSQHYPIFHQLEAVRLFSKHELFAGIKDGESLQLFEQSSRSAHKQETHTMEAVKLVE" ~
                "FDLKQTLTRLMAHLFGDELEIRWVDCYFPFTHPSFEMEINFHGEWLEVLGCGVMEQQLVN" ~
                "SAGAQDRIGWAFGLGLERLAMILYDIPDIRLFWCEDERFLKQFCVSNINQKVKFQPLSKY" ~
                "PAVINDISFWLPSENYAENDFYDLVRTIGGDLVEKVDLIDKFVHPKTHKTSHCYRITYRH" ~
                "MERTLSQREVRHIHQALQEAAVQLLGVEGRF",
    "Q10574" => "MSWEQYQMYVPQCHPSFMYQGSIQSTMTTPLQSPNFSLDSPNYPDSLSNGGGKDDKKKCR" ~
                "RYKTPSPQLLRMRRSAANERERRRMNTLNVAYDELREVLPEIDSGKKLSKFETLQMAQKY" ~
                "IECLSQILKQDSKNENLKSKSG",
    "P22816" => "MTKYNSGSSEMPAAQTIKQEYHNGYGQPTHPGYGFSAYSQQNPIAHPGQNPHQTLQNFFS" ~
                "RFNAVGDASAGNGGAASISANGSGSSCNYSHANHHPAELDKPLGMNMTPSPIYTTDYDDE" ~
                "NSSLSSEEHVLAPLVCSSAQSSRPCLTWACKACKKKSVTVDRRKAATMRERRRLRKVNEA" ~
                "FEILKRRTSSNPNQRLPKVEILRNAIEYIESLEDLLQESSTTRDGDNLAPSLSGKSCQSD" ~
                "YLSSYAGAYLEDKLSFYNKHMEKYGQFTDFDGNANGSSLDCLNLIVQSINKSTTSPIQNK" ~
                "ATPSASDTQSPPSSGATAPTSLHVNFKRKCST",
    "Q8IU24" => "MEFVELSSCRFDATPTFCDRPAAPNATVLPGEHFPVPNGSYEDQGDGHVLAPGPSFHGPG" ~
                "RCLLWACKACKKKTVPIDRRKAATMRERRRLVKVNEAFDILKKKSCANPNQRLPKVEILR" ~
                "NAISYIEQLHKLLRDSKENSSGEVSDTSAPSPGSCSDGMAAHSPHSFCTDTSGNSSWEQG" ~
                "DGQPGNGYENQSCGNTVSSLDCLSLIVQSISTIEGEENNNASNTPR",
    "Q90477" => "MELSDIPFPIPSADDFYDDPCFNTNDMHFFEDLDPRLVHVSLLKPDEHHHIEDEHVRAPS" ~
                "GHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNDAFETLKRCTSTNPNQRLP" ~
                "KVEILRNAISYIESLQALLRSQEDNYYPVLEHYSGDSDASSPRSNCSDGMMDFMGPTCQT" ~
                "RRRNSYDSSYFNDTPNADARNNKNSVVSSLDCLSSIVERISTETPACPVLSVPEGHEESP" ~
                "CSPHEGSVLSDTGTTAPSPTSCPQQQAQETIYQVL",
    "P13904" => "MELLPPPLRDMEVTEGSLCAFPTPDDFYDDPCFNTSDMSFFEDLDPRLVHVTLLKPEEPH" ~
                "HNEDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAFETLKR" ~
                "YTSTNPNQRLPKVEILRNAIRYIESLQALLHDQDEAFYPVLEHYSGDSDASSPRSNCSDG" ~
                "MMDYNSPPCGSRRRNSYDSSFYSDSPNDSRLGKSSVISSLDCLSSIVERISTQSPSCPVP" ~
                "TAVDSGSEGSPCSPLQGETLSERVITIPSPSNTCTQLSQDPSSTIYHVL",
    "P16075" => "MDLLGPMEMTEGSLCSFTAADDFYDDPCFNTSDMHFFEDLDPRLVHVGGLLKPEEHPHTR" ~
                "APPREPTEEEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERRRLSKVNEAF" ~
                "ETLKRCTSTNPNQRLPKVEILRNAIRYIESLQALLREQEDAYYPVLEHYSGESDASSPRS" ~
                "NCSDGMMEYSGPPCSSRRRNSYDSSYYTESPNDPKHGKSSVVSSLDCLSSIVERISTDNS" ~
                "TCPILPPAEAVAEGSPCSPQEGGNLSDSGAQIPSPTNCTPLPQESSSSSSSNPIYQVL",
    "P10085" => "MELLSPPLRDIDLTGPDGSLCSFETADDFYDDPCFDSPDLRFFEDLDPRLVHMGALLKPE" ~
                "EHAHFPTAVHPGPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" ~
                "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAFYAP" ~
                "GPLPPGRGSEHYSGDSDASSPRSNCSDGMMDYSGPPSGPRRQNGYDTAYYSEAARESRPG" ~
                "KSAAVSSLDCLSSIVERISTDSPAAPALLLADAPPESPPGPPEGASLSDTEQGTQTPSPD" ~
                "AAPQCPAGSNPNAIYQVL",
    "P17542" => "MTERPPSEAARSDPQLEGRDAAEASMAPPHLVLLNGVAKETSRAAAAEPPVIELGARGGP" ~
                "GGGPAGGGGAARDLKGRDAATAEARHRVPTTELCRPPGPAPAPAPASVTAELPGDGRMVQ" ~
                "LSPPALAAPAAPGRALLYSLSQPLASLGSGFFGEPDAFPMFTTNNRVKRRPSPYEMEITD" ~
                "GPHTKVVRRIFTNSRERWRQQNVNGAFAELRKLIPTHPPDKKLSKNEILRLAMKYINFLA" ~
                "KLLNDQEEEGTQRAKTGKDPVVGAGGGGGGGGGGAPPDDLLQDVLSPNSSCGSSLDGAAS" ~
                "PDSYTEEPAPKHTARSLHPAMLPAADGAGPR",
    "P15172" => "MELLSPPLRDVDLTAPDGSLCSFATTDDFYDDPCFDSPDLRFFEDLDPRLMHVGALLKPE" ~
                "EHSHFPAAVHPAPGAREDEHVRAPSGHHQAGRCLLWACKACKRKTTNADRRKAATMRERR" ~
                "RLSKVNEAFETLKRCTSSNPNQRLPKVEILRNAIRYIEGLQALLRDQDAAPPGAAAAFYA" ~
                "PGPLPPGRGGEHYSGDSDASSPRSNCSDGMMDYSGPPSGARRRNCYEGAYYNEAPSEPRP" ~
                "GKSAAVSSLDCLSSIVERISTESPAAPALLLADVPSESPPRRQEAAAPSEGESSGDPTQS" ~
                "PDAAPQCPAGANPNPIYQVL"
);

my @ACCESSIONS = ["P15172", "P17542", "P10085", "P16075", "P13904",
                  "Q90477", "Q8IU24", "P22816", "Q10574", "O95363"];

my $test1 = SmithWaterman.new("str001", "str002", "deadly", "ddgearlyk", 999);
$test1.printAlignment();

#`[[[[[[ the following exceeds the resource limits of ATO

my @test2 = Nil xx @ACCESSIONS.elems;
for ^@test2.elems -> $i {
   @test2[$i] = [ 0 xx @ACCESSIONS.elems ];
   for $i ..^ @test2.elems -> $j {
      my $temp = SmithWaterman.new(@ACCESSIONS[$i], @ACCESSIONS[$j],
                 %ACC_TO_SEQ{@ACCESSIONS[$i]}, %ACC_TO_SEQ{@ACCESSIONS[$j]}, 0);
      @test2[$i;$j] = $temp.score;
      $temp.printAlignment();
   }
}

.say for @test2;
say();

my $comp1 = SmithWaterman.new("P15172", "Q10574", %ACC_TO_SEQ{"P15172"}, %ACC_TO_SEQ{"Q10574"}, 999);
my $comp2 = SmithWaterman.new("P15172", "Q10574", %ACC_TO_SEQ{"P15172"}, %ACC_TO_SEQ{"O95363"}, 999);

say "p-value for P15172 versus Q10574: ", $comp1.pval;
say "p-value for P15172 versus O95363: ", $comp2.pval;

#]]]]]]
