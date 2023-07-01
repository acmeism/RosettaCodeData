class
    APPLICATION
inherit
    WINFORMS_FORM
        rename
            make as make_form
        end
create
    make
feature {NONE} -- Initialization
    make
            -- Run application.
        do
                -- Set window title
            set_text ("Rosetta Code")
                -- Launch application
            {WINFORMS_APPLICATION}.run_form (Current)
        end
end
