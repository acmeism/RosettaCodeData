def foo
    throw :done
end

catch :done do
    foo
end
