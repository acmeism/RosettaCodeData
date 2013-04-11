(class +Adr +Entity)
(rel nm (+Sn +Idx +String))            # Name [Soundex index]
(rel str (+String))                    # Street
(rel zip (+Ref +String))               # ZIP [Non-unique index]
(rel cit (+Fold +Idx +String))         # City [Folded substring index]
(rel st (+String))                     # State
(rel tel (+Fold +Ref +String))         # Phone [Folded non-unique index]
(rel em (+Ref +String))                # EMail [Non-unique index]
(rel txt (+Blob))                      # Memo
(rel jpg (+Blob))                      # Photo

(pool "address.db")  # Create database
