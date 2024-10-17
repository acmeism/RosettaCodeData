#!/bin/env elixir
# -*- elixir -*-

defmodule Lex do

  def main args do
    {inpf_name, outf_name, exit_status} =
      case args do
        [] -> {"-", "-", 0}
        [name] -> {name, "-", 0}
        [name1, name2] -> {name1, name2, 0}
        [name1, name2 | _] -> {name1, name2, usage_error()}
      end

    {inpf, outf, exit_status} =
      case {inpf_name, outf_name, exit_status} do
        {"-", "-", 0} -> {:stdio, :stdio, 0}
        {name1, "-", 0} ->
          {inpf, exit_status} = open_file(name1, [:read])
          {inpf, :stdio, exit_status}
        {"-", name2, 0} ->
          {outf, exit_status} = open_file(name2, [:write])
          {:stdio, outf, exit_status}
        {name1, name2, 0} ->
          {inpf, exit_status} = open_file(name1, [:read])
          if exit_status != 0 do
            {inpf, name2, exit_status}
          else
            {outf, exit_status} = open_file(name2, [:write])
            {inpf, outf, exit_status}
          end
        _ -> {inpf_name, outf_name, exit_status}
      end

    exit_status =
      case exit_status do
        0 -> main_program inpf, outf
        _ -> exit_status
    end

    # Choose one.
    System.halt exit_status     # Fast exit.
    #System.stop exit_status    # Laborious cleanup.
  end

  def main_program inpf, outf do
    inp = make_inp inpf
    scan_text outf, inp
    exit_status = 0
    exit_status
  end

  def open_file name, rw do
    case File.open name, rw do
      {:ok, f} -> {f, 0}
      _ ->
        IO.write :stderr, "Cannot open "
        IO.write :stderr, name
        case rw do
          [:read] -> IO.puts " for input"
          [:write] -> IO.puts " for output"
        end
        {name, 1}
    end
  end

  def scan_text outf, inp do
    {toktup, inp} = get_next_token inp
    print_token outf, toktup
    case toktup do
      {"End_of_input", _, _, _} -> :ok
      _ -> scan_text outf, inp
    end
  end

  def print_token outf, {tok, arg, line_no, column_no} do
    IO.write outf, (String.pad_leading "#{line_no}", 5)
    IO.write outf, " "
    IO.write outf, (String.pad_leading "#{column_no}", 5)
    IO.write outf, "  "
    IO.write outf, tok
    case tok do
      "Identifier" ->
        IO.write outf, "     "
        IO.write outf, arg
      "Integer" ->
        IO.write outf, "        "
        IO.write outf, arg
      "String" ->
        IO.write outf, "         "
        IO.write outf, arg
      _ -> :ok
    end
    IO.puts outf, ""
  end

###-------------------------------------------------------------------
###
### The token dispatcher.
###

  def get_next_token inp do
    inp = skip_spaces_and_comments inp
    {ch, inp} = get_ch inp
    {chr, line_no, column_no} = ch
    ln = line_no
    cn = column_no
    case chr do
      :eof -> {{"End_of_input", "", ln, cn}, inp}
      "," -> {{"Comma", ",", ln, cn}, inp}
      ";" -> {{"Semicolon", ";", ln, cn}, inp}
      "(" -> {{"LeftParen", "(", ln, cn}, inp}
      ")" -> {{"RightParen", ")", ln, cn}, inp}
      "{" -> {{"LeftBrace", "{", ln, cn}, inp}
      "}" -> {{"RightBrace", "}", ln, cn}, inp}
      "*" -> {{"Op_multiply", "*", ln, cn}, inp}
      "/" -> {{"Op_divide", "/", ln, cn}, inp}
      "%" -> {{"Op_mod", "%", ln, cn}, inp}
      "+" -> {{"Op_add", "+", ln, cn}, inp}
      "-" -> {{"Op_subtract", "-", ln, cn}, inp}
      "<" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "=" -> {{"Op_lessequal", "<=", ln, cn}, inp}
          _ -> {{"Op_less", "<", ln, cn}, (push_back ch1, inp)}
        end
      ">" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "=" -> {{"Op_greaterequal", ">=", ln, cn}, inp}
          _ -> {{"Op_greater", ">", ln, cn}, (push_back ch1, inp)}
        end
      "=" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "=" -> {{"Op_equal", "==", ln, cn}, inp}
          _ -> {{"Op_assign", "=", ln, cn}, (push_back ch1, inp)}
        end
      "!" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "=" -> {{"Op_notequal", "!=", ln, cn}, inp}
          _ -> {{"Op_not", "!", ln, cn}, (push_back ch1, inp)}
        end
      "&" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "&" -> {{"Op_and", "&&", ln, cn}, inp}
          _ -> unexpected_character ln, cn, chr
        end
      "|" ->
        {ch1, inp} = get_ch inp
        {chr1, _, _} = ch1
        case chr1 do
          "|" -> {{"Op_or", "||", ln, cn}, inp}
          _ -> unexpected_character ln, cn, chr
        end
      "\"" ->
        inp = push_back ch, inp
        scan_string_literal inp
      "'" ->
        inp = push_back ch, inp
        scan_character_literal inp
      _ ->
        cond do
          String.match? chr, ~r/^[[:digit:]]$/u ->
            inp = push_back ch, inp
            scan_integer_literal inp
          String.match? chr, ~r/^[[:alpha:]_]$/u ->
            inp = push_back ch, inp
            scan_identifier_or_reserved_word inp
          true -> unexpected_character ln, cn, chr
        end
    end
  end

