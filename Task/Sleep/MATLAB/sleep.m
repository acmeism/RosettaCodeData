function sleep()

    time = input('How many seconds would you like me to sleep for? ');
    assert(time > .01);
    disp('Sleeping...');
    pause(time);
    disp('Awake!');

end
