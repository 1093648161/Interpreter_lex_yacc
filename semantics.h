#include"yacc.tab.h"
extern double Scale_x, Scale_y;
extern double Origin_x, Origin_y;
extern double Rot_angle;
extern double parameter;
struct Token{
   enum yytokentype type;
   double value;
   double (* FuncPtr)(double);
};
typedef double (* FuncPtr)(double);
struct ExprNode
{
	enum yytokentype OpCode;
	union
	{ struct { ExprNode *left, *right;
		} CaseOperator;
	  struct { ExprNode * Child;
		FuncPtr MathFuncPtr;
		} CaseFunc;
	double CaseConst;
	double * CaseParmPtr;
	} Content;
};
struct ExprNode * MakeExprNode(enum yytokentype TokType, void* arg1, void* arg2);
double GetExprValue(ExprNode* Node);
