import javax.swing {
	JFrame,
	JLabel,
	Timer
}
import java.awt.event {
	MouseAdapter,
	MouseEvent,
	ActionListener,
	ActionEvent
}

shared void run() {
 	value initialText = "Hello World! ";
 	value label = JLabel(initialText);
	variable value forward = true;
	label.addMouseListener(object extends MouseAdapter() {
        	mouseClicked(MouseEvent? mouseEvent) =>
                	forward = !forward;
	});

	Timer(1k, object satisfies ActionListener {
		shared actual void actionPerformed(ActionEvent? actionEvent) {
			String left;
			String right;
			if(forward) {
				left = label.text.last?.string else "?";
				right = "".join(label.text.exceptLast);
			} else {
				left = label.text.rest;
				right = label.text.first?.string else "?";
			}
			label.text = left + right;
		}
	}).start();
	
	value frame = JFrame();
	frame.defaultCloseOperation = JFrame.\iEXIT_ON_CLOSE;
	frame.title = "Rosetta Code Animation Example";
	frame.add(label);
	frame.pack();
	frame.visible = true;
}
