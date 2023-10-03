import java.time.LocalDateTime;
import java.time.ZoneOffset;

public final class ShowTheEpoch {

	public static void main(String[] args) {
		System.out.println(LocalDateTime.ofEpochSecond(0, 0, ZoneOffset.UTC));
	}

}
