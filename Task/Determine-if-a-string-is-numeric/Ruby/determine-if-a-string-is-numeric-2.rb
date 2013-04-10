def is_numeric?(s)
    !!Float(s) rescue false
end
