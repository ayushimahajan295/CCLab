%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "infix2postfix.tab.h"   /* produced by: bison -d infix2postfix.y */
%}

/* macros */
DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*
WS      [ \t]+

%%

{DIGIT}+        { yylval.sval = strdup(yytext); return NUMBER; }
{ID}            { yylval.sval = strdup(yytext); return ID; }

{WS}            { /* skip whitespace */ }
\n              { return '\n'; }

"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }

.               { /* ignore any other character */ }
%%

int yywrap(void) { return 1; }
