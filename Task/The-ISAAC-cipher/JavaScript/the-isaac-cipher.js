randrsl = new Uint32Array(256);
randcnt = 0;
mm = new Uint32Array(256);
aa = 0;
bb = 0;
cc = 0;

function isaac() {
        cc++;
        bb += cc;
        for(var i = 0; i < 256; i++) {
                var x = mm[i];
                var sw = i & 3;
                if(sw == 0) aa = aa ^ (aa << 13);
                else if(sw == 1) aa = aa ^ (aa >>> 6);
                else if(sw == 2) aa = aa ^ (aa << 2);
                else if(sw == 3) aa = aa ^ (aa >>> 16);
                aa = mm[(i+128) & 255] + aa;
                mm[i] = mm[(x >>> 2) & 255] + aa + bb;
                bb = mm[(mm[i] >>> 10) & 255] + x;
                randrsl[i] = bb;
        }
}

function isaac_mix(x) {
        x[0] = x[0] ^ x[1] << 11;  x[3]+=x[0]; x[1]+=x[2];
        x[1] = x[1] ^ x[2] >>> 2;  x[4]+=x[1]; x[2]+=x[3];
        x[2] = x[2] ^ x[3] << 8;   x[5]+=x[2]; x[3]+=x[4];
        x[3] = x[3] ^ x[4] >>> 16; x[6]+=x[3]; x[4]+=x[5];
        x[4] = x[4] ^ x[5] << 10;  x[7]+=x[4]; x[5]+=x[6];
        x[5] = x[5] ^ x[6] >>> 4;  x[0]+=x[5]; x[6]+=x[7];
        x[6] = x[6] ^ x[7] << 8;   x[1]+=x[6]; x[7]+=x[0];
        x[7] = x[7] ^ x[0] >>> 9;  x[2]+=x[7]; x[0]+=x[1];
}

function isaac_init(flag) {
        var x = new Uint32Array([2654435769, 2654435769, 2654435769, 2654435769,
                                 2654435769, 2654435769, 2654435769, 2654435769]);
        aa=0, bb=0, cc=0;
        isaac_mix(x); isaac_mix(x); isaac_mix(x); isaac_mix(x);
        var i = 0;
        while(i < 255) {
                if(flag) for(var j = 0; j < 8; j++) x[j] += randrsl[i+j];
                isaac_mix(x);
                for(var j = 0; j < 8; j++) mm[i+j] = x[j];
                i += 8;
        }
        if(flag) {
                var i = 0;
                while(i < 255) {
                        for(var j = 0; j < 8; j++) x[j] += mm[i+j];
                        isaac_mix(x);
                        for(var j = 0; j < 8; j++) mm[i+j] = x[j];
                        i += 8;
                }
        }
        isaac();
        randcnt = 0;
}

function isaac_seed(string, flag) {
        mm = new Uint32Array(256);
        randrsl = new Uint32Array(256);
        var m = string.length;
        for(var i = 0; i < m; i++) randrsl[i] = string.charCodeAt(i);
        isaac_init(flag);
}

function isaac_random() {
        var out = randrsl[randcnt++];
        if(randcnt > 255) {
                isaac();
                randcnt = 0;
        }
        return out
}

function vernam(msg) {
        var out = "";
        for(var i = 0; i < msg.length; i++) {
                var ra = isaac_random() % 95 + 32;
                out += String.fromCharCode(ra ^ msg.charCodeAt(i));
        }
        return out;
}

function printable_hex(s) {
        out = "";
        for(var i = 0; i < s.length; i++)
                out += (s.charCodeAt(i) / 16 > 1 ? ''  : '0') + s.charCodeAt(i).toString(16);
        return out;
}

function run_isaac(key, msg)
{
        isaac_seed(key, true);

        // XOR encrypt
        var xctx = vernam(msg);

        // XOR decrypt
        isaac_seed(key, true);
        var xptx = vernam(xctx);

        return [xctx, xptx]
}

var key = 'this is my secret key'
var msg = 'a Top Secret secret'
console.log('key: '+key)
console.log('msg: '+msg)
var z = run_isaac(key, msg)
xctx = z[0];
xptx = z[1];
console.log('xor: '+printable_hex(xctx))
console.log('decrypted: '+xptx)
