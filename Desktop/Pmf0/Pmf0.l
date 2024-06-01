%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int curr_col = 1;
    int col_comment = 0;
    int row_comment = 0;
    int row_string = 0;
    int col_string = 0;

    #define nezatvoren_string() \
    printf("Potrebno je zatvoriti navodnike na:\n"); \
    printf("Red: %d, Kolona: %d\n", row_string, col_string); \
    exit(1); \

    #define nezatvoren_comm() \
    printf("Potrebno je zatvoriti komentar na:\n"); \
    printf("Red: %d, Kolona: %d\n", row_comment, col_comment); \
    exit(1); \

    #define YY_USER_ACTION curr_col += yyleng; //dodajemo duzinu izraza
    
%}

%option yylineno
%option noyywrap

%x COMMENT
%x MULTILINE_COMMENT
%x STRING_QUOTATIONS


%%

"IF"                        {   printf("Prepoznat: IF\n");
                                //return IF; 
                            }
"ELSE"                      {   printf("Prepoznat: ELSE\n");
                                //return ELSE; 
                            }
"WHILE"                     {   printf("Prepoznat: WHILE\n");
                                //return WHILE; 
                            }
"FOR"                       {   printf("Prepoznat: FOR\n");
                                //return FOR; 
                            }
"BREAK"                     {   printf("Prepoznat: BREAK\n");
                                //return BREAK; 
                            }
"CONTINUE"                  {   printf("Prepoznat: CONTINUE\n");
                                //return CONTINUE; 
                            }
"RETURN"                    {   printf("Prepoznat: RETURN\n");
                                //return RETURN; 
                            }
"TRUE"                      {   printf("Prepoznata boolean konstanta: TRUE\n");
                                //return TRUE; 
                            }
"FALSE"                     {   printf("Prepoznata boolean konstanta: FALSE\n");
                                //return FALSE; 
                            }
"DO"                        {   printf("Prepoznat: DO\n");
                                //return DO;
                            }
"INT"                       {   printf("Prepoznat tip podatka INTEGER\n");
                                //return INTEGER;
                            }
"BOOL"                      {   printf("Prepoznat tip podatka BOOL\n");
                                //return BOOL;
                            }
"STRING"                    {   printf("Prepoznat tip podatka STRING\n"); 
                                //return STRING;
                            }
"DOUBLE"                    {   printf("Prepoznat tip podatka DOUBLE\n");
                                //return DOUBLE;
                            }
";"                         {   printf("Prepoznat znak ;\n");    
                                //return SC;
                            }
"="                         {   printf("Prepoznat operator = \n");  
                                //return EQ;
                            }
"+"                         {   printf("Prepoznat operator +\n");   
                                //return SUB;
                            }
"-"                         {   printf("Prepoznat operator -\n");  
                                //return ADD;
                            }
"*"                         {   printf("Prepoznat operator *\n");   
                                //return MULT;
                            }   
"/"                         {   printf("Prepoznat operator /\n");  
                                //return DIV;
                            }
"%"                         {   printf("Prepoznat operator %%\n");  
                                //return MOD;
                            }
"!"                         {   printf("Prepoznat operator !\n");
                                //return NEGATIVE;
                            }
"=="                        {   printf("Prepoznat komparator ==\n");   
                                //return COMPARE;
                            }
"!="                        {   printf("Prepoznat komparator !=\n"); 
                                //return COMPARE_DIF;  
                            }
","                         {   printf("Prepoznat znak ,\n");   
                                //return COMA
                            }
"."                         {   printf("Prepoznat znak .\n");   
                                //return PERIOD
                            }
"("                         {   printf("Prepoznata otvorena zagrada (\n");   
                                //return OPEN_BRACKET;
                            }
")"                         {   printf("Prepoznata zatvorena zagrada )\n");   
                                //return CLOSE_BRACKET;
                            }
