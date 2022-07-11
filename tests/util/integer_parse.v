module util

import ast

fn check_integer_literal(expr ast.Expr, val i64) bool {
	if expr !is ast.Integer {
		return false
	}

	integer := expr as ast.Integer

	if integer.val != val {
		return false
	}

	if integer.tok.lit != str(val) {
		return false
	}

	return true
}
