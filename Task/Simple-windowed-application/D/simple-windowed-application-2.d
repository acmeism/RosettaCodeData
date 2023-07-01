module SimpleWindow;
import tango.text.convert.Integer;
import tango.core.Thread; // For Thread.yield

import xf.hybrid.Hybrid; //For widgets and general API
import xf.hybrid.backend.GL; // For OpenGL Renderer

void main() {
	//load config file
	scope cfg = loadHybridConfig(`./SimpleWindow.cfg`);
	scope renderer = new Renderer;
	auto counter = 0;

	bool programRunning = true;
	while (programRunning) {
		// Tell Hybrid what config to use
		gui.begin(cfg);
		// Exit program if user clicks the Close button
		if (gui().getProperty!(bool)("main.frame.closeClicked")) {
			programRunning = false;
		}
		// Update text on the label
		if (counter != 0)
			Label("main.label").text = toString(counter);
		// Increment counter if the button has been clicked
		if (Button("main.button").clicked) {
			counter++;
		}
		// Finalize. Prepare to render
		gui.end();
		// Render window using OpenGL Renderer
		gui.render(renderer);

		Thread.yield();
	}
}
