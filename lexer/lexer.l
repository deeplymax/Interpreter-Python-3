%option noyywrap
%option never-interactive
%option yylineno

%%
^\s*\n  printf("The empty string\n");
import  printf("The keyword : %s\n", yytext);
[A-Za-z_][A-Za-z0-9_]*  printf("The identifier : %s\n", yytext);
%%