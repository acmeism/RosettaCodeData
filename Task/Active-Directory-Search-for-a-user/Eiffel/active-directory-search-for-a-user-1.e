feature -- Validation

	is_user_credential_valid (a_domain, a_username, a_password: READABLE_STRING_GENERAL): BOOLEAN
			-- Is the pair `a_username'/`a_password' a valid credential in `a_domain'?
		local
			l_domain, l_username, l_password: WEL_STRING
		do
			create l_domain.make (a_domain)
			create l_username.make (a_username)
			create l_password.make (a_password)
			Result := cwel_is_credential_valid (l_domain.item, l_username.item, l_password.item)
		end
