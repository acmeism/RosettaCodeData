        var lead = 0
        for r in 0..<rows {
            if (cols <= lead) { break }
            var i = r
            while (m[i][lead] == 0) {
                i += 1
                if (i == rows) {
                    i = r
                    lead += 1
                    if (cols == lead) {
                        lead -= 1
                        break
                    }
                }
            }
            for j in 0..<cols {
                let temp = m[r][j]
                m[r][j] = m[i][j]
                m[i][j] = temp
            }
            let div = m[r][lead]
            if (div != 0) {
                for j in 0..<cols {
                    m[r][j] /= div
                }
            }
            for j in 0..<rows {
                if (j != r) {
                    let sub = m[j][lead]
                    for k in 0..<cols {
                        m[j][k] -= (sub * m[r][k])
                    }
                }
            }
            lead += 1
        }
