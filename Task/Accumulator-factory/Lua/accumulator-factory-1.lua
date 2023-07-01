function acc(init)
  init = init or 0
  return function(delta)
    init = init + (delta or 0)
    return init
  end
end
