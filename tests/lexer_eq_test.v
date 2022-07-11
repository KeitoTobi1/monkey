import lexer
import token

fn test_lexer_eq() {
	input := '
	10 == 10
	9 != 10
	'

	tests := [
		token.Token{
			kind: token.Kind.number
			lit: '10'
		},
		token.Token{
			kind: token.Kind.eq
			lit: '=='
		},
		token.Token{
			kind: token.Kind.number
			lit: '10'
		},
		token.Token{
			kind: token.Kind.number
			lit: '9'
		},
		token.Token{
			kind: token.Kind.not_eq
			lit: '!='
		},
		token.Token{
			kind: token.Kind.number
			lit: '10'
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
