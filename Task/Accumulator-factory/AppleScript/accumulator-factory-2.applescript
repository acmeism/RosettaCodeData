on run

    set x to foo(1)

    x's |λ|(5)

    foo(3)

    x's |λ|(2.3)

end run

-- foo :: Int -> Script
on foo(sum)
    script
        on |λ|(n)
            set sum to sum + n
        end |λ|
    end script
end foo
