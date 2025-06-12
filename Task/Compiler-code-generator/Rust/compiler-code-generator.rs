// src/main.rs

use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead, BufReader, BufWriter, Write};
use std::path::Path;
use std::process;
use std::error::Error;
use std::fmt;

// --- Custom Error Type ---
#[derive(Debug)]
enum CompileError {
    Io(io::Error),
    Parse(String),
    CodeGen(String),
    Runtime(String), // For potential runtime errors if extended later
}

impl fmt::Display for CompileError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            CompileError::Io(e) => write!(f, "IO Error: {}", e),
            CompileError::Parse(msg) => write!(f, "Parse Error: {}", msg),
            CompileError::CodeGen(msg) => write!(f, "Code Generation Error: {}", msg),
            CompileError::Runtime(msg) => write!(f, "Runtime Error: {}", msg),
        }
    }
}

impl Error for CompileError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            CompileError::Io(e) => Some(e),
            _ => None,
        }
    }
}

// Allow converting io::Error into CompileError
impl From<io::Error> for CompileError {
    fn from(err: io::Error) -> CompileError {
        CompileError::Io(err)
    }
}

// Convenience type alias for Results
type Result<T> = std::result::Result<T, CompileError>;

// --- Enums ---
// Using u8 for Code as in the C code (uchar)
type CodeByte = u8;

// Added derive attributes for convenience
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[repr(u8)] // Explicit representation matching C's implicit enum values
enum NodeType {
    Ident, String, Integer, Sequence, If, Prtc, Prts, Prti, While,
    Assign, Negate, Not, Mul, Div, Mod, Add, Sub, Lss, Leq,
    Gtr, Geq, Eql, Neq, And, Or,
    // Added for parsing unknown types
    Unknown,
}

