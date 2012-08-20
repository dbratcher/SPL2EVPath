%{
#include "config.h"
#include "stdio.h"
#include <stdlib.h>
#ifdef HAVE_MALLOC_H
#include <malloc.h>
#endif
#include <string.h>
#include "spl_internal.h"
#include "structs.h"
#define yyparse spl_yyparse
#define yylex spl_yylex
#define yyrestart spl_yyrestart
#define yywrap spl_yywrap
#define yyerror spl_yyerror
#define yy_create_buffer spl_yy_create_buffer
#define yy_delete_buffer spl_yy_delete_buffer
#define yy_flush_buffer spl_yy_flush_buffer
#define yy_init_buffer spl_yy_init_buffer
#define yy_load_buffer_state spl_yy_load_buffer_state
#define yy_scan_buffer spl_yy_scan_buffer
#define yy_scan_bytes spl_yy_scan_bytes
#define yy_scan_string spl_yy_scan_string
#define yy_switch_to_buffer spl_yy_switch_to_buffer
#define yychar spl_yychar
#define yyin spl_yyin
#define yyleng spl_yyleng
#define yylval spl_yylval
#define yynerrs spl_yynerrs
#define yyout spl_yyout
#define yytext spl_yytext
#define yyset_out spl_yyset_out
#define yyset_lineno spl_yyset_lineno
#define yyset_in spl_yyset_in
#define yyset_debug spl_yyset_debug
#define yyrealloc spl_yyrealloc
#define yyalloc spl_yyalloc
#define yyfree spl_yyfree
#define yypush_buffer_state spl_yypush_buffer_state
#define yypop_buffer_state spl_yypop_buffer_state
#define yylex_destroy spl_yylex_destroy
#define yyget_out spl_yyget_out
#define yyget_lineno spl_yyget_lineno
#define yyget_in spl_yyget_in
#define yyget_debug spl_yyget_debug
#define yyget_text spl_yyget_text
#define yyget_leng spl_yyget_leng

static char *create_string_from_yytext();
extern int yylex();
extern int yyparse();
static sm_ref yyparse_value;
static int yyerror_count = 1;
extern void yyerror(char *str);
static int parsing_type = 0;
void program1(sm_ref one, sm_list two);
void program2(sm_ref one, sm_list two);
static int parsing_param_spec = 0;
static spl_parse_context yycontext;
static const char *spl_code_string;
%}

%union {
    lx_info info;
    sm_ref reference;
    sm_list list;
    char *string;
};

%token <info> ARROW
%token <info> LPAREN
%token <info> RPAREN
%token <info> LCURLY
%token <info> RCURLY
%token <info> COLON
%token <info> LBRACKET
%token <info> RBRACKET
%token <info> DOT
%token <info> STAR
%token <info> AT
%token <info> SLASH
%token <info> MODULUS
%token <info> PLUS
%token <info> MINUS
%token <info> LEQ
%token <info> LT
%token <info> GEQ
%token <info> EQ
%token <info> NEQ
%token <info> LEFT_SHIFT
%token <info> RIGHT_SHIFT
%token <info> ASSIGN
%token <info> MUL_ASSIGN
%token <info> DIV_ASSIGN
%token <info> MOD_ASSIGN
%token <info> ADD_ASSIGN
%token <info> SUB_ASSIGN
%token <info> LEFT_ASSIGN
%token <info> RIGHT_ASSIGN
%token <info> AND_ASSIGN
%token <info> XOR_ASSIGN
%token <info> OR_ASSIGN
%token <info> LOG_OR
%token <info> LOG_AND
%token <info> ARITH_OR
%token <info> ARITH_AND
%token <info> ARITH_XOR
%token <info> INC_OP
%token <info> DEC_OP
%token <info> BANG
%token <info> SEMI
%token <info> IF
%token <info> ELSE
%token <info> FOR
%token <info> WHILE
%token <info> CHAR
%token <info> SHORT
%token <info> INT
%token <info> LONG
%token <info> UNSIGNED
%token <info> SIGNED
%token <info> FLOAT
%token <info> DOUBLE
%token <info> VOID
%token <info> STRING
%token <info> STATIC
%token <info> STRUCT
%token <info> UNION
%token <info> CONST
%token <info> SIZEOF
%token <info> TYPEDEF
%token <info> RETURN_TOKEN
%token <info> PRINT
%token <info> COMMA
%token <info> DOTDOTDOT
%token <info> integer_constant
%token <info> string_constant
%token <info> floating_constant
%token <info> identifier_ref
%token <info> type_id
%token <info> ANY
%token <info> AS
%token <info> ATTRIBUTE
%token <info> BLOB
%token <info> BOOLEAN
%token <info> BREAK
%token <info> COLLECTION
%token <info> COLON_COLON
%token <info> COMPLEX
%token <info> COMPLEX32
%token <info> COMPLEX64
%token <info> COMPOSITE
%token <info> CONFIG
%token <info> CONTINUE
%token <info> DECIMAL
%token <info> DECIMAL128
%token <info> DECIMAL32
%token <info> DECIMAL64
%token <info> DOT_ARITH_AND
%token <info> DOT_ARITH_OR
%token <info> DOT_ARITH_XOR
%token <info> DOT_EQ
%token <info> DOT_GEQ
%token <info> DOT_GT
%token <info> DOT_LEFT_SHIFT
%token <info> DOT_LEQ
%token <info> DOT_LT
%token <info> DOT_MINUS
%token <info> DOT_MODULUS
%token <info> DOT_NEQ
%token <info> DOT_PLUS
%token <info> DOT_RIGHT_SHIFT
%token <info> DOT_SLASH
%token <info> DOT_STAR
%token <info> ENUM
%token <info> EXPRESSION
%token <info> FALSE
%token <info> FLOAT32
%token <info> FLOAT64
%token <info> FLOATINGPOINT
%token <info> FUNCTION
%token <info> GRAPH
%token <info> IN
%token <info> INPUT
%token <info> INT128
%token <info> INT16
%token <info> INT32
%token <info> INT64
%token <info> INT8
%token <info> INTEGRAL
%token <info> LIST
%token <info> LOGIC
%token <info> MAP
%token <info> MUTABLE
%token <info> NAMESPACE
%token <info> NUMERIC
%token <info> ONPUNCT
%token <info> ONTUPLE
%token <info> OPERATOR
%token <info> ORDERED
%token <info> OUTPUT
%token <info> PARAM
%token <info> PRIMITIVE
%token <info> PUBLIC
%token <info> QUESTION
%token <info> SET
%token <info> STATE
%token <info> STATEFUL
%token <info> STREAM
%token <info> STRING8
%token <info> STRING16
%token <info> TILDE
%token <info> TIMESTAMP
%token <info> TRUE
%token <info> TUPLE
%token <info> TYPE
%token <info> UINT128
%token <info> UINT16
%token <info> UINT32
%token <info> UINT64
%token <info> UINT8
%token <info> USE
%token <info> WINDOW
%type <reference> primitiveLiteral;
%type <reference> literal;
%type <reference> primitiveType;
%type <reference> type;
%type <reference> streamspec;
%type <reference> as_clause;
%type <reference> attributeDecl;
%type <reference> expr;
%type <reference> infixOp;
%type <reference> infixExpr;
%type <reference> compositeHead;
%type <reference> opOutput;
%type <reference> opInvokeHead;
%type <reference> opInvokeActual;
%type <reference> opActual;
%type <reference> opInvokeBody;
%type <reference> opInvoke;
%type <reference> opInvokeOutput;
%type <list> opInputs;
%type <list> opOutputs;
%type <list> portInputs;
%type <list> opInvokeActual_list;
%type <list> opInvokeOutput_list;
%type <list> expr_list_comma;
%type <list> opInput_list;
%type <list> attributeDecl_list;
%type <list> invoke_actual_opt;
%type <list> tupleBody;
%type <list> tupleType;
%type <list> compositeType;
%type <list> assign_expr_list;
%type <list> streamType;
%type <list> opInvoke_list;
%type <list> id_list_dot;
%type <list> invoke_output_opt;
%%

