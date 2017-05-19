/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    SEM = 258,
    PRINT = 259,
    WHILE = 260,
    LB = 261,
    RB = 262,
    ADD = 263,
    SUB = 264,
    MUL = 265,
    DIV = 266,
    ASSIGN = 267,
    NUMBER = 268,
    FLOATNUM = 269,
    ID = 270,
    STRING = 271,
    INT = 272,
    DOUBLE = 273,
    GE = 274,
    LE = 275,
    EQ = 276,
    NE = 277,
    G = 278,
    L = 279,
    UMINUS = 280
  };
#endif
/* Tokens.  */
#define SEM 258
#define PRINT 259
#define WHILE 260
#define LB 261
#define RB 262
#define ADD 263
#define SUB 264
#define MUL 265
#define DIV 266
#define ASSIGN 267
#define NUMBER 268
#define FLOATNUM 269
#define ID 270
#define STRING 271
#define INT 272
#define DOUBLE 273
#define GE 274
#define LE 275
#define EQ 276
#define NE 277
#define G 278
#define L 279
#define UMINUS 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 53 "Compiler_E94036209_HW2.y" /* yacc.c:1909  */

    int ival;
    double dval;
    char sval[100];
    char typeval[10];

#line 111 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
