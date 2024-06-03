#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "error.h"

void nezatvoren_string(int row_string, int col_string){
    printf("Potrebno je zatvoriti navodnike na:\n"); 
    printf("Red: %d, Kolona: %d\n", row_string, col_string); 
}

void nezatvoren_comm(int row_comment, int col_comment){
    printf("Potrebno je zatvoriti komentar na:\n"); 
    printf("Red: %d, Kolona: %d\n", row_comment, col_comment);  
}

void double_error1(int row, int col){
    printf("Sintaksna greska: Double sa eksponentom mora sadrzati tacku");
    printf("Red: %d   Kolona: %d\n", row, col); 
}

void double_error2(int row, int col){
    printf("Sintaksna greska: Double sa eksponentom mora sadrzati tacku");
    printf("Red: %d   Kolona: %d\n", row, col); 
}