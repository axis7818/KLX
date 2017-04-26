echo --- flex ---
flex klx.l
echo --- bison ---
bison klx.y
echo --- compile ---
gcc lex.yy.c klx.tab.c -o klx
