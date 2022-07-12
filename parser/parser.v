module parser

import ast
import lexer
import token
import os
import strconv

// TODO: Change to Parser Combinator Base.

const (
	expr_level_cutoff_limit = 40
	stmt_level_cutoff_limit = 40
)


[heap]
struct Parser {
	filename string
mut:
	l        &lexer.Lexer
	prev_tok token.Token
	cur_tok  token.Token
	peek_tok token.Token
	expr_level int
	stmt_level int
	idx_token int
	is_decl   bool
	errors    []string
}

// fn (mut p Parser) expr_list() {}

// parser init.
fn (mut p Parser) init_parser() {
	println('init_parser')
	p.next_tok()
	p.next_tok()
}

pub fn new_file_load(filename string) Parser {
	text := os.read_file(filename) or { panic(err) }
	mut p := Parser{
		filename: filename
		l: lexer.new(text)
		errors: []string{}
	}
	p.init_parser()
	return p
}

pub fn new_stream(l &lexer.Lexer) Parser {
	mut p := Parser{
		filename: 'Stream'
		l: l
		errors: []string{}
	}
	p.init_parser()
	return p
}

fn (mut p Parser) parse_program() &ast.Program {
	mut program := &ast.Program{}
	program.stmts = []ast.Stmt{}

	for p.cur_tok.kind != token.Kind.eof {
		mut stmt := p.parse_stmt() or { return program }
		if stmt is ast.NodeError {
			error('Null Statement Program.')
		} else {
			program.stmts << stmt
		}
		p.next_tok()
	}

	return program
}

pub fn (p &Parser) err_lists() []string {
	return p.errors
}

pub fn (mut p Parser) peek_error(t token.Kind) {
	p.error('Unexpected Token. this not `$t`.')
}

fn (mut p Parser) error(msg string) {
	eprintln(msg)
	exit(1)
}

fn (mut p Parser) next_tok() {
	println('next_tok')
	p.prev_tok = p.cur_tok
	p.cur_tok = p.peek_tok
	p.peek_tok = p.l.next_tok()
	p.idx_token++
}

fn (mut p Parser) parse_stmt() ?ast.Stmt {
	match p.cur_tok.kind {
		.eof {
			return ast.EmptyStmt{
				tok: &token.Token{
					kind: p.cur_tok.kind
					lit: p.cur_tok.lit
				}
			}
		}
		.key_let {
			stmt := p.parse_let_stmt()?
			return stmt
		}
		.key_return {
			stmt := p.parse_return_stmt()?
			return stmt
		}
		else {
			stmt := p.parse_expr_stmt() or {
				return ast.NodeError{
					tok: &token.Token{
						kind: p.cur_tok.kind
						lit: p.cur_tok.lit
					}
				}
			}
			return stmt
		}
	}
}

fn (mut p Parser) delete_comments() {

}

fn (p &Parser) prev_tok_is(t token.Kind) bool {
	return p.prev_tok.kind == t
}

fn (p &Parser) cur_tok_is(t token.Kind) bool {
	return p.cur_tok.kind == t
}

fn (p &Parser) peek_tok_is(t token.Kind) bool {
	return p.peek_tok.kind == t
}

fn (mut p Parser) expect_peek(t token.Kind) bool {
	if p.peek_tok_is(t) {
		p.next_tok()
		return true
	} else {
		p.peek_error(t)
		return false
	}
}

fn (mut p Parser) parse_return_stmt() ?ast.ReturnStmt {
	ret_tok := &token.Token{
		kind: p.cur_tok.kind
		lit: p.cur_tok.lit
	}

	p.next_tok()

	for !p.cur_tok_is(token.Kind.semicolon) {
		p.next_tok()
	}

	stmt := ast.ReturnStmt{
		tok: &token.Token{
			kind: ret_tok.kind
			lit: ret_tok.lit
		}
		val: &ast.Ident{
			tok: p.cur_tok
			val: p.cur_tok.lit
		}
	}

	return stmt
}

fn (p &Parser) prev_precedence() int {
	if p.prev_tok.kind in token.precedences {
		return int(token.precedences[p.cur_tok.kind])
	}
	return 0
}

fn (p &Parser) cur_precedence() int {
	if p.cur_tok.kind in token.precedences {
		return int(token.precedences[p.cur_tok.kind])
	}
	return 0
}

fn (p &Parser) peek_precedence() int {
	if p.peek_tok.kind in token.precedences {
		return int(token.precedences[p.peek_tok.kind])
	}
	return 0
}

fn (mut p Parser) parse_integer() ?ast.Expr {
	if p.cur_tok.kind == .minus {
		mut right := p.cur_tok
		p.next_tok()
		right.lit = right.lit + p.cur_tok.lit
		number := strconv.parse_int(right.lit, 10, 64)?
		return ast.Integer{
			tok: &token.Token{
				kind: p.cur_tok.kind
				lit: right.lit
			}
			val: number
		}
	} else {
		number := strconv.parse_int(p.cur_tok.lit, 10, 64)?
		return ast.Integer{
			tok: &token.Token{
				kind: p.cur_tok.kind
				lit: p.cur_tok.lit
			}
			val: number
		}
	}
}

fn (mut p Parser) parse_expr_stmt() ?ast.ExprStmt {
	expr_tok := &token.Token{
		kind: p.cur_tok.kind
		lit: p.cur_tok.lit
	}

	expr := p.expr(0) or { panic(err) }

	stmt := ast.ExprStmt{
		tok: &token.Token{
			kind: expr_tok.kind
			lit: expr_tok.lit
		}
		val: expr
	}

	if p.peek_tok_is(token.Kind.semicolon) {
		println('parse_expr_stmt:catch the semicolon')
		p.next_tok()
	}
	return stmt
}

fn (mut p Parser) parse_let_stmt() ?ast.LetStmt {
	println('parse_let_stmt')
	let_tok := &token.Token{
		kind: p.cur_tok.kind
		lit: p.cur_tok.lit
	}

	if !p.expect_peek(token.Kind.ident) {
		return error('Invalid Let Statement.')
	}

	name_tok := &token.Token{
		kind: p.cur_tok.kind
		lit: p.cur_tok.lit
	}

	if !p.expect_peek(token.Kind.equal) {
		return error('Invalid Let Statement.')
	}

	// TODO: マニュアル通りならセミコロンが消えるはず

	for !p.cur_tok_is(token.Kind.semicolon) {
		println('parse_let_stmt:catch the semicolon')
		p.next_tok()
	}

	stmt := ast.LetStmt{
		tok: &token.Token{
			kind: let_tok.kind
			lit: let_tok.lit
		}
		name: &ast.Ident{
			tok: name_tok
			val: name_tok.lit
		}
		val: &ast.Ident{
			tok: p.cur_tok
			val: p.cur_tok.lit
		}
	}

	return stmt
}
