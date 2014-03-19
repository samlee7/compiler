%{
/*Sam Lee SSID: 860957929 */
#include <stdio.h>
#include <stdlib.h>


void yyerror(const char * msg);
extern int yylineno;
extern unsigned int column;
extern char* yytext;
extern char* ID;
extern int yylex();
extern FILE * yyin;
char * store;



%}

%union{
  int		ival;
  char*		idval;
}

%error-verbose

%start	Program 
%token PROGRAM BEGIN_PROGRAM END_PROGRAM ARRAY OF IF THEN ENDIF ELSE WHILE BEGINLOOP ENDLOOP READ WRITE AND OR NOT TRUE FALSE ADD SUB MULT DIV EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN ASSIGN INTEGER CONTINUE BREAK EXIT MOD QUESTION
%token	<ival>	NUMBER 
%token	<idval>	IDENT
%left	ADD SUB
%left	MULT DIV


%%

Program:		PROGRAM {printf("program -> PROGRAM \n");} IDENT {printf("ident -> IDENT (%s) \n", yytext);} SEMICOLON {printf("semicolon -> SEMICOLON \n");} Block END_PROGRAM {printf("end_program -> END_PROGRAM \n");}
				; 

Block:			BlockDecLoop BEGIN_PROGRAM {printf("begin_program -> BEGIN_PROGRAM \n");} BlockStmtLoop {printf("block -> declaration semicolon block2 begin_program statement semicolon block3 \n");}
				;


BlockDecLoop:	Declaration SEMICOLON {printf("semicolon -> SEMICOLON \n");} BlockDecLoop {printf("block2 -> declaration semicolon block2 \n");}
				| Declaration SEMICOLON {printf("semicolon -> SEMICOLON \n");} {printf("block2 -> declaration semicolon \n");}
				;

BlockStmtLoop:	Statement SEMICOLON {printf("semicolon -> SEMICOLON \n");} BlockStmtLoop {printf("block3 -> statement semicolon block3 \n");}
				| Statement SEMICOLON {printf("semicolon -> SEMICOLON \n");} {printf("block3 -> statement semicolon \n");}
				;

Declaration:	DecIdentLoop COLON {printf("colon -> COLON \n");} INTEGER {printf("integer -> INTEGER \n");} {printf("declaration -> ident comma declaration2 colon integer \n");}
				| DecIdentLoop COLON {printf("colon -> COLON \n");} ARRAY {printf("array -> ARRAY \n");} L_PAREN {printf("l_paren -> L_PAREN \n");} NUMBER {printf("number -> NUMBER (%s) \n", yytext);} R_PAREN{printf("r_paren -> R_PAREN \n");} OF {printf("of -> OF \n");} INTEGER {printf("integer -> INTEGER \n");} {printf("declaration -> ident comma declaration2 colon array l_paren number r_paren of integer \n");}
				;

DecIdentLoop:	IDENT {store=strtok($1," ,"); printf("ident -> IDENT (%s) \n", store);} COMMA {printf("comma -> COMMA \n");} DecIdentLoop {printf("declaration2 -> ident comma declaration2 \n");}
				| IDENT {store=strtok($1," ,"); printf("ident -> IDENT (%s) \n", store);} {printf("declaration2 -> ident \n");}
				;

Statement:		Var ASSIGN {printf("assign -> ASSIGN \n");} Expression {printf("statement -> var assign expression \n");}
				| Var ASSIGN {printf("assign -> ASSIGN \n");} Bool_Exp QUESTION {printf("question -> QUESTION \n");} Expression COLON {printf("colon -> COLON \n");} Expression {printf("statement -> var assign bool_exp question expression colon expression \n");}
				| IF {printf("if -> IF \n");} Bool_Exp THEN {printf("then -> THEN \n");} BlockStmtLoop ENDIF {printf("endif -> ENDIF \n");} {printf("statement -> if bool_exp then block3 endif \n");} 
				| IF {printf("if -> IF \n");} Bool_Exp THEN {printf("then -> THEN \n");} BlockStmtLoop ELSE {printf("else -> ELSE \n");} BlockStmtLoop ENDIF {printf("endif -> ENDIF \n");} {printf("statement -> if bool_exp then block3 else block3 endif \n");}
				| WHILE {printf("while -> WHILE \n");} Bool_Exp BEGINLOOP {printf("beginloop -> BEGINLOOP \n");} BlockStmtLoop ENDLOOP {printf("endloop -> ENDLOOP \n");} {printf("statement -> while bool_exp beginloop block3 endloop \n");}
				| READ {printf("read -> READ \n");} VarLoop {printf("statement -> read var comma varloop \n");}
				| WRITE {printf("write -> WRITE \n");} VarLoop {printf("statement -> write var comma varloop \n");}
				| BREAK {printf("break -> BREAK \n");} {printf("statement -> break \n");}
				| CONTINUE {printf("continue -> CONTINUE \n");} {printf("statement -> continue \n");}
				| EXIT {printf("exit -> EXIT \n");} {printf("statement -> exit \n");}
				;

