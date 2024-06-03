%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "Pmf0.tab.h"
    #include "error.h"

    int curr_col = 1;
    int col_comment = 0;
    int row_comment = 0;
    int row_string = 0;
    int col_string = 0;

    #define YY_USER_ACTION curr_col += yyleng; //dodajemo duzinu izraza
    
%}

%option yylineno
%option noyywrap

%x COMMENT
%x MULTILINE_COMMENT
%x STRING_QUOTATIONS


%%
";"                         {   
                                return TOKEN_SC;
                            }
"IF"                        {   
                                return TOKEN_IF; 
                            }
"ELSE"                      {   
                                return TOKEN_ELSE; 
                            }
"WHILE"                     {   
                                return TOKEN_WHILE; 
                            }
"FOR"                       {   
                                return TOKEN_FOR; 
                            }
"BREAK"                     {   
                                return TOKEN_BREAK; 
                            }
"CONTINUE"                  {   
                                return TOKEN_CONTINUE; 
                            }
"RETURN"                    {   
                                return TOKEN_RETURN; 
                            }
"TRUE"                      {   
                                return TOKEN_TRUE; 
                            }
"FALSE"                     {   
                                return TOKEN_FALSE; 
                            }
"DO"                        {   
                                return TOKEN_DO;
                            }
"INT"                       {   
                                return TOKEN_INTEGER;
                            }
"BOOL"                      {   
                                return TOKEN_BOOL;
                            }
"STRING"                    {   
                                return TOKEN_STRING;
                            }
"DOUBLE"                    {   
                                return TOKEN_DOUBLE;
                            }
"WRITE"                     {
                                return TOKEN_WRITE;
                            }
"READ"                      {
                                return TOKEN_READ;
                            }
"="                         {   
                                return TOKEN_EQ;
                            }
"+"                         {   
                                return TOKEN_SUB;
                            }
"-"                         {   
                                return TOKEN_ADD;
                            }
"*"                         {    
                                return TOKEN_MULT;
                            }   
"/"                         {  
                                return TOKEN_DIV;
                            }
"%"                         {    
                                return TOKEN_MOD;
                            }
"!"                         {   
                                return TOKEN_NEGATION;
                            }
"=="                        {   
                                return TOKEN_COMPARE;
                            }
"!="                        {   
                                return TOKEN_COMPARE_DIF;  
                            }
","                         {  
                                return TOKEN_COMA;
                            }
"."                         {   
                                return TOKEN_PERIOD;
                            }
"("                         {    
                                return OPEN_BRACKET;
                            }
")"                         {    
                                return CLOSE_BRACKET;
                            }
"<"                         {    
                                return TOKEN_LESS;
                            }
">"                         { 
                                return TOKEN_MORE;
                            }
"<="                        {   
                                return TOKEN_LESS_EQ;
                            }
">="                        {   
                                return TOKEN_MORE_EQ;
                            }
"&&"                        {  
                                return TOKEN_AND;
                            }
"||"                        {    
                                return TOKEN_OR;
                            }
"^"                         {   
                                return TOKEN_DEGREE;
                            }          
"//"                        {   
                                BEGIN( COMMENT);
                            }
"/*"                        {   col_comment = curr_col;
                                row_comment = yylineno;
                                BEGIN(MULTILINE_COMMENT); 
                            }
\"[^\n\"]*\"                {   //yylval.str_value = strdup(yytext);
                                return TOKEN_STRING;
                            }
"\""                        {   col_string = curr_col;
                                row_string = yylineno;
                                BEGIN(STRING_QUOTATIONS);
                            }
0|[1-9][0-9]*               {   
                                //yylval.int_value = atoi(yytext);
                                return TOKEN_INTEGER;
                            }
0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)    {  
                                        //yylval.hex_value = strtol(yytext,NULL,16);
                                        return TOKEN_HEX;
                                    }
[0-9]+\.[0-9]*                      {   double temp = atof(yytext);
                                        //yval.double_value = temp;
                                        return TOKEN_DOUBLE;
                                    }
[0-9]+\.[0-9]*[eE][+-]?[0-9]+       {   double temp = atof(yytext);
                                        //yval.double_value_exp = temp;
                                        return TOKEN_DOUBLE_EXP;
                                    }
\.[0-9]+                            {   double_error1(yylineno,curr_col);   }
0|[1-9][0-9]*([eE][-+]?[0-9]+)?     {   double_error2(yylineno,curr_col);   }

[a-zA-Z][a-zA-Z0-9_]{0,30}  {  
                                return TOKEN_ID;
                            }
[\n\r]                  {   curr_col = 1;    }
[ \t]                   {   /*nikome nista*/    }
.                           {   printf("Nepoznat simbol: %s\n",yytext);    }

<STRING_QUOTATIONS>{
"\"" {  printf("Navodnici su zatvoreni"); BEGIN(INITIAL);} //kraj stringa
\n {    nezatvoren_string(row_string, col_string);    }
. { }
<<EOF>> { nezatvoren_string(row_string,col_string); }
} 

<COMMENT>{
\n { BEGIN(INITIAL);}
"//" {  nezatvoren_comm(row_comment, col_comment);  } 
. { }
} 

<MULTILINE_COMMENT>{
"*/" { BEGIN(INITIAL); }
"/*" {  nezatvoren_comm(row_comment, col_comment);  }
. { }
\n { }
<<EOF>> { nezatvoren_comm(row_comment, col_comment); }
} 
%%
