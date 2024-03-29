%{
#include <stdio.h>
#include "symtab.h"
int yylex();
int yyerror(const char *msg);

void set_color(float r, float g, float b) {
   printf("%f %f %f setrgbcolor\n", r, g, b);
}

%}

%token RED ORANGE YELLOW GREEN BLUE PURPLE BROWN LIGHTBLUE DARKGREEN GREY BLACK DARKGREY
%token SQUARE TRIANGLE CIRCLE DIAMOND

%token ANCHOR AT
%token <i> NUMBER
%token <d> DOUBLE

%token SEMICOLON

%token IF ELSEIF ELSE ENDIF
%token WHILE ENDWHILE

%type  <i> param_list
%type  <i> params
%type  <i> arg_list
%type  <i> args
%token PROC ENDPROC

%token TRUE FALSE
%token GT LT EQ GE LE NE
%token NOT AND OR

%token EXPONENT
%token MULT DIVIDE MOD
%token PLUS SUBTRACT
%token OPAREN CPAREN
%token OBRAC CBRAC
%token COMMA

%token COLEQUAL
%token EQUAL
%token <n> ID

%union { node *n; int i; double d; }

%error-verbose

%%

program: header {
  printf("gsave\n");
} commands trailer;
header: {
   printf("%%!PS\n\n"
          "%%%% Cameron Taylor\n"
          "%%%% Generated by KLX version 0.0\n\n");
};
trailer: {
   printf("\n%%END\n");
};

commands: ;
commands: command SEMICOLON commands;

code_start: {
   scope_open();
   printf("{ 4 dict begin\n");
};

command: IF boolexpr code_start commands {
   printf("} if end\n");
} ENDIF {
   scope_close();
};

command: IF boolexpr code_start commands {
   scope_close();
   scope_open();
   printf(" end } { 4 dict begin \n");
} ELSE commands {
   printf(" end } ifelse\n");
   scope_close();
} ENDIF;

command: WHILE {
   scope_open();
   printf("{ ");
} boolexpr {
   printf("not { exit } if 4 dict begin\n");
} commands {
   printf("end } loop\n");
   scope_close();
} ENDWHILE;

command: ID COLEQUAL expr {
   if ($1->defined) {
     if ($1->level == level) {
       yyerror("redefinition of variable");
     } else {
       node *newN = insert($1->symbol);
       newN->defined = 1;
       newN->level = level;
       printf("/klx_%s exch def\n", newN->symbol);
     }
   } else {
     $1->defined = 1;
     $1->level = level;
     printf("/klx_%s exch def\n", $1->symbol);
   }
}
command: ID EQUAL expr {
   // set a variable that has been declared
   if (!$1->defined) {
      yyerror("undefined symbol, consider := declaration");
   } else {
      printf("/klx_%s exch store\n", $1->symbol);
   }
};

command: ID COLEQUAL PROC {
  scope_open();
  printf("/klx_%s { 4 dict begin \n", $1->symbol);
} OBRAC param_list CBRAC commands {
  printf("end } def\n");
  scope_close();

  if ($1->defined) {
    if ($1->level == level) {
      yyerror("redefinition of procedure");
    } else {
      node *newN = insert($1->symbol);
      newN->defined = 1;
      newN->level = level;
      newN->is_procedure = 1;
    }
  } else {
    $1->defined = 1;
    $1->level = level;
    $1->is_procedure = 1;
  }

  $1->arg_count = $6;
} ENDPROC;

param_list: {
  $$ = 0;
};
param_list: params {
  $$ = $1;
};
params: ID {
  printf("/klx_%s exch def\n", $1->symbol);
  $1->defined = 1;
  $1->level = level;
  $$ = 1;
};
params: ID COMMA params {
  printf("/klx_%s exch def\n", $1->symbol);
  $1->defined = 1;
  $1->level = level;
  $$ = $3 + 1;
};

