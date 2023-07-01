Term = Struct.new(:coeff, :ix1, :ix2) do
end

MAX_DIGITS = 16

def toLong(digits, reverse)
    sum = 0
    if reverse then
        i = digits.length - 1
        while i >=0
            sum = sum  *10 + digits[i]
            i = i - 1
        end
    else
        i = 0
        while i < digits.length
            sum = sum * 10 + digits[i]
            i = i + 1
        end
    end
    return sum
end

def isSquare(n)
    root = Math.sqrt(n).to_i
    return root * root == n
end

def seq(from, to, step)
    res = []
    i = from
    while i <= to
        res << i
        i = i + step
    end
    return res
end

def format_number(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def main
    pow = 1
    allTerms = []
    for i in 0 .. MAX_DIGITS - 2
        allTerms << []
    end
    for r in 2 .. MAX_DIGITS
        terms = []
        pow = pow * 10
        pow1 = pow
        pow2 = 1
        i1 = 0
        i2 = r - 1
        while i1 < i2
            terms << Term.new(pow1 - pow2, i1, i2)
            pow1 = (pow1 / 10).to_i
            pow2 = pow2 * 10
            i1 = i1 + 1
            i2 = i2 - 1
        end
        allTerms[r - 2] = terms
    end
    # map of first minus last digits for 'n' to pairs giving this value
    fml = {
        0 =>[[2, 2], [8, 8]],
        1 =>[[6, 5], [8, 7]],
        4 =>[[4, 0]],
        6 =>[[6, 0], [8, 2]]
    }
    # map of other digit differences for 'n' to pairs giving this value
    dmd = {}
    for i in 0 .. 99
        a = [(i / 10).to_i, (i % 10)]
        d = a[0] - a[1]
        if dmd.include?(d) then
            dmd[d] << a
        else
            dmd[d] = [a]
        end
    end
    fl = [0, 1, 4, 6]
    dl = seq(-9, 9, 1) # all differences
    zl = [0]           # zero differences only
    el = seq(-8, 8, 2) # even differences
    ol = seq(-9, 9, 2) # odd differences only
    il = seq(0, 9, 1)
    rares = []
    lists = []
    for i in 0 .. 3
        lists << []
    end
    fl.each_with_index { |f, i|
        lists[i] = [[f]]
    }
    digits = []
    count = 0

    # Recursive closure to generate (n+r) candidates from (n-r) candidates
    # and hence find Rare numbers with a given number of digits.
    fnpr = lambda { |cand, di, dis, indices, nmr, nd, level|
        if level == dis.length then
            digits[indices[0][0]] = fml[cand[0]][di[0]][0]
            digits[indices[0][1]] = fml[cand[0]][di[0]][1]
            le = di.length
            if nd % 2 == 1 then
                le = le - 1
                digits[(nd / 2).to_i] = di[le]
            end
            di[1 .. le - 1].each_with_index { |d, i|
                digits[indices[i + 1][0]] = dmd[cand[i + 1]][d][0]
                digits[indices[i + 1][1]] = dmd[cand[i + 1]][d][1]
            }
            r = toLong(digits, true)
            npr = nmr + 2 * r
            if not isSquare(npr) then
                return
            end
            count = count + 1
            print "     R/N %2d:" % [count]
            n = toLong(digits, false)
            print "  (%s)\n" % [format_number(n)]
            rares << n
        else
            for num in dis[level]
                di[level] = num
                fnpr.call(cand, di, dis, indices, nmr, nd, level + 1)
            end
        end
    }

    # Recursive closure to generate (n-r) candidates with a given number of digits.
    fnmr = lambda { |cand, list, indices, nd, level|
        if level == list.length then
            nmr = 0
            nmr2 = 0
            allTerms[nd - 2].each_with_index { |t, i|
                if cand[i] >= 0 then
                    nmr = nmr + t.coeff * cand[i]
                else
                    nmr2 = nmr2 = t.coeff * -cand[i]
                    if nmr >= nmr2 then
                        nmr = nmr - nmr2
                        nmr2 = 0
                    else
                        nmr2 = nmr2 - nmr
                        nmr = 0
                    end
                end
            }
            if nmr2 >= nmr then
                return
            end
            nmr = nmr - nmr2
            if not isSquare(nmr) then
                return
            end
            dis = []
            dis << seq(0, fml[cand[0]].length - 1, 1)
            for i in 1 .. cand.length - 1
                dis << seq(0, dmd[cand[i]].length - 1, 1)
            end
            if nd % 2 == 1 then
                dis << il.dup
            end
            di = []
            for i in 0 .. dis.length - 1
                di << 0
            end
            fnpr.call(cand, di, dis, indices, nmr, nd, 0)
        else
            for num in list[level]
                cand[level] = num
                fnmr.call(cand, list, indices, nd, level + 1)
            end
        end
    }

    #for nd in 2 .. MAX_DIGITS - 1
    for nd in 2 .. 10
        digits = []
        for i in 0 .. nd - 1
            digits << 0
        end
        if nd == 4 then
            lists[0] << zl.dup
            lists[1] << ol.dup
            lists[2] << el.dup
            lists[3] << ol.dup
        elsif allTerms[nd - 2].length > lists[0].length then
            for i in 0 .. 3
                lists[i] << dl.dup
            end
        end
        indices = []
        for t in allTerms[nd - 2]
            indices << [t.ix1, t.ix2]
        end
        for list in lists
            cand = []
            for i in 0 .. list.length - 1
                cand << 0
            end
            fnmr.call(cand, list, indices, nd, 0)
        end
        print "  %2d digits\n" % [nd]
    end

    rares.sort()
    print "\nThe rare numbers with up to %d digits are:\n" % [MAX_DIGITS]
    rares.each_with_index { |rare, i|
        print "  %2d:  %25s\n" % [i + 1, format_number(rare)]
    }
end

main()
