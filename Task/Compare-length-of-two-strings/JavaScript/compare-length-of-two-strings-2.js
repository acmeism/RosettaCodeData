<html>

<head>
  <style>
    div {
      margin-top: 4ch;
      margin-bottom: 4ch;
    }

    label {
      display: block;
      margin-bottom: 1ch;
    }

    textarea {
      display: block;
    }

    input {
      display: block;
      margin-top: 4ch;
      margin-bottom: 4ch;
    }
  </style>
</head>

<body>
  <main>
    <form>
      <div>
        <label for="input">Input:
        </label>
        <textarea rows="20" cols="80" id="input"></textarea>
      </div>
      <input type="button" value="press to compare strings" onclick="compareStringsLength(input, output);">
      </input>
      <div>
        <label for="output">Output:
        </label>
        <textarea rows="20" cols="80" id="output"></textarea>
      </div>
    </form>
  </main>
  <script src="stringlensort.js"></script>
</body>

</html>
