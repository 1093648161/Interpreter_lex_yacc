#include<stdio.h>
#include<iostream>
#include<fstream>
#include<string>
#include<stdlib.h>
#include "yacc.tab.h"
using namespace std;
extern FILE *yyin;
ofstream ofs;

int InitScanner(char* filename)
{
    yyin = fopen(filename, "r");
    if(yyin == NULL){
        cout << "fail to open file";
        return 0;
    }
    return 1;
}
void InitDrawer()
{
    ofs.open("drawer.py", ofstream::out);
    if (!ofs.is_open())
    {
        cout << "InitDrawer failed" << endl;
        return;
    }
    ofs << "import matplotlib.pyplot as plt" << endl;
    ofs << "fig, ax = plt.subplots(figsize=(16, 9))" << endl;
    ofs << "fig.canvas.manager.set_window_title('FuncDrawer')" << endl;
    ofs << "plt.subplots_adjust(left = 0.06, top = 0.88, bottom = 0.06, right= 0.95)" <<endl;
    ofs << "ax.set_ylim(900, 0)" << endl;
    ofs << "ax.set_xlim(0, 1600)" << endl;
    ofs << "ax.set_aspect('equal', adjustable='box')" << endl;
    return;
}
void draw(double x, double y)
{
    ofs << "ax.scatter(" << x << "," << y << ", color='black', s=1)" << endl;
}
void close()
{
    ofs << "plt.show()" << endl;
    ofs.close();
}
int main(int argc, char *argv[])
{
    InitScanner(argv[1]);
    InitDrawer();
    yyparse();
    fclose(yyin);
    close();
    system("python drawer.py");
    return 0;
}
