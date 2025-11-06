%{
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
%}

%%

0[bB][01]+    {
                  /* skip "0b"/"0B" prefix, convert remaining binary digits */
                  const char *digits = yytext + 2;
                  errno = 0;
                  unsigned long long val = strtoull(digits, NULL, 2);
                  if (errno == ERANGE) {
                      /* overflow (very large number) — still print the wrapped value */
                      printf("Binary: %s to Decimal: %llu (overflowed)\n", yytext, val);
                  } else {
                      printf("Binary: %s to Decimal: %llu\n", yytext, val);
                  }
               }

[01]+         {
                  /* bare binary sequence */
                  errno = 0;
                  unsigned long long val = strtoull(yytext, NULL, 2);
                  if (errno == ERANGE) {
                      printf("Binary: %s to Decimal: %llu (overflowed)\n", yytext, val);
                  } else {
                      printf("Binary: %s to Decimal: %llu\n", yytext, val);
                  }
               }

[ \t\n]+      { /* skip whitespace */ }
.             { /* ignore any other character */ }

%%

int yywrap(void) { return 1; }

int main(void) {
    printf("Enter binary numbers (with or without 0b prefix). Ctrl+D to end.\n");
    yylex();
    return 0;
}
