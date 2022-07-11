import lexer
import token

fn test_let_fn() {
	input := 'let five = 5;
	let ten = 10;

	let add = fn (x, y) {
		x + y;
	};

	let result = add(five, ten);'

	tests := [
		token.Token{
			kind: token.Kind.key_let
			lit: 'let'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'five'
		},
		token.Token{
			kind: token.Kind.equal
			lit: '='
		},
		token.Token{
			kind: token.Kind.number
			lit: '5'
		},
		token.Token{
			kind: token.Kind.semicolon
			lit: ';'
		},
		token.Token{
			kind: token.Kind.key_let
			lit: 'let'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'ten'
		},
		token.Token{
			kind: token.Kind.equal
			lit: '='
		},
		token.Token{
			kind: token.Kind.number
			lit: '10'
		},
		token.Token{
			kind: token.Kind.semicolon
			lit: ';'
		},
		token.Token{
			kind: token.Kind.key_let
			lit: 'let'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'add'
		},
		token.Token{
			kind: token.Kind.equal
			lit: '='
		},
		token.Token{
			kind: token.Kind.key_fn
			lit: 'fn'
		},
		token.Token{
			kind: token.Kind.lparen
			lit: '('
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'x'
		},
		token.Token{
			kind: token.Kind.comma
			lit: ','
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'y'
		},
		token.Token{
			kind: token.Kind.rparen
			lit: ')'
		},
		token.Token{
			kind: token.Kind.lbrace
			lit: '{'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'x'
		},
		token.Token{
			kind: token.Kind.plus
			lit: '+'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'y'
		},
		token.Token{
			kind: token.Kind.semicolon
			lit: ';'
		},
		token.Token{
			kind: token.Kind.rbrace
			lit: '}'
		},
		token.Token{
			kind: token.Kind.semicolon
			lit: ';'
		},
		token.Token{
			kind: token.Kind.key_let
			lit: 'let'
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'result'
		},
		token.Token{
			kind: token.Kind.equal
			lit: '='
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'add'
		},
		token.Token{
			kind: token.Kind.lparen
			lit: '('
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'five'
		},
		token.Token{
			kind: token.Kind.comma
			lit: ','
		},
		token.Token{
			kind: token.Kind.ident
			lit: 'ten'
		},
		token.Token{
			kind: token.Kind.rparen
			lit: ')'
		},
		token.Token{
			kind: token.Kind.semicolon
			lit: ';'
		},
	]

	mut lexer := lexer.new(input)

	for i, tt in tests {
		tok := lexer.next_tok()
		assert tok.kind == tt.kind && tok.lit == tt.lit
	}
}
