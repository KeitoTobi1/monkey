import lexer
import token

fn test_keyword() {
	input := ' 
	if (5 < 10) {
		return true;
	} else {
		return false;
	}
	'

	tests := [
		token.Token{
			kind: token.Kind.key_if
			lit: 'if'
		},
		token.Token{
			kind: token.Kind.lparen
			lit: '('
		},
		token.Token{
			kind: token.Kind.number
			lit: '5'
		},
		token.Token{
			kind: token.Kind.lt
			lit: '<'
		},
		token.Token{
			kind: token.Kind.number
			lit: '10'
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
			kind: token.Kind.key_return
			lit: 'return'
		},
		token.Token{
			kind: token.Kind.key_true
			lit: 'true'
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
			kind: token.Kind.key_else
			lit: 'else'
		},
		token.Token{
			kind: token.Kind.lbrace
			lit: '{'
		},
		token.Token{
			kind: token.Kind.key_return
			lit: 'return'
		},
		token.Token{
			kind: token.Kind.key_false
			lit: 'false'
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
			kind: token.Kind.eof
			lit: ''
		},
	]

	mut lexer := lexer.new(input)

	for i, tt in tests {
		tok := lexer.next_tok()
		assert tok.kind == tt.kind
		assert tok.lit == tt.lit
	}
}
