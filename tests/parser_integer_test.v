import parser
import ast
import lexer

fn test_ident() {
	input := '5;'

	mut l := lexer.new(input)
	mut p := parser.new_stream(l)

	mut program := p.parse_program()
	unsafe {
		if program == 0 {
			error('"p.parse_program()" returned nothing.')
		}
	}
	assert p.err_lists().len == 0
	assert program.stmts.len == 1
	assert program.stmts[0] is ast.ExprStmt
	stmt := program.stmts[0] as ast.ExprStmt
	assert stmt.val is ast.Integer
	ident := stmt.val as ast.Integer
	assert ident.val == 5
	assert ident.tok.lit == '5'
}
