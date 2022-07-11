import parser
import lexer
import ast

struct PrefixTest {
	input string
	op    string
	val   i64
}

fn test_prefix_operator() {
	tests := [
		PrefixTest{
			input: '!5;'
			op: '!'
			val: i64(5)
		},
		PrefixTest{
			input: '-15;'
			op: '-'
			val: i64(15)
		}
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
		assert stmt.val is ast.PrefixExpr
		prefix := stmt.val as ast.PrefixExpr
		assert prefix.op == tt.op
		assert prefix.right is ast.Integer
		integer := prefix.right as ast.Integer
		assert integer.val == tt.val
	}
}
