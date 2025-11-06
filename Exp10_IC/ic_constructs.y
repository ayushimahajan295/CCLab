%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int temp_count = 0;
int label_count = 0;

char *new_temp() {
    char buf[32];
    sprintf(buf, "t%d", ++temp_count);
    return strdup(buf);
}

char *new_label() {
    char buf[32];
    sprintf(buf, "L%d", ++label_count);
    return strdup(buf);
}
%}

%union {
    char *sval;
}

%token <sval> ID NUM
%token IF ELSE WHILE
%token EQ NEQ LE GE
%type  <sval> E cond stmt

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
      ID '=' E ';'        {
                            printf("%s = %s\n", $1, $3);
                            free($1); free($3);
                          }

    | IF '(' cond ')' '{' stmt_list '}' {
                            char *L1 = new_label();
                            char *L2 = new_label();
                            printf("if %s goto %s\n", $3, L1);
                            printf("goto %s\n", L2);
                            printf("%s:\n", L1);
                            /* inner statements already printed */
                            printf("%s:\n", L2);
                            free($3);
                          }

    | IF '(' cond ')' '{' stmt_list '}' ELSE '{' stmt_list '}' {
                            char *L1 = new_label();
                            char *L2 = new_label();
                            char *L3 = new_label();
                            printf("if %s goto %s\n", $3, L1);
                            printf("goto %s\n", L2);
                            printf("%s:\n", L1);
                            /* true block */
                            printf("goto %s\n", L3);
                            printf("%s:\n", L2);
                            /* false block */
                            printf("%s:\n", L3);
                            free($3);
                          }

    | WHILE '(' cond ')' '{' stmt_list '}' {
                            char *L1 = new_label();
                            char *L2 = new_label();
                            char *L3 = new_label();
                            printf("%s:\n", L1);
                            printf("if %s goto %s\n", $3, L2);
                            printf("goto %s\n", L3);
                            printf("%s:\n", L2);
                            /* loop body */
                            printf("goto %s\n", L1);
                            printf("%s:\n", L3);
                            free($3);
                          }

    | E ';'               { free($1); }
    ;

cond:
      E '<' E      {
                        char *t = new_temp();
                        printf("%s = %s < %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    | E '>' E      {
                        char *t = new_temp();
                        printf("%s = %s > %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    | E LE E       {
                        char *t = new_temp();
                        printf("%s = %s <= %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    | E GE E       {
                        char *t = new_temp();
                        printf("%s = %s >= %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    | E EQ E       {
                        char *t = new_temp();
                        printf("%s = %s == %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    | E NEQ E      {
                        char *t = new_temp();
                        printf("%s = %s != %s\n", t, $1, $3);
                        $$ = t;
                        free($1); free($3);
                   }
    ;

E:
      E '+' E     { char *t = new_temp(); printf("%s = %s + %s\n", t, $1, $3); $$ = t; free($1); free($3); }
    | E '-' E     { char *t = new_temp(); printf("%s = %s - %s\n", t, $1, $3); $$ = t; free($1); free($3); }
    | E '*' E     { char *t = new_temp(); printf("%s = %s * %s\n", t, $1, $3); $$ = t; free($1); free($3); }
    | E '/' E     { char *t = new_temp(); printf("%s = %s / %s\n", t, $1, $3); $$ = t; free($1); free($3); }
    | '(' E ')'   { $$ = $2; }
    | '-' E %prec UMINUS { char *t = new_temp(); printf("%s = 0 - %s\n", t, $2); $$ = t; free($2); }
    | ID          { $$ = $1; }
    | NUM         { $$ = $1; }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter code (use ;, {}, if, else, while). Example:\n");
    printf("if (a < b) { c = a + b; } else { c = a - b; }\n\n");
    yyparse();
    return 0;
}
