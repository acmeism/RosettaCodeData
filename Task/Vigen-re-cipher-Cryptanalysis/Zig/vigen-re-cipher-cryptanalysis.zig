const std = @import("std");

const CRYPTOGRAM: []const u8 =
    \\MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
    \\VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD
    \\ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS
    \\FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG
    \\ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ
    \\ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS
    \\JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT
    \\LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST
    \\MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH
    \\QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV
    \\RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW
    \\TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO
    \\SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR
    \\ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX
    \\BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB
    \\BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA
    \\FWAML ZZRXJ EKAHV FASMU LVVUT TGK
;

const FREQUENCIES = [_]f32{
    0.08167, 0.01492, 0.02202, 0.04253, 0.12702, 0.02228, 0.02015, 0.06094, 0.06966, 0.00153,
    0.01292, 0.04025, 0.02406, 0.06749, 0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09356,
    0.02758, 0.00978, 0.02560, 0.00150, 0.01994, 0.00077,
};

fn bestMatch(a: []const f32) u8 {
    var sum: f32 = 0;
    for (a) |val| {
        sum += val;
    }

    var best_fit: f32 = std.math.floatMax(f32);
    var best_rotate: u8 = 0;

    var rotate: u8 = 0;
    while (rotate <= 25) : (rotate += 1) {
        var fit: f32 = 0;
        var i: usize = 0;
        while (i <= 25) : (i += 1) {
            const char_freq = FREQUENCIES[i];
            const idx = (i + rotate) % 26;
            const d = a[idx] / sum - char_freq;
            fit += d * d / char_freq;
        }
        if (fit < best_fit) {
            best_fit = fit;
            best_rotate = rotate;
        }
    }

    return best_rotate;
}

fn freqEveryNth(msg: []const u8, key: []u8) f32 {
    const len = msg.len;
    const interval = key.len;
    var accu = [_]f32{0} ** 26;

    var j: usize = 0;
    while (j < interval) : (j += 1) {
        var out = [_]f32{0} ** 26;

        var i: usize = j;
        while (i < len) : (i += interval) {
            const idx = msg[i];
            out[idx] += 1;
        }

        const rot = bestMatch(&out);
        key[j] = rot + 'A';

        var k: usize = 0;
        while (k <= 25) : (k += 1) {
            const idx = (k + rot) % 26;
            accu[k] += out[idx];
        }
    }

    var sum: f32 = 0;
    for (accu) |val| {
        sum += val;
    }

    var ret: f32 = 0;
    var i: usize = 0;
    while (i <= 25) : (i += 1) {
        const char_freq = FREQUENCIES[i];
        const d = accu[i] / sum - char_freq;
        ret += d * d / char_freq;
    }

    return ret;
}

fn decrypt(allocator: std.mem.Allocator, text: []const u8, key: []const u8) ![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    var key_index: usize = 0;
    for (text) |c| {
        if (c >= 'A' and c <= 'Z') {
            const key_char = key[key_index % key.len];
            // Fix the integer overflow by using a safer formula
            const shift = @as(i32, c) - @as(i32, key_char);
            const adjusted_shift = @mod(shift + 26, 26);
            const decrypted = @as(u8, @intCast(adjusted_shift)) + 'A';
            try result.append(decrypted);
            key_index += 1;
        }
    }

    return result.toOwnedSlice();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Parse cryptogram - remove spaces
    var enc = std.ArrayList(u8).init(allocator);
    defer enc.deinit();

    for (CRYPTOGRAM) |c| {
        if (c >= 'A' and c <= 'Z') {
            try enc.append(c);
        }
    }

    // Convert to indices
    var cryptogram = std.ArrayList(u8).init(allocator);
    defer cryptogram.deinit();

    for (enc.items) |c| {
        try cryptogram.append(c - 'A');
    }

    var best_fit: f32 = std.math.floatMax(f32);
    var best_key = std.ArrayList(u8).init(allocator);
    defer best_key.deinit();

    var j: usize = 1;
    while (j <= 26) : (j += 1) {
        const key = try allocator.alloc(u8, j);
        const fit = freqEveryNth(cryptogram.items, key);

        if (fit < best_fit) {
            best_fit = fit;
            best_key.clearAndFree();
            try best_key.appendSlice(key);
        }
        allocator.free(key);
    }

    // Print results
    const stdout = std.io.getStdOut().writer();
    try stdout.print("best key: ", .{});
    for (best_key.items) |c| {
        try stdout.writeByte(c);
    }
    try stdout.writeByte('\n');

    const decrypted = try decrypt(allocator, enc.items, best_key.items);
    defer allocator.free(decrypted);

    try stdout.print("\nDecrypted text:\n{s}\n", .{decrypted});
}
