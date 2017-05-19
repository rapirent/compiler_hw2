/*
	Topic: Homework2 for Compiler Course
    author: Kuo Teng, Ding
	Deadline: xxx.xx.xxxx
*/

%{

/*	Definition section */
/*	insert the C library and variables you need */

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
/*Extern variables that communicate with lex*/

extern int yylineno;
extern int yylex();
extern char* yytext;
void yyerror(char *);

void create_symbol();								/*establish the symbol table structure*/
void insert_symbol(char* id, char* type, double data);	/*Insert an undeclared ID in symbol table*/
void symbol_assign(char* id, double data);				/*Assign value to a declared ID in symbol table*/
int lookup_symbol(char* id);						/*Confirm the ID exists in the symbol table*/
void dump_symbol();									/*List the ids and values of all data*/
double lookup_double_sym(char* id);

int symnum;											/*The number of the symbol*/
const int eps = 1e-8;


struct symbol {
    char sym_type[10];
    char name[100];
    double data;
    struct symbol *next;
    struct symbol *pre;
};

struct symbol *symbol_table = NULL;

/* Note that you should define the data structure of the symbol table yourself by any form */

%}

/* Token definition */

%union{
    int ival;
    double dval;
    char sval[100];
    char typeval[10];
    char boolval;
}
/* Type declaration : */
%token SEM PRINT WHILE LB RB
%token ADD SUB MUL DIV
%token ASSIGN 
%token <ival> NUMBER FLOATNUM 
%token <sval> ID STRING
%token <typeval> INT DOUBLE
%token <boolval> GE LE EQ NE G L
/*避免ambigious*/
%left GE LE EQ NE G L
%left ADD SUB
%left MUL DIV

%nonassoc UMINUS

/*	
	Use %type to specify the type of token within < > 
	if the token or name of grammar rule will return value($$) 

*/
%type <typeval> type
%type <dval> factor term arith group LB RB
%%

/* Define your parser grammar rule and the rule action */


lines:stmt
     |lines stmt
     ;

stmt: decl SEM
    | arith SEM
    | print SEM
    | assign SEM
    ;
decl:type ID
    {
        if(!symnum) {
           printf("Create symbol table\n"); 
        }
        create_symbol();
        insert_symbol($2,$1,0);
        printf("Decl\n");
    }
    |type ID ASSIGN arith
    {
        if(!symnum) {
            printf("Create Symbol table\n");
        }
        create_symbol();
        insert_symbol($2,$1,$4);
        printf("num = %d\n",$4);
        printf("Decl\n");
    }
    ;
assign: ID ASSIGN arith
    {
        symbol_assign($1, $3);
        printf("num = %lf\n",$3);
        printf("ASSIGN\n");
    }
    ;
arith:term 
    | arith ADD term 
    {
        $$ = $1 + $3;
        printf("ADD\n");
    }
    | arith SUB term
    {
        $$ = $1 - $3;
        printf("SUB\n");
    }
    ;
term: factor 
    | term MUL factor
    {
        $$ = $1 * $3;
        printf("MUL\n");
    }
    | term DIV factor
    {
        if(abs($3-0.0)<eps) {
            char tmp[200]="The divisor can’t be 0";
            yyerror(tmp);
        }
        else {
            $$ = $1 / $3;
        }
        printf("DIV\n");
    }
    ;
factor: group
    {
        int x = (int)$1;
        double y = $1 - x;
        if(abs(y)<eps) {//==0
            $<ival>$ = $1;
        }
        else {
            $<dval>$ = $1;
        }
 
    }
    | NUMBER 
    {
        $<ival>$ = $1;
    }
    | FLOATNUM
    {
        $<dval>$ = $1;
    }
    | ID 
    {
        int check;
        if(!(check = lookup_symbol($1))) {
            char tmp[200]={0};
            strcat(tmp,"can’t find variable ");
            strcat(tmp,$1);
            yyerror(tmp);
        }
        else if(check==1) {
            $<ival>$ = (int)lookup_double_sym($1);
        }
        else {
            $<dval>$ = lookup_double_sym($1);
        }
    } 
    ;
