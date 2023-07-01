note
	title: "Prototype Person"
	description: "Abstract notion of a {PERSON}."
	synopsis: "[
		Abstract Data Types as represented by any Eiffel class, fully or partially implemented, are
		not just about the attribute and routine features of the class (deferred or implemented).
		The class and each feature may also have specification rules expressed as preconditions,
		post-conditions, and class invariants. Other assertion contracts may be applied to fully
		implemented features as well.
		
		In the example below, while `age' is deferred (i.e. "abstract"), we have coded a rule which
		states that any caller of `age' must only do so after a `birth_date' has been defined and
		attached to that feature. Failing to do so will cause a contract violation. Moreover, the
		class invariant makes two strong assertions that must always hold for any implemented version
		of {PERSON}: The `birth_date' (if attached--that is--not Void or null) must be in the past
		and never in the future. Also, if "Years" are used to represent the age, the calculation of
		`age' must always agree with "current year - birth year = age".
		
		This form of Abstract Data Type specification has very clear advantages in that not only
		must client code or descendents conform statically, implementing what is deferred, but they
		must also obey the rules of the assertions dynamically in a polymorphic run-time situation.
		]"

deferred class
	PERSON

feature -- Access

	first_name,
	last_name,
	middle_name,
	suffix: STRING

	birth_date: detachable DATE
			-- Date-of-Birth for Current {PERSON}.
		deferred
		end

feature -- Basic Operations

	age: NATURAL_64
			-- Age of Current {PERSON} in some undefined units.
		require
			has_birth_date: attached birth_date
		deferred
		end

	age_units: STRING
			-- Unit-of-Measure (UOM) of `age'.
		attribute
			Result := year_unit_string
		end

	year_unit_string: STRING = "Years"

invariant
	not_future: attached birth_date as al_birth_date implies al_birth_date < (create {DATE}.make_now)
	accurate_age: attached birth_date as al_birth_date and then age > 0 and then age_units.same_string (year_unit_string)
					implies ((create {DATE}.make_now).year - al_birth_date.year) = age

end
