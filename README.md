# KLX

Cameron Taylor

---

4 files:
- .y (yacc)
- .ps (postscript)
- .l (lex)
- .klx (KLX)

make the parser: `bison klx.y`

make the scanner: `flex klx.l`

compile the parser: `gcc lex.yy.c klx.tab.c -o klx`

Run the compiler: `./klx` or `./klx < input.klx > output.ps`
