%{
#define YYSTYPE struct ExprNode*
#include<stdio.h>
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<string.h>
#include "semantics.h"
#include "yacc.tab.h"
extern int yylex(void);
extern unsigned char *yytext;
extern FILE* yyin;
extern struct Token token;
extern double parameter, Origin_x, Origin_y, Scale_x, Scale_y, Rot_angle;
void yyerror(char *s);
void draw(double x,double y);

%}

%token CONST_ID FUNC FOR FROM DRAW TO STEP ORIGIN;
%token SCALE ROT IS T ERRTOKEN;
%token SEMICO COMMA L_BRACKET R_BRACKET;
%left PLUS MINUS;
%left MUL DIV;
%right UNSUB;
%right POWER;

%%

Program:
	|Program Statement SEMICO 
	{}
	;
Statement: OriginStatement | ScaleStatement | RotStatement | ForStatement
	;
OriginStatement: ORIGIN IS L_BRACKET Expression COMMA Expression R_BRACKET
		{  Origin_x = GetExprValue($4);
		   Origin_y = GetExprValue($6);
		};
ScaleStatement: SCALE IS L_BRACKET Expression COMMA Expression R_BRACKET 
		{  Scale_x = GetExprValue($4);
		   Scale_y = GetExprValue($6);
		};
RotStatement: ROT IS Expression
		{Rot_angle = GetExprValue($3);
		};
ForStatement :FOR T FROM Expression TO Expression STEP Expression DRAW L_BRACKET Expression COMMA Expression R_BRACKET
		{  double start=GetExprValue($4);
		   double end=GetExprValue($6);
		   double step=GetExprValue($8);
		   for(parameter=start; parameter<=end; parameter+=step)
		   { 	     
		    	double local_x, local_y, temp;
			local_x=GetExprValue($11);
			local_y=GetExprValue($13);
			local_x*=Scale_x;
			local_y*=Scale_y;
			temp=local_x*cos(Rot_angle)+local_y*sin(Rot_angle);
			local_y=local_y*cos(Rot_angle)-local_x*sin(Rot_angle);
			local_x=temp;
			local_x+=Origin_x;
			local_y+=Origin_y;
        	     		draw(local_x, local_y);	     
		   }
		};

Expression:T    {$$=MakeExprNode(T,NULL,NULL);}
    |CONST_ID {$$=MakeExprNode(CONST_ID,&(token.value),NULL);}
    |Expression PLUS Expression {$$=MakeExprNode(PLUS, $1, $3);}
    |Expression MINUS Expression  {$$=MakeExprNode(MINUS,$1,$3);}
    |Expression MUL Expression  {$$=MakeExprNode(MUL,  $1, $3);}
    |Expression DIV Expression  {$$=MakeExprNode(DIV,  $1, $3);}
    |Expression POWER Expression  {$$=MakeExprNode(POWER, $1, $3);}
    |L_BRACKET Expression R_BRACKET  {$$=$2;}
    |PLUS Expression %prec UNSUB {$$=$2; }
    |MINUS Expression %prec  UNSUB {$$=$2; $$->Content.CaseConst*=-1;}
    |FUNC L_BRACKET Expression R_BRACKET {$$=MakeExprNode(FUNC, (void*)token.FuncPtr, $3);}
    ;

%%

void yyerror(char *s) {
  printf("Error: %s\n", s);
}