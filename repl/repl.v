module repl

// コンパイラ型を想定しているので。
import os
import lexer
import token
import readline

const prompt = '>>:'

pub struct Repl {
}

pub fn start() {
	mut r := readline.Readline{}
	for {
		mut input := r.read_line(repl.prompt) or { exit(1) }
		mut l := lexer.new(input)
		// 冒頭を飛ばしてしまうため。
		mut tok := l.next_tok()
		for tok.kind != token.Kind.eof {
			println('$tok')
			tok = l.next_tok()
		}
	}
}
