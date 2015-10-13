frozen class
	SINGLETON_ACCESS
feature
	singleton: SINGLETON
		once ("PROCESS")
			create Result
		ensure
			Result /= Void
		end
end
