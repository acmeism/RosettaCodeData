Rebol [
    title: "Rosetta code: Include a file"
    file:  %Include_a_file.r3
    url:   https://rosettacode.org/wiki/Include_a_file
]

;; ─── Named module (from system/options/modules) ───────────────────────────
import blend2d                 ;; searches modules path, caches on first load

;; ─── Module by file path ──────────────────────────────────────────────────
import %path/to/module.reb     ;; header required; module is sandboxed

;; ─── Module by URL ────────────────────────────────────────────────────────
import https://example.com/lib.reb

;; ─── Run a script in current context (no sandboxing) ─────────────────────
do %some-script.reb

;; ─── Run with arguments ───────────────────────────────────────────────────
do/args %some-script.reb [arg1 arg2]

;; ─── Fetch and run from URL ───────────────────────────────────────────────
do https://example.com/script.reb

;; ─── Load without evaluating (returns block) ──────────────────────────────
src: load %some-script.reb

