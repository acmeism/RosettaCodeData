use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader, Lines};
use std::process;

// --- Data Structures ---

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum NodeType {
    Ident,
    String,
    Integer,
    Sequence,
    If,
    Prtc,
    Prts,
    Prti,
    While,
    Assign,
    Negate,
    Not,
    Mul,
    Div,
    Mod,
    Add,
    Sub,
    Lss,
    Leq,
    Gtr,
    Geq,
    Eql,
    Neq,
    And,
    Or,
}

#[derive(Debug, Clone)]
struct Tree {
    node_type: NodeType,
    // Use Option<Box<Tree>> for optional, heap-allocated children
    left: Option<Box<Tree>>,
    right: Option<Box<Tree>>,
    // Store index for Ident/String or value for Integer
    value: i32,
}

// --- Global State Holder ---

#[derive(Debug, Default)]
struct InterpreterContext {
    string_pool: Vec<String>,
    global_names: Vec<String>,
    global_values: Vec<i32>,
    // Cache for faster NodeType lookup
    node_type_map: HashMap<String, NodeType>,
}

impl InterpreterContext {
    fn new() -> Self {
        let mut map = HashMap::new();
        // Initialize the map from the static array
        for &(text, node_type) in NODE_TYPE_MAPPING {
            map.insert(text.to_string(), node_type);
        }
        InterpreterContext {
            node_type_map: map,
            ..Default::default()
        }
    }

    // Helper to get NodeType from string using the map
    fn get_node_type(&self, name: &str) -> Option<NodeType> {
        self.node_type_map.get(name).cloned()
    }

    // Look up or add a string to the pool, return its index
    fn fetch_string_offset(&mut self, st_literal: &str) -> Result<usize, String> {
        if !st_literal.starts_with('"') || !st_literal.ends_with('"') {
            return Err(format!("Invalid string literal format: {}", st_literal));
        }
        // Trim quotes
        let inner = &st_literal[1..st_literal.len() - 1];

        // Basic escape sequence handling (\n, \\)
        let mut processed = String::with_capacity(inner.len());
        let mut chars = inner.chars();
        while let Some(c) = chars.next() {
            if c == '\\' {
                match chars.next() {
                    Some('n') => processed.push('\n'),
                    Some('\\') => processed.push('\\'),
                    Some(other) => {
                        // Keep literal backslash and the following char if not recognized escape
                        processed.push('\\');
                        processed.push(other);
                    }
                    None => return Err("String literal ends with dangling '\\'".to_string()),
                }
            } else {
                processed.push(c);
            }
        }

        if let Some(pos) = self.string_pool.iter().position(|s| s == &processed) {
            Ok(pos)
        } else {
            self.string_pool.push(processed);
            Ok(self.string_pool.len() - 1)
        }
    }

    // Look up or add a variable name, return its index
    fn fetch_var_offset(&mut self, name: &str) -> usize {
        if let Some(pos) = self.global_names.iter().position(|n| n == name) {
            pos
        } else {
            self.global_names.push(name.to_string());
            self.global_values.push(0); // Initialize new global variables to 0
            self.global_names.len() - 1
        }
    }
}

// --- Node Creation ---

fn make_node(node_type: NodeType, left: Option<Box<Tree>>, right: Option<Box<Tree>>) -> Box<Tree> {
    Box::new(Tree {
        node_type,
        left,
        right,
        value: 0, // Default value, not used for non-leaf nodes
    })
}

fn make_leaf(node_type: NodeType, value: i32) -> Box<Tree> {
    Box::new(Tree {
        node_type,
        left: None,
        right: None,
        value,
    })
}

// --- Interpreter ---

