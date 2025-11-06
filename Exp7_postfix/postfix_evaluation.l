%{
#include <stdio.h>
#include <stdlib.h>
#include "postfix_evaluation.tab.h"   /* for token NUMBER and yylval */
%}

/* macros */
DIGIT   [0-9]
WS      [ \t\r]+

%%
{WS}                    ;                   /* skip spaces/tabs */
\n                      { return '\n'; }    /* end of one postfix expression */
"+"|"-"|"*"|"/"|"%"     { return yytext[0]; }
{DIGIT}+                { yylval.val = atoi(yytext); return NUMBER; }
.                       { /* ignore any other char */ }
%%

int yywrap(void) { return 1; }
