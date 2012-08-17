#ifndef __STRUCTS_H
#define __STRUCTS_H
struct list_struct {
    sm_ref node;
    struct list_struct *next;
};

typedef enum {
    spl_general,
    spl_selection_statement,
    spl_assignment_expression,
    spl_reference_type_decl,
    spl_type_specifier,
    spl_constant,
    spl_label_statement,
    spl_array_type_decl,
    spl_compound_statement,
    spl_field,
    spl_struct_type_decl,
    spl_element_ref,
    spl_declaration,
    spl_identifier,
    spl_operator,
    spl_return_statement,
    spl_field_ref,
    spl_subroutine_call,
    spl_expression_statement,
    spl_cast,
    spl_iteration_statement,
    spl_last_node_type
} spl_node_type;

typedef struct {
    sm_ref conditional;
    sm_ref then_part;
    sm_ref else_part;
    srcpos lx_srcpos;
} selection_statement;


typedef struct {
    sm_list types;
    sm_ref id;
} general;

typedef struct {
    int cg_type;
    sm_ref right;
    srcpos lx_srcpos;
    sm_ref left;
} assignment_expression;

typedef struct {
    int cg_referenced_size;
    int cg_referenced_type;
    char* name;
    sm_list type_spec;
    sm_ref sm_complex_referenced_type;
    int kernel_ref;
    srcpos lx_srcpos;
} reference_type_decl;

typedef struct {
    int token;
    srcpos lx_srcpos;
    sm_ref created_type_decl;
} type_specifier;

typedef struct {
    int token;
    char* const_val;
    srcpos lx_srcpos;
} constant;

typedef struct {
    char* name;
    sm_ref statement;
} label_statement;

typedef struct {
    sm_ref sm_complex_element_type;
    int cg_element_type;
    sm_ref element_ref;
    sm_ref size_expr;
    sm_ref sm_dynamic_size;
    int cg_element_size;
    sm_list type_spec;
    int cg_static_size;
    srcpos lx_srcpos;
    int static_var;
} array_type_decl;

typedef struct {
    sm_list decls;
    sm_list statements;
} compound_statement;

typedef struct {
    char* string_type;
    sm_ref sm_complex_type;
    char* name;
    int cg_offset;
    int cg_type;
    sm_list type_spec;
    int cg_size;
} field;

typedef struct {
    char* id;
    sm_list fields;
    int cg_size;
    srcpos lx_srcpos;
} struct_type_decl;

typedef struct {
    sm_ref sm_complex_element_type;
    sm_ref sm_containing_structure_ref;
    int cg_element_type;
    int this_index_dimension;
    sm_ref expression;
    srcpos lx_srcpos;
    sm_ref array_ref;
} element_ref;

typedef struct {
    char* id;
    sm_ref sm_complex_type;
    int is_typedef;
    int cg_oprnd;
    sm_ref init_value;
    sm_list params;
    int closure_id;
    int addr_taken;
    void* cg_address;
    int is_extern;
    int cg_type;
    sm_list type_spec;
    int static_var;
    srcpos lx_srcpos;
    int param_num;
    int is_subroutine;
} declaration;

typedef struct {
    sm_ref sm_declaration;
    char* id;
    int cg_type;
    srcpos lx_srcpos;
} identifier;

typedef struct {
    int operation_type;
    int result_type;
    sm_ref right;
    srcpos lx_srcpos;
    sm_ref left;
} operator;

typedef struct {
    sm_ref expression;
    srcpos lx_srcpos;
    int cg_func_type;
} return_statement;

typedef struct {
    char* lx_field;
    sm_ref sm_field_ref;
    srcpos lx_srcpos;
    sm_ref struct_ref;
} field_ref;

typedef struct {
    sm_list arguments;
    srcpos lx_srcpos;
    sm_ref sm_func_ref;
} subroutine_call;

typedef struct {
    sm_ref expression;
} expression_statement;

typedef struct {
    sm_ref sm_complex_type;
    int cg_type;
    sm_list type_spec;
    sm_ref expression;
    srcpos lx_srcpos;
} cast;

typedef struct {
    sm_ref init_expr;
    sm_ref test_expr;
    sm_ref statement;
    srcpos lx_srcpos;
    sm_ref iter_expr;
} iteration_statement;

typedef union {
   selection_statement selection_statement;
   assignment_expression assignment_expression;
   reference_type_decl reference_type_decl;
   type_specifier type_specifier;
   constant constant;
   label_statement label_statement;
   array_type_decl array_type_decl;
   compound_statement compound_statement;
   field field;
   struct_type_decl struct_type_decl;
   element_ref element_ref;
   declaration declaration;
   identifier identifier;
   operator operator;
   return_statement return_statement;
   field_ref field_ref;
   subroutine_call subroutine_call;
   expression_statement expression_statement;
   cast cast;
   iteration_statement iteration_statement;
} sm_union;

struct sm_struct {
    spl_node_type node_type;
    int visited;
    sm_union node;
};
#endif
extern sm_ref spl_new_selection_statement();
extern sm_ref spl_new_assignment_expression();
extern sm_ref spl_new_reference_type_decl();
extern sm_ref spl_new_type_specifier();
extern sm_ref spl_new_constant();
extern sm_ref spl_new_label_statement();
extern sm_ref spl_new_array_type_decl();
extern sm_ref spl_new_compound_statement();
extern sm_ref spl_new_field();
extern sm_ref spl_new_struct_type_decl();
extern sm_ref spl_new_element_ref();
extern sm_ref spl_new_declaration();
extern sm_ref spl_new_identifier();
extern sm_ref spl_new_operator();
extern sm_ref spl_new_return_statement();
extern sm_ref spl_new_field_ref();
extern sm_ref spl_new_subroutine_call();
extern sm_ref spl_new_expression_statement();
extern sm_ref spl_new_cast();
extern sm_ref spl_new_iteration_statement();
typedef void (*spl_apply_func)(sm_ref node, void *data);
typedef void (*spl_apply_list_func)(sm_list list, void *data);
extern void spl_apply(sm_ref node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data);
extern void spl_print(sm_ref node);
extern void spl_free(sm_ref node);
extern void spl_free_list(sm_list list, void *junk);
extern void spl_rfree(sm_ref node);
extern void spl_rfree_list(sm_list list, void *junk);
extern sm_ref spl_copy(sm_ref node);
extern sm_list spl_copy_list(sm_list list);
extern srcpos spl_get_srcpos(sm_ref expr);
