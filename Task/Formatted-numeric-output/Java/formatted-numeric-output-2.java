import java.text.DecimalFormat;
import java.text.NumberFormat;

public class Format {
	public static void main(String[] args){
		NumberFormat numForm = new DecimalFormat();
		numForm.setMinimumIntegerDigits(9);
		//Maximum also available for Integer digits and Fraction digits
		numForm.setGroupingUsed(false);//stops it from inserting commas
		System.out.println(numForm.format(7.125));
		
		//example of Fraction digit options
		numForm.setMinimumIntegerDigits(5);
		numForm.setMinimumFractionDigits(5);
		System.out.println(numForm.format(7.125));
		numForm.setMinimumFractionDigits(0);
		numForm.setMaximumFractionDigits(2);
		System.out.println(numForm.format(7.125));
		System.out.println(numForm.format(7.135));//rounds to even
	}
}
