%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int count = 0;
char search_word[256];
char lower_search[256];

void to_lowercpy(char *dst, const char *src) {
    for (; *src; src++, dst++) *dst = tolower((unsigned char)*src);
    *dst = '\0';
}
%}

/* match whole words (letters only). We lowercase before comparing */
%%
[a-zA-Z]+ {
    char temp[256];
    to_lowercpy(temp, yytext);
    if (strcmp(temp, lower_search) == 0) count++;
}
.|\n    ;   /* ignore everything else */
%%

int main(int argc, char **argv)
{
    /* Usage:
       1) Provide search word and redirect input:
          wordfreq.exe Lex < input.txt
       2) Provide search word and filename:
          wordfreq.exe Lex input.txt
       3) Provide search word and read interactively:
          wordfreq.exe Lex
    */

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <word> [inputfile]\n", argv[0]);
        return 1;
    }

    /* copy search word and lower-case it for case-insensitive match */
    strncpy(search_word, argv[1], sizeof(search_word)-1);
    search_word[sizeof(search_word)-1] = '\0';
    to_lowercpy(lower_search, search_word);

    /* if input file provided as argv[2], open it and set yyin */
    if (argc >= 3) {
        FILE *f = fopen(argv[2], "r");
        if (!f) {
            perror("Cannot open input file");
            return 1;
        }
        yyin = f;
    }
    /* otherwise yyin remains stdin (so redirection works) */

    yylex();

    printf("Frequency of word '%s' (case-insensitive): %d\n", search_word, count);
    return 0;
}

int yywrap() { return 1; }
