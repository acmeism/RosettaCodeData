list:= (FillInTheBlank request: 'myMessageBoxTitle') subStrings: String crlf.
dict:= Dictionary new.
list do: [:val|
	(dict at: val copy sort ifAbsent: [dict at: val copy sort put: OrderedCollection new])
		add: val.
	].
sorted:=dict asSortedCollection: [:a :b| a size > b size].