VarLoop:		Var COMMA {printf("comma -> COMMA \n");} VarLoop {printf("varloop -> var comma varloop \n");}
				| Var {printf("varloop -> var \n");}
				;

Bool_Exp:		Relation_And_Exp RELoop {printf("bool_exp -> relation_and_exp reloop \n");}
				| Relation_And_Exp {printf("bool_exp -> relation_and_exp \n");}
				;

RELoop:			/*epsilon*/ {printf("reloop -> \n");}
				| OR {printf("or -> OR \n");} Relation_And_Exp RELoop {printf("reloop -> or relation_and_exp reloop \n");}
				;

Relation_And_Exp:	Relation_Exp RLoop {printf("relation_and_exp -> relation_exp rloop \n");}
					| Relation_Exp {printf("relation_and_exp -> relation_exp \n");}
					;

RLoop:			/*epsilon*/ {printf("rloop -> \n");}
				| AND {printf("and -> AND \n");} Relation_Exp  RLoop {printf("rloop -> and relation_exp rloop \n");}
				;

Relation_Exp:	Expression Comp Expression {printf("relation_exp -> expression comp expression \n");}
				| NOT {printf("not -> NOT ");} Expression Comp Expression {printf("relation_exp -> expression comp expression \n");} 
				| TRUE {printf("true -> TRUE \n");} {printf("relation_exp -> true \n");}
				| NOT {printf("not -> NOT ");} TRUE {printf("true -> TRUE \n");} {printf("relation_exp -> not true \n");}
				| FALSE {printf("false -> FALSE \n");} {printf("relation_exp -> false \n");}
				| NOT {printf("not -> NOT ");} FALSE {printf("false -> FALSE \n");} {printf("relation_exp -> not false \n");}
				| L_PAREN {printf("l_paren -> L_PAREN \n");} Bool_Exp R_PAREN {printf("r_paren -> R_PAREN \n");} {printf("relation_exp -> l_paren bool_exp r_paren \n");}
				| NOT {printf("not -> NOT ");} L_PAREN {printf("l_paren -> L_PAREN \n");} Bool_Exp R_PAREN{printf("r_paren -> R_PAREN \n");} {printf("relation_exp -> l_paren bool_exp r_paren \n");}	
				;

Comp:			EQ {printf("comp -> EQ \n");}
				| NEQ {printf("comp -> NEQ \n");}
				| LT {printf("comp -> LT \n");}
				| GT {printf("comp -> GT \n");}
				| LTE {printf("comp -> LTE \n");}
				| GTE {printf("comp -> GTE \n");}
				;

Expression:		Multiplicative_Exp {printf("expression -> multiplicative_exp \n");}
				| Multiplicative_Exp MELoop {printf("expression -> multiplicative_exp meloop \n");}
				;

MELoop:			/*epsilon*/ {printf("meloop -> \n");}
				| ADD Multiplicative_Exp MELoop {printf("meloop -> add multiplicative_exp meloop \n");}
				| SUB Multiplicative_Exp MELoop {printf("meloop -> sub multiplicative_exp meloop \n");}
				;

Multiplicative_Exp:	Term {printf("multiplicative_exp -> term \n");}
					| Term {printf("term ");} TermLoop {printf("multiplicative_exp -> term termloop \n");}
					;

TermLoop:		/*epsilon*/ {printf("termloop -> \n")}
				| MULT {printf("mult ");} Term TermLoop {printf("termloop -> mult term termloop \n")}
				| DIV {printf("div ");} Term TermLoop {printf("termloop -> div term termloop \n")}
				| MOD {printf("mod ");} Term TermLoop {printf("termloop -> mod term termloop \n")}
				;

Term:			Var {printf("term -> var \n");} 
				| SUB {printf("sub -> SUB ");} Var {printf("term -> sub var \n");}
				| NUMBER {printf("number -> NUMBER(%s) \n", yytext);} {printf("term -> number \n");}
				| SUB {printf("sub -> SUB ");} NUMBER {printf("number -> NUMBER(%s) \n",yytext);} {printf("term -> sub number \n");}
				| L_PAREN {printf("l_paren -> L_PAREN \n");} Expression R_PAREN{printf("r_paren -> R_PAREN \n");} {printf("term -> l_paren expression r_paren \n");}
				| SUB {printf("sub -> SUB ");} L_PAREN {printf("l_paren -> L_PAREN \n");} Expression R_PAREN{printf("r_paren -> R_PAREN \n");} {printf("term -> sub l_paren expression r_paren \n");}
				;
	
Var: 			IDENT {store=strtok($1," ,+);("); printf("ident -> IDENT (%s) \n", store);} {printf("var -> ident \n");}
				| IDENT {store=strtok($1," ,+);("); printf("ident -> IDENT (%s) \n", store);} L_PAREN {printf("l_paren ->L_PAREN \n");} Expression R_PAREN {printf("r_paren -> R_PAREN \n");} {printf("var -> ident l_paren expression r_paren \n");}
				;




%%

int main() {
yyparse();
         return 0;
}

void yyerror(const char* msg)
{
	printf("** Line %d, position %d: %s\n", yylineno, column, msg);
}
