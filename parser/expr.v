module parser

import ast
import token

// TODO: Using This Funciton.
fn (mut p Parser) expr(precedence int) ?ast.Expr {
	return p.parse_expr(precedence) or { panic(err) }
}

[deprecated]
fn (mut p Parser) check_expr() ?ast.Expr {
	match p.cur_tok.kind {
		// Prefix Operator.
		.not, .minus {
			return p.prefix_expr() or { panic(err) }
		}
		// Infix Operator.
		.ident {
			return p.parse_ident() or { panic(err) }
		}
		.number {
			return p.parse_integer() or { panic(err) }
		}
		else {
			println('p.prev_tok:$p.prev_tok')
			println('p.cur_tok:$p.cur_tok')
			println('p.peek_tok:$p.peek_tok')
			return error('parser.check_expr: Invalid Expr')
		}
	}
}

fn (mut p Parser) is_following_op() bool {
	return p.cur_tok.kind.is_operator()
}

/*
fn (mut p Parser) parse_expr(precedence int) ?ast.Expr {
	mut expr := if p.is_leading_op() {
		p.prefix_parse()
	} else {
		p.expr_with_left() or { panic(err) }
	}
	for {
		p.next_tok()
		if !p.is_following_op() {
			return expr
		}

		expr = {
			// 後続演算子のパース
		}
	}
}
*/

fn (mut p Parser) parse_expr(precedence int) ?ast.Expr {
	println('parse_expr')
	mut leading_expr := ast.empty_expr()
	match p.cur_tok.kind {
		// prefix operator
		.not, .minus {
			p.next_tok()
			leading_expr = p.prefix_expr() or { panic(err) }
		}
		// paren operator
		.lparen {
			println('Catch The .lparen')
			p.next_tok()
			val := p.parse_expr(0) or { panic(err) }
			if p.cur_tok.kind == .rparen {
				println('Catch The .rparen')
				leading_expr = ast.ParenExpr {
					tok: p.cur_tok
					val: val
				}
				p.next_tok()
				return leading_expr
			}
		}
		else {
			leading_expr = p.parse_atom_expr() or { panic(err) }
		}
	}

	return p.expr_with_left(leading_expr, p.cur_precedence())
}

fn (mut p Parser) expr_with_left(left ast.Expr, precedence int) ?ast.Expr {
	println('postfix & infix')
	println('p.prev_tok:$p.prev_tok')
	println('p.cur_tok:$p.cur_tok')
	println('p.peek_tok:$p.peek_tok')
	println('precedence:$precedence')
	println('peek_precedence:$p.peek_precedence()')
	println(p.peek_precedence() < precedence)
	mut node := left
	p.next_tok()
	for {
		if p.cur_tok_is(.semicolon) || p.cur_tok_is(.eof) {
			println('parse_expr: expr end return')
			return node
		}

		if p.cur_precedence() < precedence {
			println('parse_expr: precedence return')
			return node
		}

		if p.cur_tok.kind.is_infix() {
			println('parse_expr:peek_is_infix')
			tok := p.cur_tok
			node = p.infix_expr(node) or { panic(err) }
		} else {
			println('parse_expr:not_infix')
			return node
		}
	}
	return node
}

fn (mut p Parser) infix_expr(left ast.Expr) ?ast.Expr {
	tok := p.cur_tok
	precedence := p.cur_precedence()
	p.next_tok()
	mut right := p.parse_expr(precedence) or { panic(err) }
	return ast.InfixExpr {
		tok: tok
		op: tok.lit
		left: left
		right: right
	}
}

fn (mut p Parser) prefix_expr() ?ast.Expr {
	mut val := p.prev_tok
	match p.cur_tok.kind {
		.not, .minus {
			right := p.prefix_expr() or { panic(err) }
			return ast.PrefixExpr{
				tok: val
				op: val.lit
				right: right
			}
		}
		.ident {
			right := p.parse_ident() or { panic(err) }
			return ast.PrefixExpr{
				tok: val
				op: val.lit
				right: right
			}
		}
		.number {
			right := p.parse_integer() or { panic(err) }
			return ast.PrefixExpr{
				tok: val
				op: val.lit
				right: right
			}
		}
		else {
			println(p.cur_tok)
			println(p.peek_tok)
			return error('parser.prefix_expr: Invalid Prefix Expr.')
		}
	}
}

fn (mut p Parser) parse_atom_expr() ?ast.Expr {
	mut expr := ast.empty_expr()
	match p.cur_tok.kind {
		.ident {
			expr = p.parse_ident() or { panic(err) }
			return expr
		}
		.number {
			expr = p.parse_integer() or { panic(err) }
			return expr
		}
		else {
			println('p.prev_tok:$p.prev_tok')
			println('p.cur_tok:$p.cur_tok')
			println('p.peek_tok:$p.peek_tok')
			return error('parser.parse_atom_expr: Invalid Atomic Expr')
		}
	}
}

fn (mut p Parser) parse_ident() ?ast.Expr {
	return ast.Ident{
		tok: &token.Token{
			kind: p.cur_tok.kind
			lit: p.cur_tok.lit
		}
		val: p.cur_tok.lit
	}
}