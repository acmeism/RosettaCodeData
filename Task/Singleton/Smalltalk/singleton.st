SomeClass class>>sharedInstance

       SharedInstance ifNil: [SharedInstance := self basicNew initialize].
       ^ SharedInstance
