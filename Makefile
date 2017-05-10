
all: klx first 

lex.yy.c: klx.l
	flex klx.l

klx.tab.c klx.tab.h: klx.y
	bison -d -v -t klx.y

klx: lex.yy.c klx.tab.c klx.tab.h symtab.c symtab.h
	gcc lex.yy.c klx.tab.c symtab.c -o klx

clean:
	rm -f *.ps lex.yy.c klx.tab.* klx 

# Specific .klx files 

first: klx input/first.klx
	./klx < input/first.klx > first.ps

variables: klx input/variables.klx
	./klx < input/variables.klx > variables.ps

bad: klx input/bad.klx
	./klx < input/bad.klx > bad.ps

# control: klx input/control.klx
#    ./klx < input/control.klx > control.ps