command: ID OBRAC arg_list CBRAC {
  if (!$1->defined) {
    yyerror("undefined procedure detected");
  } else {
    printf("klx_%s\n", $1->symbol);
  }

  if ($1->arg_count != $3) {
    yyerror("incorrect number of arguments!");
  }
};

arg_list: {
  $$ = 0;
};
arg_list: args {
  $$ = $1;
};
args: expr {
  $$ = 1;
};
args: expr COMMA args {
  $$ = $3 + 1;
};

command: ANCHOR {
  printf("grestore\n");
} location;

command: color geometry location {
   printf("klx_func_geom\n"
          "grestore\n");
};

location: AT OPAREN expr COMMA expr CPAREN {
   printf("gsave\n"
          "translate\n");
};



color: RED { set_color(1.0f, 0.0f, 0.0f); };
color: ORANGE { set_color(1.0f, 0.5f, 0.0f); };
color: YELLOW { set_color(1.0f, 1.0f, 0.0f); };
color: GREEN { set_color(0.0f, 1.0f, 0.0f); };
color: BLUE { set_color(0.0f, 0.0f, 1.0f); };
color: PURPLE { set_color(0.5f, 0.0f, 1.0f); };
color: BROWN { set_color(0.64, 0.42, 0.0); };
color: LIGHTBLUE { set_color(0.13, 0.93, 0.96); };
color: DARKGREEN { set_color(0.06, 0.54, 0.0); };
color: GREY { set_color(0.58, 0.58, 0.58); };
color: BLACK { set_color(0, 0, 0); };
color: DARKGREY { set_color(0.45, 0.45, 0.45); };

geometry: SQUARE {
   printf("/klx_func_geom { newpath 0 0 moveto 0 10 lineto 10 10 lineto "
          "10 0 lineto closepath fill } def\n");
};
geometry: TRIANGLE {
   printf("/klx_func_geom { newpath 0 0 moveto 10 0 lineto 5 10 lineto "
          "closepath fill } def\n");
};
geometry: CIRCLE {
   printf("/klx_func_geom { 5 5 5 0 360 arc closepath fill } def\n");
};
geometry: DIAMOND {
   printf("/klx_func_geom { newpath 5 0 moveto 0 5 lineto 5 10 lineto 10 5 "
          "lineto closepath fill } def\n");
};

boolexpr: boolexpr OR boolands { printf("or "); };
boolexpr: boolands;
boolands: boolands AND boolunary { printf("and "); };
boolands: boolunary;
boolunary: NOT boolatom { printf("not "); };
boolunary: boolatom;

boolatom: expr GT expr { printf("gt "); };
boolatom: expr LT expr { printf("lt "); };
boolatom: expr EQ expr { printf("eq "); };
boolatom: expr GE expr { printf("ge "); };
boolatom: expr LE expr { printf("le "); };
boolatom: expr NE expr { printf("ne "); };
boolatom: OPAREN boolexpr CPAREN;
boolatom: TRUE { printf("true "); };
boolatom: FALSE { printf("false "); };

expr: expr PLUS term { printf("add "); };
expr: expr SUBTRACT term { printf("sub "); };
expr: term;

term: prod EXPONENT term { printf("exp "); };
term: prod;

prod: prod MULT unary { printf("mul "); };
prod: prod DIVIDE unary { printf("div "); };
prod: prod MOD unary { printf("mod "); };
prod: unary;

unary: SUBTRACT atom { printf("neg "); };
unary: PLUS atom;
unary: atom;

atom: NUMBER { printf("%d ", $1); };
atom: DOUBLE { printf("%f ", $1); };
atom: ID {
   if (!$1->defined) {
      // printf("SYMBOL: %s, LEVEL: %d\n", $1->symbol, $1->level);
      yyerror("undefined symbol detected");
   } else {
      printf("klx_%s ", $1->symbol);
   }
};
atom: OPAREN expr CPAREN;

%%

int yyerror(const char *msg) {
   fprintf(stderr, "ERROR: %s\n", msg);
   return 0;
}

int main(void) {
   // yydebug =1;
   yyparse();
   return 0;
}
