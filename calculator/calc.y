/* Mini Calculator */
/* calc.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
int yyerror(const char* msg);

int inti=0, into=0, intp=0, inte=0;
%}

%union {
    double dval;
    char* cc;
}

%start	input 

%token	<dval> NUMBER
%token  PLUS MINUS DIV MULT END
%type   <dval> exp
%type   <dval> line
%left	PLUS
%left 	MINUS
%left	DIV
%left	MULT
%left 	EQUAL
%left	L_PAREN
%left	R_PAREN


%%

input:	
		| input line
		;

line:   END             {}     
        | exp END      {printf("Result: %g\n",$1); }
		;

exp:	NUMBER	{ $$ = $1; inti++; }
		| exp PLUS exp	{ $$ = $1 + $3; into++; }
		| exp MULT exp	{ $$ = $1 * $3; into++; }
		| exp DIV exp	{ $$ = $1 / $3; into++; }	
        | exp MINUS exp { $$ = $1 - $3; into++; }
        | exp EQUAL     { $1; inte++; }
        | L_PAREN exp R_PAREN   { $$=$2; intp+=2; }
        | MINUS exp     { $$ = -$2 } 
		;

%%

int main(int argc, char **argv) {
	if(argc >1) 
	{
		yyin=fopen(argv[1], "r");
	}
	yyparse();
	fprintf(stdout, "End of processing\n");
	printf("NUM INTEGERS: %d\n",inti);
	printf("NUM OPERATOR: %d\n",into);
	printf("NUM PARENS: %d\n",intp);
	printf("NUM EQUALS: %d\n",inte);
	return EXIT_SUCCESS;
}

int yyerror(const char* msg)
{
	printf("%s on line %d - %s\n",msg,yylineno,yytext);
}

int yywrap(void)
{
	fprintf(stdout, "End of input reached\n");
	return 1;
}



