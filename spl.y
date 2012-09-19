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
void process_graph( sm_list two);
char *process_expr(sm_ref node, const char *str);
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
%type <reference> mappedOp;
%type <reference> infixExpr;
%type <reference> postfixExpr;
%type <reference> prefixOp;
%type <reference> prefixExpr;
%type <reference> compositeHead;
%type <reference> opOutput;
%type <reference> opInvokeHead;
%type <reference> opInvokeWindow;
%type <reference> opInvokeActual;
%type <reference> opActual;
%type <reference> opInvokeBody;
%type <reference> opInvoke;
%type <reference> invoke_logic_opt;
%type <reference> invoke_config_opt;
%type <reference> opInvokeOutput;
%type <reference> assign_expr;
%type <list> opInputs;
%type <list> opOutputs;
%type <list> portInputs;
%type <list> opInvokeActual_list;
%type <list> opInvokeOutput_list;
%type <list> opInvokeWindow_list;
%type <list> expr_list_comma;
%type <list> opInput_list;
%type <list> attributeDecl_list;
%type <list> invoke_actual_opt;
%type <list> invoke_window_opt;
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
            process_graph($2);
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
            printf("opActual?\n");
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
            tmp2->node.field.name = "opInvokeHead";
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
            //do nothing
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
            temp->node.field.name = "input";
            $$->node = temp;
            $$->next = NULL;
        }
	| opInput_list SEMI portInputs {
	    sm_list tmp = $1;
	    while (tmp->next != NULL) {
		tmp = tmp->next;
	    }
            tmp->next = malloc(sizeof(struct list_struct));
            sm_ref temp = spl_new_field();
            temp->node.field.type_spec = $3;
            temp->node.field.name = "input";
	    tmp->next->node = temp;
	    tmp->next->next = NULL;
	    $$ = $1;
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
            sm_list temp_list = NULL;
            if($2!=NULL){
                    printf("two\n");
                    fflush(stdout);
                temp_list = malloc(sizeof(struct list_struct));
                temp_list->node = $2;
                temp_list->next = NULL;
            }
            if($3!=NULL){
                sm_ref temp3 = spl_new_field();
                temp3->node.field.type_spec = $3;
                temp3->node.field.name = "window";
                if(temp_list){
                    temp_list->next = malloc(sizeof(struct list_struct));
                    temp_list->next->node = temp3;
                    temp_list->next->next = NULL;
                } else {
                    temp_list = malloc(sizeof(struct list_struct));
                    temp_list->node = temp3;
                    temp_list->next = NULL;
                }
            }
            if($4!=NULL){
                sm_ref temp3 = spl_new_field();
                temp3->node.field.type_spec = $4;
                temp3->node.field.name = "invoke_actual";
                
                if(temp_list){
                    sm_list atemp=temp_list;
                    while(atemp->next){
                        atemp=atemp->next;
                    }
                    atemp->next = malloc(sizeof(struct list_struct));
                    atemp->next->node = temp3;
                    atemp->next->next = NULL;
                } else {
                    temp_list = malloc(sizeof(struct list_struct));
                    temp_list->node = temp3;
                    temp_list->next = NULL;
                }
            }
            if($5!=NULL){
                sm_ref temp4 = spl_new_field();
                temp4->node.field.type_spec = $5;
                temp4->node.field.name = "invoke_output";
                if(temp_list){
                    sm_list atemp=temp_list;
                    while(atemp->next){
                        atemp=atemp->next;
                    }
                    atemp->next = malloc(sizeof(struct list_struct));
                    atemp->next->node = temp4;
                    atemp->next->next = NULL;
                } else {
                    temp_list = malloc(sizeof(struct list_struct));
                    temp_list->node = temp4;
                    temp_list->next = NULL;
                }
            }
            //6th param ignored
            sm_ref temp = spl_new_field();
            temp->node.field.type_spec = temp_list;
            temp->node.field.name = "invoke body";
            $$=temp;
        }
	;

invoke_logic_opt:
	/* empty */{
            $$=NULL;
        }
	| LOGIC opInvokeLogic_list {
            printf("invoke_logic_opt?\n");
        }
	;

invoke_window_opt:
	/* empty */{
            $$=NULL;
        }
	| WINDOW opInvokeWindow_list {
            $$=$2;
        }
	;

invoke_actual_opt:
	/* empty */{
            $$=NULL;
        }
	| PARAM opInvokeActual_list {
            $$=$2;
        }
	;

invoke_output_opt:
	/* empty */{
            $$=NULL;
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
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
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
            $$ = spl_new_field();
            $$->node.field.name=$1.string;
            $$->node.field.type_spec=$3;
        }
	;

opInvokeOutput:
	identifier_ref COLON assign_expr_list SEMI {
            $$=spl_new_field();
            $$->node.field.name=$1.string;
            $$->node.field.type_spec=$3;
        }
	;

assign_expr:
    identifier_ref ASSIGN expr  {
        sm_ref tmp = spl_new_assignment_expression();
        tmp->node.assignment_expression.right= $3;
        sm_ref id = spl_new_identifier();
        id->node.identifier.id=$1.string;
        tmp->node.assignment_expression.left= id;
        $$=tmp;
    }
    ;

