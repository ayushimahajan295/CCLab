%{
int token_count = 0;
%}

%%
[A-Za-z_][A-Za-z0-9_]*    { token_count++; }   /* Identifiers or keywords */
[0-9]+(\.[0-9]+)?         { token_count++; }   /* Numbers (integers/floats) */
\"([^\\\"]|\\.)*\"        { token_count++; }   /* String literals */
[+\-*/%=<>!&|^]+          { token_count++; }   /* Operators */
[(){}\[\],;:]             { token_count++; }   /* Delimiters and punctuation */
\n                        { }                  /* Ignore newlines */
[ \t]+                    { }                  /* Ignore spaces and tabs */
.                         { token_count++; }   /* Any other symbol */
%%

int main()
{
    yylex();
    printf("\nTotal number of tokens: %d\n", token_count);
    return 0;
}

int yywrap()
{
    return 1;
}
