program chaocipher(input, output);

const
	{ This denotes a `set` literal: }
	alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
		'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
	{ The `card` function is an Extended Pascal (ISO 10206) extension. }
	alphabetCardinality = card(alphabet);
	{ 1st character denotes “zenith”. }
	zenith = 1;
	{ In a 26-character alphabet the 14th character denotes “nadir”. }
	nadir = alphabetCardinality div 2 + 1;
	{ For simplicity use compile-time-defined maximum lengths. }
	messageMaximumLength = 80;

type
	{ This “discriminates” the Extended Pascal schema data type `string` to be }
	{ capable of holding strings up to `alphabetCardinality` `char` values. }
	map = string(alphabetCardinality);
	{ Variables of this data type can only assume integer values within 1..26: }
	mapCharacterIndex = 1..alphabetCardinality;
	{ Later used as a buffer for the input/output. }
	message = string(messageMaximumLength);
	messageCharacterIndex = 1..messageMaximumLength;
	{ Stores a key for the Chaocipher algorithm. }
	key = record
			cipherText: map;
			plainText: map;
		end;

{ --- auxilliary routines ---------------------------------------------- }

{
	\brief verifies that a key is valid for the Chaocipher
	\param sample a potential `key` for a Chaocipher
	\return `true` iff \param sample is an acceptable `key`
}
{ `protected` (Extended Pascal extension) denotes an immutable parameter. }
function isValid(protected sample: key): Boolean;
	{ Determines whether a `map` contains all characters of `alphabet`. }
	{ Nesting this function allows for a neat expression below. }
	function isComplete(protected text: map): Boolean;
	var
		i: integer;
		{ `value []` will initialize this variable to an empty set value. }
		{ This is an Extended Pascal (ISO 10206) extension. }
		s: set of char value [];
	begin
		{ NB: In Pascal `for`-loop limits are inclusive. }
		for i := 1 to length(text) do
		begin
			{ This adds the set containing one character to the set `s`. }
			s := s + [text[i]]
		end;
		isComplete := card(s) = alphabetCardinality
	end;
begin
	{ This way `sample.cipherText` can be simply written as `cipherText`. }
	with sample do
	begin
		{ `and_then` is an EP extension indicating “lazy evaluation”. }
		isValid := (alphabetCardinality > 8) and_then
			isComplete(cipherText) and_then isComplete(plainText)
	end
end;

{
	\brief permutes a key for the next encryption/decryption step
	\param shift the index of the characters just substituted
}
{ `var` means the parameter value will be modified _at_ the call site. }
procedure permute(var state: key; protected shift: mapCharacterIndex);
begin
	with state do
	begin
		{ Indices in `cipherText[1..pred(shift)]` _must_ be non-descending: }
		if shift > 1 then
		begin
			cipherText := subStr(cipherText, shift) + cipherText[1..pred(shift)]
			{ `subStr(str, ini)` is equivalent to `str[ini..length(str)]`. }
		end;
		{ Likewise, `succ(shift)` must be a valid index in `plainText`: }
		if shift < alphabetCardinality then
		begin
			plainText := subStr(plainText, succ(shift)) + plainText[1..shift]
		end;
		
		{ If it does _not_ _alter_ the _entire_ string’s _length_, you can }
		{ modify parts of a string like this (Extended Pascal extension): }
		cipherText[zenith+1..nadir] := cipherText[zenith+2..nadir] + cipherText[zenith+1];
		plainText[zenith+2..nadir] := plainText[zenith+3..nadir] + plainText[zenith+2]
	end
end;

{ --- the core routine of the algorithm -------------------------------- }

{
	\brief performs Chaocipher common steps
	\param line the message to encrypt/decrypt
	\param state the initial key to start encrpytion/decryption with
	\param locate a function determining the 2-tuple index in the key
	\param substitute the procedure substituting the correct characters
}
procedure chaocipher(
		var line: message;
		var state: key;
		{ These are “routine parameters”. Essentially the address of a routine }
		{ matching the specified routine signature is passed to `chaocipher`. }
		function locate(protected i: messageCharacterIndex): mapCharacterIndex;
		procedure substitute(
				protected i: messageCharacterIndex;
				protected z: mapCharacterIndex
			)
	);
var
	{ For demonstration purposes: In this program }
	{ `line.capacity` refers to `messageMaximumLength`. }
	i: 1..line.capacity;
	substitutionPairIndex: mapCharacterIndex;
begin
	{ Don’t trust user input, even though this is just a RosettaCode example. }
	if not isValid(state) then
	begin
		writeLn('Error: Key is invalid. Got:');
		writeLn('Cipher text: ', state.cipherText);
		writeLn(' Plain text: ', state.plainText);
		halt
	end;
	
	for i := 1 to length(line) do
	begin
		{ We’ll better skip characters that aren’t in the `alphabet`. }
		if line[i] in alphabet then
		begin
			{ Here you see the beauty of using routine parameters. }
			{ Depending on whether we’re encrypting or decrypting, }
			{ you need to find a character in the `cipherText` or }
			{ `plainText` key value respectively, yet the basic order
			{ of the steps are still the same. }
			substitutionPairIndex := locate(i);
			substitute(i, substitutionPairIndex);
			permute(state, substitutionPairIndex)
		end
	end
end;

{ --- entry routines --------------------------------------------------- }

{
	\brief encrypts a message according to Chaocipher
	\param line a message to encrypt
	\param state the key to begin with
	\return the encrypted message \param line using the provided key
}
{ Note: without `var` or `protected` both `encrypt` and `decrypt`get }
{       and have their own independent copies of the parameter values. }
function encrypt(line: message; state: key): message;
	function encryptor(protected i: messageCharacterIndex): mapCharacterIndex;
	begin
		encryptor := index(state.plainText, line[i])
	end;
	procedure substitutor(
			protected i: messageCharacterIndex;
			protected z: mapCharacterIndex
		);
	begin
		line[i] := state.cipherText[z]
	end;
begin	
	chaocipher(line, state, encryptor, substitutor);
	encrypt := line
end;

{
	\brief decrypts a message according to Chaocipher
	\param line the encrypted message
	\param state the key to begin with
	\return the decrypted message \param line using the provided key
}
function decrypt(line: message; state: key): message;
	function decryptor(protected i: messageCharacterIndex): mapCharacterIndex;
	begin
		decryptor := index(state.cipherText, line[i])
	end;
	procedure substitutor(
			protected i: messageCharacterIndex;
			protected z: mapCharacterIndex
		);
	begin
		line[i] := state.plainText[z]
	end;
begin
	chaocipher(line, state, decryptor, substitutor);
	decrypt := line
end;

{ === MAIN ============================================================= }
var
	exampleKey: key;
	line: message;
begin
	{ Instead of writing `exampleKey.cipherText := '…', you can }
	{ write in Extended Pascal a `record` literal like this: }
	exampleKey := key[
			cipherText: 'HXUCZVAMDSLKPEFJRIGTWOBNYQ';
			plainText: 'PTLNBQDEOYSFAVZKGJRIHWXUMC';
		];
	
	{ `EOF` is shorthand for `EOF(input)`. }
	while not EOF do
	begin
		{ `readLn(line)` is shorthand for `readLn(input, line)`. }
		readLn(line);
		line := encrypt(line, exampleKey);
		writeLn(decrypt(line, exampleKey));
		{ Likewise, `writeLn(line)` is short for `writeLn(output, line)`. }
		writeLn(line)
	end
end.
