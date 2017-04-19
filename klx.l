%option noyywrap

%x COMMENT

%%

\/\*              BEGIN(COMMENT);
<COMMENT>(.|\n)   ;
<COMMENT>\*\/     BEGIN(INITIAL);
\/\/.*\n          ;

red               return 6;
orange            return 7;
yellow            return 8;
green             return 9;
blue              return 10;
purple            return 11;

square            return 1;
triangle          return 3;
circle            return 4;
diamond           return 5;
,                 return 2;

[[:space:]]       ;
.                 fprintf(stderr, "Unexpected symbol\n");


%%
