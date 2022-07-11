module lexer

import token

// TODO:パーサーのアルゴリズムも変更しなければ。

pub const (
	b_lf        = 13
	b_cr        = 10
	b_tab       = `\t`
	end_of_text = u32(~0)
)

[heap]
pub struct Lexer {
	input string
mut:
	pos      int
	read_pos int
	ch       u8
}

pub fn new(input string) &Lexer {
	mut l := &Lexer{
		input: input
	}
	l.read_char()
	return l
}

pub fn (mut l Lexer) next_tok() token.Token {
	mut tok := token.Token{}

	l.skip_whitespace()

	match l.ch {
		`!` {
			if l.peek_char() == `=` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = token.Token{
					kind: token.Kind.not_eq
					lit: lit
				}
			} else {
				tok = new_tok(token.Kind.not, l.ch)
			}
		}
		`?` {
			tok = new_tok(token.Kind.question, l.ch)
		}
		`=` {
			if l.peek_char() == `=` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = token.Token{
					kind: token.Kind.eq
					lit: lit
				}
			} else {
				tok = new_tok(token.Kind.equal, l.ch)
			}
		}
		`|` {
			if l.peek_char() == `>` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = token.Token{
					kind: token.Kind.pipe
					lit: lit
				}
			} else {
				tok = new_tok(token.Kind.illegal, l.ch)
			}
		}
		`-` {
			if l.peek_char() == `-` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = new_tok(token.Kind.decrement, l.ch)
				tok = token.Token{
					kind: token.Kind.decrement
					lit: lit
				}
			}
			else if l.peek_char() == `>` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = new_tok(token.Kind.arrow, l.ch)
				tok = token.Token{
					kind: token.Kind.arrow
					lit: lit
				}
			}
			else {
				tok = new_tok(token.Kind.minus, l.ch)
			}
		}
		`/` {
			tok = new_tok(token.Kind.slash, l.ch)
		}
		`<` {
			tok = new_tok(token.Kind.lt, l.ch)
		}
		`>` {
			tok = new_tok(token.Kind.gt, l.ch)
		}
		`*` {
			tok = new_tok(token.Kind.asterisk, l.ch)
		}
		`:` {
			if l.peek_char() == `-` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = new_tok(token.Kind.logic_decl, l.ch)
				tok = token.Token{
					kind: token.Kind.logic_decl
					lit: lit
				}
			} 
			else if l.peek_char() == `=` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = new_tok(token.Kind.func_decl, l.ch)
				tok = token.Token{
					kind: token.Kind.func_decl
					lit: lit
				}
			}
			else {
				tok = new_tok(token.Kind.colon, l.ch)
			}
		}
		`;` {
			tok = new_tok(token.Kind.semicolon, l.ch)
		}
		`(` {
			tok = new_tok(token.Kind.lparen, l.ch)
		}
		`)` {
			tok = new_tok(token.Kind.rparen, l.ch)
		}
		`,` {
			tok = new_tok(token.Kind.comma, l.ch)
		}
		`+` {
			// increment added.
			if l.peek_char() == `+` {
				ch := l.ch
				l.read_char()
				lit := ch.ascii_str() + l.ch.ascii_str()
				tok = new_tok(token.Kind.increment, l.ch)
				tok = token.Token{
					kind: token.Kind.increment
					lit: lit
				}
			} else {
				tok = new_tok(token.Kind.plus, l.ch)
			}
		}
		`{` {
			tok = new_tok(token.Kind.lbrace, l.ch)
		}
		`}` {
			tok = new_tok(token.Kind.rbrace, l.ch)
		}
		u8(0) {
			tok = new_tok(token.Kind.eof, l.ch)
		}
		else {
			if l.is_letter(l.ch) {
				tok.lit = l.read_ident()
				tok.kind = token.lookup_ident(tok.lit)
				return tok
			} else if l.is_digit(l.ch) {
				tok.lit = l.read_number()
				tok.kind = token.Kind.number
				return tok
			} else {
				tok = new_tok(token.Kind.illegal, l.ch)
				return tok
			}
		}
	}

	l.read_char()
	return tok
}

fn (mut l Lexer) peek_char() u8 {
	if l.read_pos >= l.input.len {
		return 0
	} else {
		return l.input[l.read_pos]
	}
}

fn (mut l Lexer) check_ident() {
	println('Work In Progress.')
}

fn (mut l Lexer) check_newline() {
	println('Work In Progress.')
}

// TODO: Change to the Code.
fn (mut l Lexer) skip_whitespace() {
	for l.ch == ` ` || l.ch == `\t` || l.ch == `\n` || l.ch == `\r` {
		l.read_char()
	}
}

fn (mut l Lexer) read_ident() string {
	pos := l.pos
	for l.is_letter(l.ch) {
		l.read_char()
	}
	return l.input[pos..l.pos]
}

fn (mut l Lexer) read_number() string {
	pos := l.pos
	for l.is_digit(l.ch) {
		l.read_char()
	}
	return l.input[pos..l.pos]
}

fn (l Lexer) is_letter(ch u8) bool {
	return (`a` <= ch && ch <= `z`) || (`A` <= ch && ch <= `Z`) || (ch == `_`)
}

fn (l Lexer) is_digit(ch u8) bool {
	return `0` <= ch && ch <= `9`
}

fn (mut l Lexer) read_char() {
	if l.read_pos >= l.input.len {
		l.ch = u8(0)
	} else {
		l.ch = l.input[l.read_pos]
	}
	l.pos = l.read_pos
	l.read_pos++
}

pub fn new_tok(kind token.Kind, ch u8) token.Token {
	if ch == u8(0) {
		return token.Token{
			kind: kind
			lit: ''
		}
	} else {
		return token.Token{
			kind: kind
			lit: ch.ascii_str()
		}
	}
}
