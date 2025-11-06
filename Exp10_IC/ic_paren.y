%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

static int temp_count = 0;

char *new_temp() {
    char buf[32];
    sprintf(buf, "t%d", ++temp_count);
    return strdup(buf);
}
%}

%union {
    char *sval;
}

%token <sval> ID NUM
%type  <sval> E stmt

/* precedence: * and / higher than + and -, unary minus highest (right-assoc) */
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program:
    stmt_list
    ;

stmt_list:
      /* empty */
    | stmt_list stmt
    ;

stmt:
    ID '=' E ';'   {
                      printf("%s = %s\n", $1, $3);
                      free($1); free($3);
                   }
  | E ';'          { free($1); }   /* expression statement */
  ;

E:
    E '+' E   {
                  char *t = new_temp();
                  printf("%s = %s + %s\n", t, $1, $3);
                  $$ = t;
                  free($1); free($3);
              }
  | E '-' E   {
                  char *t = new_temp();
                  printf("%s = %s - %s\n", t, $1, $3);
                  $$ = t;
                  free($1); free($3);
              }
  | E '*' E   {
                  char *t = new_temp();
                  printf("%s = %s * %s\n", t, $1, $3);
                  $$ = t;
                  free($1); free($3);
              }
  | E '/' E   {
                  char *t = new_temp();
                  printf("%s = %s / %s\n", t, $1, $3);
                  $$ = t;
                  free($1); free($3);
              }
  | '(' E ')' { $$ = $2; }               /* parentheses: pass inner place up */
  | '-' E %prec UMINUS {
                  char *t = new_temp();
                  printf("%s = 0 - %s\n", t, $2);
                  $$ = t;
                  free($2);
              }
  | ID        { $$ = $1; }
  | NUM       { $$ = $1; }
  ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Enter statements (end with EOF). Example: a = (b + c) * (d - 2);\n");
    yyparse();
    return 0;
}
