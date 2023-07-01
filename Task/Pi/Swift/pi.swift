//
//  main.swift
//  pi digits
//
//  Created by max goren on 11/11/21.
//  Copyright © 2021 maxcodes. All rights reserved.
//

import Foundation

var r = [Int]()
var i = 0
var k = 2800
var b = 0
var c = 0
var d = 0

for _ in 0...2800 {
    r.append(2000);
}
while k > 0 {
    d = 0;
    i = k;
    while (true) {
        d = d + r[i] * 10000
        b = 2 * i - 1
        r[i] = d % b
        d = d / b
        i = i - 1
        if i == 0 {
            break;
        }
        d = d * i;
    }
    print(c +  d / 10000, "")
    c = d % 10000
    k = k - 14
}
