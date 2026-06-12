import 'dart:io';

class Token {
  dynamic value;
  bool isSequence;

  Token(this.value, this.isSequence);
}

class Sequence {
  List<dynamic> _items = [];

  Sequence([List<dynamic>? items]) {
    if (items != null) {
      _items.addAll(items);
    }
  }

  Sequence.from(List<dynamic> items) {
    _items.addAll(items);
  }

  // Delegate to the internal list
  void add(dynamic item) => _items.add(item);
  void addAll(Iterable<dynamic> items) => _items.addAll(items);
  dynamic operator [](int index) => _items[index];
  void operator []=(int index, dynamic value) => _items[index] = value;
  int get length => _items.length;
  void clear() => _items.clear();
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  @override
  String toString() => _items.toString();
}

class EBNFParser {
  late String src;
  String ch = '';
  int sdx = 0;
  Token? token;
  bool err = false;
  List<String> idents = [];
  List<int> ididx = [];
  List<Sequence> productions = [];
  Sequence extras = Sequence();
  List<String> results = ["pass", "fail"];

  int btoi(bool b) {
    return b ? 1 : 0;
  }

  int invalid(String msg) {
    err = true;
    print(msg);
    sdx = src.length; // set to eof
    return -1;
  }

  void skipSpaces() {
    while (sdx < src.length) {
      ch = src[sdx];
      if (!" \t\r\n".contains(ch)) {
        break;
      }
      sdx++;
    }
  }

  void getToken() {
    // Yields a single character token, one of {}()[]|=.;
    // or {"terminal",string} or {"ident", string} or -1.
    skipSpaces();
    if (sdx >= src.length) {
      token = Token(-1, false);
      return;
    }
    int tokstart = sdx;
    if ("{}()[]|=.;".contains(ch)) {
      sdx++;
      token = Token(ch, false);
    } else if (ch == '"' || ch == "'") {
      String closech = ch;
      int tokend = tokstart + 1;
      while (tokend < src.length && src[tokend] != closech) {
        tokend++;
      }
      if (tokend >= src.length) {
        token = Token(invalid("no closing quote"), false);
      } else {
        sdx = tokend + 1;
        token = Token(Sequence(["terminal", src.substring(tokstart + 1, tokend)]), true);
      }
    } else if (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) {
      // To simplify things for the purposes of this task,
      // identifiers are strictly a-z only, not A-Z or 1-9.
      while (sdx < src.length && ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) {
        sdx++;
        if (sdx < src.length) {
          ch = src[sdx];
        }
      }
      token = Token(Sequence(["ident", src.substring(tokstart, sdx)]), true);
    } else {
      token = Token(invalid("invalid ebnf"), false);
    }
  }

  void matchToken(String expectedCh) {
    if (token!.value != expectedCh) {
      token = Token(invalid("invalid ebnf ($expectedCh expected)"), false);
    } else {
      getToken();
    }
  }

  int addIdent(String ident) {
    int k = idents.indexOf(ident);
    if (k == -1) {
      idents.add(ident);
      k = idents.length - 1;
      ididx.add(-1);
    }
    return k;
  }

  dynamic factor() {
    dynamic res;
    if (token!.isSequence) {
      Sequence t = token!.value as Sequence;
      if (t[0] == "ident") {
        int idx = addIdent(t[1] as String);
        t.add(idx);
        token!.value = t;
      }
      res = token!.value;
      getToken();
    } else if (token!.value == '[') {
      getToken();
      res = Sequence(["optional", expression()]);
      matchToken(']');
    } else if (token!.value == '(') {
      getToken();
      res = expression();
      matchToken(')');
    } else if (token!.value == '{') {
      getToken();
      res = Sequence(["repeat", expression()]);
      matchToken('}');
    } else {
      throw Exception("invalid token in factor() function");
    }
    if (res is Sequence && res.length == 1) {
      return res[0];
    }
    return res;
  }

  dynamic term() {
    Sequence res = Sequence([factor()]);
    List<dynamic> tokens = [-1, '|', '.', ';', ')', ']', '}'];

    outer:
    while (true) {
      for (dynamic t in tokens) {
        if (t == token!.value) {
          break outer;
        }
      }
      res.add(factor());
    }

    if (res.length == 1) {
      return res[0];
    }
    return res;
  }

  dynamic expression() {
    Sequence res = Sequence([term()]);
    if (token!.value == '|') {
      res = Sequence(["or", res[0]]);
      while (token!.value == '|') {
        getToken();
        res.add(term());
      }
    }
    if (res.length == 1) {
      return res[0];
    }
    return res;
  }

  dynamic production() {
    // Returns a token or -1; the real result is left in 'productions' etc,
    getToken();
    if (token!.value != '}') {
      if (token!.value == -1) {
        return invalid("invalid ebnf (missing closing })");
      }
      if (!token!.isSequence) {
        return -1;
      }
      Sequence t = token!.value as Sequence;
      if (t[0] != "ident") {
        return -1;
      }
      String ident = t[1] as String;
      int idx = addIdent(ident);
      getToken();
      matchToken('=');
      if (token!.value == -1) {
        return -1;
      }
      productions.add(Sequence([ident, idx, expression()]));
      ididx[idx] = productions.length - 1;
    }
    return token!.value;
  }

