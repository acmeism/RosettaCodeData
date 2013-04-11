class
    MAIN_WINDOW
inherit
    EV_TITLED_WINDOW
        redefine
            initialize
        end
create
    default_create
feature {NONE} -- Initialization
    initialize
            -- Build the interface for this window.
        do
                -- Call initialize in parent class EV_TITLED_WINDOW
            Precursor {EV_TITLED_WINDOW}
                -- Build a container for widgets for this window
            build_main_container
                -- Add the container to this window
            extend (main_container)
                -- Add `request_close_window' to the actions taken when the user clicks
                -- on the cross in the title bar.
            close_request_actions.extend (agent request_close_window)
                -- Set the title of the window
            set_title ("Rosetta Code")
                -- Set the initial size of the window
            set_size (400, 400)
        end
feature {NONE} -- Implementation, Close event
    request_close_window
            -- The user wants to close the window
        do
                -- Destroy this window
            destroy;
                -- Destroy application
            (create {EV_ENVIRONMENT}).application.destroy
        end
feature {NONE} -- Implementation
    main_container: EV_VERTICAL_BOX
            -- Main container contains all widgets displayed in this window.
            -- In this case a single text area.
    build_main_container
            -- Create and populate `main_container'.
        require
            main_container_not_yet_created: main_container = Void
        do
            create main_container
            main_container.extend (create {EV_TEXT})
        ensure
            main_container_created: main_container /= Void
        end
end
