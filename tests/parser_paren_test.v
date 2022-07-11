import parser
import lexer
import ast

struct ParenTest {
	input string
	val   string
}

fn test_paren() {
	tests := [
		ParenTest{
			input: '(!5);'
			val: '(!5)'
		},
		ParenTest{
			input: '(-15);'
			val: '(-15)'
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
		assert stmt.val is ast.ParenExpr
		paren := stmt.val as ast.ParenExpr
		val := paren.val.str()
		assert val == tt.val
	}
}