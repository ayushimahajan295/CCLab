%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

/* declare token and value type */
%union {
    int val;
}
%token <val> NUMBER
%type <val> expr

%%

input:
      /* empty */
    | input line
    ;

line:
      '\n'                     { /* blank line; do nothing */ }
    | expr '\n'                { printf("Result = %d\n", $1); }
    ;

expr:
      NUMBER                   { $$ = $1; }
    | expr expr '+'            { $$ = $1 + $2; }
    | expr expr '-'            { $$ = $1 - $2; }
    | expr expr '*'            { $$ = $1 * $2; }
    | expr expr '/'            {
                                  if ($2 == 0) {
                                      fprintf(stderr, "Error: division by zero\n");
                                      exit(1);
                                  }
                                  $$ = $1 / $2;
                                }
    | expr expr '%'            {
                                  if ($2 == 0) {
                                      fprintf(stderr, "Error: modulo by zero\n");
                                      exit(1);
                                  }
                                  $$ = $1 % $2;
                                }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(void) {
    printf("Enter postfix expressions (one per line). Ctrl+D (Unix) / Ctrl+Z (Windows) to end.\n");
    yyparse();
    return 0;
}