start : 
	compilationUnit {
            printf("start?\n");
        }
	;

compilationUnit:
	namespace useDirective_list	comp_or_func_list {
            printf("compilationUnit?\n");
        }
	;

comp_or_func_list
	:comp_or_func {
            printf("comp_or_func_list?\n");
        }
	|comp_or_func_list comp_or_func {
            printf("comp_or_func_list?\n");
        }
	;

comp_or_func
	:compositeDef {
            printf("comp_or_func?\n");
        }
	|functionDef {
            printf("comp_or_func?\n");
        }
	;

namespace:
	NAMESPACE id_list_dot SEMI {
            printf("namespace?\n");
        }
	;

id_list_dot
	:identifier_ref {
            $$ = malloc(sizeof(struct list_struct));
            sm_ref atmp = spl_new_identifier();
            atmp->node.identifier.id = $1.string;
            $$->node = atmp;
            $$->next = NULL;
        }
	|id_list_dot DOT identifier_ref {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
            sm_ref tmp2 = spl_new_identifier();
            tmp2->node.identifier.id = $3.string;
	    tmp->next = malloc(sizeof(struct list_struct));
	    tmp->next->node = tmp2;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

id_list_comma
	:identifier_ref {
            printf("id_list_comma?\n");
        }
	|id_list_comma COMMA identifier_ref {
            printf("id_list_comma?\n");
        }
	;

useDirective_list
	: /* empty */
	|useDirective_list useDirective {
            printf("useDirective_list?\n");
        }
	;

useDirective
	: USE id_list_dot COLON_COLON STAR SEMI{
            printf("useDirective?\n");
        }
	| USE id_list_dot COLON_COLON identifier_ref SEMI{
            printf("useDirective?\n");
        }
	;

compositeDef:
	compositeHead compositeBody {
            printf("compositeDef?\n");
        }
	;

compositeHead
	: public_opt COMPOSITE identifier_ref {
	    $$ = spl_new_identifier();
	    $$->node.identifier.id = $3.string;
	    $$->node.identifier.lx_srcpos = $3.lx_srcpos;
        }
	| public_opt COMPOSITE identifier_ref LPAREN compositeInOutList RPAREN {
            printf("compositeHead?\n");
        }
	;

public_opt:
	/*empty*/
	| PUBLIC {
            printf("public opt?\n");
        }
	;

compositeInOutList:
	compositeInOut {
            printf("compositeInOutList?\n");
        }
	| compositeInOutList SEMI compositeInOut {
            printf("compositeInOutList?\n");
        }
	;

compositeInOut:
	INPUT streamlist {
            printf("compositeInOut?\n");
        }
	| OUTPUT streamlist {
            printf("compositeInOut?\n");
        }
	;

streamlist:
	streamspec {
            printf("streamlist?\n");
        }
	|streamlist COMMA streamspec {
            printf("streamlist?\n");
        }
	;

streamspec:
	identifier_ref {
	    $$ = spl_new_identifier();
	    $$->node.identifier.id = $1.string;
	    $$->node.identifier.lx_srcpos = $1.lx_srcpos;
	}
	| streamType identifier_ref {
	    $$ = spl_new_identifier();
	    $$->node.identifier.id = $2.string;
	    $$->node.identifier.lx_srcpos = $2.lx_srcpos;
	}
	;

streamType:
	STREAM LT tupleBody '>' {
            $$ = $3;
        }
	;

compositeBody:
	LCURLY param_opt type_opt graph_opt config_opt RCURLY {
            printf("compositeBody?\n");
        }
	;

param_opt:
	/*empty*/
	| PARAM compositeFormal_list{
            printf("param_opt?\n");
        }
	;

compositeFormal_list:
	compositeFormal {
            printf("compositeFormal_list?\n");
        }
	| compositeFormal_list compositeFormal {
            printf("compositeFormal_list?\n");
        }

type_opt:
	/*empty*/
	| TYPEDEF compositeTypeDef_list {
            printf("type_opt?\n");
        }
	;

compositeTypeDef_list:
	compositeTypeDef {
            printf("compositeTypeDef_list?\n");
        }
	| compositeTypeDef_list compositeTypeDef {
            printf("compositeTypeDef_list?\n");
        }
	;

graph_opt:
	/*empty*/
	| GRAPH opInvoke_list {
            printf("printing program to main.c\n");
            //program1(NULL, $2); //prints individual stones each with with its own output type
            program2(NULL,$2); //closer to dfg_chain_test
        }
	;

opInvoke_list:
	opInvoke {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| opInvoke_list opInvoke {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
	    tmp->next = malloc(sizeof(struct list_struct));
	    tmp->next->node = $2;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

config_opt:
	/*empty*/
	| CONFIG configuration_list{
            printf("config_opt?\n");
        }
	;

configuration_list:
	configuration {
            printf("configuration_list?\n");
        }
	| configuration_list configuration {
            printf("configuration_list?\n");
        }
	;

compositeFormal:
	ATTRIBUTE identifier_ref SEMI {
            printf("compositeFormal?\n");
        }
	| EXPRESSION typeArgs_list  identifier_ref SEMI /* Operator parameter modes */ {
            printf("compositeFormal?\n");
        }
	| FUNCTION identifier_ref SEMI {
            printf("compositeFormal?\n");
        }
	| OPERATOR identifier_ref SEMI {
            printf("compositeFormal?\n");
        }
	| TYPE identifier_ref SEMI {
            printf("compositeFormal?\n");
        }
	| ATTRIBUTE identifier_ref COLON opActual SEMI {
            printf("compositeFormal?\n");
        }
	| EXPRESSION typeArgs_list  identifier_ref COLON opActual SEMI /* Operator parameter modes */ {
            printf("compositeFormal?\n");
        }
	| FUNCTION identifier_ref COLON opActual SEMI {
            printf("compositeFormal?\n");
        }
	| OPERATOR identifier_ref COLON opActual SEMI {
            printf("compositeFormal?\n");
        }
	| TYPE identifier_ref COLON opActual SEMI {
            printf("compositeFormal?\n");
        }
	;

opInvokeActual:
	identifier_ref COLON opActual SEMI {
            $$ = spl_new_field();
            $$->node.field.name = $1.string;
            $$->node.field.sm_complex_type = $3;
        }
	;

opActual:
	type {
            printf("opActual?");
        }
	| expr_list_comma {
            $$ = spl_new_field();
            $$->node.field.name = "opActual";
            $$->node.field.type_spec = $1;
        }
	;

expr_list_comma:
	expr {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| expr_list_comma COMMA expr {
            printf("expr_list_comma?\n");
        }
	;

/* expr_list_comma is config_clause_list */
configuration:
	identifier_ref COLON expr_list_comma SEMI {
            printf("configuration?\n");
        }
	;

opInvoke:
	opInvokeHead opInvokeBody {
            $$= spl_new_assignment_expression();
            $$->node.assignment_expression.left=$1;
            $$->node.assignment_expression.right=$2;
        }
	;

opInvokeHead:
	opOutputs ASSIGN identifier_ref opInputs {
            $$= spl_new_assignment_expression();
            sm_ref tmp2= spl_new_field();
            tmp2->node.field.name = $3.string;
            tmp2->node.field.type_spec = $1;
            $$->node.assignment_expression.left = tmp2;
            sm_ref tmp= spl_new_field();
            tmp->node.field.name = $3.string;
            tmp->node.field.type_spec = $4;
            $$->node.assignment_expression.right = tmp;
        }
	;

as_clause:
	/*empty*/{
            printf("as_clause?\n");
        }
	| AS identifier_ref {
	    $$ = spl_new_field();
	    $$->node.field.name = $2.string;
	}
	;

opOutputs:
	opOutput {  
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| LPAREN RPAREN as_clause  {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $3;
            $$->next = NULL;
        }
	| LPAREN opOutput_list RPAREN as_clause  {
            printf("opOutputs?\n");
        }
	;

opOutput_list:
	opOutput {
            printf("opOutput_list?\n");
        }
	| opOutput_list SEMI opOutput {
            printf("opOutput_list?\n");
        }
	;

opOutput:
	streamType identifier_ref as_clause {
            $$ = spl_new_field();
            $$->node.field.type_spec = $1;
            $$->node.field.name = $2.string;
        }
	;

opInputs:
	LPAREN RPAREN {
            $$ = NULL;
        }
	| LPAREN opInput_list RPAREN {
            $$= $2;
        }
	;

opInput_list:
	portInputs {
            $$ = malloc(sizeof(struct list_struct));   
            sm_ref temp = spl_new_field();
            temp->node.field.type_spec = $1;
            temp->node.field.name = "opInput_list";
            $$->node = temp;
            $$->next = NULL;
        }
	| opInput_list SEMI portInputs {
            printf("opInput_list?\n");
        }
	;

portInputs:
	id_list_dot as_clause {
            $$=$1;
        }
	| streamType id_list_dot as_clause {
            printf("portInputs?\n");
        }
	;

opInvokeBody:
	LCURLY invoke_logic_opt invoke_window_opt invoke_actual_opt invoke_output_opt invoke_config_opt RCURLY {
            $$=NULL;
        }
	;

invoke_logic_opt:
	/* empty */
	| LOGIC opInvokeLogic_list {
            printf("invoke_logic_opt?\n");
        }
	;

invoke_window_opt:
	/* empty */{
            printf("invoke_window_opt?\n");
        }
	| WINDOW opInvokeWindow_list {
            printf("invoke_window_opt?\n");
        }
	;

invoke_actual_opt:
	/* empty */{
            printf("invoke_actual_opt?\n");
        }
	| PARAM opInvokeActual_list {
            $$=$2;
        }
	;

invoke_output_opt:
	/* empty */{
            printf("invoke_output_opt?\n");
        }
	| OUTPUT opInvokeOutput_list {
            $$=$2;
        }
	;

invoke_config_opt:
	/* empty */
	| CONFIG configuration_list {
            printf("invoke_config_opt?\n");
        }
	;

opInvokeLogic_list:
	opInvokeLogic {
            printf("opInvokeLogic_list?\n");
        }
	| opInvokeLogic_list opInvokeLogic {
            printf("opInvokeLogic_list?\n");
        }
	;

opInvokeWindow_list:
	opInvokeWindow {
            printf("opInvokeWindow_list?\n");
        }
	| opInvokeWindow_list opInvokeWindow {
            printf("opInvokeWindow_list?\n");
        }
	;

opInvokeActual_list:
	opInvokeActual {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| opInvokeActual_list opInvokeActual {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
	    tmp->next = malloc(sizeof(struct list_struct));
	    tmp->next->node = $2;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

opInvokeOutput_list:
	opInvokeOutput {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| opInvokeOutput_list opInvokeOutput {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
	    tmp->next = malloc(sizeof(struct list_struct));
	    tmp->next->node = $2;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

opInvokeLogic:
	opInvokeCode {
            printf("opInvokeLogic?\n");
        }
	| opInvokeState {
            printf("opInvokeLogic?\n");
        }
	;

opInvokeCode:
	ONTUPLE identifier_ref COLON stmt {
            printf("opInvokeCode?\n");
        }
	| ONPUNCT identifier_ref COLON stmt {
            printf("opInvokeCode?\n");
        }
	;

opInvokeState:
	STATE COLON varDef {
            printf("opInvokeState?\n");
        }
	| STATE COLON LCURLY varDef_list RCURLY {
            printf("opInvokeState?\n");
        }
	;

varDef_list:
	varDef {
            printf("varDef_list?\n");
        }
	| varDef_list varDef {
            printf("varDef_list?\n");
        }
	;

opInvokeWindow:
	identifier_ref COLON expr_list_comma SEMI {
            printf("opInvokeWindow?\n");
        }
	;

opInvokeOutput:
	identifier_ref COLON assign_expr_list SEMI {
            $$=spl_new_field();
            $$->node.field.name=$1.string;
            $$->node.field.type_spec=$3;
        }
	;

assign_expr_list:
	identifier_ref ASSIGN expr  {
            $$ = malloc(sizeof(struct list_struct));
            sm_ref tmp = spl_new_assignment_expression();
            tmp->node.assignment_expression.right= $3;
            $$->node = tmp;
            $$->next = NULL;
        }
	| assign_expr_list COMMA identifier_ref ASSIGN expr {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
	    tmp->next = malloc(sizeof(struct list_struct));
            sm_ref tmp2 = spl_new_assignment_expression();
            tmp2->node.assignment_expression.right= $5;
            sm_ref id = spl_new_identifier();
            id->node.identifier.id=$3.string;
            tmp2->node.assignment_expression.left= id;
	    tmp->next->node = tmp2;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

functionDef:
	functionHead blockStmt {
            printf("functionDef?\n");
        }
	;

functionHead:
	functionModifier_list type identifier_ref LPAREN functionFormal_list RPAREN {
            printf("functionHead?");
        }
	;

functionModifier_list:
	/* empty */
	| functionModifier_list PUBLIC {
            printf("functionModifier_list?\n");
        }
	| functionModifier_list STATEFUL {
            printf("functionModifier_list?\n");
        }
	;

functionFormal_list:
	functionFormal {
            printf("functionFormal_list?\n");
        }
	| functionFormal_list COMMA functionFormal {
            printf("functionFormal_list?\n");
        }
	;

functionFormal:
	mutable_opt type identifier_ref {
            printf("functionFormal?");
        }
	;

/* !!!!!!!!!  this is missing from the grammar on the web !!!!!!!!!!!!!!!!!!!!!!!*/

stmt:
	varDef  {
            printf("stmt?\n");
        }
	| blockStmt  {
            printf("stmt?\n");
        }
	| exprStmt {
            printf("stmt?\n");
        }
	| ifStmt  {
            printf("stmt?\n");
        }
	| forStmt  {
            printf("stmt?\n");
        }
	| whileStmt {
            printf("stmt?\n");
        }
	| breakStmt  {
            printf("stmt?\n");
        }
	| continueStmt  {
            printf("stmt?\n");
        }
	| returnStmt {
            printf("stmt?\n");
        }
	;

varDef:
	mutable_opt type assign_expr_list SEMI {
            printf("varDef?");
        }
	;

mutable_opt:
	/*empty*/
	| MUTABLE {
            printf("mutable_opt?\n");
        }
	;

blockStmt:
	LCURLY stmt_typedef_list RCURLY {
            printf("blockStmt?\n");
        }
	;

stmt_typedef_list:
	/*empty*/
	| stmt_typedef_list stmt {
            printf("stmt_typedef_list?\n");
        }
	| stmt_typedef_list standAloneTypeDef {
            printf("stmt_typedef_list?\n");
        }
	;

exprStmt:
	expr SEMI {
            printf("exprStmt?\n");
        }
	;

ifStmt:
	IF LPAREN expr RPAREN stmt  {
            printf("ifStmt?\n");
        }
	|IF LPAREN expr RPAREN stmt ELSE stmt {
            printf("ifStmt?\n");
        }
	;

forStmt:
	FOR LPAREN type identifier_ref IN expr RPAREN stmt {
            printf("forStmt?");
        }
	;

whileStmt:
	WHILE LPAREN expr RPAREN stmt {
            printf("whileStmt?\n");
        }
	;

breakStmt:
	BREAK SEMI {
            printf("breakStmt?\n");
        }
	;

continueStmt:
	CONTINUE SEMI {
            printf("continueStmt?\n");
        }
	;

returnStmt:
	RETURN_TOKEN SEMI {
            printf("returnStmt?\n");
        }
	| RETURN_TOKEN expr SEMI {
            printf("returnStmt?\n");
        }
	;

expr:
	prefixExpr   {
            printf("expr?\n");
        }
	| infixExpr {
            $$= $1;
        }
	| postfixExpr {
            printf("expr?\n");
        }
	| conditionalExpr  {
            printf("expr?\n");
        }
	| LPAREN expr RPAREN   {
            printf("expr?\n");
        }
	| identifier_ref {
	    $$ = spl_new_identifier();
	    $$->node.identifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.identifier.id = $1.string;
	}
	| literal {
            $$=$1;
        }
	;

prefixExpr:
	prefixOp expr {
            printf("prefixExpr?\n");
        }
	;

prefixOp:
	BANG {
            printf("prefixOp?\n");
        }
        | MINUS {
            printf("prefixOp?\n");
        }
	| TILDE {
            printf("prefixOp?\n");
        }
	| INC_OP {
            printf("prefixOp?\n");
        }
	| DEC_OP {
            printf("prefixOp?\n");
        }
	;

infixExpr:
	expr infixOp expr {
	    $$ = $2;
	    $$->node.operator.right = $3;
	    $$->node.operator.left = $1;
        }
	| expr mappedOp expr {
            printf("infixExpr?\n");
        }
	| expr assignOp expr {
            printf("infixExpr?\n");
        }
	;

infixOp:
	PLUS {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = PLUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| MINUS {
            printf("infixOp?\n");
        }
	| STAR {
            printf("infixOp?\n");
        }
	| SLASH {
            printf("infixOp?\n");
        }
	| MODULUS {
            printf("infixOp?\n");
        }
	| LEFT_SHIFT {
            printf("infixOp?\n");
        }
	| ">>" {
            printf("infixOp?\n");
        }
	| ARITH_AND {
            printf("infixOp?\n");
        }
	| ARITH_XOR {
            printf("infixOp?\n");
        }
	| ARITH_OR {
            printf("infixOp?\n");
        }
	| LOG_AND {
            printf("infixOp?\n");
        }
	| LOG_OR {
            printf("infixOp?\n");
        }
	| IN {
            printf("infixOp?\n");
        }
	| LT {
            printf("infixOp?\n");
        }
	| LEQ {
            printf("infixOp?\n");
        }
	| '>' {
            printf("infixOp?\n");
        }
	| GEQ {
            printf("infixOp?\n");
        }
	| NEQ {
            printf("infixOp?\n");
        }
	| EQ {
            printf("infixOp?\n");
        }
	;

mappedOp:
	DOT_PLUS {
            printf("mappedOp?\n");
        }
	| DOT_MINUS {
            printf("mappedOp?\n");
        }
	| DOT_STAR {
            printf("mappedOp?\n");
        }
	| DOT_SLASH {
            printf("mappedOp?\n");
        }
	| DOT_MODULUS {
            printf("mappedOp?\n");
        }
	| DOT_LEFT_SHIFT {
            printf("mappedOp?\n");
        }
	| DOT_RIGHT_SHIFT {
            printf("mappedOp?\n");
        }
	| DOT_ARITH_AND {
            printf("mappedOp?\n");
        }
	| DOT_ARITH_XOR {
            printf("mappedOp?\n");
        }
	| DOT_ARITH_OR {
            printf("mappedOp?\n");
        }
	| DOT_LEQ {
            printf("mappedOp?\n");
        }
	| DOT_LT {
            printf("mappedOp?\n");
        }
	| DOT_GT {
            printf("mappedOp?\n");
        }
	| DOT_GEQ {
            printf("mappedOp?\n");
        }
	| DOT_NEQ {
            printf("mappedOp?\n");
        }
	| DOT_EQ {
            printf("mappedOp?\n");
        }
	;

assignOp:
	ASSIGN {
            printf("assignOp?\n");
        }
	| ADD_ASSIGN {
            printf("assignOp?\n");
        }
	| SUB_ASSIGN {
            printf("assignOp?\n");
        }
	| MUL_ASSIGN {
            printf("assignOp?\n");
        }
	| DIV_ASSIGN {
            printf("assignOp?\n");
        }
	| MOD_ASSIGN {
            printf("assignOp?\n");
        }
	| LEFT_ASSIGN {
            printf("assignOp?\n");
        }
	| RIGHT_ASSIGN {
            printf("assignOp?\n");
        }
	| AND_ASSIGN {
            printf("assignOp?\n");
        }
	| XOR_ASSIGN {
            printf("assignOp?\n");
        }
	| OR_ASSIGN {
            printf("assignOp?\n");
        }
	;

postfixExpr:
	identifier_ref LPAREN expr_list_comma RPAREN {
            printf("postfixExpr?\n");
        }
	| type LPAREN expr RPAREN {
            printf("postfixExpr?");
        }
	| expr LBRACKET subscript RBRACKET {
            printf("postfixExpr?\n");
        }
	| expr DOT identifier_ref {
            printf("postfixExpr?\n");
        }
	| expr postfixOp {
            printf("postfixExpr?\n");
        }
	;

subscript:
	expr {
            printf("subscript?\n");
        }
	| expr_opt COLON expr_opt {
            printf("subscript?\n");
        }
	;

expr_opt:
	/*empty*/
	| expr {
            printf("expr_opt?\n");
        }
	;

postfixOp:
	INC_OP {
            printf("postfixOp?\n");
        }
	| DEC_OP {
            printf("postfixOp?\n");
        }
	;

conditionalExpr:
	expr QUESTION expr COLON expr {
            printf("conditionalExpr?\n");
        }
	;

literal:
	primitiveLiteral {
            $$ = $1;
        }
	| listLiteral {
            printf("literal?\n");
        }
	| setLiteral {
            printf("literal?\n");
        }
	| mapLiteral {
            printf("literal?\n");
        }
	| tupleLiteral {
            printf("literal?\n");
        }

	/* collections */
listLiteral:
	LBRACKET expr_list_comma RBRACKET {
            printf("listLiteral?\n");
        }
	;

setLiteral:
	LCURLY expr_list_comma RCURLY {
            printf("setLiteral?\n");
        }
	;

mapLiteral:
	LCURLY map_list RCURLY {
            printf("mapLiteral?\n");
        }
	;

map_list:
	map {
            printf("map_list?\n");
        }
	| map_list COMMA map {
            printf("map_list?\n");
        }
	;

map:
	expr COLON expr {
            printf("map?\n");
        }
	;

tupleLiteral:
	LCURLY assign_expr_list RCURLY {
            printf("tupleLiteral?\n");
        }
	;

primitiveLiteral:
	TRUE {
            printf("primitiveLiteral?\n");
        }
	| FALSE {
            printf("primitiveLiteral?\n");
        }
	| string_constant {
	    $$ = spl_new_constant();
	    $$->node.constant.token = string_constant;
	    $$->node.constant.const_val = $1.string;
	    $$->node.constant.lx_srcpos = $1.lx_srcpos;
        }
	| floating_constant {
	    $$ = spl_new_constant();
	    $$->node.constant.token = floating_constant;
	    $$->node.constant.const_val = $1.string;
	    $$->node.constant.lx_srcpos = $1.lx_srcpos;
        }
	| integer_constant {
	    $$ = spl_new_constant();
	    $$->node.constant.token = integer_constant;
	    $$->node.constant.const_val = $1.string;
	    $$->node.constant.lx_srcpos = $1.lx_srcpos;
        }
	;

standAloneTypeDef:
	TYPE identifier_ref ASSIGN type SEMI {
            printf("standAloneTypeDef?");
        }
	|TYPE identifier_ref ASSIGN tupleBody SEMI {
            printf("standAloneTypeDef?\n");
        }
	;

compositeTypeDef:
	static_opt identifier_ref ASSIGN type SEMI {
            printf("compositeTypeDef?");
        }
	| static_opt identifier_ref ASSIGN tupleBody SEMI {
            printf("compositeTypeDef?\n");
        }
	;

static_opt:
	/*empty*/
	| STATIC {
            printf("static_opt?\n");
        }
	;

typeArgs_list:
	/*empty*/
	| typeArgs_list typeArgs {
            printf("typeArgs_list?\n");
        }
	;

type:
	type_id {
            printf("type?\n");
        }
	| VOID  {
            printf("type?\n");
        }
	| primitiveType {
            $$=$1;
        }
	| compositeType {
            printf("type?");
        }
	;

typeArgs:
	LT type_list '>' {
            printf("typeArgs?\n");
        }
	;

type_list:
	type {
            printf("type_list?");
        }
	| type_list COMMA type{
            printf("type_list?");
        }
	;

typeDims:
	LBRACKET expr RBRACKET {
            printf("typeDims?\n");
        }
	;

primitiveType:
	BOOLEAN {
            printf("primitiveType?\n");
        }
	| ENUM LCURLY id_list_comma RCURLY {
            printf("primitiveType?\n");
        }
	| INT8 {
            printf("primitiveType?\n");
        }
	| INT16 {
            printf("primitiveType?\n");
        }
	| INT32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT32;
	}
	| INT64 {
            printf("primitiveType?\n");
        }
	| INT128 {
            printf("primitiveType?\n");
        }
	| UINT8 {
            printf("primitiveType?\n");
        }
	| UINT16 {
            printf("primitiveType?\n");
        }
	| UINT32 {
            printf("primitiveType?\n");
        }
	| UINT64 {
            printf("primitiveType?\n");
        }
	| UINT128 {
            printf("primitiveType?\n");
        }
	| FLOAT32 {
            printf("primitiveType?\n");
        }
	| FLOAT64 {
            printf("primitiveType?\n");
        }
	| DECIMAL32 {
            printf("primitiveType?\n");
        }
	| DECIMAL64 {
            printf("primitiveType?\n");
        }
	| DECIMAL128 {
            printf("primitiveType?\n");
        }
	| COMPLEX32 {
            printf("primitiveType?\n");
        }
	| COMPLEX64 {
            printf("primitiveType?\n");
        }
	| TIMESTAMP {
            printf("primitiveType?\n");
        }
	| BLOB {
            printf("primitiveType?\n");
        }
	| STRING8 typeDims_opt {
            printf("primitiveType?\n");
        }
	| STRING16 {
            printf("primitiveType?\n");
        }
	;

typeDims_opt:
	/*empty*/
	| typeDims {
            printf("typeDims_opt?\n");
        }
	;

compositeType:
	tupleType {
            printf("compositeType?\n");
            $$=$1;
        }
	| LIST typeArgs typeDims_opt {
            printf("compositeType?\n");
        }
	| MAP typeArgs typeDims_opt {
            printf("compositeType?\n");
        }
	| SET typeArgs typeDims_opt {
            printf("compositeType?\n");
        }
	;

tupleType:
	TUPLE LT tupleBody '>'{
            printf("tupleType?\n");
            $$=$3;
        }
	;

tupleBody:
	attributeDecl_list {
            $$=$1;
        }
	| id_tt_list {
            printf("tupleBody?\n");
        }
	;

attributeDecl_list:
	attributeDecl {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| attributeDecl_list COMMA attributeDecl {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
	    tmp->next = malloc(sizeof(struct list_struct));
	    tmp->next->node = $3;
	    tmp->next->next = NULL;
	    $$ = $1;
        }
	;

id_tt_list:
	identifier_ref {
            printf("id_tt_list?\n");
        }
	| tupleType {
            printf("id_tt_list?\n");
        }
	| id_tt_list COMMA identifier_ref {
            printf("id_tt_list?\n");
        }
	| id_tt_list COMMA tupleType {
            printf("id_tt_list?\n");
        }
	;

attributeDecl:
	type identifier_ref {
	    $$ = spl_new_identifier();
            $$->node.identifier.cg_type =$1->node.type_specifier.token;
	    $$->node.identifier.lx_srcpos = $2.lx_srcpos;
	    $$->node.identifier.id = $2.string;
        }
	;

%%

#include "lex.yy.c"

typedef struct scope *scope_ptr;

struct parse_struct {
    sm_list decls;
    sm_list standard_decls;
    scope_ptr scope;
    int defined_type_count;
    char **defined_types;
    void *client_data;
    err_out_func_t error_func;
};

void program1(sm_ref one, sm_list two) {
    FILE* fp = fopen("main.c", "w");
    fprintf(fp,"#include <stdio.h>\n");
    fprintf(fp,"#include <string.h>\n");
    fprintf(fp,"#include \"evpath.h\"\n");
    fprintf(fp,"\n");
    sm_list tmp = two;
    while (tmp->next != NULL) {
        if(tmp->node->node.assignment_expression.left->node.assignment_expression.left->node.field.type_spec){
        
            //print struct
            sm_ref node_ref=tmp->node->node.assignment_expression.left->node.assignment_expression.left;
            fprintf(fp,"typedef struct _%s_rec {\n",node_ref->node.field.name);
            sm_list next_level=node_ref->node.field.type_spec;
            while(next_level->next !=NULL){
                fprintf(fp,"\tint %s;\n",next_level->node->node.identifier.id);
                next_level=next_level->next;
            }
            fprintf(fp,"\tint %s;\n",next_level->node->node.identifier.id);
            fprintf(fp,"} %s_rec, *%s_rec_ptr;\n\n",node_ref->node.field.name,node_ref->node.field.name);
            
            
            
            //print FMfield
            fprintf(fp,"static FMField %s_field_list [] = {\n",node_ref->node.field.name);
            next_level=node_ref->node.field.type_spec;
            while(next_level->next !=NULL){
                fprintf(fp,"\t{\"%s\", \"integer\", sizeof(int), FMOffset(%s_rec_ptr, %s)},\n",next_level->node->node.identifier.id,node_ref->node.field.name,next_level->node->node.identifier.id);
                next_level=next_level->next;
            }
            fprintf(fp,"\t{\"%s\", \"integer\", sizeof(int), FMOffset(%s_rec_ptr, %s)},\n",next_level->node->node.identifier.id,node_ref->node.field.name,next_level->node->node.identifier.id);
            fprintf(fp,"\t{NULL, NULL, 0, 0}\n");
            fprintf(fp,"};\n\n",node_ref->node.field.name,node_ref->node.field.name);
            
            
            //print FMstruct
            fprintf(fp,"static FMStructDescRec %s_format_list [] = {\n",node_ref->node.field.name);
            fprintf(fp,"\t{\"%s\", %s_field_list, sizeof(%s_rec), NULL},\n",node_ref->node.field.name,node_ref->node.field.name,node_ref->node.field.name);
            fprintf(fp,"\t{NULL, NULL}\n");
            fprintf(fp,"};\n\n");
            
            
            //print handler
            fprintf(fp,"static int %s_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {\n",node_ref->node.field.name);
            fprintf(fp,"\t%s_rec_ptr event = vevent;\n",node_ref->node.field.name);
            fprintf(fp,"\tprintf(\"%s got a struct with the following:\\n\");\n",node_ref->node.field.name);
            next_level=node_ref->node.field.type_spec;
            while(next_level->next !=NULL){
                fprintf(fp,"\tprintf(\"%s:%%d\\n\",event->%s);\n",next_level->node->node.identifier.id,next_level->node->node.identifier.id);
                next_level=next_level->next;
            }
            fprintf(fp,"\tprintf(\"%s:%%d\\n\",event->%s);\n",next_level->node->node.identifier.id,next_level->node->node.identifier.id);
            fprintf(fp,"};\n\n");
        }
        tmp = tmp->next;
    }
    
    
    //print main stuff
    fprintf(fp, "\n\nint main(int argc, char **argv) {\n");
    fprintf(fp, "\tCManager cm;\n");
    
    //print main declarations
    tmp = two;
    while (tmp->next != NULL) {
        if(tmp->node->node.assignment_expression.left->node.assignment_expression.left->node.field.type_spec){
            //print stone
            sm_ref node_ref=tmp->node->node.assignment_expression.left->node.assignment_expression.left;
            fprintf(fp,"\t%s_rec %s_data;\n",node_ref->node.field.name,node_ref->node.field.name);
            fprintf(fp,"\tEVstone %s_stone;\n",node_ref->node.field.name);
            fprintf(fp,"\tEVsource %s_source;\n\n",node_ref->node.field.name);
        }
        tmp = tmp->next;
    }
    
    //print main stuff
    fprintf(fp, "\tcm = CManager_create();\n");
    
    //print create stones
    tmp = two;
    while (tmp->next != NULL) {
        if(tmp->node->node.assignment_expression.left->node.assignment_expression.left->node.field.type_spec){
            sm_ref node_ref=tmp->node->node.assignment_expression.left->node.assignment_expression.left;
            fprintf(fp,"\t%s_stone = EValloc_stone(cm);\n",node_ref->node.field.name);
            fprintf(fp,"\tEVassoc_terminal_action(cm, %s_stone, %s_format_list, %s_handler, NULL);\n\n",node_ref->node.field.name,node_ref->node.field.name,node_ref->node.field.name);
            fprintf(fp,"\t%s_source = EVcreate_submit_handle(cm, %s_stone, %s_format_list);\n",node_ref->node.field.name,node_ref->node.field.name,node_ref->node.field.name);
            sm_list next_level=node_ref->node.field.type_spec;
            while(next_level->next !=NULL){
                fprintf(fp,"\t%s_data.%s = 1;\n",node_ref->node.field.name,next_level->node->node.identifier.id);
                next_level=next_level->next;
            }
            fprintf(fp,"\t%s_data.%s = 1;\n",node_ref->node.field.name,next_level->node->node.identifier.id);
            fprintf(fp,"\tEVsubmit(%s_source, &%s_data, NULL);\n\n",node_ref->node.field.name,node_ref->node.field.name);
        }
        tmp = tmp->next;
    }
    
    fprintf(fp,"\n\n}");
    
    fclose(fp);
}

void debug_print(FILE* fp, const char* string, int tabs){
    int i =0;
    for(i=0; i<tabs; i++){
        fprintf(fp, "\t");
    }
    fprintf(fp, "printf(\"%s\\n\");\n", string);
    for(i=0;  i<tabs; i++){
        fprintf(fp, "\t");
    }
    fprintf(fp, "fflush(stdout);\n");
}

void print_filter(FILE* fp, const char *name, sm_list ids) {
    fprintf(fp,"static char* %s_filter = \"{\\n\\\n",name);
    fprintf(fp,"int hop_count;\\n\\\n");
    fprintf(fp,"hop_count = attr_ivalue(event_attrs, \\\"hop_count_atom\\\");\\n\\\n");
    fprintf(fp,"hop_count++;\\n\\\n");
    while(ids != NULL) { 
        fprintf(fp,"printf(\\\"in  %s filter with %s = %%d\\\\n\\\", input.%s);\\n\\\n", name, ids->node->node.identifier.id, ids->node->node.identifier.id);
        fprintf(fp,"input.%s+=1;\\n\\\n", ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"set_int_attr(event_attrs, \\\"hop_count_atom\\\", hop_count);\\n\\\n");
    fprintf(fp,"}\\0\\0\";\n\n");
}

void print_struct(FILE* fp, const char *name, sm_list ids){
    fprintf(fp,"typedef struct _%s_rec {\n", name);
    while(ids !=NULL){
        fprintf(fp,"\tint %s;\n",ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"} %s_rec, *%s_rec_ptr;\n\n",name,name);
}

void print_FMfield(FILE* fp, const char * name, sm_list ids) {
    fprintf(fp,"static FMField %s_field_list [] = {\n",name);
    while(ids != NULL){
        fprintf(fp,"\t{\"%s\", \"integer\", sizeof(int), FMOffset(%s_rec_ptr, %s)},\n",ids->node->node.identifier.id,name,ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"\t{NULL, NULL, 0, 0}\n");
    fprintf(fp,"};\n\n");
}

void print_FMstruct(FILE* fp, const char *name) {
    fprintf(fp,"static FMStructDescRec %s_format_list [] = {\n",name);
    fprintf(fp,"\t{\"%s\", %s_field_list, sizeof(%s_rec), NULL},\n",name,name,name);
    fprintf(fp,"\t{NULL, NULL}\n");
    fprintf(fp,"};\n\n");
}

void print_handler(FILE* fp, const char *name, sm_list ids) {
    fprintf(fp,"static int %s_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {\n",name);
    fprintf(fp,"\t%s_rec_ptr event = vevent;\n",name);
    fprintf(fp,"\tprintf(\"%s got a struct with the following:\\n\");\n",name);
    while(ids !=NULL){
        fprintf(fp,"\tprintf(\"%s:%%d\\n\",event->%s);\n",ids->node->node.identifier.id,ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"\tEVdfg_shutdown(test_dfg, 0);\n");
    fprintf(fp,"};\n\n");
}

void print_generate(FILE* fp, const char *name, sm_list ids) {
    fprintf(fp, "void generate_%s_record(%s_rec_ptr event)\n", name, name);
    fprintf(fp, "{\n");
    while(ids !=NULL){
        fprintf(fp, "\tevent->%s = 0;\n", ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp, "}\n\n");
}

void print_master(FILE* fp, const char *name) {
    fprintf(fp, "\n\nextern int be_test_master(int argc, char **argv) {\n");
    debug_print(fp, "in master",1);
    fprintf(fp, "\tchar **nodes;\n");
    fprintf(fp, "\tCManager cm;\n");
    fprintf(fp, "\tattr_list contact_list;\n");
    fprintf(fp, "\tchar *str_contact;\n");
    fprintf(fp, "\tEVdfg_stone src, last, tmp, sink;\n");
    fprintf(fp, "\tEVsource source_handle;\n");
    fprintf(fp, "\tint node_count = 5;\n");
    fprintf(fp, "\tint i;\n");
    fprintf(fp, "\tnodes = malloc(sizeof(nodes[0]) * (node_count+1));\n");
    fprintf(fp, "\tfor (i=0; i < node_count; i++) {\n");
    fprintf(fp, "\t\tnodes[i] = malloc(5);\n");
    fprintf(fp, "\t\tsprintf(nodes[i], \"N%%d\", i);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tcm = CManager_create();\n");
    fprintf(fp, "\tCMlisten(cm);\n");
    fprintf(fp, "\tcontact_list = CMget_contact_list(cm);\n");
    fprintf(fp, "\tstr_contact = attr_list_to_string(contact_list);\n");
    fprintf(fp, "\tsource_handle = EVcreate_submit_handle(cm, -1, %s_format_list);\n", name);
    fprintf(fp, "\tEVdfg_register_source(\"master_source\", source_handle);\n");
    fprintf(fp, "\tEVdfg_register_sink_handler(cm, \"%s_handler\", %s_format_list, (EVSimpleHandlerFunc) %s_handler);\n", name, name, name);
    fprintf(fp, "\ttest_dfg = EVdfg_create(cm);\n");
    fprintf(fp, "\tEVdfg_register_node_list(test_dfg, &nodes[0]);\n");
    fprintf(fp, "\tsrc = EVdfg_create_source_stone(test_dfg, \"master_source\");\n");
    fprintf(fp, "\tEVdfg_assign_node(src, nodes[0]);\n");
    fprintf(fp, "\tchar *filter;\n");
    fprintf(fp, "\tfilter = create_filter_action_spec(NULL, %s_filter);\n", name);
    fprintf(fp, "\tlast = src;\n");
    fprintf(fp, "\tfor (i=1; i < node_count -1; i++) {\n");
    fprintf(fp, "\t\ttmp = EVdfg_create_stone(test_dfg, filter);\n");
    fprintf(fp, "\t\tEVdfg_link_port(last, 0, tmp);\n");
    fprintf(fp, "\t\tEVdfg_assign_node(tmp, nodes[i]);\n");
    fprintf(fp, "\t\tlast = tmp;\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tsink = EVdfg_create_sink_stone(test_dfg, \"%s_handler\");\n", name);
    fprintf(fp, "\tEVdfg_link_port(last, 0, sink);\n");
    fprintf(fp, "\tEVdfg_assign_node(sink, nodes[node_count-1]);\n");
    fprintf(fp, "\tEVdfg_realize(test_dfg);\n");
    fprintf(fp, "\tEVdfg_join_dfg(test_dfg, nodes[0], str_contact);\n");
    fprintf(fp, "\ttest_fork_children(&nodes[0], str_contact);\n");
    fprintf(fp, "\tif (EVdfg_ready_wait(test_dfg) != 1) {\n");
    fprintf(fp, "\t\t/* dfg initialization failed! */\n");
    fprintf(fp, "\t\texit(1);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tif (EVdfg_active_sink_count(test_dfg) == 0) {\n");
    fprintf(fp, "\t\tEVdfg_ready_for_shutdown(test_dfg);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tif (EVdfg_source_active(source_handle)) {\n");
    fprintf(fp, "\t\t%s_rec rec;\n", name);
    fprintf(fp, "\t\tatom_t hop_count_atom;\n");
    fprintf(fp, "\t\tattr_list attrs = create_attr_list();\n");
    fprintf(fp, "\t\thop_count_atom = attr_atom_from_string(\"hop_count_atom\");\n");
    fprintf(fp, "\t\tadd_int_attr(attrs, hop_count_atom, 1);\n");
    fprintf(fp, "\t\tgenerate_%s_record(&rec);\n", name);
    fprintf(fp, "\t\t/* submit would be quietly ignored if source is not active */\n");
    fprintf(fp, "\t\tEVsubmit(source_handle, &rec, attrs);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tstatus = EVdfg_wait_for_shutdown(test_dfg);\n");
    fprintf(fp, "\twait_for_children(nodes);\n");
    fprintf(fp, "\tCManager_close(cm);\n");
    fprintf(fp, "\treturn status;\n");
    fprintf(fp, "}\n\n");
}

void print_child(FILE* fp, const char *name) {
    fprintf(fp, "extern int\n");
    fprintf(fp, "be_test_child(int argc, char **argv)\n");
    fprintf(fp, "{\n");
    debug_print(fp, "in child", 1);
    fprintf(fp, "\tCManager cm;\n");
    fprintf(fp, "\tEVsource src;\n");
    fprintf(fp, "\tcm = CManager_create();\n");
    fprintf(fp, "\tif (argc != 3) {\n");
    fprintf(fp, "\t\tprintf(\"Child usage:  evtest  <nodename> <mastercontact>\\n\");\n");
    fprintf(fp, "\t\texit(1);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\ttest_dfg = EVdfg_create(cm);\n");
    fprintf(fp, "\tsrc = EVcreate_submit_handle(cm, -1, %s_format_list);\n", name);
    fprintf(fp, "\tEVdfg_register_source(\"master_source\", src);\n");
    fprintf(fp, "\tEVdfg_register_sink_handler(cm, \"%s_handler\", %s_format_list, (EVSimpleHandlerFunc) %s_handler);\n", name, name, name);
    fprintf(fp, "\tEVdfg_join_dfg(test_dfg, argv[1], argv[2]);\n");
    fprintf(fp, "\tEVdfg_ready_wait(test_dfg);\n");
    fprintf(fp, "\tif (EVdfg_active_sink_count(test_dfg) == 0) {\n");
    fprintf(fp, "\t\tEVdfg_ready_for_shutdown(test_dfg);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\tif (EVdfg_source_active(src)) {\n");
    fprintf(fp, "\t\t%s_rec rec;\n", name);
    fprintf(fp, "\t\tgenerate_%s_record(&rec);\n", name);
    fprintf(fp, "\t\t/* submit would be quietly ignored if source is not active */\n");
    fprintf(fp, "\t\tEVsubmit(src, &rec, NULL);\n");
    fprintf(fp, "\t}\n");
    fprintf(fp, "\treturn EVdfg_wait_for_shutdown(test_dfg);\n");
    fprintf(fp, "}\n");
}

void program2(sm_ref one, sm_list two) {
    FILE* fp = fopen("main.c", "w");
    fprintf(fp,"#include <stdio.h>\n");
    fprintf(fp,"#include <stdlib.h>\n");
    fprintf(fp,"#include <string.h>\n");
    fprintf(fp,"#include \"config.h\"\n");
    fprintf(fp,"#include \"evpath.h\"\n");
    fprintf(fp,"#include \"ev_dfg.h\"\n");
    fprintf(fp,"#include \"test_support.h\"\n");
    fprintf(fp,"\n");
    fprintf(fp,"int status;\n");
    fprintf(fp,"static EVdfg test_dfg;\n");
    fprintf(fp,"\n");
    sm_list tmp = two;
    while (tmp != NULL) {
        if(tmp->node->node.assignment_expression.left){
            printf("\n\nNode's left\n--------------\n\n");
            spl_print(tmp->node->node.assignment_expression.left);
            fflush(stdout);
        }
        if(tmp->node->node.assignment_expression.left->node.assignment_expression.left){
            //pull relevant parts out of abstract syntax tree
            sm_ref stream_decl=tmp->node->node.assignment_expression.left->node.assignment_expression.left->node.field.type_spec->node;
            printf("\n\nNode's left left\n--------------\n\n");
            spl_print(tmp->node->node.assignment_expression.left->node.assignment_expression.left);
            printf("\n\nNode's left right\n--------------\n\n");
            spl_print(tmp->node->node.assignment_expression.left->node.assignment_expression.right);
            const char * name=stream_decl->node.field.name;
            sm_list ids= stream_decl->node.field.type_spec;
            spl_print(stream_decl);
            
            //print filter
            print_filter(fp, name, ids);
            
            //print struct
            print_struct(fp, name, ids);
            
            //print FMfield
            print_FMfield(fp, name, ids);
            
            //print FMstruct
            print_FMstruct(fp, name);
            
            //print handler
            print_handler(fp, name, ids);
            
            //print generate functions
            print_generate(fp, name, ids);
        }
        tmp = tmp->next;
    }
    
    //print master stuff
    print_master(fp, "Sum");
    
    //print child stuff
    print_child(fp, "Sum");

    
    fclose(fp);
}

static void default_error_out(void *client_data, char *string);

extern spl_parse_context new_spl_parse_context() {
    spl_parse_context context = malloc(sizeof(struct parse_struct));
    context->decls = NULL;
    context->standard_decls = NULL;
    context->scope = NULL;
    context->defined_type_count = 0;
    context->defined_types = NULL;
    context->error_func = default_error_out;
    context->client_data = NULL;
    return context;
}

spl_code_gen(char *code) {
    spl_parse_context context = new_spl_parse_context();

    if (code != NULL) {
	setup_for_string_parse(code, context->defined_type_count, context->defined_types);
	spl_code_string = code;
    }

    yyerror_count = 0;
    yycontext = context;
    yyparse();
    terminate_string_parse();

    if ((yyparse_value == NULL) || (yyerror_count != 0)) {
	return 0;
    }
}

static char * copy_line(const char *line_begin){
    const char *line_end;
    if ((line_end = strchr(line_begin, 10)) == NULL) {
	/* no CR */
	return strdup(line_begin);
    } else {
	char *tmp = malloc(line_end - line_begin + 1);
	strncpy(tmp, line_begin, line_end - line_begin);
	tmp[line_end - line_begin] = 0;
	return tmp;
    }
}

static void default_error_out(void *client_data, char *string) {
    fprintf(stderr, "%s", string);
}

static void print_context(spl_parse_context context, int line, int character) {
    const char *tmp = spl_code_string;
    const char *line_begin = spl_code_string;
    char *line_copy = NULL;
    int i, line_len, offset = 0;

    while (line > 1) {
	switch(*tmp) {
	case 10:
	    line_begin = tmp + 1;
	    line--;
	    break;
	case 0:
	    line = 1;   /* end of src */
	    break;
	}
	tmp++;
    }
    if (character > 40) {
	offset = character - 40;
    }
    line_copy = copy_line(line_begin + offset);
    line_len = strlen(line_copy);
    if (line_len > 60) {
	line_copy[60] = 0;
    }
    context->error_func(context->client_data, line_copy);
    context->error_func(context->client_data, "\n");
    free(line_copy);
    for(i=offset + 1; i< character; i++) {
	if (line_begin[i-1] == '\t') {
	    context->error_func(context->client_data, "\t");
	} else {
	    context->error_func(context->client_data, " ");
	}
    }
    context->error_func(context->client_data, "^\n");
}

void yyerror(char *str) {
    char tmp_str[100];
    sprintf(tmp_str, "## Error %s\n", str);
    yycontext->error_func(yycontext->client_data, tmp_str);
    yycontext->error_func(yycontext->client_data, "## While parsing near ");
    yycontext->error_func(yycontext->client_data, yytext);
    sprintf(tmp_str, ", offset = %d, line = %d ####\n",lex_offset,line_count);
    yycontext->error_func(yycontext->client_data, tmp_str);
    print_context(yycontext, line_count, lex_offset);
    yyerror_count++;
}

extern void spl_print_srcpos(srcpos pos) {
    printf("line %d, char %d", pos.line, pos.character);
}

