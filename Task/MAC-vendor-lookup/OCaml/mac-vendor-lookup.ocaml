(* build with ocamlfind ocamlopt -package netclient -linkpkg macaddr.ml -o macaddr *)

open Printf
open Nethttp_client.Convenience
open Unix

(* example vendors, including a nonsense one *)

let vendors = ["FF:FF:FF:67:07:BE"; "D4:F4:6F:C9:EF:8D"; "FC:FB:FB:01:FA:21"; "88:53:2E:67:07:BE"]

let get_vendor addr =
  sleep 3; (* built-in delay to handle rate-limiting at macvendors.com *)

  let client = http_get_message ("http://api.macvendors.com/" ^ addr) in
  match client # response_status_code with
  | 200 -> client # response_body # value
  | 404 -> "N/A"
  | _ -> "NULL"

let rec parse_vendors vendors =
  match vendors with
  | [] -> []
  | hd::tl -> get_vendor hd :: parse_vendors tl

let rec print_vendors vendor_list =
  match vendor_list with
  | [] -> ""
  | hd::tl -> printf "%s\n" hd; print_vendors tl

let main =
  let vendor_list = parse_vendors vendors in
  print_vendors vendor_list
