%{
#include <stdio.h>
#include <stdlib.h>

/* Function to convert a decimal integer to binary string */
void decToBinary(unsigned long long n) {
    if (n == 0) {
        printf("0b0");
        return;
    }
    char binary[65];  // For 64-bit numbers
    int i = 0;
    while (n > 0) {
        binary[i++] = (n % 2) + '0';
        n /= 2;
    }
    printf("0b");
    for (int j = i - 1; j >= 0; j--)
        putchar(binary[j]);
}
%}

%%

-?[0-9]+    {
                if (yytext[0] == '-') {
                    unsigned long long v = strtoull(yytext + 1, NULL, 10);
                    printf("-"); 
                    decToBinary(v);
                } else {
                    unsigned long long v = strtoull(yytext, NULL, 10);
                    decToBinary(v);
                }
            }

.|\n        { putchar(yytext[0]); }   /* Print all non-numeric text as-is */

%%

int main() {
    yylex();
    return 0;
}

int yywrap() { return 1; }