// Takes context mutably because assignment modifies global_values
fn interp(node: Option<&Box<Tree>>, context: &mut InterpreterContext) -> i32 {
    if node.is_none() {
        return 0; // Interpret null node as 0 or do nothing
    }
    let node = node.unwrap(); // We know it's Some

    match node.node_type {
        NodeType::Integer => node.value,
        NodeType::Ident => {
            // Access global_values using the index stored in node.value
            // Provide a default value (e.g., 0) if index is somehow out of bounds, though fetch_var_offset should prevent this.
             context.global_values.get(node.value as usize).cloned().unwrap_or_else(|| {
                eprintln!("warning: Undefined variable accessed (index {})", node.value);
                0
            })
        }
        NodeType::String => node.value, // Index into string_pool

        NodeType::Assign => {
            // Left child must be an identifier leaf
            let var_index = match node.left {
                Some(ref left_node) if left_node.node_type == NodeType::Ident => left_node.value as usize,
                _ => panic!("Assignment target must be an identifier"),
            };
            let val_to_assign = interp(node.right.as_ref(), context);
            if var_index < context.global_values.len() {
                context.global_values[var_index] = val_to_assign;
            } else {
                 // This should ideally not happen if fetch_var_offset works correctly
                 panic!("Assignment to invalid variable index {}", var_index);
            }
            val_to_assign // Assignment expression evaluates to the assigned value
        }

        // Binary Operators
        NodeType::Add => interp(node.left.as_ref(), context) + interp(node.right.as_ref(), context),
        NodeType::Sub => interp(node.left.as_ref(), context) - interp(node.right.as_ref(), context),
        NodeType::Mul => interp(node.left.as_ref(), context) * interp(node.right.as_ref(), context),
        NodeType::Div => {
            let right_val = interp(node.right.as_ref(), context);
            if right_val == 0 {
                eprintln!("error: Division by zero");
                process::exit(1);
            }
            interp(node.left.as_ref(), context) / right_val
        }
        NodeType::Mod => {
            let right_val = interp(node.right.as_ref(), context);
             if right_val == 0 {
                eprintln!("error: Modulo by zero");
                process::exit(1);
            }
            interp(node.left.as_ref(), context) % right_val
        }
        NodeType::Lss => (interp(node.left.as_ref(), context) < interp(node.right.as_ref(), context)) as i32,
        NodeType::Gtr => (interp(node.left.as_ref(), context) > interp(node.right.as_ref(), context)) as i32,
        NodeType::Leq => (interp(node.left.as_ref(), context) <= interp(node.right.as_ref(), context)) as i32,
        NodeType::Geq => (interp(node.left.as_ref(), context) >= interp(node.right.as_ref(), context)) as i32,
        NodeType::Eql => (interp(node.left.as_ref(), context) == interp(node.right.as_ref(), context)) as i32,
        NodeType::Neq => (interp(node.left.as_ref(), context) != interp(node.right.as_ref(), context)) as i32,
        NodeType::And => (interp(node.left.as_ref(), context) != 0 && interp(node.right.as_ref(), context) != 0) as i32,
        NodeType::Or => (interp(node.left.as_ref(), context) != 0 || interp(node.right.as_ref(), context) != 0) as i32,

        // Unary Operators
        NodeType::Negate => -interp(node.left.as_ref(), context),
        NodeType::Not => (interp(node.left.as_ref(), context) == 0) as i32,

        // Control Flow
        NodeType::If => {
            let condition = interp(node.left.as_ref(), context);
            if condition != 0 {
                // If branch is in right->left
                interp(node.right.as_ref().and_then(|n| n.left.as_ref()), context);
            } else {
                // Else branch is in right->right
                interp(node.right.as_ref().and_then(|n| n.right.as_ref()), context);
            }
            0 // If statement doesn't return a value
        }
        NodeType::While => {
            while interp(node.left.as_ref(), context) != 0 {
                interp(node.right.as_ref(), context);
            }
            0 // While loop doesn't return a value
        }

        // Print Statements
        NodeType::Prtc => {
            let val = interp(node.left.as_ref(), context);
             // Attempt to print as char, handle potential errors
             if let Some(c) = std::char::from_u32(val as u32) {
                 print!("{}", c);
             } else {
                 eprintln!("warning: Prtc value {} cannot be represented as char", val);
             }
            io::Write::flush(&mut io::stdout()).expect("Could not flush stdout");
            0
        }
        NodeType::Prti => {
            print!("{}", interp(node.left.as_ref(), context));
            io::Write::flush(&mut io::stdout()).expect("Could not flush stdout");
            0
        }
         NodeType::Prts => {
            let string_index = interp(node.left.as_ref(), context) as usize;
            if let Some(s) = context.string_pool.get(string_index) {
                print!("{}", s);
                 io::Write::flush(&mut io::stdout()).expect("Could not flush stdout");
            } else {
                 eprintln!("warning: Prts invalid string index {}", string_index);
            }
            0
        }

        // Sequencing
        NodeType::Sequence => {
            interp(node.left.as_ref(), context); // Evaluate left side effect
            interp(node.right.as_ref(), context); // Evaluate right side effect
            0 // Sequence doesn't return a value
        }
    }
}

// --- Parser ---

