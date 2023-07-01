define stripper(in::string,destroy::string) => {
	with toremove in #destroy->values do => {
		#in->replace(#toremove,'')
	}
	return #in
}
stripper('She was a soul stripper. She took my heart!','aei')
