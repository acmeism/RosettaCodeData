import javax.swing.JFrame

object ShowWindow{
  def main(args: Array[String]){
    var jf = new JFrame("Hello!")

    jf.setSize(800, 600)
    jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
    jf.setVisible(true)
  }
}
