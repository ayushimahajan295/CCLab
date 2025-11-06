%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* helper to build postfix strings */
char *make_postfix_binary(char *left, char *right, const char *op) {
    size_t len = strlen(left) + 1 + strlen(right) + 1 + strlen(op) + 1; /* spaces + null */
    char *res = (char*)malloc(len);
    if (!res) { fprintf(stderr,"malloc failed\n"); exit(1); }
    /* format: "<left> <right> <op>" */
    snprintf(res, len, "%s %s %s", left, right, op);
    free(left); free(right);
    return res;
}

char *make_postfix_unary_minus(char *operand) {
    /* Implement unary minus as: "0 <operand> -" */
    size_t len = 2 + 1 + strlen(operand) + 1 + 1 + 1; /* "0" + space + operand + space + "-" + null */
    char *res = (char*)malloc(len);
    if (!res) { fprintf(stderr,"malloc failed\n"); exit(1); }
    snprintf(res, len, "0 %s -", operand);
    free(operand);
    return res;
}

void yyerror(const char *s);
int yylex(void);
%}

/* semantic value is string (char*) */
%union {
    char *sval;
}

%token <sval> NUMBER ID
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <sval> expr

%%

input:
      /* empty */
    | input line
    ;

line:
      '\n'                { /* blank line */ }
    | expr '\n'           { printf("%s\n", $1); free($1); }
    ;

expr:
      NUMBER              { $$ = $1; }               /* NUMBER already strdup'd in lexer */
    | ID                  { $$ = $1; }
    | expr '+' expr       { $$ = make_postfix_binary($1, $3, "+"); }
    | expr '-' expr       { $$ = make_postfix_binary($1, $3, "-"); }
    | expr '*' expr       { $$ = make_postfix_binary($1, $3, "*"); }
    | expr '/' expr       { $$ = make_postfix_binary($1, $3, "/"); }
    | '(' expr ')'        { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = make_postfix_unary_minus($2); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(void) {
    printf("Enter infix expressions (one per line). Ctrl+Z then Enter to stop on Windows.\n");
    yyparse();
    return 0;
}
