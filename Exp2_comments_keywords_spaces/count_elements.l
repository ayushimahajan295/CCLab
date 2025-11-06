%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* Counters */
int comment_count = 0;
int keyword_count = 0;
int identifier_count = 0;
int word_count = 0;
int line_count = 0;
int space_count = 0;

/* List of C keywords */
char *keywords[] = {
    "auto", "break", "case", "char", "const", "continue", "default",
    "do", "double", "else", "enum", "extern", "float", "for", "goto",
    "if", "int", "long", "register", "return", "short", "signed",
    "sizeof", "static", "struct", "switch", "typedef", "union",
    "unsigned", "void", "volatile", "while", "include", "define", NULL
};

int is_keyword(char *s) {
    for (int i = 0; keywords[i]; i++) {
        if (strcmp(s, keywords[i]) == 0)
            return 1;
    }
    return 0;
}
%}

/* Token definitions */
%%
"//".*                  { comment_count++; }                            /* single-line comment */
"/*"([^*]|\*+[^*/])*\*+"/"  { comment_count++; }                        /* multi-line comment */

[a-zA-Z_][a-zA-Z0-9_]*  {
                            word_count++;
                            if (is_keyword(yytext))
                                keyword_count++;
                            else
                                identifier_count++;
                        }

[0-9]+(\.[0-9]+)?       { word_count++; }                               /* numeric word */

[ \t]+                  { space_count += yyleng; }                      /* spaces/tabs */

\n                      { line_count++; }                               /* new line */

.                       ;                                               /* ignore other chars */
%%

int main(void) {
    yylex();

    printf("\n--- FILE STATISTICS ---\n");
    printf("Lines       : %d\n", line_count);
    printf("Spaces      : %d\n", space_count);
    printf("Comments    : %d\n", comment_count);
    printf("Keywords    : %d\n", keyword_count);
    printf("Identifiers : %d\n", identifier_count);
    printf("Words       : %d\n", word_count);

    return 0;
}

int yywrap(void) { return 1; }
