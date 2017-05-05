%{
#include "symtab.h"
#include "klx.tab.h"
%}

%option noyywrap

%x COMMENT

%%

\/\*              BEGIN(COMMENT);
<COMMENT>(.|\n)   ;
<COMMENT>\*\/     BEGIN(INITIAL);
\/\/.*\n          ;

Red               return RED;
Orange            return ORANGE;
Yellow            return YELLOW;
Green             return GREEN;
Blue              return BLUE;
Purple            return PURPLE;

Square            return SQUARE;
Triangle          return TRIANGLE;
Circle            return CIRCLE;
Diamond           return DIAMOND;

At                return AT;
[0-9]*            {
                     yylval.i = atoi(yytext); 
                     return NUMBER;
                  }
[0-9]+\.[0-9]*    {
                     yylval.d = atof(yytext);
                     return DOUBLE;
                  }

;                 return SEMICOLON;

\+                return PLUS;
\*                return MULT;
\(                return OPAREN;
\)                return CPAREN;

\-                return SUBTRACT;
\/                return DIVIDE;
\^                return EXPONENT;
\%                return MOD;
,                 return COMMA;

:=                return COLEQUAL;
=                 return EQUAL;
[a-z]+            {
                     // put the symbol in the lookup table
                     yylval.n = lookup(yytext); 
                     if (yylval.n == NULL) 
                        yylval.n = insert(yytext);
                     return ID;
                  }

[[:space:]]       ;
.                 fprintf(stderr, "Unexpected symbol\n");

%%
