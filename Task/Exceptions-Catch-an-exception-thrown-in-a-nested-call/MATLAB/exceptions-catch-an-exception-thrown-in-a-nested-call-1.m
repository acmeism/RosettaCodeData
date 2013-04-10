function exceptionsCatchNestedCall()
    function foo()

        try
            bar(1);
            bar(2);
        catch
            disp(lasterror);
            rethrow(lasterror);
        end

    end

    function bar(i)
        baz(i);
    end

    function baz(i)
        switch i
            case 1
                error('BAZ:U0','HAHAHAH');
            case 2
                error('BAZ:U1','AWWWW');
            otherwise
                disp 'I can''t do that Dave.';
        end
    end

    foo();

end
