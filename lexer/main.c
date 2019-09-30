#include "lex.yy.c"
int main (int argc, char * argv[]) {

    char pathInput[81] = "tests/inputs/";
    char pathOutput[81] = "tests/outputs/";

    strcat(pathInput, argv[1]);
    strcat(pathOutput, argv[1]);

    strcat(pathInput, ".txt");
    strcat(pathOutput, "-out.txt");
    
    printf("Test #%s successfull maked\n", argv[1]);

    freopen(pathOutput, "w", stdout);
    yyin = fopen(pathInput, "r");

    yylex();
}