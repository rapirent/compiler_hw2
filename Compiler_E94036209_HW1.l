/*
	Topic: Homework1 for Compiler Course
    author: kuoteng, Ding
*/

%{

/*	Definition section */

/*	insert the C library and variables you need */

	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
    #include <string.h>
   
    typedef enum type_node{
        DOUBLE = 0,
        INT = 1,
        NONE = 2,
    }type;
    struct node {
        int num;
        char name[10];
        type t;
        char type_name[10];//為了要印出不同的type name
        struct node* next;
        struct node* pre;
    };
    struct node *symbol_table = NULL;
/*
	Symbol table function

	TAs create the basic function which you have to fill.
	We encourage you define new function to make the program work better.
	However, the four basic functions must be finished.
*/
	void create_symbol();
    void insert_symbol(char* s);
	int lookup_symbol(char* sym);
	void dump_symbol();
	int linenum = 0;
    int num = 0;
    type now_type = NONE;
    int pre_newline = 0;
%}
%x COMMENT
 /*	define regular expression label */

DOUBLE  [dD][oO][uU][bB][lL][eE]
INT     [Ii][Nn][Tt]
letter  [a-zA-Z]
digit   [0-9]
id      {letter}+({letter}|{digit})*
number  {digit}+ 
IF      [iI][fF]
ELSE    [eE][lL][sS][eE]
print   [Pp][Rr][Ii][Nn][Tt]
WS      [ \t\v\f]
STRING  \".*\"
RELATION [\<(\<\=)(\>\=)\>(\=\=)(\!\=)]
WHILE   [wW][hH][iI][lL][eE]



%%
 /*	Rules section */

{STRING}            {   printf("%s \t STRING \n",yytext); pre_newline = 0;}
{INT}               {
                        create_symbol();
                        now_type = INT;
                        strcpy(symbol_table->type_name,yytext);
                        symbol_table->t = INT;
                        pre_newline = 0;
                    }
{DOUBLE}            {
                        create_symbol();
                        symbol_table->t = DOUBLE;
                        strcpy(symbol_table->type_name,yytext);
                        now_type = DOUBLE;
                        pre_newline = 0;
                    }
";" 				{   printf("%s \t SEMICOLON \n",yytext); pre_newline = 0;}
{IF}                {   printf("%s \t IF FUNCTION \n", yytext); pre_newline = 0;}
{ELSE}              {   printf("%s \t ELSE FUNCTION \n", yytext); pre_newline = 0;}
{WHILE}             {   printf("%s \t WHILE FUNCTION \n",yytext); pre_newline = 0;}
{print}				{   printf("%s \t PRINT FUNCTION \n", yytext); pre_newline = 0;}
"=" 				{   printf("%s \t ASSIGN \n",yytext); pre_newline = 0;}
[\+\-\*\/]		    {   printf("%s \t OPERTATOR \n",yytext); pre_newline = 0;}
{digit}+{id}        {   pre_newline = 0;}
{id} 				{   
                        if(now_type == NONE) {
                            /*if(lookup_symbol(yytext)==1) {*/
                            printf("%s \t ID \n",yytext);
                            /*}*/
                            
                        }
                        else {
                            
                            if(now_type == INT) {
                                printf("%s \t int TYPE VAR\n",yytext);
                            }
                            else {
                                printf("%s \t double TYPE VAR\n",yytext);
                            }
                            if(!num) {
                                printf("Create a symbol table\n");
                            }

                            insert_symbol(yytext);
                            now_type = NONE;
                        }
                        pre_newline = 0;
                    }
{digit}+			{   printf("%s \t NUMBER \n",yytext); pre_newline = 0;}
{digit}+.{digit}+   {   printf("%s \t FLOATNUMBER \n",yytext); pre_newline = 0;}
"%"                 {   printf("%s \t REMAINDER \n",yytext); pre_newline = 0;}
"^"                 {   printf("%s \t EXPONENTIATION \n",yytext); pre_newline = 0;}
","                 {   printf("%s \t COMMA \n",yytext); pre_newline = 0;}
"("                 {   printf("%s \t LB \n",yytext); pre_newline = 0;}
")"                 {   printf("%s \t RB \n",yytext); pre_newline = 0;}
{RELATION}          {   printf("%s \t RELATIONAL \n",yytext); pre_newline = 0;}
[\n]				{   linenum++; pre_newline = 1;} 
{WS}                {   pre_newline = 0;}

"/*"                {   
                        BEGIN(COMMENT);
                        printf("COMMENT start\n");
                        pre_newline = 0;
                    }
<COMMENT>"*/"       {   
                        BEGIN(INITIAL);
                        printf("COMMENT end\n");
                        pre_newline = 1;
                    }
<COMMENT>\n         {   linenum++; pre_newline = 1;}
<COMMENT>.          {   pre_newline = 0;}
<COMMENT><<EOF>>    {
                        printf("unterminated comment\n");
                        pre_newline = 0;
                        return 0;
                    }
"//".*\n            {   
                        linenum++;
                        printf("line COMMENT\n");
                        pre_newline = 1;
                    }
.                   {   pre_newline = 0;}
%%

/*	C Code section */

/*	You have to define your C function in this section */

int main(int argc,char *argv[]){

    if(argc < 2) {
        fprintf(stderr,"you should enter a filename\n");
        return 1;
    }
    yyin = fopen(argv[1],"r");
    yylex();
    if(pre_newline == 0) {
        linenum++;
    }
    dump_symbol();

    return 0;
}

int yywrap(void) {
    return 1;
}

void create_symbol() {
    struct node *new_node;
    new_node = malloc(sizeof(struct node));
    if (new_node == NULL) {
        exit(EXIT_FAILURE);
    }
    memset(new_node->type_name,0,sizeof(new_node->type_name));
    memset(new_node->name,0,sizeof(new_node->name));
    new_node->pre = NULL;
    if(symbol_table != NULL) {
        symbol_table -> pre = new_node;
    }
    new_node->next = symbol_table;
    symbol_table = new_node;


}

void insert_symbol(char* s){
    if(lookup_symbol(s)==1) {
        return;   
    }


    symbol_table->num = ++num;
    strcpy(symbol_table->name,s);

    printf("Insert a symbol: %s\n",s);
}

int lookup_symbol(char* sym){
    struct node *tmp  = symbol_table;
    while(tmp!=NULL&&tmp->name!=NULL) {
        if(strcmp(tmp->name,sym)==0) {
            return 1;
        }
        tmp = tmp->next;
    }
    return 0;
}

void dump_symbol(void){
    printf("Parse over, the line number is %d.\n\n",linenum);
    printf("The symbol table dump: \n");
    struct node *tmp = symbol_table;
    if(tmp == NULL) {
        printf("symbol table is empty\n");
        return;
    }
    while(tmp->next!=NULL) {
        tmp = tmp->next;
    }
    while(tmp!=NULL) {
        printf("%d \t %s \t %s\n",tmp->num,tmp->name,tmp->type_name);
        tmp = tmp->pre;
        if(tmp!=NULL) {
            free(tmp->next);
        }
    }
}