assign_expr_list:
	assign_expr {
            $$ = malloc(sizeof(struct list_struct));
            $$->node = $1;
            $$->next = NULL;
        }
	| assign_expr_list COMMA assign_expr {
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


functionDef:
	functionHead blockStmt {
            printf("functionDef?\n");
        }
	;

functionHead:
	functionModifier_list type identifier_ref LPAREN functionFormal_list RPAREN {
            printf("functionHead?\n");
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
            printf("functionFormal?\n");
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
            printf("varDef?\n");
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
            printf("forStmt?\n");
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
            $$= $1;
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
        	$$= $1;
		$$->node.operator.right = $2;
	}
	;

prefixOp:
	BANG {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = BANG;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
        | MINUS {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = MINUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| TILDE {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = TILDE;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| INC_OP {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = INC_OP;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DEC_OP {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DEC_OP;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
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
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = MINUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| STAR {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = STAR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| SLASH {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = SLASH;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| MODULUS {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = MODULUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| LEFT_SHIFT {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = LEFT_SHIFT;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| ">>" {
        	printf("infixop?\n");	
	}
	| ARITH_AND {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = ARITH_AND;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| ARITH_XOR {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = ARITH_XOR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| ARITH_OR {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = ARITH_OR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| LOG_AND {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = LOG_AND;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| LOG_OR {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = LOG_OR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| IN {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = IN;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| LT {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = LT;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| LEQ {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = LEQ;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| '>' {
        	printf("infixop?\n");
	}
	| GEQ {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = GEQ;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| NEQ {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = NEQ;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| EQ {
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = EQ;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	;

mappedOp:
	DOT_PLUS {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_PLUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_MINUS {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_PLUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_STAR {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_STAR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_SLASH {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_SLASH;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_MODULUS {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_MODULUS;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_LEFT_SHIFT {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_LEFT_SHIFT;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_RIGHT_SHIFT {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_RIGHT_SHIFT;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_ARITH_AND {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_ARITH_AND;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_ARITH_XOR {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_ARITH_XOR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
        }
	| DOT_ARITH_OR {
            printf("mappedOp?\n");
	    $$ = spl_new_operator();
	    $$->node.operator.operation_type = DOT_ARITH_OR;
	    $$->node.operator.lx_srcpos = $1.lx_srcpos;
	    $$->node.operator.right = NULL;
	    $$->node.operator.left = NULL;
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
            $$=spl_new_field();
            $$->node.field.name = $1.string;
            $$->node.field.type_spec = $3;
        }
	| type LPAREN expr RPAREN {
            $$=spl_new_element_ref();
            $$->node.element_ref.expression = $3;
            $$->node.element_ref.array_ref = $1;
        }
	| expr LBRACKET subscript RBRACKET {
            printf("postfixExpr?\n");
        }
	| expr DOT identifier_ref {
            sm_ref id = spl_new_identifier();
	    id->node.identifier.lx_srcpos = $3.lx_srcpos;
	    id->node.identifier.id = $3.string;
            $$=spl_new_element_ref();
            $$->node.element_ref.expression = $1;
            $$->node.element_ref.array_ref = id;
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
	    $$ = spl_new_constant();
	    $$->node.constant.token = integer_constant;
	    $$->node.constant.const_val = "1";
	    $$->node.constant.lx_srcpos = $1.lx_srcpos;
        }
	| FALSE {
	    $$ = spl_new_constant();
	    $$->node.constant.token = integer_constant;
	    $$->node.constant.const_val = "0";
	    $$->node.constant.lx_srcpos = $1.lx_srcpos;
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
            printf("standAloneTypeDef?\n");
        }
	|TYPE identifier_ref ASSIGN tupleBody SEMI {
            printf("standAloneTypeDef?\n");
        }
	;

compositeTypeDef:
	static_opt identifier_ref ASSIGN type SEMI {
            printf("compositeTypeDef?\n");
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
            printf("type?\n");
        }
	;

typeArgs:
	LT type_list '>' {
            printf("typeArgs?\n");
        }
	;

type_list:
	type {
            printf("type_list?\n");
        }
	| type_list COMMA type{
            printf("type_list?\n");
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
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT8;
        }
	| INT16 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT16;
	}
	| INT32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT32;
	}
	| INT64 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT64;
        }
	| INT128 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = INT128;
        }
	| UINT8 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = UINT8;
        }
	| UINT16 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = UINT16;
        }
	| UINT32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = UINT32;
        }
	| UINT64 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = UINT64;
        }
	| UINT128 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = UINT128;
        }
	| FLOAT32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = FLOAT32;
        }
	| FLOAT64 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = FLOAT64;
        }
	| DECIMAL32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = DECIMAL32;
        }
	| DECIMAL64 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = DECIMAL64;
        }
	| DECIMAL128 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = DECIMAL128;
        }
	| COMPLEX32 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = COMPLEX32;
        }
	| COMPLEX64 {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = COMPLEX64;;
        }
	| TIMESTAMP {
            printf("primitiveType?\n");
        }
	| BLOB {
            printf("primitiveType?\n");
        }
	| STRING8 typeDims_opt {
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = STRING8;
        }
	| STRING16 {
            printf("primitiveType?\n");
	    $$ = spl_new_type_specifier();
	    $$->node.type_specifier.lx_srcpos = $1.lx_srcpos;
	    $$->node.type_specifier.token = STRING16;
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

typedef struct _symbol {
    sm_ref node;
    char *name;
    int type;
    int port;
    struct _symbol *next;
} Symbol;

Symbol *list=NULL;
int stream_count=0;

void add_symbol(sm_ref node, const char *name, int type){
    Symbol *temp=list;
    if(temp==NULL){
        list=malloc(sizeof(Symbol));
        temp=list;
    } else {
        while(temp->next){
            temp=temp->next;
        }
        temp->next = malloc(sizeof(Symbol));
        temp=temp->next;
    }
    temp->type=type;
    temp->node=node;
    temp->port=0;
    temp->name=strdup(name);
    if(type==1){
        stream_count++;
    }
}

sm_ref find_next_type(Symbol *start, int type) {
    sm_ref temp=NULL;
    while(start && start->type != type) {
        start=start->next;
    }
    if(start) {
        temp=start->node;
    }
    return temp;
}

Symbol *find_stream_symbol(const char*name) {
    Symbol *temp=list;
    while(temp && strcmp(temp->name, name)!=0){
        while(temp && temp->type != 1) {
            temp=temp->next;
        }
        temp=temp->next;
    }
    return temp;
    
}

sm_ref find_stream(const char *name) {
    Symbol *temp=find_stream_symbol(name);
    sm_ref temp2=NULL;
    if(temp){
        temp2=temp->node;
    }
    return temp2;
}

struct parse_struct {
    sm_list decls;
    sm_list standard_decls;
    scope_ptr scope;
    int defined_type_count;
    char **defined_types;
    void *client_data;
    err_out_func_t error_func;
};


void debug_print(FILE* fp, const char* string, int tabs){
    int i =0;
    for(i=0; i<tabs; i++){
        fprintf(fp, "   ");
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

void print_transform(FILE* fp, const char *name, const char *input, sm_list lines){
    fprintf(fp,"static char* %s_to_%s_transform = \"{\\n\\\n", input,name);
    
    while(lines && lines->node){
        if(lines->node->node.assignment_expression.left){
            fprintf(fp,"    %s", process_expr(lines->node->node.assignment_expression.left,"output."));
        }
        if(lines->node->node.assignment_expression.right){
            fprintf(fp," = %s;\\n\\\n", process_expr(lines->node->node.assignment_expression.right,"input."));
        }
        lines=lines->next;
    }
    
    
    
    fprintf(fp,"    return 1;\\n\\\n");
    fprintf(fp,"}\";\n\n\n");
}

void print_barrier(FILE* fp, const char *name, sm_list inputs, sm_list lines){
    //lists
    fprintf(fp, "static FMStructDescList %s_inputs[] = {", name);
    sm_list orig_inputs=inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"%s_format_list, ",input);
        inputs=inputs->next;
    }
    fprintf(fp, "%s_format_list, NULL};\n\n", name);
    
    //header
    fprintf(fp,"static char* ");
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"%s_",input);
        inputs=inputs->next;
    }
    fprintf(fp,"to_%s = \"{\\n\\\n",name);
    
    //variables
    fprintf(fp,"    int found=0;\\n\\\n");
    inputs = orig_inputs;
    int input_cnt=0;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"    %s *rec_%s;\\n\\\n",input, input);
        input_cnt++;
        inputs=inputs->next;
    }
    fprintf(fp,"    %s c;\\n\\\n", name);
    
    //count available
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"    if (EVpresent(%s_ID, 0)) {\\n\\\n",input);
        fprintf(fp,"        rec_%s = EVdata_%s(0); ++found;\\n\\\n",input, input);
        fprintf(fp,"    }\\n\\\n");
        inputs=inputs->next;
    }
    
    //process
    fprintf(fp,"    if (found == %d) {\\n\\\n",input_cnt);
    while(lines && lines->node){
        if(lines->node->node.assignment_expression.left){
            fprintf(fp,"        %s", process_expr(lines->node->node.assignment_expression.left,"c."));
        }
        if(lines->node->node.assignment_expression.right){
            fprintf(fp," = %s;\\n\\\n", process_expr(lines->node->node.assignment_expression.right,"rec_"));
        }
        lines=lines->next;
    }
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"        EVdiscard_%s(0);\\n\\\n",input);
        inputs=inputs->next;
    }
    fprintf(fp,"        EVsubmit(0, c);\\n\\\n");
    fprintf(fp,"    }\\n\\\n");
    fprintf(fp,"    return 1;\\n\\\n");
    fprintf(fp,"}\";\n\n\n");
}

int has_max(sm_ref node){
    if(strcmp(node->node.field.name,"Max")==0){
        return 1;
    }
    return 0;
}

int has_min(sm_ref node){
    if(strcmp(node->node.field.name,"Min")==0){
        return 1;
    }
    return 0;
}

int has_avg(sm_ref node){
    if(strcmp(node->node.field.name,"Average")==0){
        return 1;
    }
    return 0;
}

void print_aggregate(FILE* fp, const char *name, const char *window_type, int count, sm_list inputs, sm_list lines){
    //lists
    fprintf(fp, "static FMStructDescList %s_inputs[] = {", name);
    sm_list orig_inputs=inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"%s_format_list, ",input);
        inputs=inputs->next;
    }
    fprintf(fp, "%s_format_list, NULL};\n\n", name);
    
    //header
    fprintf(fp,"static char* ");
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        fprintf(fp,"%s_",input);
        inputs=inputs->next;
    }
    fprintf(fp,"to_%s = \"{\\n\\\n",name);
    
    //variables
    fprintf(fp,"    int found=0;\\n\\\n");
    inputs = orig_inputs;
    int input_cnt=0;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        int i=0;
        for(i=0; i<count; i++){
            fprintf(fp,"    %s *rec_%s_%d;\\n\\\n",input, input, i);
        }
        input_cnt++;
        inputs=inputs->next;
    }
    fprintf(fp,"    %s ret;\\n\\\n", name);
    
    //count available
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        int i=0;
        for(i=0; i<count; i++){
            fprintf(fp,"    if (EVpresent(%s_ID, %d)) {\\n\\\n",input, i);
            fprintf(fp,"        rec_%s_%d = EVdata_%s(%d); ++found;\\n\\\n",input, i, input, i);
            fprintf(fp,"    }\\n\\\n");
        }
        inputs=inputs->next;
    }
    
    //process
    fprintf(fp,"    if (found == %d) {\\n\\\n",count);
    while(lines && lines->node){
        //check if line contains max
        if(has_max(lines->node->node.assignment_expression.right)){
            sm_ref max = lines->node->node.assignment_expression.right;
            const char *left=lines->node->node.assignment_expression.left->node.identifier.id;
            const char *right=max->node.field.type_spec->node->node.identifier.id;
            inputs = orig_inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                int i=0;
                fprintf(fp,"        ret.%s=rec_%s_%d.%s;\\n\\\n",left,input, i, right, left, input, i, right);
                for(i=1; i<count; i++){
                    fprintf(fp,"        if(ret.%s<rec_%s_%d.%s) ret.%s=rec_%s_%d.%s;\\n\\\n",left,input, i, right, left, input, i, right);
                }
                inputs=inputs->next;
            }
        } else if (has_min(lines->node->node.assignment_expression.right)) {
            sm_ref max = lines->node->node.assignment_expression.right;
            const char *left=lines->node->node.assignment_expression.left->node.identifier.id;
            const char *right=max->node.field.type_spec->node->node.identifier.id;
            inputs = orig_inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                int i=0;
                fprintf(fp,"        ret.%s=rec_%s_%d.%s;\\n\\\n",left,input, i, right, left, input, i, right);
                for(i=1; i<count; i++){
                    fprintf(fp,"        if(ret.%s>rec_%s_%d.%s) ret.%s=rec_%s_%d.%s;\\n\\\n",left,input, i, right, left, input, i, right);
                }
                inputs=inputs->next;
            }
        } else if (has_avg(lines->node->node.assignment_expression.right)) {
            sm_ref max = lines->node->node.assignment_expression.right;
            const char *left=lines->node->node.assignment_expression.left->node.identifier.id;
            const char *right=max->node.field.type_spec->node->node.identifier.id;
            inputs = orig_inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                int i=0;
                fprintf(fp,"        ret.%s=rec_%s_%d.%s;\\n\\\n",left,input, i, right, left, input, i, right);
                for(i=1; i<count; i++){
                    fprintf(fp,"        ret.%s=(ret.%s*%d+rec_%s_%d.%s)/%d;\\n\\\n",left, left, i, input, i, right, i+1);
                }
                inputs=inputs->next;
            }
        } else {
            if(lines->node->node.assignment_expression.left){
                fprintf(fp,"        %s", process_expr(lines->node->node.assignment_expression.left,"ret."));
            }
            if(lines->node->node.assignment_expression.right){
                fprintf(fp," = %s;\\n\\\n", process_expr(lines->node->node.assignment_expression.right,"rec_"));
            }
        }
        lines=lines->next;
    }
    inputs = orig_inputs;
    while(inputs && inputs->node){
        const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
        int i=0;
        for(i=0; i<count; i++){
            fprintf(fp,"        EVdiscard_%s(0);\\n\\\n",input);
        }
        inputs=inputs->next;
    }
    fprintf(fp,"        EVsubmit(0, ret);\\n\\\n");
    fprintf(fp,"    }\\n\\\n");
    fprintf(fp,"    return 1;\\n\\\n");
    fprintf(fp,"}\";\n\n\n");
}

