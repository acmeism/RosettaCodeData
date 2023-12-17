DEFINITION RosettaMergeSort;

	TYPE
		Template = ABSTRACT RECORD
			(IN t: Template) Before- (front, rear: ANYPTR): BOOLEAN, NEW, ABSTRACT;
			(IN t: Template) Length (s: ANYPTR): INTEGER, NEW;
			(IN t: Template) Next- (s: ANYPTR): ANYPTR, NEW, ABSTRACT;
			(IN t: Template) Set- (s, next: ANYPTR): ANYPTR, NEW, ABSTRACT;
			(IN t: Template) Sort (s: ANYPTR): ANYPTR, NEW
		END;

END RosettaMergeSort.