###-------------------------------------------------------------------
###
### Skipping past spaces and /* ... */ comments.
###
### Comments are treated exactly like a bit of whitespace. They never
### make it to the dispatcher.
###

  def skip_spaces_and_comments inp do
    {ch, inp} = get_ch inp
    {chr, line_no, column_no} = ch
    cond do
      chr == :eof -> push_back ch, inp
      String.match? chr, ~r/^[[:space:]]$/u ->
        skip_spaces_and_comments inp
      chr == "/" ->
        {ch1, inp} = get_ch inp
        case ch1 do
          {"*", _, _} ->
            inp = scan_comment inp, line_no, column_no
            skip_spaces_and_comments inp
          _ -> push_back ch, (push_back ch1, inp)
        end
      true -> push_back ch, inp
    end
  end

  def scan_comment inp, line_no, column_no do
    {ch, inp} = get_ch inp
    case ch do
      {:eof, _, _} -> unterminated_comment line_no, column_no
      {"*", _, _} ->
        {ch1, inp} = get_ch inp
        case ch1 do
          {:eof, _, _} -> unterminated_comment line_no, column_no
          {"/", _, _} -> inp
          _ -> scan_comment inp, line_no, column_no
        end
      _ -> scan_comment inp, line_no, column_no
    end
  end

###-------------------------------------------------------------------
###
### Scanning of integer literals, identifiers, and reserved words.
###
### These three types of token are very similar to each other.
###

  def scan_integer_literal inp do
    # Scan an entire word, not just digits. This way we detect
    # erroneous text such as "23skidoo".
    {line_no, column_no, inp} = get_position inp
    {word, inp} = scan_word inp
    if String.match? word, (~r/^[[:digit:]]+$/u) do
      {{"Integer", word, line_no, column_no}, inp}
    else
      invalid_integer_literal line_no, column_no, word
    end
  end

  def scan_identifier_or_reserved_word inp do
    # It is assumed that the first character is of the correct type,
    # thanks to the dispatcher.
    {line_no, column_no, inp} = get_position inp
    {word, inp} = scan_word inp
    tok =
      case word do
        "if" -> "Keyword_if"
        "else" -> "Keyword_else"
        "while" -> "Keyword_while"
        "print" -> "Keyword_print"
        "putc" -> "Keyword_putc"
        _ -> "Identifier"
      end
    {{tok, word, line_no, column_no}, inp}
  end

  def scan_word inp, word\\"" do
    {ch, inp} = get_ch inp
    {chr, _, _} = ch
    if String.match? chr, (~r/^[[:alnum:]_]$/u) do
      scan_word inp, (word <> chr)
    else
      {word, (push_back ch, inp)}
    end
  end

  def get_position inp do
    {ch, inp} = get_ch inp
    {_, line_no, column_no} = ch
    inp = push_back ch, inp
    {line_no, column_no, inp}
  end

###-------------------------------------------------------------------
###
### Scanning of string literals.
###
### It is assumed that the first character is the opening quote, and
### that the closing quote is the same character.
###

  def scan_string_literal inp do
    {ch, inp} = get_ch inp
    {quote_mark, line_no, column_no} = ch
    {contents, inp} = scan_str_lit inp, ch
    {{"String", quote_mark <> contents <> quote_mark,
      line_no, column_no},
     inp}
  end

  def scan_str_lit inp, ch, contents\\"" do
    {quote_mark, line_no, column_no} = ch
    {ch1, inp} = get_ch inp
    {chr1, line_no1, column_no1} = ch1
    if chr1 == quote_mark do
      {contents, inp}
    else
      case chr1 do
        :eof -> eoi_in_string_literal line_no, column_no
        "\n" -> eoln_in_string_literal line_no, column_no
        "\\" ->
          {ch2, inp} = get_ch inp
          {chr2, _, _} = ch2
          case chr2 do
            "n" -> scan_str_lit inp, ch, (contents <> "\\n")
            "\\" -> scan_str_lit inp, ch, (contents <> "\\\\")
            _ -> unsupported_escape line_no1, column_no1, chr2
          end
        _ -> scan_str_lit inp, ch, (contents <> chr1)
      end
    end
  end

