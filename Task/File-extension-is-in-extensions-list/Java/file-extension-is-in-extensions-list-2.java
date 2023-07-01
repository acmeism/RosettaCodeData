public static boolean extIsIn(String test, String... exts){
	for(int i = 0; i < exts.length; i++){
		exts[i] = exts[i].replaceAll("\\.", "");
	}
	return (new FileNameExtensionFilter("extension test", exts)).accept(new File(test));
}
