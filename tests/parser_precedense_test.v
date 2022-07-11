import parser
import lexer

struct PrecedensesTest {
	input  string
	output string
}

fn test_precedence() {
	tests := [
		PrecedensesTest{
			input: '-a * b'
			output: '((-a) * b)'
		},
		PrecedensesTest{
			input: '!-a'
			output: '(!(-a))'
		},
		PrecedensesTest{
			input: 'a + b + c'
			output: '((a + b) + c)'
		},
		PrecedensesTest{
			input: 'a + b - c'
			output: '((a + b) - c)'
		},
		PrecedensesTest{
			input: 'a + b / c'
			output: '(a + (b / c))'
		},
		PrecedensesTest{
			input: 'a * b * c'
			output: '((a * b) * c)'
		},
		PrecedensesTest{
			input: 'a * b / c'
			output: '((a * b) / c)'
		},
		PrecedensesTest{
			input: 'a + b * c + d / e - f'
			output: '(((a + (b * c)) + (d / e)) - f)'
		},
		PrecedensesTest{
			input: '3 + 4; -5 * 5'
			output: '(3 + 4)((-5) * 5)'
		},
		PrecedensesTest{
			input: '5 > 4 == 3 < 4'
			output: '((5 > 4) == (3 < 4))'
		},
		PrecedensesTest{
			input: '5 < 4 != 3 > 4'
			output: '((5 > 4) != (3 < 4))'
		},
		PrecedensesTest{
			input: '3 + 4 * 5 == 3 * 1 + 4 * 5'
			output: '((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))'
		},
	]

	for i, tt in tests {
		mut l := lexer.new(tt.input)
		mut p := parser.new_stream(l)
		program := p.parse_program()

		unsafe {
			if program == 0 {
				error('"p.parse_program()" returned nothing.')
			}
		}
		actual := program.str()
		assert actual == tt.output
	}
}
