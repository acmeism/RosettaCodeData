use std::iter::FromIterator;

const CRYPTOGRAM: &str = "MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD
ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS
FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG
ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ
ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS
JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT
LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST
MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH
QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV
RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW
TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO
SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR
ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX
BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB
BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA
FWAML ZZRXJ EKAHV FASMU LVVUT TGK";

const FREQUENCIES: [f32; 26] = [
    0.08167, 0.01492, 0.02202, 0.04253, 0.12702, 0.02228, 0.02015, 0.06094, 0.06966, 0.00153,
    0.01292, 0.04025, 0.02406, 0.06749, 0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09356,
    0.02758, 0.00978, 0.02560, 0.00150, 0.01994, 0.00077,
];

fn best_match(a: &[f32]) -> u8 {
    let sum: f32 = a.iter().sum();
    let mut best_fit = std::f32::MAX;
    let mut best_rotate = 0;
    for rotate in 0..=25 {
        let mut fit = 0.;
        for i in 0..=25 {
            let char_freq = FREQUENCIES[i];
            let idx = (i + rotate as usize) % 26 as usize;
            let d = a[idx] / sum - char_freq;
            fit += d * d / char_freq;
        }
        if fit < best_fit {
            best_fit = fit;
            best_rotate = rotate;
        }
    }

    best_rotate
}

fn freq_every_nth(msg: &[u8], key: &mut [char]) -> f32 {
    let len = msg.len();
    let interval = key.len();
    let mut accu = [0.; 26];
    for j in 0..interval {
        let mut out = [0.; 26];
        for i in (j..len).step_by(interval) {
            let idx = msg[i] as usize;
            out[idx] += 1.;
        }
        let rot = best_match(&out);
        key[j] = char::from(rot + b'A');
        for i in 0..=25 {
            let idx: usize = (i + rot as usize) % 26;
            accu[i] += out[idx];
        }
    }
    let sum: f32 = accu.iter().sum();
    let mut ret = 0.;
    for i in 0..=25 {
        let char_freq = FREQUENCIES[i];
        let d = accu[i] / sum - char_freq;
        ret += d * d / char_freq;
    }
    ret
}

fn decrypt(text: &str, key: &str) -> String {
    let key_chars_cycle = key.as_bytes().iter().map(|b| *b as i32).cycle();
    let is_ascii_uppercase = |c: &u8| (b'A'..=b'Z').contains(c);
    text.as_bytes()
        .iter()
        .filter(|c| is_ascii_uppercase(c))
        .map(|b| *b as i32)
        .zip(key_chars_cycle)
        .fold(String::new(), |mut acc, (c, key_char)| {
            let ci: u8 = ((c - key_char + 26) % 26) as u8;
            acc.push(char::from(b'A' + ci));
            acc
        })
}
fn main() {
    let enc = CRYPTOGRAM
        .split_ascii_whitespace()
        .collect::<Vec<_>>()
        .join("");
    let cryptogram: Vec<u8> = enc.as_bytes().iter().map(|b| u8::from(b - b'A')).collect();
    let mut best_fit = std::f32::MAX;
    let mut best_key = String::new();
    for j in 1..=26 {
        let mut key = vec!['\0'; j];
        let fit = freq_every_nth(&cryptogram, &mut key);
        let s_key = String::from_iter(key); // 'from_iter' is imported from std::iter::FromIterator;
        if fit < best_fit {
            best_fit = fit;
            best_key = s_key;
        }
    }

    println!("best key: {}", &best_key);
    println!("\nDecrypted text:\n{}", decrypt(&enc, &best_key));
}
