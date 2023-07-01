const
    tvl_not: array[TriBool] = (tbTrue, tbMaybe, tbFalse);
    tvl_and: array[TriBool, TriBool] = (
        (tbFalse, tbFalse, tbFalse),
        (tbFalse, tbMaybe, tbMaybe),
        (tbFalse, tbMaybe, tbTrue),
        );
    tvl_or: array[TriBool, TriBool] = (
        (tbFalse, tbMaybe, tbTrue),
        (tbMaybe, tbMaybe, tbTrue),
        (tbTrue, tbTrue, tbTrue),
        );
    tvl_xor: array[TriBool, TriBool] = (
        (tbFalse, tbMaybe, tbTrue),
        (tbMaybe, tbMaybe, tbMaybe),
        (tbTrue, tbMaybe, tbFalse),
        );
    tvl_eq: array[TriBool, TriBool] = (
        (tbTrue, tbMaybe, tbFalse),
        (tbMaybe, tbMaybe, tbMaybe),
        (tbFalse, tbMaybe, tbTrue),
        );
