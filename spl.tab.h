/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ARROW = 258,
     LPAREN = 259,
     RPAREN = 260,
     LCURLY = 261,
     RCURLY = 262,
     COLON = 263,
     LBRACKET = 264,
     RBRACKET = 265,
     DOT = 266,
     STAR = 267,
     AT = 268,
     SLASH = 269,
     MODULUS = 270,
     PLUS = 271,
     MINUS = 272,
     LEQ = 273,
     LT = 274,
     GEQ = 275,
     EQ = 276,
     NEQ = 277,
     LEFT_SHIFT = 278,
     RIGHT_SHIFT = 279,
     ASSIGN = 280,
     MUL_ASSIGN = 281,
     DIV_ASSIGN = 282,
     MOD_ASSIGN = 283,
     ADD_ASSIGN = 284,
     SUB_ASSIGN = 285,
     LEFT_ASSIGN = 286,
     RIGHT_ASSIGN = 287,
     AND_ASSIGN = 288,
     XOR_ASSIGN = 289,
     OR_ASSIGN = 290,
     LOG_OR = 291,
     LOG_AND = 292,
     ARITH_OR = 293,
     ARITH_AND = 294,
     ARITH_XOR = 295,
     INC_OP = 296,
     DEC_OP = 297,
     BANG = 298,
     SEMI = 299,
     IF = 300,
     ELSE = 301,
     FOR = 302,
     WHILE = 303,
     CHAR = 304,
     SHORT = 305,
     INT = 306,
     LONG = 307,
     UNSIGNED = 308,
     SIGNED = 309,
     FLOAT = 310,
     DOUBLE = 311,
     VOID = 312,
     STRING = 313,
     STATIC = 314,
     STRUCT = 315,
     UNION = 316,
     CONST = 317,
     SIZEOF = 318,
     TYPEDEF = 319,
     RETURN_TOKEN = 320,
     PRINT = 321,
     COMMA = 322,
     DOTDOTDOT = 323,
     integer_constant = 324,
     string_constant = 325,
     floating_constant = 326,
     identifier_ref = 327,
     type_id = 328,
     ANY = 329,
     AS = 330,
     ATTRIBUTE = 331,
     BLOB = 332,
     BOOLEAN = 333,
     BREAK = 334,
     COLLECTION = 335,
     COLON_COLON = 336,
     COMPLEX = 337,
     COMPLEX32 = 338,
     COMPLEX64 = 339,
     COMPOSITE = 340,
     CONFIG = 341,
     CONTINUE = 342,
     DECIMAL = 343,
     DECIMAL128 = 344,
     DECIMAL32 = 345,
     DECIMAL64 = 346,
     DOT_ARITH_AND = 347,
     DOT_ARITH_OR = 348,
     DOT_ARITH_XOR = 349,
     DOT_EQ = 350,
     DOT_GEQ = 351,
     DOT_GT = 352,
     DOT_LEFT_SHIFT = 353,
     DOT_LEQ = 354,
     DOT_LT = 355,
     DOT_MINUS = 356,
     DOT_MODULUS = 357,
     DOT_NEQ = 358,
     DOT_PLUS = 359,
     DOT_RIGHT_SHIFT = 360,
     DOT_SLASH = 361,
     DOT_STAR = 362,
     ENUM = 363,
     EXPRESSION = 364,
     FALSE = 365,
     FLOAT32 = 366,
     FLOAT64 = 367,
     FLOATINGPOINT = 368,
     FUNCTION = 369,
     GRAPH = 370,
     IN = 371,
     INPUT = 372,
     INT128 = 373,
     INT16 = 374,
     INT32 = 375,
     INT64 = 376,
     INT8 = 377,
     INTEGRAL = 378,
     LIST = 379,
     LOGIC = 380,
     MAP = 381,
     MUTABLE = 382,
     NAMESPACE = 383,
     NUMERIC = 384,
     ONPUNCT = 385,
     ONTUPLE = 386,
     OPERATOR = 387,
     ORDERED = 388,
     OUTPUT = 389,
     PARAM = 390,
     PRIMITIVE = 391,
     PUBLIC = 392,
     QUESTION = 393,
     SET = 394,
     STATE = 395,
     STATEFUL = 396,
     STREAM = 397,
     STRING8 = 398,
     STRING16 = 399,
     TILDE = 400,
     TIMESTAMP = 401,
     TRUE = 402,
     TUPLE = 403,
     TYPE = 404,
     UINT128 = 405,
     UINT16 = 406,
     UINT32 = 407,
     UINT64 = 408,
     UINT8 = 409,
     USE = 410,
     WINDOW = 411
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2068 of yacc.c  */
#line 63 "spl.y"

    lx_info info;
    sm_ref reference;
    sm_list list;
    char *string;



/* Line 2068 of yacc.c  */
#line 215 "/home/drew/projects/SPL2EVPath/spl.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


