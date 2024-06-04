%{
#include <stdio.h>
#include <math.h>
#include "yacc.tab.h"
#include "semantics.h"
unsigned int LineNo=1;
Token token;
%}

%%

"--".*         
"//".*           
"/*"([^*]|\n)*"*/"  
[ \t]
[\r]  
[\n]  {LineNo++; }  

"origin" {return ORIGIN;}
"scale"  {return SCALE;}
"rot"  {return ROT;}
"is"  {return IS;}
"for"  {return FOR;}
"from"  {return FROM;}
"to"  {return TO;}
"step"  {return STEP;}
"draw"  {return DRAW;}
"t"  {return T;}

"pi"  {token.type=CONST_ID; token.value=3.14159; return CONST_ID;}
"e"  {token.type=CONST_ID; token.value=2.71828 ;return CONST_ID;}

"sin"  {token.type=FUNC; token.FuncPtr=sin;return FUNC;}
"cos"  {token.type=FUNC; token.FuncPtr=cos;return FUNC;}
"tan"  {token.type=FUNC; token.FuncPtr=tan;return FUNC;}
"exp"  {token.type=FUNC; token.FuncPtr=exp;return FUNC;}
"ln"  {token.type=FUNC; token.FuncPtr=log;return FUNC;}
"sqrt"  {token.type=FUNC; token.FuncPtr=sqrt;return FUNC;}

"**"  {return POWER;}
"-"  {return MINUS;}
"+"  {return PLUS;}
"*"  {return MUL;}
"/"  {return DIV;}
","  {return COMMA;}
";"  { return SEMICO;}
"("  {return L_BRACKET;}
")"  {return R_BRACKET;}


[0-9]+(\.[0-9]+)? {token.value=atof(yytext); token.type=CONST_ID; return CONST_ID;} 
[a-z][_a-z0-9_]*   {  return ERRTOKEN;}
. {return ERRTOKEN;}
%%
int yywrap() { return 1; }