class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
            -- Run application.
        local
            my_point: POINT
            my_circle: CIRCLE
        do
            create my_point.make_origin
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make_origin
            print (my_point.out + "%N")

            create my_point.make (10, 15)
            print (my_point.out + "%N")

            create {CIRCLE} my_point.make (20, 25, 5)
            print (my_point.out + "%N")

            create my_circle.make (30, 35, 10)
            print (my_circle.out + "%N")

            create my_circle.make_from_point (my_point, 35)
            print (my_circle.out + "%N")
        end

end
