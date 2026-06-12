import qm
print(qm.qm(ones=[1, 2, 5], dc=[0, 7]))


# See https://robertdick.org/python/qm.html
# **qm**(ones\=\[\], zeros\=\[\], dc\=\[\])
#
# Compute minimal two-level sum-of-products form.
# Arguments are:
# ones: iterable of integer minterms
# zeros: iterable of integer maxterms
# dc: iterable of integers specifying don't-care terms
#
# For proper operation, either (or both) the 'ones' and 'zeros'
# parameters must be specified.If one of these parameters is not
# specified, it will be computed from the combination of the other
# parameter and the optional 'dc' parameter.
#
# An assertion error will be raised if any terms are specified
# in more than one argument, or if all three arguments are given
# and not all terms are specified.
