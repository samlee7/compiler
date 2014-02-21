
%{
   #include "y.tab.h"
   #include <stdlib.h>
   #include <stdio.h>
   int currLine = 1, currPos = 1;
   int numNumbers = 0;
   int numOperators = 0;
   int numParens = 0;
   int numEquals = 0;


%}

%option yylineno

DIGIT [0-9]
E [eE]
OP [\-\+]

%%

"-" {currPos += yyleng; numOperators++; return MINUS;}
"+" {currPos += yyleng; numOperators++; return PLUS;}
"*" {currPos += yyleng; numOperators++; return MULT;}
"/" {currPos += yyleng; numOperators++; return DIV;}
"=" {currPos += yyleng; numEquals++; return EQUAL;}
"(" {currPos += yyleng; numParens++; return L_PAREN;}
")" {currPos += yyleng; numParens++; return R_PAREN;}


{DIGIT}+ {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}
{DIGIT}+"."{DIGIT}+ {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}
{DIGIT}+{E}{OP}{DIGIT}+                     {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}
{DIGIT}+"."{DIGIT}+{E}{OP}{DIGIT}+          {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}
{DIGIT}+{E}{DIGIT}+                         {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}
{DIGIT}+"."{DIGIT}+{E}{DIGIT}+              {currPos += yyleng; yylval.dval = atof(yytext); numNumbers++; return NUMBER;}

[ \t]+ {/* ignore spaces */ currPos += yyleng;}

"\n" {currLine++; currPos = 1; return END;}

. {printf("ERROR at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%
