%{
int char_count = 0;
int space_count = 0;
int tab_count = 0;
%}

%%
" "        { space_count++; }          /* Count spaces only */
"\t"       { tab_count++; }            /* Count tabs only */
\n         { /* Ignore newlines */ }   /* Don’t count newlines */
.          { char_count++; }           /* Count all other visible characters */
%%

int main()
{
    yylex();
    printf("\nTotal Characters (excluding spaces, tabs, newlines): %d", char_count);
    printf("\nTotal White Spaces: %d", space_count);
    printf("\nTotal Tabs: %d\n", tab_count);
    return 0;
}

int yywrap()
{
    return 1;
}
