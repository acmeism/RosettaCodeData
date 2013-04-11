class
    APPLICATION
inherit
    EV_APPLICATION
create
    make_and_launch
feature {NONE} -- Initialization
    make_and_launch
            -- Initialize and launch application
        do
            default_create
            create first_window
            first_window.show
            launch
        end
feature {NONE} -- Implementation
    first_window: MAIN_WINDOW
            -- Main window.
end
