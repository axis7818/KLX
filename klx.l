%{
#include "klx.tab.h"
%}

%option noyywrap

%x COMMENT

%%

\/\*              BEGIN(COMMENT);
<COMMENT>(.|\n)   ;
<COMMENT>\*\/     BEGIN(INITIAL);
\/\/.*\n          ;

red               return RED;
orange            return ORANGE;
yellow            return YELLOW;
green             return GREEN;
blue              return BLUE;
purple            return PURPLE;

square            return SQUARE;
triangle          return TRIANGLE;
circle            return CIRCLE;
diamond           return DIAMOND;

at                return AT;
[0-9]*            yylval = atoi(yytext); return NUMBER;

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

[[:space:]]       ;
.                 fprintf(stderr, "Unexpected symbol\n");

%%
