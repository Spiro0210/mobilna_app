%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>

    struct Variable{
        char* id;
        int value;
        struct Variable* next;
    }

    //sad tabela...
%}

%start S 
%token SC
%token ID
%token IF ELSE WHILE FOR BREAK CONTINUE RETURN 
%token TRUE FALSE DO
%token INTEGER BOOL STRING DOUBLE DOUBLE_EXP HEX
%token ASSIGN EQ SUB ADD MULT DIV MOD
%token NEGATIVE COMPARE COMPARE_DIF COMA PERIOD OPEN_BRACKET CLOSE_BRACKET
%token LESS MORE LESS_EQ MORE_EQ AND OR DIF DEGREE 
%left ADD SUB
%left MUL DIV MOD
%nonassoc EQ COMPARE COMPARE_DIF
%left LESS MORE LESS_EQ MORE_EQ
%left AND OR

%right DEGREE

%%
S: S stat   { }
    |   S statDouble  { }
    |   S statDoubleExp { }
    |   S statHex { }
    |   S statBool { }
    |   S statStr { }
    |
;

stat: exp T_SC {printf("%d\n", $1);}
    | ID EQ exp T_SC {printf("%s=%d\n", $1, $3);}
;

statDouble: expDouble T_SC {printf("%f\n",$1);}
    | ID EQ expDouble T_SC {printf("%s=%f\n", $1, $3);}
;

statDoubleExp: expDoubleExp T_SC {printf("%e\n", $1);}
    | ID EQ expDoubleExp T_SC {printf("%s=%e\n", $1, $3);}
;

statHex: expHex T_SC {printf("%x\n", $1);}
    | ID EQ expHex T_SC {printf("%s=%x\n", $1, $3);}
;

statBool: expBool T_SC {printf("%d\n", $1);}
    | ID EQ expBool T_SC {printf("%s=%d\n", $1, $3);}
;

statStr: expStr T_SC {printf("%s\n", $1);}
    | ID EQ expStr T_SC {printf("%s=%s\n", $1, $3);}
;

exp:
    exp ADD exp              { $$=$1+$3; }
    | exp SUB exp           { $$=$1-$3; }
    | exp MULT exp             { $$=$1*$3; }
    | exp DIV exp             { $$=$1/$3; }
    | exp MOD exp             { $$=$1%$3; }
    | exp COMPARE exp       { $$=$1==$3; }
    | exp LESS exp           { $$=$1<$3; }
    | exp MORE exp            { $$=$1>$3; }
    | exp LESS_EQ exp    { $$=$1<=$3; }
    | exp MORE_EQ exp     { $$=$1>=$3; }
    | exp COMPARE_DIF exp       { $$=$1!=$3; }
    | exp DEGREE exp       { /*...*/ }
    | OPEN_BRACKET exp CLOSE_BRACKET    { $$=$2; }
    | INTEGER                     { $$=$1;}
    | ID                   { /*kad napravim tabelu*/ }
;

expDouble: 
    expDouble ADD expDouble     { $$=$1+$3; }
    | expDouble SUB expDouble   { $$=$1-$3; }
    | expDouble MULT expDouble  { $$=$1*$3; }
    | expDouble DIV expDouble   { $$=$1/$3; }
    | expDouble COMPARE expDouble { $$=$1==$3; }
    | expDouble LESS expDouble  { $$=$1<$3; }
    | expDouble MORE expDouble  { $$=$1>$3; }
    | expDouble LESS_EQ expDouble { $$=$1<=$3; }
    | expDouble MORE_EQ expDouble { $$=$1>=$3; }
    | expDouble COMPARE_DIF expDouble { $$=$1!=$3; }
    | OPEN_BRACKET expDouble CLOSE_BRACKET { $$=$2; }
    | DOUBLE                { $$=$1; }
;

expDoubleExp: 
    expDoubleExp ADD expDoubleExp     { $$=$1+$3; }
    | expDoubleExp SUB expDoubleExp   { $$=$1-$3; }
    | expDoubleExp MULT expDoubleExp  { $$=$1*$3; }
    | expDoubleExp DIV expDoubleExp   { $$=$1/$3; }
    | expDoubleExp COMPARE expDoubleExp { $$=$1==$3; }
    | expDoubleExp LESS expDoubleExp  { $$=$1<$3; }
    | expDoubleExp MORE expDoubleExp  { $$=$1>$3; }
    | expDoubleExp LESS_EQ expDoubleExp { $$=$1<=$3; }
    | expDoubleExp MORE_EQ expDoubleExp { $$=$1>=$3; }
    | expDoubleExp COMPARE_DIF expDoubleExp { $$=$1!=$3; }
    | OPEN_BRACKET expDoubleExp CLOSE_BRACKET { $$=$2; }
    | DOUBLE_EXP                { $$=$1; }
;

expHex:
    expHex ADD expHex          { $$=$1+$3; }
    | expHex SUB expHex       { $$=$1-$3; }
    | expHex MULT expHex             { $$=$1*$3; }
    | expHex DIV expHex             { $$=$1/$3; }
    | expHex COMPARE expHex       { $$=$1==$3; }
    | expHex LESS expHex           { $$=$1<$3; }
    | expHex MORE expHex            { $$=$1>$3; }
    | expHex LESS_EQ expHex    { $$=$1<=$3; }
    | expHex MORE_EQ expHex     { $$=$1>=$3; }
    | expHex COMPARE_DIF expHex       { $$=$1!=$3; }
    | OPEN_BRACKET expHex CLOSE_BRACKET       { $$=$2;}
    | HEX                       { $$=$1;}
;

expBool:
    NEGATIVE expBool    { $$=!$1; }
    | expBool AND expBool { $$=$1&&$3; }
    | expBool OR expBool { $$=$1||$3; }
    | expBool COMPARE expBool { $$=$1==$3; }
    | expBool COMPARE_DIF expBool { $$=$1!=$3; }
    | OPEN_BRACKET expBool OPEN_BRACKET { $$=$2; }
    | BOOL { $$=$1; }
;

expStr:
    STRING { $$=strdup($1); }
;

%%

void yyerror(const char* s){
    printf("%s\n",s);
}
int main(){
    int res = yyparse(); //pokrece i vraca parser
    if(res==0){
        printf("Ispravan ulaz\n");
    }else{
        printf("Neispravan ulaz\n");
    }
    return 0;
}