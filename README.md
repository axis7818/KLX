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

---

## Numbers

In klx.l (need to #include <stdlib> (need to `extern int yylval;`)
`yylval = atoi(yytext); return NUM;`

In klx.y
`MOVE NUMBER NUMBER     { printf("%d %d translate\n", $2, $3); };`

---

implement procedures 
