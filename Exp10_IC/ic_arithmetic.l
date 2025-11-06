%{
#include "ic_arithmetic.tab.h"
#include <string.h>
%}

%%

[ \t\n]+               ;               /* skip whitespace */
[0-9]+(\.[0-9]+)?      { yylval.sval = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }
"="                    { return '='; }
"("                    { return '('; }
")"                    { return ')'; }
"+"                    { return '+'; }
"-"                    { return '-'; }
"*"                    { return '*'; }
"/"                    { return '/'; }
";"                    { return ';'; }
.                      { return yytext[0]; }

%%
int yywrap(void) { return 1; }
