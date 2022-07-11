import parser
import ast
import lexer

fn test_let_stmts() {
	input := '
		let x = 5;
		let y = 10;
		let foobar = 838383;
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

	tests := [
		'x',
		'y',
		'foobar',
	]

	for i, tt in tests {
		mut stmt := program.stmts[i]
		ident_name := tests[i]
		assert stmt is ast.LetStmt
		let := stmt as ast.LetStmt
		assert let.tok.lit == 'let'
		assert let.name.val == ident_name
		assert let.name.tok.lit == ident_name
	}
}
