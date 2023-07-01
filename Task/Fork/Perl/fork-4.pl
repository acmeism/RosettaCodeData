use Proc::Fork;
run_fork {
    child {
        # child code ...
    }
    parent {
        # parent code ...
    }
    retry {
        # retry code ...
    }
    error {
        # error handling ...
    }
};
