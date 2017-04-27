
all: klx first.ps

lex.yy.c: klx.l
	flex klx.l

klx.tab.c klx.tab.h: klx.y
	bison -d -v -t klx.y

klx: lex.yy.c klx.tab.c klx.tab.h
	gcc lex.yy.c klx.tab.c -o klx

first.ps: klx first.klx
	./klx < first.klx > first.ps

clean:
	rm -f *.ps lex.yy.c klx.tab.* klx
