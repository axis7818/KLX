echo --- flexing ---
flex klx.l
echo --- bison ---
bison klx.y
echo --- compiling ---
gcc lex.yy.c klx.tab.c -o klx

