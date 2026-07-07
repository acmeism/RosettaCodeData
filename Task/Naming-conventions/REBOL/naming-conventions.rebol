Rebol [
    title: "Rosetta code: Naming conventions"
    file:  %Naming_conventions.r3
    url:   https://rosettacode.org/wiki/Naming_conventions
]

;;-----------------------------------------------------------------------------
;; NAMING CONVENTIONS IN REBOL
;;-----------------------------------------------------------------------------

;; 1. GENERAL STYLE
;;    Rebol uses kebab-case for almost everything.
;;    Underscores and camelCase are valid but uncommon and discouraged.

my-variable: 42
my-function: func [x][x * 2]

;; 2. WORDS (VARIABLES)
;;    Lowercase kebab-case. No sigils required.

counter: 0
max-retries: 5
buffer-size: 1024

;; 3. FUNCTIONS (NATIVE, MEZZANINE, USER-DEFINED)
;;    All use the same kebab-case convention — no distinction in naming between
;;    native (C-level) builtins and user-defined functions.

;; Native (C-level):        append, insert, copy, parse, load, save
;; Mezzanine (Rebol-level): probe, reform, rejoin, repend, to-string
;; User-defined:
greet: func [name [string!]] ["Hello, " name]

;; 4. PREDICATES / BOOLEAN TESTS
;;    Conventionally suffixed with "?" — not enforced, purely by convention.

if empty? ""         [print "empty string"]
if zero? 0           [print "zero value"]
if file? %readme.txt [print "is a file"]

;; User-defined predicate:
prime?: func [
    "Returns true if n is a prime number"
    n [integer!]
][
    if n < 2 [return false]
    for i 2 square-root n 1 [
        if zero? n % i [return false]
    ]
    true
]

;; 5. MUTATING / DESTRUCTIVE FUNCTIONS
;;     No naming convention signals mutation. Instead, the docstring marks
;;     modified arguments with "(modified)".

append: func [
    "Appends a value to the tail of a series"
    series [series!]  "(modified)"
    value  [any-type!]
][...]

;; The standard library follows this pattern throughout:
;;   sort, reverse, insert, remove — all mutate, none use a special suffix.
;;   The spec block's "(modified)" annotation is the agreed signal.

;; 6. CONVERSION FUNCTIONS
;;    Conventionally prefixed with "to-".

to-integer "42"   ;; string -> integer
to-string  42     ;; integer -> string
to-block   "a b"  ;; string -> block

;; 7. DATATYPES
;;    Every datatype name ends with "!" — mandatory, enforced by the language.
;;    This makes type names unambiguous and visually distinct from values.

integer!  string!  block!  map!  word!
pair!     vector!  binary! date! time!
function! object!  port!   url!  file!

;; 8. REFINEMENTS (FUNCTION OPTIONS)
;;    Prefixed with "/" — mandatory syntax, enforced by the parser.
;;    Words that follow "/" in a function call or spec are refinements.

copy/part "hello world" 5       ;; => "hello"
append/only block [1 2 3]       ;; treats [1 2 3] as a single item

;; 9. OBJECTS AND INSTANCES
;;    No formal class system; objects are prototypes made with `make object!`.
;;    Prototype templates conventionally use the "!" suffix, mirroring datatype names.
;;    Instances use plain kebab-case.

point!:  make object! [x: 0  y: 0]
my-point: make point! [x: 3  y: 4]

;; 10. CONSTANTS / ENUMERATIONS
;;     No enforced convention. Common patterns seen in practice:
;;       ALL-CAPS for true constants (borrowed from C, rare)
;;       plain kebab-case (most common, indistinguishable from variables)

max-value: 100          ;; typical
;MAX-VALUE: 100         ;; rare, C-influenced style (valid but unusual)

;; 11. LOCAL / PRIVATE WORDS
;;     Rebol has no access modifiers. "Private" is purely conventional.

;; The standard library itself has no hidden-namespace mechanism.
;; Everything bound in a context is accessible if you hold a reference.

;; 12. SET-WORDS AND GET-WORDS
;;     Assignment uses set-word! syntax (trailing ":").
;;     Retrieval of a word's value without evaluation uses get-word! (leading ":").

x: 10           ;; set-word — assigns 10 to x
:x              ;; get-word — retrieves function/value without calling it

callback: :print  ;; store reference to print without invoking it

;; 13. SYSTEM WORDS AND NAMESPACES
;;     The `system` object holds interpreter internals, accessed via paths.
;;     Convention: system/... path notation for all runtime state.

system/version           ;; Rebol version
system/options/quiet     ;; interpreter flags
system/catalog/datatypes ;; registered types

;; 14. FILE AND URL LITERALS
;;     File paths use the "%" prefix — mandatory syntax.
;;     URLs use scheme prefixes — mandatory syntax.

%readme.txt             ;; file!
%/usr/local/bin/        ;; file! (absolute)
https://rebol.tech      ;; url!

;; 15. SUMMARY TABLE
;;
;;  Pattern          Example                    Enforced?   Convention
;;  ─────────────────────────────────────────────────────────────────────────
;;  kebab-case       my-var, do-thing           No          Universal default
;;  word?            empty?, file?, prime?      No          Predicate hint
;;  word!            integer!, string!, pair!   YES         Datatype names
;;  /refinement      copy/part, sort/skip       YES         Function options
;;  to-type          to-string, to-integer      No          Conversion funcs
;;  system/...       system/version             No          Runtime internals
;;  %path            %file.txt, %/dir/          YES         File literals
;;  https://...      https://rebol.tech         YES         URL literals
;;  :word            :print, :my-func           YES         Get-word (no eval)
;;  word:            x: 10                      YES         Set-word (assign)
