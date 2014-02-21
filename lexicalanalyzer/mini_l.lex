%{
	/*Sam Lee SSID: 860957929 */
    /* need this for the call to atof() below */
    #include <math.h>
	int column=0;
%}

%option yylineno
DIGIT [0-9]
ALPHA [A-Za-z]

%%

"program"   					{column+=7; printf("PROGRAM\n"); }
"beginprogram"					{column+=12;  printf("BEGIN_PROGRAM\n");}
"endprogram"					{column+=10;  printf("END_PROGRAM\n");}
"integer"						{column+=7;  printf("INTEGER\n");}
"array"							{column+=5;  printf("ARRAY\n");}
"of"							{column+=2;  printf("OF\n");}
"if"							{column+=2;  printf("IF\n");}
"then"							{column+=4;  printf("THEN\n");}
"endif"							{column+=5;  printf("ENDIF\n");}
"else"							{column+=4;  printf("ELSE\n");}
"while"							{column+=5;  printf("WHILE\n");}
"beginloop"						{column+=9;  printf("BEGINLOOP\n");}
"endloop"						{column+=7;  printf("ENDLOOP\n");}
"break"							{column+=5;  printf("BREAK\n");}
"continue"						{column+=8;  printf("CONTINUE\n");}
"exit"							{column+=4;  printf("EXIT\n");}
"read"							{column+=4;  printf("READ\n");}
"write"							{column+=5;  printf("WRITE\n");}
"and"							{column+=3;  printf("AND\n");}
"or"							{column+=2;  printf("OR\n");}
"not"							{column+=3;  printf("NOT\n");}
"true"							{column+=4;  printf("TRUE\n");}
"false"							{column+=5;  printf("FALSE\n");}

"-"								{column+=1;  printf("SUB\n");}
"+"								{column+=1;  printf("ADD\n");}
"*"								{column+=1;  printf("MULT\n");}
"/"								{column+=1;  printf("DIV\n");}
"%"								{column+=1;  printf("MOD\n");}

"=="							{column+=2;  printf("EQ\n");}
"<>"							{column+=2;  printf("NEQ\n");}
"<"								{column+=1;  printf("LT\n");}
">"								{column+=1;  printf("GT\n");}
"<="							{column+=2;  printf("LTE\n");}
">="							{column+=2;  printf("GTE\n");}

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
														printf("IDENT %s\n",yytext);
														column+=yyleng;
													}
	
												}



{DIGIT}+						{column+=yyleng; printf("NUMBER %d\n",atoi(yytext)); }

";"								{column+=1;  printf("SEMICOLON\n");}
":"								{column+=1;  printf("COLON\n");}
","								{column+=1;  printf("COMMA\n");}
"?"								{column+=1;  printf("QUESTION\n");}
"("								{column+=1;  printf("L_PAREN\n");}
")"								{column+=1;  printf("R_PAREN\n");}
":="							{column+=2;  printf("ASSIGN\n");}

[ ]								{column+=1;} 
[\t\r]+
[\n]							{column=0;}
"##".*	

								/* symbols that are not defined are unrecognized */
.								{column+=yyleng; printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", yylineno, column, yytext); }

%%

main()
{
    yylex();
}

