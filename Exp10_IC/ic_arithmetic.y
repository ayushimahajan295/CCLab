%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

static int temp_count = 0;

/* create new temporary name like t1, t2, ... */
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
%type <sval> E stmt

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
      ID '=' E ';'    {
                        /* assignment: $1 is ID name; $3 is place (temp/var/number) */
                        printf("%s = %s\n", $1, $3);
                        free($1);
                        free($3);
                      }
    | E ';'           { /* expression statement — result already generated in E actions */
                        free($1);
                      }
    ;

E:
      E '+' E         {
                        char *t = new_temp();
                        printf("%s = %s + %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                      }
    | E '-' E         {
                        char *t = new_temp();
                        printf("%s = %s - %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                      }
    | E '*' E         {
                        char *t = new_temp();
                        printf("%s = %s * %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                      }
    | E '/' E         {
                        char *t = new_temp();
                        printf("%s = %s / %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                      }
    | '(' E ')'       { $$ = $2; }    /* pass through */
    | '-' E %prec UMINUS {
                        /* unary minus: t = 0 - E */
                        char *t = new_temp();
                        printf("%s = 0 - %s\n", t, $2);
                        $$ = t;
                        free($2);
                      }
    | ID              { $$ = $1; }     /* ID (place is the name itself) */
    | NUM             { $$ = $1; }     /* NUM (literal) */
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Enter statements (end with EOF). Example: a = b + c * (d - 2);\n");
    yyparse();
    return 0;
}
