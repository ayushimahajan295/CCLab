%{
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
%}

%%

-?[0-9]+     {
                /* Convert decimal token to unsigned long long for formatting.
                   Handle optional leading '-' separately so we print -0x... */
                if (yytext[0] == '-') {
                    unsigned long long v = strtoull(yytext + 1, NULL, 10);
                    printf("-0x%llX", (unsigned long long)v);
                } else {
                    unsigned long long v = strtoull(yytext, NULL, 10);
                    printf("0x%llX", (unsigned long long)v);
                }
             }

.|\n         { /* print everything else as-is (spaces, punctuation, letters, newlines) */
                putchar(yytext[0]);
             }

%%

int main(void) {
    yylex();
    return 0;
}

int yywrap(void) { return 1; }
