%{
extern int yylval;
%}

%option noyywrap

%x COMMENT

%%

\/\*              BEGIN(COMMENT);
<COMMENT>(.|\n)   ;
<COMMENT>\*\/     BEGIN(INITIAL);
\/\/.*\n          ;

red               return 1;
orange            return 2;
yellow            return 3;
green             return 4;
blue              return 5;
purple            return 6;

square            return 7;
triangle          return 8;
circle            return 9;
diamond           return 10;

at                return 11;
[0-9]*            yylval = atoi(yytext); return 12;

;                 return 13;

\+                return 14;
\*                return 15;
\(                return 16;
\)                return 17;

\-                return 18;
\/                return 19;
\^                return 20;
\%                return 21;
,                 return 22;

[[:space:]]       ;
.                 fprintf(stderr, "Unexpected symbol\n");

%%