###-------------------------------------------------------------------
###
### Scanning of character literals.
###
### It is assumed that the first character is the opening quote, and
### that the closing quote is the same character.
###
### The tedious part of scanning a character literal is distinguishing
### between the kinds of lexical error. (One might wish to modify the
### code to detect, as a distinct kind of error, end of line within a
### character literal.)
###

  def scan_character_literal inp do
    {ch, inp} = get_ch inp
    {_, line_no, column_no} = ch
    {ch1, inp} = get_ch inp
    {chr1, line_no1, column_no1} = ch1
    {intval, inp} =
      case chr1 do
        :eof -> unterminated_character_literal line_no, column_no
        "\\" ->
          {ch2, inp} = get_ch inp
          {chr2, _, _} = ch2
          case chr2 do
            :eof -> unterminated_character_literal line_no, column_no
            "n" -> {(:binary.first "\n"), inp}
            "\\" -> {(:binary.first "\\"), inp}
            _ -> unsupported_escape line_no1, column_no1, chr2
          end
        _ -> {(:binary.first chr1), inp}
      end
    inp = check_character_literal_end inp, ch
    {{"Integer", "#{intval}", line_no, column_no}, inp}
  end

  def check_character_literal_end inp, ch do
    {chr, _, _} = ch
    {{chr1, _, _}, inp} = get_ch inp
    if chr1 == chr do
      inp
    else
      # Lexical error.
      find_char_lit_end inp, ch
    end
  end

  def find_char_lit_end inp, ch do
    {chr, line_no, column_no} = ch
    {{chr1, _, _}, inp} = get_ch inp
    if chr1 == chr do
      multicharacter_literal line_no, column_no
    else
      case chr1 do
        :eof -> unterminated_character_literal line_no, column_no
        _ -> find_char_lit_end inp, ch
      end
    end
  end

###-------------------------------------------------------------------
###
### Character-at-a-time input, with unrestricted pushback, and with
### line and column numbering.
###

  def make_inp inpf do
    {inpf, [], 1, 1}
  end

  def get_ch {inpf, pushback, line_no, column_no} do
    case pushback do
      [head | tail] ->
        {head, {inpf, tail, line_no, column_no}}
      [] ->
        case IO.read(inpf, 1) do
          :eof ->
            {{:eof, line_no, column_no},
             {inpf, pushback, line_no, column_no}}
          {:error, _} ->
            {{:eof, line_no, column_no},
             {inpf, pushback, line_no, column_no}}
          chr ->
            case chr do
              "\n" ->
                {{chr, line_no, column_no},
                 {inpf, pushback, line_no + 1, 1}}
              _ ->
                {{chr, line_no, column_no},
                 {inpf, pushback, line_no, column_no + 1}}
            end
        end
    end
  end

  def push_back ch, {inpf, pushback, line_no, column_no} do
    {inpf, [ch | pushback], line_no, column_no}
  end

###-------------------------------------------------------------------
###
### Lexical and usage errors.
###

  def unterminated_comment line_no, column_no do
    raise "#{scriptname()}: unterminated comment at #{line_no}:#{column_no}"
  end

  def invalid_integer_literal line_no, column_no, word do
    raise "#{scriptname()}: invalid integer literal #{word} at #{line_no}:#{column_no}"
  end

  def unsupported_escape line_no, column_no, chr do
    raise "#{scriptname()}: unsupported escape \\#{chr} at #{line_no}:#{column_no}"
  end

  def eoi_in_string_literal line_no, column_no do
    raise "#{scriptname()}: end of input in string literal starting at #{line_no}:#{column_no}"
  end

  def eoln_in_string_literal line_no, column_no do
    raise "#{scriptname()}: end of line in string literal starting at #{line_no}:#{column_no}"
  end

  def multicharacter_literal line_no, column_no do
    raise "#{scriptname()}: unsupported multicharacter literal at #{line_no}:#{column_no}"
  end

  def unterminated_character_literal line_no, column_no do
    raise "#{scriptname()}: unterminated character literal starting at #{line_no}:#{column_no}"
  end

  def unexpected_character line_no, column_no, chr do
    raise "#{scriptname()}: unexpected character '#{chr}' at #{line_no}:#{column_no}"
  end

  def usage_error() do
    IO.puts "Usage: #{scriptname()} [INPUTFILE [OUTPUTFILE]]"
    IO.puts "If either of INPUTFILE or OUTPUTFILE is not present or is \"-\","
    IO.puts "standard input or standard output is used, respectively."
    exit_status = 2
    exit_status
  end

  def scriptname() do
    Path.basename(__ENV__.file)
  end

#---------------------------------------------------------------------

end ## module Lex

Lex.main(System.argv)
