%{
#include "ic_constructs.tab.h"
#include <string.h>
%}

%%

[ \t\r\n]+               ;    /* skip whitespace */
"if"                     { return IF; }
"else"                   { return ELSE; }
"while"                  { return WHILE; }
"("                      { return '('; }
")"                      { return ')'; }
"{"                      { return '{'; }
"}"                      { return '}'; }
"="                      { return '='; }
"=="                     { return EQ; }
"!="                     { return NEQ; }
"<="                     { return LE; }
">="                     { return GE; }
"<"                      { return '<'; }
">"                      { return '>'; }
"+"                      { return '+'; }
"-"                      { return '-'; }
"*"                      { return '*'; }
"/"                      { return '/'; }
";"                      { return ';'; }
[0-9]+(\.[0-9]+)?        { yylval.sval = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.sval = strdup(yytext); return ID; }
.                        { return yytext[0]; }

%%
int yywrap(void) { return 1; }
