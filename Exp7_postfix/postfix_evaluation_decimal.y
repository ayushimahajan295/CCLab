%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);
%}

/* use double for numeric values */
%union {
    double dval;
}

%token <dval> NUMBER
%type <dval> expr

%%

input:
      /* empty */
    | input line
    ;

line:
      '\n'                     { /* blank, ignore */ }
    | expr '\n'                { printf("%g\n", $1); }
    ;

expr:
      NUMBER                   { $$ = $1; }
    | expr expr '+'            { $$ = $1 + $2; }
    | expr expr '-'            { $$ = $1 - $2; }
    | expr expr '*'            { $$ = $1 * $2; }
    | expr expr '/'            {
                                  if ($2 == 0.0) {
                                      fprintf(stderr, "Error: division by zero\n");
                                      YYABORT;
                                  }
                                  $$ = $1 / $2;
                                }
    | expr expr '%'            {
                                  if ($2 == 0.0) {
                                      fprintf(stderr, "Error: modulo by zero\n");
                                      YYABORT;
                                  }
                                  $$ = fmod($1, $2);
                                }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(void) {
    printf("Enter postfix expressions (one per line). Use Ctrl+Z then Enter on Windows to finish.\n");
    yyparse();
    return 0;
}
