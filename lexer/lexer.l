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
%x ONELINECOMMENT
%x MULTILINEDOUBLEQUOTES
%x MULTILINESINGLEQUOTES
%x SINGLEQUOTESSTRING
%x DOUBLEQUOTESSTRING




INTEGER 	[0-9]+
EXP			(e|E)(\-|\+)?{INTEGER}
FLOAT		([0-9]*([0-9]\.|\.[0-9])[0-9]*({EXP})?|{INTEGER}({EXP}))
IDENTIFIER 	[A-Za-z_][A-Za-z0-9_]*
EMPTYINDENTS [ \t]

%%

%{
    int stack[1000];
    stack[0] = 0;
    int lastIndex = 0;

    int countParenthesesBrackets = 0;
    int countSquareBrackets = 0;
    int countCurlyBrackets = 0;
    int boolean_isInString = 0;

	int INDENT_SPACE_COUNT = 4;

	char tmp[1000];
	tmp[0] = 0;

	char toHex[3];
%}


%{
    /* Basics */
%}
^\s*\n  printf("The empty DOUBLEQUOTESSTRING\n");

#	{BEGIN(ONELINECOMMENT); tmp[0] = 0;}
<ONELINECOMMENT>[^\\\n]+ strcat(tmp, yytext);
<ONELINECOMMENT>[\\\n]	{printf("The one line tmp : %s\n", tmp); BEGIN(INITIAL);}

%{
    /* Work with strings */
%}

\"{3}																									{BEGIN(MULTILINEDOUBLEQUOTES); tmp[0] = 0;}
<MULTILINEDOUBLEQUOTES>\\n																				strcat(tmp,"\n");
<MULTILINEDOUBLEQUOTES,DOUBLEQUOTESSTRING,MULTILINESINGLEQUOTES>\\\"									strcat(tmp,"\"");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\\\					strcat(tmp,"\\");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\\'					strcat(tmp,"\'");
<MULTILINEDOUBLEQUOTES,DOUBLEQUOTESSTRING,MULTILINESINGLEQUOTES>\'										strcat(tmp,"\'");
<MULTILINEDOUBLEQUOTES,SINGLEQUOTESSTRING,MULTILINESINGLEQUOTES>\"										strcat(tmp,"\"");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\n					strcat(tmp, "\n");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\a					strcat(tmp,"\a");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\b					strcat(tmp,"\b");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\f					strcat(tmp,"\f");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\r					strcat(tmp,"\r");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\t					strcat(tmp,"\t");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\\v					strcat(tmp,"\v");
<MULTILINEDOUBLEQUOTES,MULTILINESINGLEQUOTES,DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>[^\"\\\n\'\a\b\f\r\t\v\x]+		strcat(tmp, yytext);
<MULTILINEDOUBLEQUOTES>\"\"\" 		{printf("MULTILINEDOUBLEQUOTES literal: %s\n",tmp); BEGIN(INITIAL);}

\"											{ BEGIN(DOUBLEQUOTESSTRING); tmp[0] = 0; }
<DOUBLEQUOTESSTRING,SINGLEQUOTESSTRING>\n	{ printf("Error! STRING is not closed\n"); BEGIN(INITIAL); }
<DOUBLEQUOTESSTRING>\" 						{ printf("DOUBLEQUOTESSTRING literal %s\n", tmp); BEGIN(INITIAL); }

\'							{BEGIN(SINGLEQUOTESSTRING); tmp[0] = 0;}
<SINGLEQUOTESSTRING>\' 		{printf("SINGLEQUOTESSTRING literal %s\n", tmp); BEGIN(INITIAL);}

%{
    /* Work with tabs */
%}


<DENT>^[ \t]*#			{tmp[0] = 0; BEGIN(ONELINECOMMENT);}
<DENT>^[ \t]*\n         printf("The empty DOUBLEQUOTESSTRING in dent\n");
<DENT>^[ ]+ {
				if( !(boolean_isInString || countParenthesesBrackets || countSquareBrackets || countCurlyBrackets) ) {
					indentation(stack, &lastIndex, strlen(yytext));
					BEGIN(INITIAL);
				}
			}
<DENT>^[\t]+ {
				if( !(boolean_isInString || countParenthesesBrackets || countSquareBrackets || countCurlyBrackets) ) {
					indentation(stack, &lastIndex, strlen(yytext) * INDENT_SPACE_COUNT);
					BEGIN(INITIAL);
				}
			}
<DENT>^[ \t]{2,} {
					if( !(boolean_isInString || countParenthesesBrackets || countSquareBrackets || countCurlyBrackets) ) {
						printf("Error! You mixed tabs and spaces");
					}
				 }
<DENT>""/.		{
					if( !(boolean_isInString || countParenthesesBrackets || countSquareBrackets || countCurlyBrackets) ) {
						indentation(stack, &lastIndex, 0);
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

{FLOAT}			printf("The float number %f \n", atof(yytext));
{INTEGER} 			printf("The integer number %d \n", atoi(yytext));
{IDENTIFIER}	printf("The identifier : %s \n", yytext);


\\\s*\n		{printf("The backslash"); boolean_isInString = 1;}
\n 			{
				if (!countParenthesesBrackets && !countSquareBrackets && !countCurlyBrackets) {
					boolean_isInString = 0;
					printf("The newline started\n");
					BEGIN(DENT);
				}
			}

{EMPTYINDENTS} {;}

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