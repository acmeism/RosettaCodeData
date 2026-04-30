p (2008..2121).select { |year| Time.utc(year, 12, 25).sunday? }
