function churchZero()
  return function(x) return x end
end

function churchSucc(c)
  return function(f)
    return function(x)
      return f(c(f)(x))
    end
  end
end

function churchAdd(c, d)
  return function(f)
    return function(x)
      return c(f)(d(f)(x))
    end
  end
end

function churchMul(c, d)
  return function(f)
      return c(d(f))
  end
end

function churchExp(c, e)
  return e(c)
end

function numToChurch(n)
  local ret = churchZero
  for i = 1, n do
    ret = succ(ret)
  end
  return ret
end

function churchToNum(c)
  return c(function(x) return x + 1 end)(0)
end

three =  churchSucc(churchSucc(churchSucc(churchZero)))
four = churchSucc(churchSucc(churchSucc(churchSucc(churchZero))))

print("'three'\t=", churchToNum(three))
print("'four' \t=", churchToNum(four))
print("'three' * 'four' =", churchToNum(churchMul(three, four)))
print("'three' + 'four' =", churchToNum(churchAdd(three, four)))
print("'three' ^ 'four' =", churchToNum(churchExp(three, four)))
print("'four' ^ 'three' =", churchToNum(churchExp(four, three)))
