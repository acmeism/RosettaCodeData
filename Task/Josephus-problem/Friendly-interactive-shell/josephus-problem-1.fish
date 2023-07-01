function execute
    # If the list is empty, don't do anything.
    test (count $argv) -ge 2; or return
    # If the list has only one element, return it
    if test (count $argv) -eq 2
        echo $argv[2]
        return
    end
    # Rotate prisoners
    for i in (seq 2 $argv[1])
        set argv $argv[1 3..-1 2]
    end
    # Mention killed prisoner
    echo $argv[2]
    # Kill rest recursively
    execute $argv[1 3..-1]
end

echo Prisoner (execute 3 (seq 0 40))[-1] survived.
