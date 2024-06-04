#include"semantics.h"
#include<stdlib.h>
#include<math.h>
double Scale_x=1, Scale_y=1;
double Origin_x=0.0, Origin_y=0.0;
double Rot_angle=0.0;
double parameter=0;
struct ExprNode * MakeExprNode(enum yytokentype TokType, void* arg1, void* arg2)
{
	ExprNode* ExprPtr=(ExprNode*)malloc(sizeof(struct ExprNode));
	ExprPtr->OpCode=TokType;
	switch( TokType )
  	{
    case CONST_ID:
		ExprPtr->Content.CaseConst = *(double*)arg1; break;
  	 case T:
		ExprPtr->Content.CaseParmPtr = &parameter; 	break;
    case FUNC:
		ExprPtr->Content.CaseFunc.MathFuncPtr = (FuncPtr)arg1;
		ExprPtr->Content.CaseFunc.Child =(ExprNode *)arg2;
		break;
   	default:
		ExprPtr->Content.CaseOperator.left =(ExprNode *)arg1;
		ExprPtr->Content.CaseOperator.right=(ExprNode *)arg2;
		break;
  	}

}
double GetExprValue(ExprNode* Node)
{
     switch(Node->OpCode)
     {
     	case T:
     		return parameter;
     		break;
     	case CONST_ID:
     		return Node->Content.CaseConst;
     		break;
     	case FUNC:
     		return Node->Content.CaseFunc.MathFuncPtr(GetExprValue(Node->Content.CaseFunc.Child));
     		break;
     	case MINUS:
     		return GetExprValue(Node->Content.CaseOperator.left)-GetExprValue(Node->Content.CaseOperator.right);
     		break;
     	case PLUS:
     		return GetExprValue(Node->Content.CaseOperator.left)+GetExprValue(Node->Content.CaseOperator.right);
     		break;
     	case MUL:
     		return GetExprValue(Node->Content.CaseOperator.left)*GetExprValue(Node->Content.CaseOperator.right);
     		break;
     	case DIV:
     		return GetExprValue(Node->Content.CaseOperator.left)/GetExprValue(Node->Content.CaseOperator.right);
     		break;
     	case POWER:
     		return pow(GetExprValue(Node->Content.CaseOperator.left),GetExprValue(Node->Content.CaseOperator.right));
     		break;
     	default:
		return 0.0;
     		break;
	 }
}
