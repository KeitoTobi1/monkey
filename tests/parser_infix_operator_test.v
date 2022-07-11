import parser
import lexer
import ast

struct InfixTest {
	input string
	op    string
	left  i64
	right i64
}

fn test_infix_operator() {
	tests := [
		InfixTest{
			input: '5 + 5;'
			op: '+'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 - 5;'
			op: '-'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 * 5;'
			op: '*'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 / 5;'
			op: '/'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 > 5;'
			op: '>'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 < 5;'
			op: '<'
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 == 5;'
			op: '=='
			left: i64(5)
			right: i64(5)
		},
		InfixTest{
			input: '5 != 5;'
			op: '!='
			left: i64(5)
			right: i64(5)
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
		assert p.err_lists().len == 0
		assert program.stmts.len == 1
		assert program.stmts[0] is ast.ExprStmt
		stmt := program.stmts[0] as ast.ExprStmt
		assert stmt.val is ast.InfixExpr
		infix := stmt.val as ast.InfixExpr
		assert infix.op == tt.op
		assert infix.left is ast.Integer
		assert infix.right is ast.Integer
	}
}
