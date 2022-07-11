import parser
import ast
import lexer

fn test_return_stmt() {
	input := '
		return 5;
		return 10;
		return 993322;
	'

	mut l := lexer.new(input)
	mut p := parser.new_stream(l)

	err := p.err_lists()
	assert err.len == 0

	program := p.parse_program()
	unsafe {
		if program == 0 {
			error('"p.parse_program()" returned nothing.')
		}
	}
	if program.stmts.len != 3 {
		error('"program.stmts" is invalid statements. program.stmts read "$program.stmts.len"?')
	}

	for stmt in program.stmts {
		assert stmt is ast.ReturnStmt
		ret := stmt as ast.ReturnStmt
		assert ret.tok.lit == 'return'
	}
}
