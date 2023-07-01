def is_numeric?(s)
    !!Float(s, exception: false)
end
