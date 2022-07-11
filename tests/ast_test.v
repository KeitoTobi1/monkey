import ast
import token

pub fn test_string() {
	mut program := &ast.Program{
		stmts: []ast.Stmt{}
	}

	program.stmts << ast.LetStmt{
		tok: token.Token{
			kind: token.Kind.key_let
			lit: 'let'
		}
		name: &ast.Ident{
			tok: token.Token{
				kind: token.Kind.ident
				lit: 'my_var'
			}
			val: 'my_var'
		}
		val: &ast.Ident{
			tok: token.Token{
				kind: token.Kind.ident
				lit: 'another_var'
			}
			val: 'another_var'
		}
	}

	println(program.stmts)

	assert program.str() == 'let my_var = another_var;'
}
