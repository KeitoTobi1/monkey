import lexer
import token

fn test_off_by_one() {
	input := '
	!-/*5;
	5 < 10 > 5
	'

	tests := [
		token.Token{
			kind: token.Kind.not
			lit: '!'
		},
		token.Token{
			kind: token.Kind.minus
			lit: '-'
		},
		token.Token{
			kind: token.Kind.slash
			lit: '/'
		},
		token.Token{
			kind: token.Kind.asterisk
			lit: '*'
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
			kind: token.Kind.gt
			lit: '>'
		},
		token.Token{
			kind: token.Kind.number
			lit: '5'
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
