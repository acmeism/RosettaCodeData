import javafx.application.Application;
import javafx.event.EventHandler;
import javafx.geometry.Point3D;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.shape.MeshView;
import javafx.scene.shape.TriangleMesh;
import javafx.scene.transform.Rotate;
import javafx.stage.Stage;
public class DeathStar extends Application {

	private static final int DIVISION = 200;// the bigger the higher resolution
	float radius = 300;// radius of the sphere

	@Override
	public void start(Stage primaryStage) throws Exception {
		Point3D otherSphere = new Point3D(-radius, 0, -radius * 1.5);
		final TriangleMesh triangleMesh = createMesh(DIVISION, radius, otherSphere);
		MeshView a = new MeshView(triangleMesh);

		a.setTranslateY(radius);
		a.setTranslateX(radius);
		a.setRotationAxis(Rotate.Y_AXIS);
		Scene scene = new Scene(new Group(a));
//		uncomment if you want to move the other sphere
		
//		scene.setOnKeyPressed(new EventHandler<KeyEvent>() {
//			Point3D sphere = otherSphere;
//
//			@Override
//			public void handle(KeyEvent e) {
//				KeyCode code = e.getCode();
//				switch (code) {
//				case UP:
//					sphere = sphere.add(0, -10, 0);
//					break;
//				case DOWN:
//					sphere = sphere.add(0, 10, 0);
//					break;
//				case LEFT:
//					sphere = sphere.add(-10, 0, 0);
//					break;
//				case RIGHT:
//					sphere = sphere.add(10, 0, 0);
//					break;
//				case W:
//					sphere = sphere.add(0, 0, 10);
//					break;
//				case S:
//					sphere = sphere.add(0, 0, -10);
//					break;
//				default:
//					return;
//				}
//				a.setMesh(createMesh(DIVISION, radius, sphere));
//
//			}
//		});

		primaryStage.setScene(scene);
		primaryStage.show();
	}

	static TriangleMesh createMesh(final int division, final float radius, final Point3D centerOtherSphere) {
		Rotate rotate = new Rotate(180, centerOtherSphere);
		final int div2 = division / 2;

		final int nPoints = division * (div2 - 1) + 2;
		final int nTPoints = (division + 1) * (div2 - 1) + division * 2;
		final int nFaces = division * (div2 - 2) * 2 + division * 2;

		final float rDiv = 1.f / division;

		float points[] = new float[nPoints * 3];
		float tPoints[] = new float[nTPoints * 2];
		int faces[] = new int[nFaces * 6];

		int pPos = 0, tPos = 0;

		for (int y = 0; y < div2 - 1; ++y) {
			float va = rDiv * (y + 1 - div2 / 2) * 2 * (float) Math.PI;
			float sin_va = (float) Math.sin(va);
			float cos_va = (float) Math.cos(va);

			float ty = 0.5f + sin_va * 0.5f;
			for (int i = 0; i < division; ++i) {
				double a = rDiv * i * 2 * (float) Math.PI;
				float hSin = (float) Math.sin(a);
				float hCos = (float) Math.cos(a);
				points[pPos + 0] = hSin * cos_va * radius;
				points[pPos + 2] = hCos * cos_va * radius;
				points[pPos + 1] = sin_va * radius;

				final Point3D point3D = new Point3D(points[pPos + 0], points[pPos + 1], points[pPos + 2]);
				double distance = centerOtherSphere.distance(point3D);
				if (distance <= radius) {
					Point3D subtract = centerOtherSphere.subtract(point3D);
					Point3D transform = rotate.transform(subtract);
					points[pPos + 0] = (float) transform.getX();
					points[pPos + 1] = (float) transform.getY();
					points[pPos + 2] = (float) transform.getZ();
					
				}
				tPoints[tPos + 0] = 1 - rDiv * i;
				tPoints[tPos + 1] = ty;
				pPos += 3;
				tPos += 2;
			}
			tPoints[tPos + 0] = 0;
			tPoints[tPos + 1] = ty;
			tPos += 2;
		}

		points[pPos + 0] = 0;
		points[pPos + 1] = -radius;
		points[pPos + 2] = 0;
		points[pPos + 3] = 0;
		points[pPos + 4] = radius;
		points[pPos + 5] = 0;
		pPos += 6;

		int pS = (div2 - 1) * division;

		float textureDelta = 1.f / 256;
		for (int i = 0; i < division; ++i) {
			tPoints[tPos + 0] = rDiv * (0.5f + i);
			tPoints[tPos + 1] = textureDelta;
			tPos += 2;
		}

		for (int i = 0; i < division; ++i) {
			tPoints[tPos + 0] = rDiv * (0.5f + i);
			tPoints[tPos + 1] = 1 - textureDelta;
			tPos += 2;
		}

		int fIndex = 0;
		for (int y = 0; y < div2 - 2; ++y) {
			for (int x = 0; x < division; ++x) {
				int p0 = y * division + x;
				int p1 = p0 + 1;
				int p2 = p0 + division;
				int p3 = p1 + division;

				int t0 = p0 + y;
				int t1 = t0 + 1;
				int t2 = t0 + division + 1;
				int t3 = t1 + division + 1;

				// add p0, p1, p2
				faces[fIndex + 0] = p0;
				faces[fIndex + 1] = t0;
				faces[fIndex + 2] = p1 % division == 0 ? p1 - division : p1;
				faces[fIndex + 3] = t1;
				faces[fIndex + 4] = p2;
				faces[fIndex + 5] = t2;
				fIndex += 6;

				// add p3, p2, p1
				faces[fIndex + 0] = p3 % division == 0 ? p3 - division : p3;
				faces[fIndex + 1] = t3;
				faces[fIndex + 2] = p2;
				faces[fIndex + 3] = t2;
				faces[fIndex + 4] = p1 % division == 0 ? p1 - division : p1;
				faces[fIndex + 5] = t1;
				fIndex += 6;
			}
		}

		int p0 = pS;
		int tB = (div2 - 1) * (division + 1);
		for (int x = 0; x < division; ++x) {
			int p2 = x, p1 = x + 1, t0 = tB + x;
			faces[fIndex + 0] = p0;
			faces[fIndex + 1] = t0;
			faces[fIndex + 2] = p1 == division ? 0 : p1;
			faces[fIndex + 3] = p1;
			faces[fIndex + 4] = p2;
			faces[fIndex + 5] = p2;
			fIndex += 6;
		}

		p0 = p0 + 1;
		tB = tB + division;
		int pB = (div2 - 2) * division;

		for (int x = 0; x < division; ++x) {
			int p1 = pB + x, p2 = pB + x + 1, t0 = tB + x;
			int t1 = (div2 - 2) * (division + 1) + x, t2 = t1 + 1;
			faces[fIndex + 0] = p0;
			faces[fIndex + 1] = t0;
			faces[fIndex + 2] = p1;
			faces[fIndex + 3] = t1;
			faces[fIndex + 4] = p2 % division == 0 ? p2 - division : p2;
			faces[fIndex + 5] = t2;
			fIndex += 6;
		}

		TriangleMesh m = new TriangleMesh();
		m.getPoints().setAll(points);
		m.getTexCoords().setAll(tPoints);
		m.getFaces().setAll(faces);

		return m;
	}

	public static void main(String[] args) {

		launch(args);
	}

}
