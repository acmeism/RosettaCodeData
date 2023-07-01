shared void run() {print(let (x = """shared void run() {print(let (x = $) x.replaceFirst("$", "\"\"\"" + x + "\"\"\""));}""") x.replaceFirst("$", "\"\"\"" + x + "\"\"\""));}
