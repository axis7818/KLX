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
Brown             return BROWN;
Lightblue         return LIGHTBLUE;
Darkgreen         return DARKGREEN;
Grey              return GREY;
Black             return BLACK;
Darkgrey          return DARKGREY;

Square            return SQUARE;
Triangle          return TRIANGLE;
Circle            return CIRCLE;
Diamond           return DIAMOND;

Anchor            return ANCHOR;

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

\>                return GT;
\>=               return GE;
\<=               return LE;
\<                return LT;
==                return EQ;
!=                return NE;
Not               return NOT;
And               return AND;
Or                return OR;
True              return TRUE;
False             return FALSE;

\+                return PLUS;
\*                return MULT;
\(                return OPAREN;
\)                return CPAREN;
\[                return OBRAC;
\]                return CBRAC;

\-                return SUBTRACT;
\/                return DIVIDE;
\^                return EXPONENT;
\%                return MOD;
,                 return COMMA;

:=                return COLEQUAL;
=                 return EQUAL;
[a-z_]+           {
                     // put the symbol in the lookup table
                     yylval.n = lookup(yytext);
                     if (yylval.n == NULL) {
                        yylval.n = insert(yytext);
                     }
                     return ID;
                  }

If                return IF;
Else              return ELSE;
Elseif            return ELSEIF;
Endif             return ENDIF;
While             return WHILE;
Endwhile          return ENDWHILE;
Proc              return PROC;
Endproc           return ENDPROC;

[[:space:]]       ;
.                 fprintf(stderr, "Unexpected symbol\n");

%%
