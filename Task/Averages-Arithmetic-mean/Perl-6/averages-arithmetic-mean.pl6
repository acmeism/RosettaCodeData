multi mean([]){ Failure.new('mean on empty list is not defined') }; # Failure-objects are lazy exceptions
multi mean (@a) { ([+] @a) / @a }
