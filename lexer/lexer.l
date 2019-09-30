%option noyywrap
%option never-interactive
%option yylineno

%%
%{
    /* Basics */
%}
^\s*\n  printf("The empty string\n");

%{
    /* Keywords */
%}
import      printf("The keyword : %s\n", yytext);
False       printf("The keyword : %s\n", yytext);
True        printf("The keyword : %s\n", yytext);

%{
    /* Operators */
%}
\+          printf("The operator : %s\n", yytext);
-           printf("The operator : %s\n", yytext);
\*          printf("The operator : %s\n", yytext);
\/     		printf("The operator : %s\n", yytext);

%{
    /* Identifiers */
%}
[A-Za-z_][A-Za-z0-9_]*  printf("The identifier : %s\n", yytext);
%%