print: PRINT group
    {
        int x = (int)$2;
        double y = $2 - x;
        if(abs(y)<eps) {
            printf("Print : %lf\n",$2);
        }
        else {
            printf("Print : %d\n",(int)$2);
        }
    }
    | PRINT LB STRING RB
    {
        printf("Print : %s\n",$3);
    }
    ;
group:LB arith RB
    {
        int x = (int)$2;
        double y = $2 - x;
        if(abs(y)<eps) {
            $<ival>$ = $2;
        }
        else {
            $<dval>$ = $2;
        }
    }
    ;
type: INT {sscanf("int","%s",$$);}
    | DOUBLE {sscanf("double","%s",$$);}
    ;
%%

int main(int argc, char** argv)
{
    yylineno = 1;
    symnum = 0;
    yyparse();

//	printf("%d \n\n",yylineno);
	dump_symbol();
    return 0;
}

void yyerror(char *s) {
    printf("<ERROR> %s (line %d)\n",s,yylineno);
//    printf("%s on %d line %s \n",s , yylineno, yytext);
}


/*symbol create function*/
void create_symbol() {
    struct symbol *new_node;
    new_node = malloc(sizeof(struct symbol));
    if (new_node == NULL) {
        exit(EXIT_FAILURE);
    }
    memset(new_node->sym_type,0,sizeof(new_node->sym_type));
    memset(new_node->name,0,sizeof(new_node->name));
    new_node->pre = NULL;
    if(symbol_table != NULL) {
        symbol_table -> pre = new_node;
    }
    new_node->next = symbol_table;
    symbol_table = new_node;

}

/*symbol insert function*/
void insert_symbol(char* id, char* type, double data) {
	if(lookup_symbol(id)) {
        char tmp[200] = {0};
        strcat(tmp,"re-declaration for variable ");
        strcat(tmp,id);
        yyerror(tmp);
        return;   
    }
    symbol_table->data = data;
    strcpy(symbol_table->name,id);
    strcpy(symbol_table->sym_type,type);
    printf("Insert a symbol: %s\n",id);
    symnum++;
}


/*symbol value lookup and check exist function*/
int lookup_symbol(char* id){
	struct symbol *tmp  = symbol_table;
    while(tmp!=NULL&&tmp->name!=NULL) {
        if(strcmp(tmp->name,id)==0) {
            if(strcmp(tmp->sym_type,"int")==0) {
                return 1;
            }
            else {
                return 2;
            }
        }
        tmp = tmp->next;
    }
    return 0;
}

/*symbol value assign function*/
void symbol_assign(char* id, double data) {
    int check;
    if(!(check = lookup_symbol(id))) {
        char tmp[200] = {0};
        strcat(tmp,"can’t find variable ");
        strcat(tmp,id);
        yyerror(tmp);
        return;
    }
    struct symbol *tmp  = symbol_table;
    if(check==1) {
        while(tmp!=NULL&&tmp->name!=NULL) {
            if(strcmp(tmp->name,id)==0) {
                tmp->data = (int)data;
                return;
            }
            tmp = tmp->next;
        }
    }
    else {
        while(tmp!=NULL&&tmp->name!=NULL) {
            if(strcmp(tmp->name,id)==0) {
                tmp->data = data;
                return;
            }
            tmp = tmp->next;
        } 
    }
}

/*symbol dump function*/
void dump_symbol(){
	printf("Total lines: %d.\n\n",yylineno);
    printf("The symbol table: \n\n");
    struct symbol *tmp = symbol_table;
    if(tmp == NULL) {
        printf("symbol table is empty\n");
        return;
    }
    printf("ID \t Type \t Data\n");
    while(tmp->next!=NULL) {
        tmp = tmp->next;
    }
    while(tmp!=NULL) {
        if(strcmp(tmp->sym_type,"int")==0) {
            printf("%s \t %s \t %d\n",tmp->name,tmp->sym_type,(int)tmp->data);
        }
        else {
            printf("%s \t %s \t %lf\n",tmp->name,tmp->sym_type,tmp->data);
        }
        tmp = tmp->pre;
        if(tmp!=NULL) {
            free(tmp->next);
        }
    }

}
double lookup_double_sym(char* id) {
	struct symbol *tmp  = symbol_table;
    while(tmp!=NULL&&tmp->name!=NULL) {
        if(strcmp(tmp->name,id)==0) {
            return tmp->data;
        }
        tmp = tmp->next;
    }
}