  int parse(String ebnf) {
    // Returns +1 if ok, -1 if bad.
    print("parse:");
    print("$ebnf ===>");
    err = false;
    src = ebnf;
    sdx = 0;
    idents.clear();
    ididx.clear();
    productions.clear();
    extras.clear();

    getToken();
    if (token!.isSequence) {
      Sequence t = token!.value as Sequence;
      t[0] = "title";
      extras.add(token!.value);
      getToken();
    }
    if (token!.value != '{') {
      return invalid("invalid ebnf (missing opening {)");
    }

    while (true) {
      dynamic tokenResult = production();
      if (tokenResult == '}' || tokenResult == -1) {
        break;
      }
    }

    getToken();
    if (token!.isSequence) {
      Sequence t = token!.value as Sequence;
      t[0] = "comment";
      extras.add(token!.value);
      getToken();
    }
    if (token!.value != -1) {
      return invalid("invalid ebnf (missing eof?)");
    }
    if (err) {
      return -1;
    }

    int k = -1;
    for (int i = 0; i < ididx.length; i++) {
      if (ididx[i] == -1) {
        k = i;
        break;
      }
    }
    if (k != -1) {
      return invalid("invalid ebnf (undefined:${idents[k]})");
    }

    pprint(productions, "productions");
    pprint(idents, "idents");
    pprint(ididx, "ididx");
    pprint(extras, "extras");
    return 1;
  }

  // Adjusts Dart's normal printing to look more like Phix output.
  void pprint(dynamic ob, String header) {
    print("\n$header:");
    String pp = ob.toString();
    pp = pp.replaceAll("[", "{");
    pp = pp.replaceAll("]", "}");
    pp = pp.replaceAll(" ", ", ");
    for (int i = 0; i < idents.length; i++) {
      pp = pp.replaceAll(i.toString(), i.toString());
    }
    print(pp);
  }

  // The rules that applies() has to deal with are:
  // {factors} - if rule[0] is not string,
  // just apply one after the other recursively.
  // {"terminal", "a1"}       -- literal constants
  // {"or", <e1>, <e2>, ...}  -- (any) one of n
  // {"repeat", <e1>}         -- as per "{}" in ebnf
  // {"optional", <e1>}       -- as per "[]" in ebnf
  // {"ident", <name>, idx}   -- apply the sub-rule

  bool applies(Sequence rule) {
    int wasSdx = sdx; // in case of failure
    dynamic r1 = rule[0];

    if (r1 is! String) {
      for (int i = 0; i < rule.length; i++) {
        if (!applies(rule[i] as Sequence)) {
          sdx = wasSdx;
          return false;
        }
      }
    } else if (r1 == "terminal") {
      skipSpaces();
      String r2 = rule[1] as String;
      for (int i = 0; i < r2.length; i++) {
        if (sdx >= src.length || src[sdx] != r2[i]) {
          sdx = wasSdx;
          return false;
        }
        sdx++;
      }
    } else if (r1 == "or") {
      for (int i = 1; i < rule.length; i++) {
        if (applies(rule[i] as Sequence)) {
          return true;
        }
      }
      sdx = wasSdx;
      return false;
    } else if (r1 == "repeat") {
      while (applies(rule[1] as Sequence)) {
        // continue repeating
      }
    } else if (r1 == "optional") {
      applies(rule[1] as Sequence);
    } else if (r1 == "ident") {
      int i = rule[2] as int;
      int ii = ididx[i];
      if (!applies(productions[ii][2] as Sequence)) {
        sdx = wasSdx;
        return false;
      }
    } else {
      throw Exception("invalid rule in applies() function");
    }
    return true;
  }

  void checkValid(String test) {
    src = test;
    sdx = 0;
    bool res = applies(productions[0][2] as Sequence);
    skipSpaces();
    if (sdx < src.length) {
      res = false;
    }
    print('"$test", ${results[1 - btoi(res)]}');
  }
}

void main() {
  EBNFParser parser = EBNFParser();

  List<String> ebnfs = [
    '"a" {\n'
    '    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;\n'
    '} "z" ',

    '{\n'
    '    expr = term { plus term } .\n'
    '    term = factor { times factor } .\n'
    '    factor = number | \'(\' expr \')\' .\n'
    ' \n'
    '    plus = "+" | "-" .\n'
    '    times = "*" | "/" .\n'
    ' \n'
    '    number = digit { digit } .\n'
    '    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .\n'
    '}',

    'a = "1"',
    '{ a = "1" ;',
    '{ hello world = "1"; }',
    '{ foo = bar . }'
  ];

  List<List<String>> tests = [
    [
      "a1a3a4a4a5a6",
      "a1 a2a6",
      "a1 a3 a4 a6",
      "a1 a4 a5 a6",
      "a1 a2 a4 a5 a5 a6",
      "a1 a2 a4 a5 a6 a7",
      "your ad here"
    ],
    [
      "2",
      "2*3 + 4/23 - 7",
      "(3 + 4) * 6-2+(4*(4))",
      "-2",
      "3 +",
      "(4 + 3"
    ]
  ];

  for (int i = 0; i < ebnfs.length; i++) {
    if (parser.parse(ebnfs[i]) == 1) {
      print("\ntests:");
      if (i < tests.length) {
        for (String test in tests[i]) {
          parser.checkValid(test);
        }
      }
    }
    print("");
  }
}
