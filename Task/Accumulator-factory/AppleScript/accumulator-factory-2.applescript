on run

    set x to foo(1)

    x's lambda(5)

    foo(3)

    x's lambda(2.3)

end run

-- foo :: Int -> Script
on foo(sum)
    script
        on lambda(n)
            set sum to sum + n
        end lambda
    end script
end foo
