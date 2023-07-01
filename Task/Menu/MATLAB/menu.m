function sucess = menu(list)

    if numel(list) == 0
        sucess = '';
        return
    end

    while(true)

        disp('Please select one of these options:');

        for i = (1:numel(list))

            disp([num2str(i) ') ' list{i}]);

        end

        disp([num2str(numel(list)+1) ') exit']);

        try
            key = input(':: ');
            if key == numel(list)+1
                break
            elseif (key > numel(list)) || (key < 0)
                continue
            else
                disp(['-> ' list{key}]);
            end
        catch
            continue
        end


    end

    sucess = true;

end
