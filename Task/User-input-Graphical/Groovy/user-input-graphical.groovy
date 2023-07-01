import javax.swing.JOptionPane

def number = JOptionPane.showInputDialog ("Enter an Integer") as Integer
def string = JOptionPane.showInputDialog ("Enter a String")

assert number instanceof Integer
assert string instanceof String
