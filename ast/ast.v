module ast

import token
import strings

// TODO: ast is Expr only from 0.0.2.
pub type Node = Expr | Stmt

pub type Stmt = Block | EmptyStmt | ExprStmt | LetStmt | NodeError | ReturnStmt | VlangStmt

pub type Expr = EmptyExpr | ParenExpr | Ident | IfExpr | InfixExpr | Integer | PrefixExpr | Symbol

pub struct Block {
pub:
	stmts []Stmt
	tok   token.Token
}

[minify]
pub struct Var {
pub:
	// hash u32
	name string
pub mut:
	expr Expr
}

pub struct Matcher {
pub:
	tok token.Token
}

// TODO: Using to Julia Style Macro System.
pub struct Symbol {
pub:
	// hash u32
	tok token.Token
	lit string
}

pub struct InfixExpr {
pub:
	tok token.Token
	// op Symbol
	op    string
pub mut:
	left  Expr
	right Expr
}

pub fn (ie InfixExpr) sexpr() string {
	return '(' + '$ie.op ' + '$ie.left.tok.lit ' + '$ie.right.tok.lit ' + ')'
}

pub struct PrefixExpr {
pub:
	tok token.Token
	// op Symbol
	op    string
	right Expr
}

pub fn (pe PrefixExpr) sexpr() string {
	return '(' + '$pe.op' + '$pe.right.tok.lit' + ')'
}

pub struct ParenExpr {
pub:
	tok token.Token
	val Expr
}

pub struct IfExpr {
pub:
	// hash u32
	tok token.Token
}

// システムプログラミング的な用途を想定した機能
pub struct VlangStmt {
	// hash u32
	tok    token.Token
	source string
}

pub struct NodeError {
pub:
	// hash u32
	tok token.Token
}

pub struct ExprStmt {
pub:
	// hash u32
	tok token.Token
	val Expr
}

pub fn empty_expr() Expr {
	return EmptyExpr{}
}

/*
pub fn (e Expr) sexpr() string {

}
*/

pub fn (e Expr) str() string {
	match e {
		Ident {
			return e.tok.lit
		}
		Integer {
			return e.tok.lit
		}
		PrefixExpr {
			return '(' + '$e.op' + e.right.str() + ')'
		}
		ParenExpr {
			return '($e.val)'
		}
		InfixExpr {
			return '(' + e.left.str() + ' $e.op ' + e.right.str() + ')'
		}
		else {
			return ' '
		}
	}
}

pub struct EmptyStmt {
pub:
	// hash u32
	tok token.Token
}

pub struct Integer {
pub:
	// hash u32
	tok token.Token
	val i64
}

pub fn (intg Integer) sexpr() string {
	return intg.tok.lit
}

pub fn (intg Integer) str() string {
	return intg.tok.lit
}

pub struct LetStmt {
pub:
	// hash u32
	tok token.Token
	// name &Symbol
	name &Ident
	val  Expr
}

pub fn (ls LetStmt) sexpr() string {
	return '$ls.tok.lit' + ' ' + '$ls.name.tok.lit' + ' = ' + '$ls.val.tok.lit' + ';'
}

pub struct ReturnStmt {
pub mut:
	tok token.Token
	val Expr
}

pub fn (rs ReturnStmt) sexpr() string {
	return '$rs.tok.lit ' + '$rs.val.tok.lit' + ';'
}

pub struct Ident {
pub:
	// hash u32
	tok token.Token
	val string
}

pub struct EmptyExpr {
pub:
	// hash u32
	tok token.Token
	val string
}

pub fn (s Stmt) str() string {
	mut sb := strings.new_builder(50)
	match s {
		LetStmt {
			return '$s.tok.lit ' + '$s.name.tok.lit' + ' = ' + '$s.val.tok.lit' + ';'
		}
		ReturnStmt {
			return '$s.tok.lit ' + '$s.val.tok.lit' + ';'
		}
		ExprStmt {
			return s.val.str()
		}
		else {}
	}

	return sb.str()
}

pub struct Program {
	code_size u64
pub mut:
	stmts []Stmt
}

pub fn (p &Program) str() string {
	mut sb := strings.new_builder(50)
	for program in p.stmts {
		sb.write_string(program.str())
	}

	return sb.str()
}
