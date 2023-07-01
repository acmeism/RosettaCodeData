const Пасха = год => {
	let дата = (год % 19 * 19 + 15) % 30;
	дата += (год % 4 * 2 + год % 7 * 4 + 6 * дата + 6) % 7;
	if (год >= 1918) дата += (год / 100 | 0) - (год / 400 | 0) - 2;
	return new Date(год, 2, 22 + дата);
};

for (let год = 400; год <= 2100; год += год < 2000 ? 100 : год >= 2020 ? 80 : год < 2010 ? 10 : 1) {
	const дата_Пасхи = Пасха(год);
	document.write(
		год + ": " +
		[ ["Easter", 1], ["Ascension", 40], ["Trinity (Pentecost)", 50], ["All Saints' Sunday", 57] ].map(праздник => {
			let дата = new Date(дата_Пасхи);
			дата.setDate(дата.getDate() + праздник[1] - 1);
			return праздник[0] + ": " + new Intl.DateTimeFormat("ru", { month: "numeric", day: "numeric" }).format(дата);
		}).join("; ") + ".<br />"
	);
}
