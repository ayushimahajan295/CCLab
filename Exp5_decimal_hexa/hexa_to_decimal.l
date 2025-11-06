%{ 
#include <stdio.h> 
#include <stdlib.h> 
%} 
 
%% 
0[xX][0-9a-fA-F]+ { 
int num = (int)strtol(yytext, NULL, 16); 
printf("Hexadecimal: %s to Decimal: %d\n", yytext, num); 
} 
[0-9a-fA-F]+ { 
int num = (int)strtol(yytext, NULL, 16); 
printf("Hexadecimal: %s to Decimal: %d\n", yytext, num); 
} 
[ \t\n]+   { /* ignore spaces/tabs/newlines */ } 
.          { /* ignore */ } 
%% 
int yywrap() { return 1; } 
int main() { 
printf("Enter hexadecimal numbers (with/without 0x):\n"); 
yylex(); 
return 0; 
}