"<"                         {   printf("Prepoznat komparator <\n");   
                                //return LESS;
                            }
">"                         {   printf("Prepoznat komparator >\n");   
                                //return MORE;
                            }
"<="                        {   printf("Prepoznat komparator <=\n");   
                                //return LESS_EQ;
                            }
">="                        {   printf("Prepoznat komparator >=\n");   
                                //return MORE_EQ;
                            }
"&&"                        {   printf("Prepoznat logicki operator &&\n");  
                                //return AND;
                            }
"||"                        {   printf("Prepoznat logicki operator ||\n");   
                                //return OR;
                            }
"!"                         {   printf("Prepoznat logicki operator !\n"); 
                                //return DIF;
                            }
"^"                         {   printf("Prepoznat operator ^\n");  
                                //return DEGREE;
                            }          
"//"                        {   BEGIN( COMMENT);
                                printf("Prepoznat komentar\n");
                            }
"/*"                        {   col_comment = curr_col;
                                row_comment = yylineno;
                                BEGIN(MULTILINE_COMMENT); 
                                printf("Prepoznat komentar u vise linija\n");
                            }
\"[^\n\"]*\"                {   //yylval.str_value = strdup(yytext);
                                printf("Prepoznat STRING: %s\n",yytext);
                                //return STRING;
                            }
"\""                        {   col_string = curr_col;
                                row_string = yylineno;
                                BEGIN(STRING_QUOTATIONS);
                                printf("Prepoznat navodnik\n");
                            }
0|[1-9][0-9]*               {   printf("Prepoznata decimalna konstanta: %s\n", yytext);
                                //yylval.int_value = atoi(yytext);
                                //return INTEGER;
                            }
0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)    {   printf("Prepoznata heksadecimalna konstanta: %s\n", yytext);
                                        //yylval.hex_value = strtol(yytext,NULL,16);
                                        //return HEX;
                                    }
[0-9]+\.[0-9]*                      {   double temp = atof(yytext);
                                        //yval.double_value = temp;
                                        printf("Prepoznata double konstanta: %s\n", yytext);
                                        //return DOUBLE;
                                    }
[0-9]+\.[0-9]*[eE][+-]?[0-9]+       {   double temp = atof(yytext);
                                        //yval.double_value_exp = temp;
                                        printf("Prepoznata double konstanta: %s\n", yytext);
                                        //return DOUBLE_EXP;
                                    }
\.[0-9]+                    {   printf("Sintaksna greska: Double ne mozemo pocinjati sa tackom");
                                printf("Red: %d   Kolona: %d\n", yylineno, curr_col); 
                                exit(1);
                            }
0|[1-9][0-9]*([eE][-+]?[0-9]+)? {   printf("Sintaksna greska: Double sa eksponentom mora sadrzati tacku");
                                    printf("Red: %d   Kolona: %d\n", yylineno, curr_col); 
                                    exit(1);
                                }

[a-zA-Z][a-zA-Z0-9_]{0,30}  {   printf("Prepoznat identifikator: %s\n",yytext);
                                //return ID;
                            }
[\n\r]                  {   curr_col = 1;    }
[ \t]                   {   /*nikome nista*/    }
.                           {   printf("Nepoznat simbol: %s\n",yytext);
                                exit(1);
                            }

<STRING_QUOTATIONS>{
"\"" {  printf("Navodnici su zatvoreni"); BEGIN(INITIAL);} //kraj stringa
\n {    nezatvoren_string();    }
. { }
<<EOF>> { nezatvoren_string(); }
} 

<COMMENT>{
\n { BEGIN(INITIAL);}
"//" {  nezatvoren_comm();  } 
. { }
} 

<MULTILINE_COMMENT>{
"*/" { BEGIN(INITIAL); }
"/*" {  nezatvoren_comm();  }
. { }
\n { }
<<EOF>> { nezatvoren_comm(); }
} 
%%

int main(){
    yylex();
    return 0;
}