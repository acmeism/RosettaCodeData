	cwel_is_credential_valid (a_domain, a_username, a_password: POINTER): BOOLEAN
		external
			"C inline use %"wel_user_validation.h%""
		alias
			"return cwel_is_credential_valid ((LPTSTR) $a_domain, (LPTSTR) $a_username, (LPTSTR) $a_password);"
		end
