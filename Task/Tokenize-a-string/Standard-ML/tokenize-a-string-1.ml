val splitter = String.tokens (fn c => c = #",");
val main = (String.concatWith ".") o splitter;
