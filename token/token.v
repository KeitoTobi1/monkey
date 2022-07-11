module token

pub struct Token {
pub mut:
	kind Kind
	lit  string
	// len  int
	// pos  int
	// col  int
}

pub enum Kind {
	__start__
	illegal
	eof
	pipe // |>
	arrow // ->
	logic_decl // :-
	func_decl // :=
	question // ?
	dot
	dotdot
	ident
	number
	equal
	plus
	minus
	increment // ++
	decrement // --
	not // !
	asterisk // *
	slash
	lt
	gt
	eq
	not_eq
	comma
	colon // :
	semicolon // ;
	lparen
	rparen
	lbrace
	rbrace
	lf
	cr
	tab
	key_beg
	key_if
	key_is
	key_as
	key_else
	key_pass
	key_return
	key_true
	key_false
	key_mut
	key_interface
	key_type
	key_fn
	key_let
	key_assert
	key_cons
	key_snoc
	key_end
	__end__
}

pub fn lookup_ident(lit string) Kind {
	if lit in token.keywords {
		return token.keywords[lit]
	}
	return Kind.ident
}

pub enum Precedence {
	lowest
	cond
	equals
	lessgreater
	sum
	product
	prefix
	arrow
	pipe
	call
}

[inline]
pub fn (kind Kind) is_operator() bool {
	return kind in [.plus, .minus, .asterisk, .slash, .eq, .not_eq, .lt, .gt]
}

[inline]
pub fn (kind Kind) is_prefix() bool {
	return kind in [.minus, .not, .lparen]
}

[inline]
pub fn (kind Kind) is_infix() bool {
	return kind in [.plus, .minus, .asterisk, .slash, .eq, .not_eq, .lt, .gt]
}

const precedences = {
	Kind.eq:       Precedence.equals
	Kind.not_eq:   Precedence.equals
	Kind.lt:       Precedence.lessgreater
	Kind.gt:       Precedence.lessgreater
	Kind.plus:     Precedence.sum
	Kind.minus:    Precedence.sum
	Kind.slash:    Precedence.product
	Kind.asterisk: Precedence.product
}

// const keyword_str = build_keys()
const keywords = {
	'if':        Kind.key_if
	'else':      Kind.key_else
	'is':        Kind.key_is
	'as':        Kind.key_as
	'pass':      Kind.key_pass
	'true':      Kind.key_true
	'false':     Kind.key_false
	'return':    Kind.key_return
	'let':       Kind.key_let
	'fn':        Kind.key_fn
	'mut':       Kind.key_mut
	'interface': Kind.key_interface
	'type':      Kind.key_type
	'assert':    Kind.key_assert
	'cons':      Kind.key_cons
	'snoc':      Kind.key_snoc
}

const nr_tokens = int(Kind.__end__)

// TODO: Change to vlang style.
const token_str = build_token_str()

fn build_token_str() []string {
	mut s := []string{len: token.nr_tokens}
	s[Kind.illegal] = 'illegal'
	s[Kind.eof] = 'eof'
	s[Kind.ident] = 'ident'
	s[Kind.number] = 'number'
	s[Kind.eq] = '=='
	s[Kind.not_eq] = '!='
	s[Kind.equal] = '='
	s[Kind.plus] = '+'
	s[Kind.minus] = '-'
	s[Kind.not] = '!'
	s[Kind.asterisk] = '*'
	s[Kind.slash] = '/'
	s[Kind.lt] = '<'
	s[Kind.gt] = '>'
	s[Kind.comma] = ','
	s[Kind.semicolon] = ';'
	s[Kind.lparen] = '('
	s[Kind.rparen] = ')'
	s[Kind.lbrace] = '{'
	s[Kind.rbrace] = '}'
	s[Kind.key_let] = 'let'
	s[Kind.key_mut] = 'mut'
	s[Kind.key_return] = 'return'
	s[Kind.key_if] = 'if'
	s[Kind.key_else] = 'else'

	return s
}

fn build_key() []string {
	mut s := []string{len: token.nr_tokens}
	s[Kind.key_if] = 'if'
	s[Kind.key_else] = 'else'
	s[Kind.key_return] = 'return'
	s[Kind.key_true] = 'true'
	s[Kind.key_false] = 'false'
	s[Kind.key_fn] = 'fn'
	s[Kind.key_let] = 'let'
	s[Kind.key_mut] = 'mut'

	return s
}
