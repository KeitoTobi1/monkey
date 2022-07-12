module parser

import ast
import token

fn (mut p Parser) expr(precedence int) ?ast.Expr {
	return p.parse_expr(precedence) or { panic(err) }
}

fn (mut p Parser) is_following_op() bool {
	return p.cur_tok.kind.is_operator()
}

fn (mut p Parser) parse_expr(precedence int) ?ast.Expr {
	println('parse_expr')
	p.expr_level++
	println(p.expr_level)
	if p.expr_level > parser.expr_level_cutoff_limit {
		return error('parse_expr: too many expr levels:$p.expr_level')
	}
	mut leading_expr := ast.empty_expr()
	match p.cur_tok.kind {
		// prefix operator
		.not, .minus {
			println('prefix operetor')
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
	for precedence < p.cur_precedence() {
		if p.cur_tok_is(.semicolon) || p.cur_tok_is(.eof) {
			println('parse_expr: expr end return')
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
	println('infix_expr')
	tok := p.cur_tok
	precedence := p.cur_precedence()
	p.next_tok()
	mut right := p.parse_expr(precedence) or { panic(err) }
	p.expr_level--
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
	println('parse_atom_expr')
	mut expr := ast.empty_expr()
	match p.cur_tok.kind {
		.ident {
			expr = p.parse_ident() or { panic(err) }
			p.expr_level--
			return expr
		}
		.number {
			expr = p.parse_integer() or { panic(err) }
			p.expr_level--
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
	println('parse_ident')
	return ast.Ident{
		tok: &token.Token{
			kind: p.cur_tok.kind
			lit: p.cur_tok.lit
		}
		val: p.cur_tok.lit
	}
}