/* Copyright © 2017 John L . Gustafson
 *
 * Permission is hereby granted, free of charge to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction including without limitation the rights to use
 * copy, modify, merge, publish, distribute, sub - license, and/or sell copies of
 * the Software and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions :
 *
 * This copyright and permission notice shall be included in all copies or
 * substantial portions of the software .
 *
 * THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT . IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OR CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE .
 */

const nbits = 8
const es = 2
const npat = 1 << nbits
const useed = 1 << (1 << es)

function x2p(x) {
    "use strict";
    let i, p,
        e = 1 << (es - 1),
        y = Math.abs(x);
    if (y == 0) return 0
    if (y == Math.Infinity) return 1 << (nbits - 1)
    if (y >= 1) {
        p = 1
        i = 2
        while (y >= useed && i < nbits) {
            p = 2 * p + 1
            y = y / useed
            i = i + 1
        }
        p = 2 * p
        i = i + 1
    } else {
        p = 0
        i = 1
        while (y < 1 && i <= nbits) {
            y = y * useed
            i = i + 1
        }
        if (i >= nbits) {
            p = 2
            i = nbits + 1
        } else {
            p = 1
            i = i + 1
        }
    }

    while (e > 0.5 && i <= nbits) {
        p = 2 * p
        if (y >= 2 * e) {
            y = y / (1 << e)
            p = p + 1
        }
        e = e / 2
        i = i + 1
    }
    y = y - 1

    while (y > 0 && i <= nbits) {
        y = 2 * y
        p  = 2 * p + Math.floor(y)
        y = y - Math.floor(y)
        i = i + 1
    }
    p = p * (1 << (nbits + 1 - i))
    i = i + 1
    i = p & 1
    p = Math.floor((p/2))
    if (i != 0) {
        if (y == 1 || y == 0) {
            p = p + (p & 1)
        } else {
            p = p + 1
        }
    }
    return (x < 0 ? npat - p : p) % npat
}

console.log(x2p(Math.PI));
