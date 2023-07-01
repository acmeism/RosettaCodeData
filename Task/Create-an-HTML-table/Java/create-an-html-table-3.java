public class HTML {

	public static String array2HTML(Object[][] array){
		StringBuilder html = new StringBuilder(
				"<table>");
		for(Object elem:array[0]){
			html.append("<th>" + elem.toString() + "</th>");
		}
		for(int i = 1; i < array.length; i++){
			Object[] row = array[i];
			html.append("<tr>");
			for(Object elem:row){
				html.append("<td>" + elem.toString() + "</td>");
			}
			html.append("</tr>");
		}
		html.append("</table>");
		return html.toString();
	}
	
	public static void main(String[] args){
		Object[][] ints = {{"","X","Y","Z"},{1,1,2,3},{2,4,5,6},{3,7,8,9},{4,10,11,12}};
		System.out.println(array2HTML(ints));
	}
}
