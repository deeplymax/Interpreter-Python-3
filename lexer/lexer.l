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
if          printf("The keyword : %s\n", yytext);
else        printf("The keyword : %s\n", yytext);
elif        printf("The keyword : %s\n", yytext);
for         printf("The keyword : %s\n", yytext);
in          printf("The keyword : %s\n", yytext);
while       printf("The keyword : %s\n", yytext);
None        printf("The keyword : %s\n", yytext);
and         printf("The keyword : %s\n", yytext);
as          printf("The keyword : %s\n", yytext);
assert      printf("The keyword : %s\n", yytext);
break       printf("The keyword : %s\n", yytext);
class       printf("The keyword : %s\n", yytext);
continue    printf("The keyword : %s\n", yytext);
def         printf("The keyword : %s\n", yytext);
del         printf("The keyword : %s\n", yytext);
except      printf("The keyword : %s\n", yytext);
finally     printf("The keyword : %s\n", yytext);
from        printf("The keyword : %s\n", yytext);
global      printf("The keyword : %s\n", yytext);
is          printf("The keyword : %s\n", yytext);
lambda      printf("The keyword : %s\n", yytext);
nonlocal    printf("The keyword : %s\n", yytext);
not         printf("The keyword : %s\n", yytext);
or          printf("The keyword : %s\n", yytext);
pass        printf("The keyword : %s\n", yytext);
raise       printf("The keyword : %s\n", yytext);
return      printf("The keyword : %s\n", yytext);
try         printf("The keyword : %s\n", yytext);
with        printf("The keyword : %s\n", yytext);
yield       printf("The keyword : %s\n", yytext);

%{
    /* Operators */
%}
\+          printf("The operator : %s\n", yytext);
-           printf("The operator : %s\n", yytext);
\*          printf("The operator : %s\n", yytext);
\/          printf("The operator : %s\n", yytext);

%{
    /* Identifiers */
%}
[A-Za-z_][A-Za-z0-9_]*  printf("The identifier : %s\n", yytext);
%%