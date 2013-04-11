class
    APPLICATION
create
    make

feature
    make
            -- Create and print sorted set
        do
            create my_set.make
            my_set.put_front (2)
            my_set.put_front (6)
            my_set.put_front (1)
            my_set.put_front (5)
            my_set.put_front (3)
            my_set.put_front (9)
            my_set.put_front (8)
            my_set.put_front (4)
            my_set.put_front (10)
            my_set.put_front (7)
            print ("Before: ")
            across my_set as ic loop print (ic.item.out + " ")  end
            print ("%NAfter : ")
            my_set.sort
            across my_set as ic loop print (ic.item.out + " ")  end
        end

    my_set: MY_SORTED_SET [INTEGER]
            -- Set to be sorted
end