const char *get_struct_type(int cg_type){
	switch(cg_type){
		default:
		case INT8:
		case INT16:
		case INT32:
		case INT64:
		case INT128:
			return "int";
		case UINT8:
		case UINT16:
		case UINT32:
		case UINT64:
		case UINT128:
			return "unsigned int";
		case FLOAT32:
		case FLOAT64:
			return "float";
		case DECIMAL32:
		case DECIMAL64:
		case DECIMAL128:
			return "double";
		case STRING8:
		case STRING16:
			return "char";
		case COMPLEX32:
		case COMPLEX64:
			return "complex";
	}
}

void print_struct(FILE* fp, const char *name, sm_list ids){
    fprintf(fp,"typedef struct _%s_rec {\n", name);
    while(ids !=NULL){
        const char *type = get_struct_type(ids->node->node.identifier.cg_type);
        fprintf(fp,"\t%s %s;\n",type, ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"} %s_rec, *%s_rec_ptr;\n\n",name,name);
}

const char *get_FMField_type(int cg_type){
	switch(cg_type){
		default:
		case INT8:
		case INT16:
		case INT32:
		case INT64:
		case INT128:
			return "integer";
		case UINT8:
		case UINT16:
		case UINT32:
		case UINT64:
		case UINT128:
			return "unsigned integer";
		case FLOAT32:
		case FLOAT64:
			return "float";
		case DECIMAL32:
		case DECIMAL64:
		case DECIMAL128:
			return "double";
		case STRING8:
		case STRING16:
			return "char";
		case COMPLEX32:
		case COMPLEX64:
			return "complex";
	}
}

int get_FMField_size(int cg_type){
	switch(cg_type){
		default:
		case INT32:
		case UINT32:
		case FLOAT32:
		case DECIMAL32:
		case COMPLEX32:
			return 4;
		case INT8:
		case UINT8:
			return 1;
		case INT16:
		case UINT16:
			return 2;
		case INT64:
		case UINT64:
		case FLOAT64:
		case DECIMAL64:
		case COMPLEX64:
		case STRING8:
			return 8;
		case INT128:
		case UINT128:
		case DECIMAL128:
		case STRING16:
			return 16;
	}
}

void print_FMfield(FILE* fp, const char * name, sm_list ids) {
    fprintf(fp,"static FMField %s_field_list [] = {\n",name);
    while(ids != NULL){
	char *id = ids->node->node.identifier.id;
        const char* type=get_FMField_type(ids->node->node.identifier.cg_type);
	int size = get_FMField_size(ids->node->node.identifier.cg_type);
	fprintf(fp,"\t{\"%s\", \"%s\", %d, FMOffset(%s_rec_ptr, %s)},\n",id, type, size, name,id);
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


char *process_expr(sm_ref node, const char *str){
    if(node->node_type==spl_operator){
        char *buffer=calloc(sizeof(char),100);
        if(node->node.operator.operation_type == PLUS){
            strcpy(buffer, process_expr(node->node.operator.left, str));
            strcat(buffer, " + ");
            strcat(buffer, process_expr(node->node.operator.right, str));
            return buffer;
        } else {
            printf("ERROR!!!!\n\n\n\n");
        }
    } else if(node->node_type == spl_identifier){
        char *buffer=calloc(sizeof(char),100);
        strcpy(buffer, str);
        strcat(buffer, node->node.identifier.id);
        return buffer;
    } else if (node->node_type == spl_constant){
        return node->node.constant.const_val;
    } else if (node->node_type == spl_element_ref) {
        char *buffer=calloc(sizeof(char),100);
        strcpy(buffer, str);
        strcat(buffer, node->node.element_ref.expression->node.identifier.id);
        strcat(buffer, ".");
        strcat(buffer, node->node.element_ref.array_ref->node.identifier.id);
        return buffer;
    }
    return "unknown";
}

char *get_stream_type(sm_ref stream){
    sm_ref stream_decl = stream->node.assignment_expression.left;
    sm_ref right_stream_decl=stream_decl->node.assignment_expression.right;
    char *stream_type = right_stream_decl->node.field.name;
    return stream_type;
}

char *get_stream_input_name(sm_ref stream){
    sm_ref stream_decl = stream->node.assignment_expression.left;
    sm_ref right_stream_decl=stream_decl->node.assignment_expression.right;
    sm_list inputs=NULL;
    char *input=NULL;
    if(right_stream_decl->node.field.type_spec){
        inputs = right_stream_decl->node.field.type_spec->node->node.field.type_spec;
        input = inputs->node->node.identifier.id;
    }
    return input;
}

const char *get_print_type(int cg_type){
    switch(cg_type){
		default:
		case INT8:
		case INT16:
		case INT32:
		case INT64:
		case INT128:
			return "d";
		case UINT8:
		case UINT16:
		case UINT32:
		case UINT64:
		case UINT128:
			return "u";
		case FLOAT32:
		case FLOAT64:
			return "g";
		case DECIMAL32:
		case DECIMAL64:
		case DECIMAL128:
			return "g";
		case STRING8:
		case STRING16:
			return "s";
		case COMPLEX32:
		case COMPLEX64:
			return "d";
	}
}

sm_list get_stream_output_ids(sm_ref stream){
    sm_ref stream_decl = stream->node.assignment_expression.left;
    sm_ref left_stream_decl=stream_decl->node.assignment_expression.left->node.field.type_spec->node;
    sm_list output_ids= left_stream_decl->node.field.type_spec;
    return output_ids;
}

const char *get_file_name(sm_ref stream){
    sm_ref body = stream->node.assignment_expression.right;
    sm_list blocks=body->node.field.type_spec;
    char * block_name=NULL;
    sm_list lines=NULL;
    sm_list inside_lines=NULL;
    while(blocks && blocks->node){
        block_name = blocks->node->node.field.name;
        lines = blocks->node->node.field.type_spec;
        while(lines && lines->node){
            if(strcmp(lines->node->node.field.name,"file")==0){
                return lines->node->node.field.sm_complex_type->node.field.type_spec->node->node.constant.const_val;
            }
            lines=lines->next;
        }
        blocks=blocks->next;
    }
    printf("\n\n");
}

void print_active_sources(FILE* fp){
    Symbol *temp=list;
    while(temp){
        if(strcmp(get_stream_type(temp->node),"FileSource")==0){
            const char * file_name = get_file_name(temp->node);
            fprintf(fp, "   if (EVdfg_source_active(%s_source_handle)) {\n", temp->name);
            fprintf(fp, "       %s_rec rec;\n", temp->name);
            fprintf(fp, "       attr_list attrs = create_attr_list();\n");
            fprintf(fp, "       FILE* file = fopen(\"%s\",\"r\");\n", file_name);
            fprintf(fp, "       if(file) {\n");
            fprintf(fp, "           while(!feof(file)) { \n");
            
            
            fprintf(fp, "               fscanf(file, \"");
            sm_list myids= get_stream_output_ids(temp->node);
            while(myids != NULL){
                const char* type=get_print_type(myids->node->node.identifier.cg_type);
                fprintf(fp, "%%%s",type);
                myids=myids->next;
                if(myids){
                    fprintf(fp, ",");
                }
            }
            fprintf(fp, "\",");
            myids= get_stream_output_ids(temp->node);
            while(myids != NULL){
                char *id = myids->node->node.identifier.id;
                fprintf(fp, "&rec.%s",id);
                myids=myids->next;
                if(myids){
                    fprintf(fp,",");
                }
            }
            fprintf(fp, ");\n");
            fprintf(fp, "               EVsubmit(%s_source_handle, &rec, attrs);\n", temp->name);
            fprintf(fp, "           }\n");
            fprintf(fp, "           fclose(file);\n");
            fprintf(fp, "        } else {  \n");
            fprintf(fp, "           generate_%s_record(&rec);\n", temp->name);
            fprintf(fp, "           EVsubmit(%s_source_handle, &rec, attrs);\n", temp->name);
            fprintf(fp, "       }\n");
            fprintf(fp, "   }\n");
        }
        temp=temp->next;
    }
}

void print_sink_handler(FILE* fp, const char *name, const char *input_name, const char* file_name){
    sm_ref input_stream = find_stream(input_name);
    sm_list ids = get_stream_output_ids(input_stream);
    fprintf(fp,"static int %s_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {\n",name);
    fprintf(fp,"\t%s_rec_ptr event = vevent;\n",input_name);
    fprintf(fp,"\tprintf(\"%s got a struct with the following :\\n\");\n",name);
    fflush(stdout);
    while(ids !=NULL){
        const char* type=get_print_type(ids->node->node.identifier.cg_type);
        fprintf(fp,"\tprintf(\"%s:%%%s\\n\",event->%s);\n",ids->node->node.identifier.id, type, ids->node->node.identifier.id);
        ids=ids->next;
    }
    fprintf(fp,"\tprintf(\"printing to file %s:\\n\");\n",file_name);
    fprintf(fp,"\tFILE* fp=fopen(\"%s\",\"a\");\n",file_name);
    fprintf(fp, "\tfprintf(fp, \"");
    ids = get_stream_output_ids(input_stream);
    fflush(stdout);
    while(ids != NULL){
        const char* type=get_print_type(ids->node->node.identifier.cg_type);
        fprintf(fp, "%%%s",type);
        ids=ids->next;
        if(ids){
            fprintf(fp, ",");
        }
    }
    fprintf(fp, "\\n\",");
    ids= get_stream_output_ids(input_stream);
    fflush(stdout);
    while(ids != NULL){
        char *id = ids->node->node.identifier.id;
        fprintf(fp, "event->%s",id);
        ids=ids->next;
        if(ids){
            fprintf(fp,",");
        }
    }
    fprintf(fp, ");\n");
    fprintf(fp,"\tfclose(fp);\n",file_name);
    fprintf(fp,"}\n",file_name);
    
}

sm_list get_stream_inputs(sm_ref stream){
    sm_ref stream_decl = stream->node.assignment_expression.left;
    sm_ref right_stream_decl=stream_decl->node.assignment_expression.right;
    sm_list inputs=NULL;
    if(right_stream_decl->node.field.type_spec){
        inputs = right_stream_decl->node.field.type_spec;
    }
    return inputs;
}

void process_graph( sm_list two) {
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
        //pull relevant parts out of abstract syntax tree
        sm_ref stream = tmp->node;
        sm_ref stream_decl = stream->node.assignment_expression.left;
        sm_ref left_stream_decl=stream_decl->node.assignment_expression.left->node.field.type_spec->node;
        const char * stream_name=left_stream_decl->node.field.name;
        sm_list output_ids= left_stream_decl->node.field.type_spec;
        printf("stream name:%s\n",stream_name);
        printf("stream outputs:");
        sm_list ids=output_ids;
        while(ids != NULL){
            printf(" %s", ids->node->node.identifier.id);
            ids=ids->next;
        }
        printf("\n");
        sm_ref right_stream_decl=stream_decl->node.assignment_expression.right;
        const char *stream_type = right_stream_decl->node.field.name;
        printf("structure type:%s\n",stream_type);
        sm_list inputs=NULL;
        const char *input1=NULL;
        if(right_stream_decl->node.field.type_spec){
            inputs = right_stream_decl->node.field.type_spec;
            input1 = inputs->node->node.field.type_spec->node->node.identifier.id;
            printf("stream input1:%s\n",input1);
        }


        printf("Body:\n");
        sm_ref body = stream->node.assignment_expression.right;
        sm_list blocks=body->node.field.type_spec;
        printf("Blocks:\n");
        char * block_name=NULL;
        const char *window_type=NULL;
        sm_list lines=NULL;
        sm_list inside_lines=NULL;
        int count=0;
        while(blocks && blocks->node){
            block_name = blocks->node->node.field.name;
            printf("block name:%s\n", block_name);
            lines = blocks->node->node.field.type_spec;
            sm_list temp=lines;
            while(temp && temp->node){      
                if(strcmp(block_name,"window")==0){
                    window_type = temp->node->node.field.type_spec->node->node.identifier.id;
                    printf("window type: %s\n",window_type);
                    count = atoi(temp->node->node.field.type_spec->next->node->node.field.type_spec->node->node.constant.const_val);
                    printf("count: %d\n",count);
                } else if(strcmp(block_name,"invoke_output")==0){
                    inside_lines = lines->node->node.field.type_spec;
                    sm_list temp2=inside_lines;
                    while(temp2 && temp2->node){
                        printf("output line1:\n");
                        if(temp2->node->node.assignment_expression.left){
                            printf("assign left:%s\n", process_expr(temp2->node->node.assignment_expression.left, "output."));
                        }
                        if(temp2->node->node.assignment_expression.right){
                            printf("assign right:%s\n", process_expr(temp2->node->node.assignment_expression.right, "input."));
                        }
                        
                        temp2=temp2->next;   
                    }
                } else if(strcmp(block_name, "invoke_actual")==0) {
                    const char *file_name = get_file_name(stream);
                    printf("filename:%s\n",file_name);
                    break;
                }
                temp=temp->next;   
            }
            blocks=blocks->next;
        }
        printf("\n\n");
        
        add_symbol(stream, stream_name, 1);
        
         //print struct
        print_struct(fp, stream_name, output_ids);
        
        //print FMfield
        print_FMfield(fp, stream_name, output_ids);
        
        //print FMstruct
        print_FMstruct(fp, stream_name);

        if(strcmp(stream_type,"Functor")==0){
            print_transform(fp, stream_name, input1, inside_lines);
        }
        
        if(strcmp(stream_type,"Barrier")==0){
            print_barrier(fp, stream_name, inputs, inside_lines);
        }
        
        if(strcmp(stream_type,"Aggregate")==0){
            print_aggregate(fp, stream_name, window_type, count, inputs, inside_lines);
        }
        
        if(strcmp(stream_type,"FileSink")==0){
            //print handler
            const char *file_name = get_file_name(stream);
            print_sink_handler(fp, stream_name, input1, file_name);
        }
        
        //print generate functions
        print_generate(fp, stream_name, output_ids);
        tmp = tmp->next;
    }
    
    
    
    
    //print master stuff
    fprintf(fp, "\n\nextern int be_test_master(int argc, char **argv) {\n");
    debug_print(fp, "in master",1);
    
    //print management structures
    fprintf(fp, "   /*in graph management structures*/\n");
    fprintf(fp, "   CManager cm;\n");
    fprintf(fp, "   attr_list contact_list;\n");
    fprintf(fp, "   char *str_contact;\n");
    fprintf(fp, "   char *action;\n");
    fprintf(fp, "   EVdfg_stone src, dst;\n");
    
    // print stream names
    fprintf(fp, "    char **nodes;\n");
    fprintf(fp, "    int node_count = %d;\n", stream_count);
    fprintf(fp, "    int i=0;\n");
    fprintf(fp, "    nodes = malloc(sizeof(nodes[0]) * (node_count+1));\n");
    
    Symbol *temp=list;
    while(temp){
        fprintf(fp, "    /* %s Stream */\n", temp->name);
        fprintf(fp, "    nodes[i] = strdup(\"%s\");\n", temp->name);
        fprintf(fp, "    EVdfg_stone %s_stone;\n", temp->name);
        fprintf(fp, "    i++;\n");
        if(strcmp(get_stream_type(temp->node),"FileSource")==0){
            fprintf(fp, "    EVsource %s_source_handle;\n", temp->name);    
        }
        temp=temp->next;
    }
    
    // print initialization
    fprintf(fp, "    printf(\"initializing\\n\");\n");
    fprintf(fp, "    fflush(stdout);\n");
    fprintf(fp, "    /* management initialization */\n");
    fprintf(fp, "    cm = CManager_create();\n");
    fprintf(fp, "    CMlisten(cm);\n");
    fprintf(fp, "    contact_list = CMget_contact_list(cm);\n");
    fprintf(fp, "    str_contact = attr_list_to_string(contact_list);\n");
    fprintf(fp, "    printf(\"-setting up graph\\n\");\n");
    fprintf(fp, "    fflush(stdout);\n");
    fprintf(fp, "    /* setup graph */\n");
    fprintf(fp, "    test_dfg = EVdfg_create(cm);\n");
    fprintf(fp, "    EVdfg_register_node_list(test_dfg, &nodes[0]);\n");
    
    // setup graph
    temp=list;
    int cnt=0;
    while(temp){
        if(strcmp(get_stream_type(temp->node),"FileSource")==0) {
            fprintf(fp, "    %s_source_handle = EVcreate_submit_handle(cm, -1, %s_format_list);\n", temp->name, temp->name);
            fprintf(fp, "    EVdfg_register_source(\"%s\", %s_source_handle);\n", temp->name, temp->name);
            fprintf(fp, "    %s_stone = EVdfg_create_source_stone(test_dfg, \"%s\");\n", temp->name, temp->name);
        } else if (strcmp(get_stream_type(temp->node),"FileSink")==0) {
            char *input_name = get_stream_input_name(temp->node);
            Symbol *input_sym= find_stream_symbol(input_name);
            fprintf(fp, "    EVdfg_register_sink_handler(cm, \"%s_handler\", %s_format_list, (EVSimpleHandlerFunc) %s_handler);\n",temp->name, input_name, temp->name);
            fprintf(fp, "    %s_stone = EVdfg_create_sink_stone(test_dfg, \"%s_handler\");\n", temp->name, temp->name);
            fprintf(fp, "    EVdfg_link_port(%s_stone, %d, %s_stone);\n", input_name, input_sym->port++, temp->name);
        } else if (strcmp(get_stream_type(temp->node),"Functor")==0) {
            char *input_name = get_stream_input_name(temp->node);
            Symbol *input_sym= find_stream_symbol(input_name);
            fprintf(fp, "    action = create_transform_action_spec(%s_format_list, %s_format_list, %s_to_%s_transform);\n", input_name, temp->name, input_name, temp->name);
            fprintf(fp, "    %s_stone = EVdfg_create_stone(test_dfg, action);\n", temp->name);
            fprintf(fp, "    EVdfg_link_port(%s_stone, %d, %s_stone);\n", input_name, input_sym->port++, temp->name);
        } else if (strcmp(get_stream_type(temp->node),"Barrier")==0) {
            sm_list inputs = get_stream_inputs(temp->node);
            
            fprintf(fp, "    action = create_multityped_action_spec(%s_inputs, ", temp->name);
            sm_list orig_inputs=inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                fprintf(fp,"%s_",input);
                inputs=inputs->next;
            }
            fprintf(fp, "to_%s);\n", temp->name);
            fprintf(fp, "    %s_stone = EVdfg_create_stone(test_dfg, action);\n", temp->name);
            inputs=orig_inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                fprintf(fp,"    EVdfg_link_port(%s_stone, 0, %s_stone);\n",input, temp->name);
                inputs=inputs->next;
            }
        } else if (strcmp(get_stream_type(temp->node),"Aggregate")==0){
            sm_list inputs = get_stream_inputs(temp->node);
            
            fprintf(fp, "    action = create_multityped_action_spec(%s_inputs, ", temp->name);
            sm_list orig_inputs=inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                fprintf(fp,"%s_",input);
                inputs=inputs->next;
            }
            fprintf(fp, "to_%s);\n", temp->name);
            fprintf(fp, "    %s_stone = EVdfg_create_stone(test_dfg, action);\n", temp->name);
            inputs=orig_inputs;
            while(inputs && inputs->node){
                const char *input = inputs->node->node.field.type_spec->node->node.identifier.id;
                fprintf(fp,"    EVdfg_link_port(%s_stone, 0, %s_stone);\n",input, temp->name);
                inputs=inputs->next;
            }
        }
        fprintf(fp, "    EVdfg_assign_node(%s_stone, nodes[%d]);\n", temp->name, cnt);
        cnt++;
        temp=temp->next;
    }
    
    // print startup
    fprintf(fp, "    EVdfg_realize(test_dfg);\n");
    fprintf(fp, "    EVdfg_join_dfg(test_dfg, nodes[0], str_contact);\n");
    fprintf(fp, "    test_fork_children(&nodes[0], str_contact);\n");
    fprintf(fp, "    if (EVdfg_ready_wait(test_dfg) != 1) {\n");
    fprintf(fp, "        /* dfg initialization failed! */\n");
    fprintf(fp, "        exit(1);\n");
    fprintf(fp, "    }\n");
    
    // print active sources
    print_active_sources(fp);
    
    // print shutdown check
    fprintf(fp, "   if (EVdfg_active_sink_count(test_dfg) == 0) {\n");
    fprintf(fp, "       EVdfg_ready_for_shutdown(test_dfg);\n");
    fprintf(fp, "   }\n");
    
    // print master close
    fprintf(fp, "   status = EVdfg_wait_for_shutdown(test_dfg);\n");
    fprintf(fp, "   wait_for_children(nodes);\n");
    fprintf(fp, "   CManager_close(cm);\n");
    fprintf(fp, "   return status;\n");
    fprintf(fp, "}\n\n");
    
    
    
    // print child stuff
    fprintf(fp, "extern int\n");
    fprintf(fp, "be_test_child(int argc, char **argv)\n");
    fprintf(fp, "{\n");
    debug_print(fp, "in child", 1);
    fprintf(fp, "   CManager cm;\n");
    fprintf(fp, "   EVsource src;\n");
    fprintf(fp, "   cm = CManager_create();\n");
    fprintf(fp, "   if (argc != 3) {\n");
    fprintf(fp, "       printf(\"Child usage:  evtest  <nodename> <mastercontact>\\n\");\n");
    fprintf(fp, "       exit(1);\n");
    fprintf(fp, "   }\n");
    fprintf(fp, "   test_dfg = EVdfg_create(cm);\n");
    
    
    temp=list;
    while(temp){
        if(strcmp(get_stream_type(temp->node),"FileSource")==0){
            fprintf(fp, "   src = EVcreate_submit_handle(cm, -1, %s_format_list);\n", temp->name);
            fprintf(fp, "   EVsource %s_source_handle;\n", temp->name);
            fprintf(fp, "    %s_source_handle = EVcreate_submit_handle(cm, -1, %s_format_list);\n", temp->name, temp->name);
            fprintf(fp, "    EVdfg_register_source(\"%s\", %s_source_handle);\n", temp->name, temp->name);
            fprintf(fp, "   EVdfg_register_source(\"%s\", src);\n", temp->name);
        } else 
        if(strcmp(get_stream_type(temp->node),"FileSink")==0){
            char *input_name = get_stream_input_name(temp->node);
            fprintf(fp, "   EVdfg_register_sink_handler(cm, \"%s_handler\", %s_format_list, (EVSimpleHandlerFunc) %s_handler);\n", temp->name, input_name, temp->name);
        }
        temp=temp->next;
    }
    fprintf(fp, "   EVdfg_join_dfg(test_dfg, argv[1], argv[2]);\n");
    fprintf(fp, "   EVdfg_ready_wait(test_dfg);\n");
    
    // print shutdown check
    fprintf(fp, "   if (EVdfg_active_sink_count(test_dfg) == 0) {\n");
    fprintf(fp, "       EVdfg_ready_for_shutdown(test_dfg);\n");
    fprintf(fp, "   }\n");
    
    // print active sources
    print_active_sources(fp);
    
    // print child close  
    fprintf(fp, "   return EVdfg_wait_for_shutdown(test_dfg);\n");
    fprintf(fp, "}\n");
    
    
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

