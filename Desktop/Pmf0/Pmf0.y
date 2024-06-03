%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "Pmf0.tab.h"
    #include "error.h"

    struct Variable{
        char* id;
        int value;
        struct Variable* next;
    };

    void yyerror(const char* s);

    //sad tabela...
%}

%start S 
%token TOKEN_SC
%token TOKEN_ID
%token TOKEN_IF 
%token TOKEN_ELSE 
%token TOKEN_WHILE 
%token TOKEN_FOR 
%token TOKEN_BREAK 
%token TOKEN_CONTINUE 
%token TOKEN_RETURN 
%token TOKEN_TRUE TOKEN_FALSE 
%token TOKEN_DO
%token TOKEN_INTEGER TOKEN_BOOL TOKEN_STRING TOKEN_DOUBLE TOKEN_DOUBLE_EXP TOKEN_HEX
%token TOKEN_EQ TOKEN_ADD TOKEN_SUB TOKEN_MULT TOKEN_DIV TOKEN_MOD
%token TOKEN_NEGATION TOKEN_COMPARE TOKEN_COMPARE_DIF TOKEN_COMA TOKEN_PERIOD
%token OPEN_BRACKET CLOSE_BRACKET
%token TOKEN_LESS TOKEN_MORE TOKEN_LESS_EQ TOKEN_MORE_EQ TOKEN_AND TOKEN_OR TOKEN_DEGREE 
%token TOKEN_READ TOKEN_WRITE 

%left TOKEN_ADD TOKEN_SUB
%left TOKEN_MULT TOKEN_DIV TOKEN_MOD
%nonassoc TOKEN_EQ TOKEN_COMPARE TOKEN_COMPARE_DIF
%left TOKEN_LESS TOKEN_MORE TOKEN_LESS_EQ TOKEN_MORE_EQ
%left TOKEN_AND TOKEN_OR

%%
S: S stat   { }
    |   S statDouble  { }
    |   S statDoubleExp { }
    |   S statHex { }
    |   S statBool { }
    |   S statStr { }
    |
;

stat: exp TOKEN_SC {printf("%d\n", $1);}
    | TOKEN_ID TOKEN_EQ exp TOKEN_SC {printf("%s=%d\n", $1, $3);}
;

statDouble: expDouble TOKEN_SC {printf("%f\n",$1);}
    | TOKEN_ID TOKEN_EQ expDouble TOKEN_SC {printf("%s=%f\n", $1, $3);}
;

statDoubleExp: expDoubleExp TOKEN_SC {printf("%e\n", $1);}
    | TOKEN_ID TOKEN_EQ expDoubleExp TOKEN_SC {printf("%s=%e\n", $1, $3);}
;

statHex: expHex TOKEN_SC {printf("%x\n", $1);}
    | TOKEN_ID TOKEN_EQ expHex TOKEN_SC {printf("%s=%x\n", $1, $3);}
;

statBool: expBool TOKEN_SC {printf("%d\n", $1);}
    | TOKEN_ID TOKEN_EQ expBool TOKEN_SC {printf("%s=%d\n", $1, $3);}
;

statStr: expStr TOKEN_SC {printf("%s\n", $1);}
    | TOKEN_ID TOKEN_EQ expStr TOKEN_SC {printf("%s=%s\n", $1, $3);}
;

exp:
    exp TOKEN_ADD exp              { $$=$1+$3; }
    | exp TOKEN_SUB exp           { $$=$1-$3; }
    | exp TOKEN_MULT exp             { $$=$1*$3; }
    | exp TOKEN_DIV exp             { $$=$1/$3; }
    | exp TOKEN_MOD exp             { $$=$1%$3; }
    | exp TOKEN_COMPARE exp       { $$=$1==$3; }
    | exp TOKEN_LESS exp           { $$=$1<$3; }
    | exp TOKEN_MORE exp            { $$=$1>$3; }
    | exp TOKEN_LESS_EQ exp    { $$=$1<=$3; }
    | exp TOKEN_MORE_EQ exp     { $$=$1>=$3; }
    | exp TOKEN_COMPARE_DIF exp       { $$=$1!=$3; }
    | OPEN_BRACKET exp CLOSE_BRACKET    { $$=$2; }
    | TOKEN_INTEGER                     { $$=$1;}
    | TOKEN_ID                   { /*kad napravim tabelu*/ }
