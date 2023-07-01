(
f = { |separator|
	var count = 0;
	var counting = { |name|
		count = count + 1;
		count.asString ++ separator + name ++ "\n"
	};
	counting.("first") + counting.("second") + counting.("third")
};
)

f.(".")
