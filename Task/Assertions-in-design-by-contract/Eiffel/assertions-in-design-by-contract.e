  acc: INTEGER
  average_of_absolutes (values: ARRAY[INTEGER]): INTEGER
    require
      non_empty_values: values.count > 0
    do
      acc := 0
      values.do_all(agent abs_sum)
      Result := acc // values.count
    ensure
      non_neg_result: Result >= 0
    end
