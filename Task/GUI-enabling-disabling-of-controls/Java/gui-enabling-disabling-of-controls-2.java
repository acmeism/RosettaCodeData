import javafx.application.Application;
import javafx.beans.property.LongProperty;
import javafx.beans.property.SimpleLongProperty;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.util.converter.NumberStringConverter;

public class InteractFX extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage stage) throws Exception {

        TextField input = new TextField("0"){
            // only accept numbers as input
            @Override public void replaceText(int start, int end, String text) {
                if (text.matches("[0-9]*")) {
                    super.replaceText(start, end, text);
                }
            }

            // only accept numbers on copy+paste
            @Override public void replaceSelection(String text) {
                if (text.matches("[0-9]*")) {
                    super.replaceSelection(text);
                }
            }
        };

        // when the textfield is empty, replace text with "0"
        input.textProperty().addListener((observable, oldValue, newValue)->{
            if(newValue == null || newValue.trim().isEmpty()){
                input.setText("0");
            }
        });


        // get a bi-directional bound long-property of the input value
        LongProperty inputValue = new SimpleLongProperty();
        input.textProperty().bindBidirectional(inputValue, new NumberStringConverter());

        // textfield is disabled when the current value is other than "0"
        input.disableProperty().bind(inputValue.isNotEqualTo(0));


        Button increment = new Button("Increment");
        increment.setOnAction(event-> inputValue.set(inputValue.get() + 1));

        // incr-button is disabled when input is >= 10
        increment.disableProperty().bind(inputValue.greaterThanOrEqualTo(10));


        Button decrement = new Button("Decrement");
        decrement.setOnAction(event-> inputValue.set(inputValue.get() - 1));

        // decrement button is disabled when input is <=0
        decrement.disableProperty().bind(inputValue.lessThanOrEqualTo(0));


        // layout
        VBox root = new VBox();
        root.getChildren().add(input);
        HBox buttons = new HBox();
        buttons.getChildren().addAll(increment,decrement);
        root.getChildren().add(buttons);

        stage.setScene(new Scene(root));
        stage.sizeToScene();
        stage.show();
    }
}
