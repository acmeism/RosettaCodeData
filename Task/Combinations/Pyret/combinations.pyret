fun combos<a>(lst :: List<a>, size :: Number) -> List<List<a>>:
  # return all subsets of lst of a certain size,
  # maintaining the original ordering of the list

  # Let's handle a bunch of degenerate cases up front
  # to be defensive...
  if lst.length() < size:
    # return an empty list if size is too big
    [list:]
  else if lst.length() == size:
    # combos([list: 1,2,3,4]) == list[list: 1,2,3,4]]
    [list: lst]
  else if size == 1:
    # combos(list: 5, 9]) == list[[list: 5], [list: 9]]
    lst.map(lam(elem): [list: elem] end)
  else:
    # The main resursive step here is to consider
    # all the combinations of the list that have the
    # first element (aka head) and then those that don't
    # don't.
    cases(List) lst:
      | empty => [list:]
      | link(head, rest) =>
        # All the subsets of our list either include the
        # first element of the list (aka head) or they don't.
        with-head-combos = combos(rest, size - 1).map(
          lam(combo):
          link(head, combo) end
          )
        without-head-combos = combos(rest, size)
        with-head-combos._plus(without-head-combos)
    end
  end
where:
  # define semantics for the degenerate cases, although
  # maybe we should just make some of these raise errors
  combos([list:], 0) is [list: [list:]]
  combos([list:], 1) is [list:]
  combos([list: "foo"], 1) is [list: [list: "foo"]]
  combos([list: "foo"], 2) is [list:]

  # test the normal stuff
  lst = [list: 1, 2, 3]
  combos(lst, 1) is [list:
    [list: 1],
    [list: 2],
    [list: 3]
  ]
  combos(lst, 2) is [list:
    [list: 1, 2],
    [list: 1, 3],
    [list: 2, 3]
  ]
  combos(lst, 3) is [list:
    [list: 1, 2, 3]
  ]

  # remember the 10th row of Pascal's Triangle? :)
  lst10 = [list: 1,2,3,4,5,6,7,8,9,10]
  combos(lst10, 3).length() is 120
  combos(lst10, 4).length() is 210
  combos(lst10, 5).length() is 252
  combos(lst10, 6).length() is 210
  combos(lst10, 7).length() is 120

  # more sanity checks...
  for each(sublst from combos(lst10, 6)):
    sublst.length() is 6
  end

  for each(sublst from combos(lst10, 9)):
    sublst.length() is 9
  end
end

fun int-combos(n :: Number, m :: Number) -> List<List<Number>>:
  doc: "return all lists of size m containing distinct, ordered nonnegative ints < n"
  lst = range(0, n)
  combos(lst, m)
where:
  int-combos(5, 5) is [list: [list: 0,1,2,3,4]]
  int-combos(3, 2) is [list:
    [list: 0, 1],
    [list: 0, 2],
    [list: 1, 2]
  ]
end

fun display-3-comb-5-for-rosetta-code():
  # The very concrete nature of this function is driven
  # by the web page from Rosetta Code.  We want to display
  # output similar to the top of this page:
  #
  # https://rosettacode.org/wiki/Combinations
  results = int-combos(5, 3)
  for each(lst from results):
    print(lst.join-str(" "))
  end
end

display-3-comb-5-for-rosetta-code()
