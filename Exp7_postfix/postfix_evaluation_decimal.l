%{
#include <stdio.h>
#include <stdlib.h>
#include "postfix_evaluation_decimal.tab.h"   /* produced by: bison -d postfix_eval.y */
%}

%%
-?[0-9][0-9]*\.[0-9][0-9]*    {
                                yylval.dval = atof(yytext);
                                return NUMBER;
                             }
-?[0-9][0-9]*                {
                                yylval.dval = atof(yytext);
                                return NUMBER;
                             }
[ \t]+                      { /* skip spaces and tabs */ }
\n                          { return '\n'; }
"+"                         { return '+'; }
"-"                         { return '-'; }
"*"                         { return '*'; }
"/"                         { return '/'; }
"%"                         { return '%'; }
.                           { /* ignore other characters */ }
%%

int yywrap(void) { return 1; }
