
all: klx final

lex.yy.c: klx.l
	flex klx.l

klx.tab.c klx.tab.h: klx.y
	bison -d -v -t klx.y

klx: lex.yy.c klx.tab.c klx.tab.h symtab.c symtab.h
	gcc lex.yy.c klx.tab.c symtab.c -o klx

clean:
	rm -f *.ps lex.yy.c klx.tab.* klx

# Specific .klx files

variables: klx variables.klx
	./klx < variables.klx > variables.ps

final: klx final.klx
	./klx < final.klx > final.ps
	ps2pdf final.ps
