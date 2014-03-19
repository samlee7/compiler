%{
	/*Sam Lee SSID: 860957929 */
	#include <stdlib.h>
	#include <string.h>
	#include <ctype.h>
    #include <stdio.h>
    #include <math.h>
	#include "y.tab.h"
	int column=0;
%}

%option yylineno
DIGIT [0-9]
ALPHA [A-Za-z]

%%

"program"   					{column+=7; return PROGRAM; }
"beginprogram"					{column+=12;  return BEGIN_PROGRAM;}
"endprogram"					{column+=10;  return END_PROGRAM;}
"integer"						{column+=7;  return INTEGER;}
"array"							{column+=5;  return ARRAY;}
"of"							{column+=2;  return OF;}
"if"							{column+=2;  return IF;}
"then"							{column+=4;  return THEN;}
"endif"							{column+=5;  return ENDIF;}
"else"							{column+=4;  return ELSE;}
"while"							{column+=5;  return WHILE;}
"beginloop"						{column+=9;  return BEGINLOOP;}
"endloop"						{column+=7;  return ENDLOOP;}
"break"							{column+=5;  return BREAK;}
"continue"						{column+=8;  return CONTINUE;}
"exit"							{column+=4;  return EXIT;}
"read"							{column+=4;  return READ;}
"write"							{column+=5;  return WRITE;}
"and"							{column+=3;  return AND;}
"or"							{column+=2;  return OR;}
"not"							{column+=3;  return NOT;}
"true"							{column+=4;  return TRUE;}
"false"							{column+=5;  return FALSE;}

"-"								{column+=1;  return SUB;}
"+"								{column+=1;  return ADD;}
"*"								{column+=1;  return MULT;}
"/"								{column+=1;  return DIV;}
"%"								{column+=1;  return MOD;}

"=="							{column+=2;  return EQ;}
"<>"							{column+=2;  return NEQ;}
"<"								{column+=1;  return LT;}
">"								{column+=1;  return GT;}
"<="							{column+=2;  return LTE;}
">="							{column+=2;  return GTE;}

({DIGIT})*({ALPHA}|"_")+({DIGIT}|{ALPHA}|"_")*  { 	if(isdigit(yytext[0])) /* IDENT cannot start with a digit */
													{ 	
														printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", yylineno, column, yytext);
														column+=yyleng;
													}
													else if(yytext[yyleng-1]=='_') /* IDENT cannot end with an underscore */
													{
														printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", yylineno, column, yytext);
														column+=yyleng;
													}
													else
													{
														yylval.idval=yytext;
														return IDENT;
														column+=yyleng;
													}
												
												}



{DIGIT}+						{column+=yyleng; return NUMBER; yylval.ival=atoi(yytext); }

";"								{column+=1;  return SEMICOLON;}
":"								{column+=1;  return COLON;}
","								{column+=1;  return COMMA;}
"?"								{column+=1;  return QUESTION;}
"("								{column+=1;  return L_PAREN;}								
")"								{column+=1;  return R_PAREN;}
":="							{column+=2;  return ASSIGN;}

[ ]								{column+=1;} 
[\t\r]+
[\n]							{column=0;}
"##".*	

								/* symbols that are not defined are unrecognized */
.								{column+=yyleng; printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", yylineno, column, yytext); }

%%