;

expDouble: 
    expDouble TOKEN_ADD expDouble     { $$=$1+$3; }
    | expDouble TOKEN_SUB expDouble   { $$=$1-$3; }
    | expDouble TOKEN_MULT expDouble  { $$=$1*$3; }
    | expDouble TOKEN_DIV expDouble   { $$=$1/$3; }
    | expDouble TOKEN_COMPARE expDouble { $$=$1==$3; }
    | expDouble TOKEN_LESS expDouble  { $$=$1<$3; }
    | expDouble TOKEN_MORE expDouble  { $$=$1>$3; }
    | expDouble TOKEN_LESS_EQ expDouble { $$=$1<=$3; }
    | expDouble TOKEN_MORE_EQ expDouble { $$=$1>=$3; }
    | expDouble TOKEN_COMPARE_DIF expDouble { $$=$1!=$3; }
    | OPEN_BRACKET expDouble CLOSE_BRACKET { $$=$2; }
    | TOKEN_DOUBLE                { $$=$1; }
;

expDoubleExp: 
    expDoubleExp TOKEN_ADD expDoubleExp     { $$=$1+$3; }
    | expDoubleExp TOKEN_SUB expDoubleExp   { $$=$1-$3; }
    | expDoubleExp TOKEN_MULT expDoubleExp  { $$=$1*$3; }
    | expDoubleExp TOKEN_DIV expDoubleExp   { $$=$1/$3; }
    | expDoubleExp TOKEN_COMPARE expDoubleExp { $$=$1==$3; }
    | expDoubleExp TOKEN_LESS expDoubleExp  { $$=$1<$3; }
    | expDoubleExp TOKEN_MORE expDoubleExp  { $$=$1>$3; }
    | expDoubleExp TOKEN_LESS_EQ expDoubleExp { $$=$1<=$3; }
    | expDoubleExp TOKEN_MORE_EQ expDoubleExp { $$=$1>=$3; }
    | expDoubleExp TOKEN_COMPARE_DIF expDoubleExp { $$=$1!=$3; }
    | OPEN_BRACKET expDoubleExp CLOSE_BRACKET { $$=$2; }
    | TOKEN_DOUBLE_EXP                { $$=$1; }
;

expHex:
    expHex TOKEN_ADD expHex          { $$=$1+$3; }
    | expHex TOKEN_SUB expHex       { $$=$1-$3; }
    | expHex TOKEN_MULT expHex             { $$=$1*$3; }
    | expHex TOKEN_DIV expHex             { $$=$1/$3; }
    | expHex TOKEN_COMPARE expHex       { $$=$1==$3; }
    | expHex TOKEN_LESS expHex           { $$=$1<$3; }
    | expHex TOKEN_MORE expHex            { $$=$1>$3; }
    | expHex TOKEN_LESS_EQ expHex    { $$=$1<=$3; }
    | expHex TOKEN_MORE_EQ expHex     { $$=$1>=$3; }
    | expHex TOKEN_COMPARE_DIF expHex       { $$=$1!=$3; }
    | OPEN_BRACKET expHex CLOSE_BRACKET       { $$=$2;}
    | TOKEN_HEX                       { $$=$1;}
;

expBool:
    TOKEN_TRUE  {$$=$1;}
    |   TOKEN_FALSE {$$=$1;}
;

expStr:
    TOKEN_STRING { /*strdup mi ne radi?*/ }
;

%%

void yyerror(const char* s){
    printf("%s\n", s);
}

int main(){
    int res=yyparse();

    if(res==0){
        printf("Ulaz ispravan\n");
    } else printf("Ulaz neispravan\n");
    
    return 0;
}