// Mapping string names to NodeType - replacing get_enum_value C function
fn node_type_from_str(s: &str) -> NodeType {
    match s {
        "Identifier" => NodeType::Ident,
        "String" => NodeType::String,
        "Integer" => NodeType::Integer,
        "Sequence" => NodeType::Sequence,
        "If" => NodeType::If,
        "Prtc" => NodeType::Prtc,
        "Prts" => NodeType::Prts,
        "Prti" => NodeType::Prti,
        "While" => NodeType::While,
        "Assign" => NodeType::Assign,
        "Negate" => NodeType::Negate,
        "Not" => NodeType::Not,
        "Multiply" => NodeType::Mul,
        "Divide" => NodeType::Div,
        "Mod" => NodeType::Mod,
        "Add" => NodeType::Add,
        "Subtract" => NodeType::Sub,
        "Less" => NodeType::Lss,
        "LessEqual" => NodeType::Leq,
        "Greater" => NodeType::Gtr,
        "GreaterEqual" => NodeType::Geq,
        "Equal" => NodeType::Eql,
        "NotEqual" => NodeType::Neq,
        "And" => NodeType::And,
        "Or" => NodeType::Or,
        _ => NodeType::Unknown, // Handle unknown tokens gracefully
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
enum OpCode {
    Fetch, Store, Push, Add, Sub, Mul, Div, Mod, Lt, Gt, Le, Ge, Eq, Ne, And,
    Or, Neg, Not, Jmp, Jz, Prtc, Prts, Prti, Halt,
}

// --- Structs ---
#[derive(Debug, Clone)] // Added Clone for easier handling if needed
struct Tree {
    node_type: NodeType,
    // Use Option<Box<Tree>> for optional children
    left: Option<Box<Tree>>,
    right: Option<Box<Tree>>,
    // Use String for owned string values
    value: Option<String>,
}

impl Tree {
    // Constructor for nodes with children
    fn new_node(node_type: NodeType, left: Tree, right: Tree) -> Box<Tree> {
        Box::new(Tree {
            node_type,
            left: Some(Box::new(left)),
            right: Some(Box::new(right)),
            value: None,
        })
    }

     // Constructor for nodes with children (accepting Option<Box<Tree>>)
     fn new_node_option(node_type: NodeType, left: Option<Box<Tree>>, right: Option<Box<Tree>>) -> Box<Tree> {
        Box::new(Tree {
            node_type,
            left,
            right,
            value: None,
        })
    }


    // Constructor for leaf nodes with a value
    fn new_leaf(node_type: NodeType, value: &str) -> Box<Tree> {
        Box::new(Tree {
            node_type,
            left: None,
            right: None,
            value: Some(value.to_string()),
        })
    }
}

// --- Code Generation State ---
struct CodeGenState {
    object: Vec<CodeByte>, // Replaces da_dim(object, code)
    globals: Vec<String>, // Replaces da_dim(globals, const char *)
    string_pool: Vec<String>, // Replaces da_dim(string_pool, const char *)
    // `here` is implicitly `object.len()`
}

impl CodeGenState {
    fn new() -> Self {
        CodeGenState {
            object: Vec::new(),
            globals: Vec::new(),
            string_pool: Vec::new(),
        }
    }

    // Get current code position
    fn here(&self) -> usize {
        self.object.len()
    }

    // Replaces emit_byte
    fn emit_byte(&mut self, byte: CodeByte) {
        self.object.push(byte);
    }

    // Emit an opcode
    fn emit_opcode(&mut self, opcode: OpCode) {
        self.object.push(opcode as CodeByte);
    }

    // Replaces emit_int - uses little-endian encoding
    fn emit_int(&mut self, value: i32) {
        self.object.extend_from_slice(&value.to_le_bytes());
    }

    // Replaces hole()
    fn emit_hole(&mut self) -> usize {
        let pos = self.here();
        self.emit_int(0); // Placeholder value
        pos
    }

    // Replaces fix() - patches a previous hole
    // Uses little-endian encoding
    fn fix_jump(&mut self, hole_pos: usize, jump_target: usize) -> Result<()> {
        if hole_pos + 4 > self.object.len() {
             return Err(CompileError::CodeGen("Invalid hole position for jump fix".to_string()));
        }
        // Calculate relative offset
        let offset = jump_target as isize - (hole_pos as isize + 4); // offset is from *after* the int
        let offset_bytes = (offset as i32).to_le_bytes();
        self.object[hole_pos..hole_pos + 4].copy_from_slice(&offset_bytes);
        Ok(())
    }

     // Like C's fix, but uses absolute target address for patching data later
     // Use for patching arbitrary data, not jumps
    fn fix_data(&mut self, pos: usize, value: i32) -> Result<()> {
        if pos + 4 > self.object.len() {
            return Err(CompileError::CodeGen("Invalid position for data fix".to_string()));
        }
        let value_bytes = value.to_le_bytes();
        self.object[pos..pos + 4].copy_from_slice(&value_bytes);
         Ok(())
    }


    // Replaces fetch_var_offset
    fn fetch_var_offset(&mut self, id: &str) -> usize {
        if let Some(pos) = self.globals.iter().position(|g| g == id) {
            pos
        } else {
            self.globals.push(id.to_string());
            self.globals.len() - 1
        }
    }

    // Replaces fetch_string_offset
    fn fetch_string_offset(&mut self, st: &str) -> usize {
        if let Some(pos) = self.string_pool.iter().position(|s| s == st) {
            pos
        } else {
            self.string_pool.push(st.to_string());
            self.string_pool.len() - 1
        }
    }

    // Replaces type_to_op
    fn type_to_op(node_type: NodeType) -> Option<OpCode> {
        match node_type {
            NodeType::Negate => Some(OpCode::Neg),
            NodeType::Not => Some(OpCode::Not),
            NodeType::Mul => Some(OpCode::Mul),
            NodeType::Div => Some(OpCode::Div),
            NodeType::Mod => Some(OpCode::Mod),
            NodeType::Add => Some(OpCode::Add),
            NodeType::Sub => Some(OpCode::Sub),
            NodeType::Lss => Some(OpCode::Lt),
            NodeType::Leq => Some(OpCode::Le),
            NodeType::Gtr => Some(OpCode::Gt),
            NodeType::Geq => Some(OpCode::Ge),
            NodeType::Eql => Some(OpCode::Eq),
            NodeType::Neq => Some(OpCode::Ne),
            NodeType::And => Some(OpCode::And),
            NodeType::Or => Some(OpCode::Or),
            _ => None, // Other node types don't map directly to a single opcode
        }
    }

    // --- Code Generator Logic ---
    // Takes Option<&Tree> because some nodes might have absent children
    fn code_gen(&mut self, node: Option<&Tree>) -> Result<()> {
        let node = match node {
            Some(n) => n,
            None => return Ok(()), // Nothing to generate for a None node
        };

        match node.node_type {
            NodeType::Ident => {
                let ident = node.value.as_ref().ok_or_else(|| {
                    CompileError::CodeGen("Identifier node is missing value".to_string())
                })?;
                self.emit_opcode(OpCode::Fetch);
                let offset = self.fetch_var_offset(ident);
                self.emit_int(offset as i32);
            }
            NodeType::Integer => {
                let val_str = node.value.as_ref().ok_or_else(|| {
                    CompileError::CodeGen("Integer node is missing value".to_string())
                })?;
                let value = val_str.parse::<i32>().map_err(|e| {
                    CompileError::Parse(format!("Invalid integer literal '{}': {}", val_str, e))
                })?;
                self.emit_opcode(OpCode::Push);
                self.emit_int(value);
            }
            NodeType::String => {
                let val_str = node.value.as_ref().ok_or_else(|| {
                    CompileError::CodeGen("String node is missing value".to_string())
                })?;
                self.emit_opcode(OpCode::Push);
                let offset = self.fetch_string_offset(val_str);
                self.emit_int(offset as i32);
            }
            NodeType::Assign => {
                let ident_node = node.left.as_ref().ok_or_else(|| {
                     CompileError::CodeGen("Assignment missing identifier (left side)".to_string())
                })?;
                 let ident = ident_node.value.as_ref().ok_or_else(|| {
                    CompileError::CodeGen("Assignment identifier node missing value".to_string())
                })?;
                 if ident_node.node_type != NodeType::Ident {
                     return Err(CompileError::CodeGen("Left side of assignment must be an identifier".to_string()));
                 }

                let var_offset = self.fetch_var_offset(ident);
                self.code_gen(node.right.as_deref())?; // Generate value first
                self.emit_opcode(OpCode::Store);
                self.emit_int(var_offset as i32);
            }
            NodeType::If => {
                // If condition
                self.code_gen(node.left.as_deref())?;
                self.emit_opcode(OpCode::Jz); // Jump if zero (false)
                let jump_over_true_branch_hole = self.emit_hole();

                // True branch (must be present, wrapped in Sequence or single node)
                let if_body = node.right.as_ref().ok_or_else(|| CompileError::CodeGen("If node missing body (right side)".to_string()))?;

                self.code_gen(if_body.left.as_deref())?; // Execute 'then' part

                // Handle optional 'else' part
                let mut jump_over_else_branch_hole: Option<usize> = None;
                if if_body.right.is_some() {
                    self.emit_opcode(OpCode::Jmp); // Jump over the 'else' part
                    jump_over_else_branch_hole = Some(self.emit_hole());
                }

                // Patch the first jump (jz) to point after the 'then' block (or after the 'jmp' if there's an else)
                let after_true_branch = self.here();
                self.fix_jump(jump_over_true_branch_hole, after_true_branch)?;

                // Generate 'else' block if it exists
                if let Some(else_node) = &if_body.right {
                    self.code_gen(Some(else_node))?;
                    // Patch the jump over the else branch
                     let after_else_branch = self.here();
                     if let Some(hole) = jump_over_else_branch_hole {
                          self.fix_jump(hole, after_else_branch)?;
                     } else {
                          // Should not happen if if_body.right was Some
                          return Err(CompileError::CodeGen("Internal error: Missing else jump hole".to_string()));
                     }
                }
            }
            NodeType::While => {
                let condition_start = self.here();
                self.code_gen(node.left.as_deref())?; // While expr
                self.emit_opcode(OpCode::Jz); // If false, jump to end
                let exit_jump_hole = self.emit_hole();

                self.code_gen(node.right.as_deref())?; // Loop body
                self.emit_opcode(OpCode::Jmp); // Jump back to condition
                // Use emit_hole + fix_jump for the backward jump
                let back_jump_hole = self.emit_hole();
                self.fix_jump(back_jump_hole, condition_start)?;

                let after_loop = self.here();
                self.fix_jump(exit_jump_hole, after_loop)?; // Patch the exit jump
            }
            NodeType::Sequence => {
                self.code_gen(node.left.as_deref())?;
                self.code_gen(node.right.as_deref())?;
            }
            NodeType::Prtc => {
                self.code_gen(node.left.as_deref())?;
                self.emit_opcode(OpCode::Prtc);
            }
            NodeType::Prti => {
                self.code_gen(node.left.as_deref())?;
                self.emit_opcode(OpCode::Prti);
            }
            NodeType::Prts => {
                self.code_gen(node.left.as_deref())?;
                self.emit_opcode(OpCode::Prts);
            }
            // Binary Operators
            NodeType::Lss | NodeType::Gtr | NodeType::Leq | NodeType::Geq |
            NodeType::Eql | NodeType::Neq | NodeType::And | NodeType::Or |
            NodeType::Sub | NodeType::Add | NodeType::Div | NodeType::Mul |
            NodeType::Mod => {
                self.code_gen(node.left.as_deref())?;
                self.code_gen(node.right.as_deref())?;
                if let Some(op) = CodeGenState::type_to_op(node.node_type) {
                    self.emit_opcode(op);
                } else {
                    return Err(CompileError::CodeGen(format!(
                        "Cannot map node type {:?} to binary opcode", node.node_type
                    )));
                }
            }
            // Unary Operators
            NodeType::Negate | NodeType::Not => {
                self.code_gen(node.left.as_deref())?;
                 if let Some(op) = CodeGenState::type_to_op(node.node_type) {
                    self.emit_opcode(op);
                } else {
                     return Err(CompileError::CodeGen(format!(
                        "Cannot map node type {:?} to unary opcode", node.node_type
                    )));
                }
            }
            NodeType::Unknown => {
                 return Err(CompileError::CodeGen("Encountered Unknown node type during code generation".to_string()));
            }
        }
        Ok(())
    }

    // Replaces code_finish
    fn code_finish(&mut self) {
        self.emit_opcode(OpCode::Halt);
    }
}


// --- Disassembler ---
// Replaces list_code
// Takes BufWriter for potentially better performance with many writes
fn list_code<W: Write>(state: &CodeGenState, writer: &mut BufWriter<W>) -> Result<()> {
    writeln!(writer, "Datasize: {} Strings: {}", state.globals.len(), state.string_pool.len())?;
    for s in &state.string_pool {
        writeln!(writer, "{}", s)?;
    }
    writeln!(writer, "--- Code ---")?;

    let code = &state.object;
    let mut pc = 0;

    while pc < code.len() {
        let start_pc = pc;
        write!(writer, "{:5} ", start_pc)?;

        // Function to safely read an i32 operand
        let read_operand = |current_pc: usize| -> Result<(i32, usize)> {
            let end_operand = current_pc + 4;
            if end_operand > code.len() {
                Err(CompileError::Runtime("Unexpected end of code while reading operand".to_string()))
            } else {
                 // Read bytes assuming little-endian
                let mut bytes = [0u8; 4];
                bytes.copy_from_slice(&code[current_pc..end_operand]);
                Ok((i32::from_le_bytes(bytes), end_operand))
            }
        };

         // Function to safely read an opcode byte
         let read_opcode_byte = |current_pc: usize| -> Result<(u8, usize)> {
             if current_pc >= code.len() {
                 Err(CompileError::Runtime("Unexpected end of code while reading opcode".to_string()))
             } else {
                 Ok((code[current_pc], current_pc + 1))
             }
         };

        let (opcode_byte, next_pc) = read_opcode_byte(pc)?;
        pc = next_pc; // Move pc past the opcode byte

        // Try to convert byte to OpCode enum
        let opcode: OpCode = unsafe {
             // This is safe IF OpCode is repr(u8) and opcode_byte is a valid variant value.
             // A safer way would be a match statement or a function.
             if opcode_byte <= OpCode::Halt as u8 {
                std::mem::transmute(opcode_byte)
             } else {
                 writeln!(writer, "ERROR: Unknown opcode byte {}", opcode_byte)?;
                 return Err(CompileError::Runtime(format!("Unknown opcode byte: {}", opcode_byte)));
             }
        };


        match opcode {
            OpCode::Fetch => {
                let (operand, next_pc) = read_operand(pc)?; pc = next_pc;
                writeln!(writer, "fetch [{}]", operand)?;
            }
            OpCode::Store => {
                let (operand, next_pc) = read_operand(pc)?; pc = next_pc;
                writeln!(writer, "store [{}]", operand)?;
            }
            OpCode::Push => {
                let (operand, next_pc) = read_operand(pc)?; pc = next_pc;
                writeln!(writer, "push  {}", operand)?;
            }
            OpCode::Add => writeln!(writer, "add")?,
            OpCode::Sub => writeln!(writer, "sub")?,
            OpCode::Mul => writeln!(writer, "mul")?,
            OpCode::Div => writeln!(writer, "div")?,
            OpCode::Mod => writeln!(writer, "mod")?,
            OpCode::Lt => writeln!(writer, "lt")?,
            OpCode::Gt => writeln!(writer, "gt")?,
            OpCode::Le => writeln!(writer, "le")?,
            OpCode::Ge => writeln!(writer, "ge")?,
            OpCode::Eq => writeln!(writer, "eq")?,
            OpCode::Ne => writeln!(writer, "ne")?,
            OpCode::And => writeln!(writer, "and")?,
            OpCode::Or => writeln!(writer, "or")?,
            OpCode::Neg => writeln!(writer, "neg")?,
            OpCode::Not => writeln!(writer, "not")?,
            OpCode::Jmp | OpCode::Jz => {
                let (offset, next_pc) = read_operand(pc)?; pc = next_pc;
                // Calculate absolute target address
                // offset is relative to the instruction *after* the operand
                let target_pc = (pc as isize + offset as isize) as usize;
                let op_str = if opcode == OpCode::Jmp { "jmp" } else { "jz " };
                writeln!(writer, "{}    ({}) {}", op_str, offset, target_pc)?;

            }
            OpCode::Prtc => writeln!(writer, "prtc")?,
            OpCode::Prti => writeln!(writer, "prti")?,
            OpCode::Prts => writeln!(writer, "prts")?,
            OpCode::Halt => {
                writeln!(writer, "halt")?;
                break; // Stop disassembly after HALT
            }
            // The transmute above should prevent reaching here if OpCode is exhaustive
            // _ => {
            //     writeln!(writer, "ERROR: Unknown opcode {}", opcode_byte)?;
            //     return Err(CompileError::Runtime(format!("Unknown opcode byte: {}", opcode_byte)));
            // }
        }
    }
    writer.flush()?; // Ensure buffer is written
    Ok(())
}


// --- AST Loader ---
struct AstLoader<R: BufRead> {
    reader: R,
    line_buffer: String,
}

impl<R: BufRead> AstLoader<R> {
    fn new(reader: R) -> Self {
        AstLoader {
            reader,
            line_buffer: String::new(),
        }
    }

    // Replaces read_line and rtrim
    fn read_next_line(&mut self) -> Result<Option<&str>> {
        self.line_buffer.clear();
        match self.reader.read_line(&mut self.line_buffer)? {
            0 => Ok(None), // EOF
            _ => Ok(Some(self.line_buffer.trim_end())), // Return trimmed line
        }
    }

    // Replaces load_ast (recursive part)
    fn load_ast_recursive(&mut self) -> Result<Option<Box<Tree>>> {
        let line = match self.read_next_line()? {
            Some(l) if !l.is_empty() && !l.starts_with(';') => l,
            Some(_) => return self.load_ast_recursive(), // Skip empty lines or comments
            None => return Ok(None), // End of input
        };

        let mut parts = line.splitn(2, ' '); // Split into token and the rest
        let token = parts.next().ok_or_else(|| CompileError::Parse("Empty line encountered unexpectedly".to_string()))?;
        let maybe_value = parts.next();

        let node_type = node_type_from_str(token);
        if node_type == NodeType::Unknown {
            return Err(CompileError::Parse(format!("Unknown token '{}'", token)));
        }

        // Check if it's a leaf node (has extra data on the same line)
        if let Some(value_part) = maybe_value {
             let trimmed_value = value_part.trim_start();
             if !trimmed_value.is_empty() {
                // It's a leaf node (Identifier, String, Integer)
                match node_type {
                    NodeType::Ident | NodeType::String | NodeType::Integer => {
                       Ok(Some(Tree::new_leaf(node_type, trimmed_value)))
                    }
                    _ => Err(CompileError::Parse(format!(
                        "Node type {:?} unexpectedly found with value '{}' on the same line",
                        node_type, trimmed_value
                    ))),
                }
             } else {
                 // It's an internal node, load children recursively
                 let left = self.load_ast_recursive()?;
                 let right = self.load_ast_recursive()?;
                 Ok(Some(Tree::new_node_option(node_type, left, right)))
             }
        } else {
            // No extra data, must be an internal node with children on subsequent lines
            let left = self.load_ast_recursive()?;
            let right = self.load_ast_recursive()?;
             Ok(Some(Tree::new_node_option(node_type, left, right)))
        }
    }
}


// --- Main Function ---
fn main() {
    if let Err(e) = run() {
        eprintln!("Error: {}", e);
        process::exit(1);
    }
}

fn run() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    let source_filename = args.get(1).map(String::as_str).unwrap_or("");
    let dest_filename = args.get(2).map(String::as_str).unwrap_or("");

    // --- Setup I/O ---
    // Use Box<dyn BufRead> to handle both Stdin and Files
    let source_reader: Box<dyn BufRead> = if source_filename.is_empty() {
        Box::new(BufReader::new(io::stdin()))
    } else {
        let file = File::open(Path::new(source_filename))
            .map_err(|e| CompileError::Io(e))?; // Convert IO error
        Box::new(BufReader::new(file))
    };

    // Use Box<dyn Write> and BufWriter for output
    let dest_writer: Box<dyn Write> = if dest_filename.is_empty() {
        Box::new(io::stdout())
    } else {
        let file = File::create(Path::new(dest_filename))
             .map_err(|e| CompileError::Io(e))?;
        Box::new(file)
    };
    let mut buffered_writer = BufWriter::new(dest_writer);


    // --- Load AST ---
    let mut loader = AstLoader::new(source_reader);
    let ast_root = loader.load_ast_recursive()?;

    // --- Code Generation ---
    let mut state = CodeGenState::new();
    state.code_gen(ast_root.as_deref())?; // Pass reference
    state.code_finish();

    // --- List Code ---
    list_code(&state, &mut buffered_writer)?;

    Ok(())
}