// Map C enum names to Rust NodeType enum
// Stored statically for efficiency
static NODE_TYPE_MAPPING: &[(&str, NodeType)] = &[
    ("Identifier", NodeType::Ident),
    ("String", NodeType::String),
    ("Integer", NodeType::Integer),
    ("Sequence", NodeType::Sequence),
    ("If", NodeType::If),
    ("Prtc", NodeType::Prtc),
    ("Prts", NodeType::Prts),
    ("Prti", NodeType::Prti),
    ("While", NodeType::While),
    ("Assign", NodeType::Assign),
    ("Negate", NodeType::Negate),
    ("Not", NodeType::Not),
    ("Multiply", NodeType::Mul), // Changed from C
    ("Divide", NodeType::Div),   // Changed from C
    ("Mod", NodeType::Mod),
    ("Add", NodeType::Add),
    ("Subtract", NodeType::Sub), // Changed from C
    ("Less", NodeType::Lss),     // Changed from C
    ("LessEqual", NodeType::Leq),
    ("Greater", NodeType::Gtr),   // Changed from C
    ("GreaterEqual", NodeType::Geq),
    ("Equal", NodeType::Eql),     // Changed from C
    ("NotEqual", NodeType::Neq),
    ("And", NodeType::And),
    ("Or", NodeType::Or),
];

// Helper function to report errors and exit
fn report_error<T>(message: &str) -> Result<T, String> {
    Err(message.to_string())
}


// Recursive function to load the AST from the input lines
fn load_ast<B: BufRead>(
    lines: &mut Lines<B>,
    context: &mut InterpreterContext,
) -> Result<Option<Box<Tree>>, String> {
    match lines.next() {
        None => Ok(None), // End of input
        Some(line_result) => {
            let line = line_result.map_err(|e| format!("IO Error reading line: {}", e))?;
            let trimmed_line = line.trim();

            // Skip comments and empty lines
            if trimmed_line.is_empty() || trimmed_line.starts_with(';') {
                return load_ast(lines, context); // Read next line
            }

            // Split into tokens (NodeType and optional data)
            let mut parts = trimmed_line.splitn(2, ' ');
            let node_type_str = parts.next().ok_or("Line is unexpectedly empty after trim")?;
            let data_part = parts.next().map(|s| s.trim()).filter(|s| !s.is_empty());

            // Get the NodeType enum variant
            let node_type = context
                .get_node_type(node_type_str)
                .ok_or_else(|| format!("Unknown node type token: {}", node_type_str))?;

            // If there's data, it's a leaf node
            if let Some(data) = data_part {
                let value = match node_type {
                    NodeType::Ident => context.fetch_var_offset(data) as i32,
                    NodeType::Integer => data.parse::<i32>()
                                             .map_err(|_| format!("Invalid integer literal: {}", data))?,
                    NodeType::String => context.fetch_string_offset(data)? as i32,
                    _ => return report_error(&format!("Node type '{}' should not have data '{}'", node_type_str, data)),
                };
                Ok(Some(make_leaf(node_type, value)))
            } else {
                 // No data part, so it's an internal node. Recursively load children.
                 // Check arity based on node type
                 match node_type {
                      // Unary operators or control structures needing one child/subtree
                     NodeType::Negate | NodeType::Not | NodeType::Prtc | NodeType::Prti | NodeType::Prts => {
                         let left = load_ast(lines, context)?;
                         Ok(Some(make_node(node_type, left, None)))
                     }
                     // Binary operators or control structures needing two children/subtrees
                     NodeType::Sequence | NodeType::If | NodeType::While | NodeType::Assign |
                     NodeType::Mul | NodeType::Div | NodeType::Mod | NodeType::Add | NodeType::Sub |
                     NodeType::Lss | NodeType::Leq | NodeType::Gtr | NodeType::Geq |
                     NodeType::Eql | NodeType::Neq | NodeType::And | NodeType::Or => {
                         let left = load_ast(lines, context)?;
                         let right = load_ast(lines, context)?;
                         Ok(Some(make_node(node_type, left, right)))
                     }
                     // Leaf node types that were handled above. Error if encountered here.
                     NodeType::Ident | NodeType::String | NodeType::Integer => {
                         report_error(&format!("Leaf node type '{}' found without data", node_type_str))
                     }
                 }
            }
        }
    }
}

// --- Main Function ---

fn main() -> Result<(), String> {
    let args: Vec<String> = env::args().collect();

    // Determine input source: file or stdin
    let input: Box<dyn BufRead> = if args.len() > 1 && !args[1].is_empty() {
        let filename = &args[1];
        let file = File::open(filename)
            .map_err(|e| format!("Cannot open file '{}': {}", filename, e))?;
        Box::new(BufReader::new(file))
    } else {
        Box::new(BufReader::new(io::stdin()))
    };

    let mut lines = input.lines();
    let mut context = InterpreterContext::new();

    // Load the entire AST structure
    let ast_root = load_ast(&mut lines, &mut context)?;

    // Interpret the loaded AST
    interp(ast_root.as_ref(), &mut context);

    println!(); // Add a newline like the C version might implicitly do after last print

    Ok(())
}
