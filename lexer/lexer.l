%{
#include <stdio.h>
#include <stdlib.h>
/* Calculate the indention */
void indentation(int* stack, int* lastIndex, int size);
%}

%option noyywrap
%option never-interactive
%option yylineno

%x DENT

%%

%{
    int stack[1000];
    stack[0] = 0;
    int lastIndex = 0;
    int countParenthesesBrackets = 0;
    int countSquareBrackets = 0;
    int countCurlyBrackets = 0;
    int boolean_isInString = 0;
%}


%{
    /* Basics */
%}
^\s*\n  printf("The empty string\n");

<DENT>^[ \t]*\n         printf("EMPTYSTRING\n");
<DENT>^[ ]+ {
				if( !(boolean_isInString || countParenthesesBrackets || countSquareBrackets || countCurlyBrackets) )
				{
					indentation(stack, &lastIndex, strlen(yytext));
					BEGIN(INITIAL);
				}
			}

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
\(			{printf("The operator : %s\n", yytext); ++countParenthesesBrackets;}
\)			{printf("The operator : %s\n", yytext); --countParenthesesBrackets;}
\[			{printf("The operator : %s\n", yytext); ++countSquareBrackets;}
\]			{printf("The operator : %s\n", yytext); --countSquareBrackets;}
\{			{printf("The operator : %s\n", yytext); ++countCurlyBrackets;}
\}			{printf("The operator : %s\n", yytext); --countCurlyBrackets;}
\+          printf("The operator : %s\n", yytext);
-           printf("The operator : %s\n", yytext);
\*          printf("The operator : %s\n", yytext);
\/          printf("The operator : %s\n", yytext);
\*\*     	printf("The operator : %s\n", yytext);
\/\/     	printf("The operator : %s\n", yytext);
\%     		printf("The operator : %s\n", yytext);
\>     		printf("The operator : %s\n", yytext);
\<     		printf("The operator : %s\n", yytext);
\<=     	printf("The operator : %s\n", yytext);
\>=     	printf("The operator : %s\n", yytext);
==     		printf("The operator : %s\n", yytext);
!=     		printf("The operator : %s\n", yytext);
,     		printf("The operator : %s\n", yytext);
:     		printf("The operator : %s\n", yytext);
\.     		printf("The operator : %s\n", yytext);
\;     		printf("The operator : %s\n", yytext);
\=     		printf("The operator : %s\n", yytext);
->     		printf("The operator : %s\n", yytext);
\+=     	printf("The operator : %s\n", yytext);
-=     		printf("The operator : %s\n", yytext);
\*=     	printf("The operator : %s\n", yytext);
\/=     	printf("The operator : %s\n", yytext);
\/\/=     	printf("The operator : %s\n", yytext);
%=     		printf("The operator : %s\n", yytext);
\*\*=     	printf("The operator : %s\n", yytext);

%{
    /* Identifiers */
%}
[A-Za-z_][A-Za-z0-9_]*  printf("The identifier : %s\n", yytext);

\n 			{
				if (!countParenthesesBrackets && !countSquareBrackets && !countCurlyBrackets) {
					boolean_isInString = 0;
					printf("The newline started\n");
					BEGIN(DENT);
				}
			}
<<EOF>> { indentation(stack, &lastIndex, 0); yyterminate(); }
%%

void indentation (int *stack, int *lastIndex, int size) {
    /* Check dedent */
	if (size < stack[*lastIndex]) {
		int tmpIndex = *lastIndex;
        /* find appropriate dedent */
		while(size < stack[tmpIndex]) {
			tmpIndex--;
        }
        /* if cant find appropriate dedent */
		if (size != stack[tmpIndex]) {
			printf("Error: Find inappropriate dedent %d\n", size);
        }
		else {
			while(*lastIndex > tmpIndex) {
                printf("The dedent done from %d to %d\n", stack[(*lastIndex)], stack[*(lastIndex) - 1]);
				(*lastIndex)--;
			}
		}
	}		
    /* Check indent */
	if (size > stack[*lastIndex]) {
		(*lastIndex)++;
		stack[*lastIndex] = size;
        printf("The indent done from %d to %d\n", stack[(*lastIndex) - 1], stack[*(lastIndex)]);
	}
}