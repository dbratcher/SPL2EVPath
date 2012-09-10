#include "config.h"
#include <stdio.h>
#include "spl.h"
#include "spl_internal.h"
#include "structs.h"
#ifdef HAVE_MALLOC_H
#include <malloc.h>
#endif
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#include <string.h>
#ifndef NULL
#define NULL 0
#endif
extern sm_ref
spl_new_selection_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_selection_statement;
    return tmp;
}

extern sm_ref
spl_new_assignment_expression()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_assignment_expression;
    return tmp;
}

extern sm_ref
spl_new_reference_type_decl()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_reference_type_decl;
    return tmp;
}

extern sm_ref
spl_new_type_specifier()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_type_specifier;
    return tmp;
}

extern sm_ref
spl_new_constant()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_constant;
    return tmp;
}

extern sm_ref
spl_new_label_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_label_statement;
    return tmp;
}

extern sm_ref
spl_new_array_type_decl()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_array_type_decl;
    return tmp;
}

extern sm_ref
spl_new_compound_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_compound_statement;
    return tmp;
}

extern sm_ref
spl_new_field()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_field;
    return tmp;
}

extern sm_ref
spl_new_struct_type_decl()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_struct_type_decl;
    return tmp;
}

extern sm_ref
spl_new_element_ref()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_element_ref;
    return tmp;
}

extern sm_ref
spl_new_declaration()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_declaration;
    return tmp;
}

extern sm_ref
spl_new_identifier()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_identifier;
    return tmp;
}

extern sm_ref
spl_new_operator()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_operator;
    return tmp;
}

extern sm_ref
spl_new_return_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_return_statement;
    return tmp;
}

extern sm_ref
spl_new_field_ref()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_field_ref;
    return tmp;
}

extern sm_ref
spl_new_subroutine_call()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_subroutine_call;
    return tmp;
}

extern sm_ref
spl_new_expression_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_expression_statement;
    return tmp;
}

extern sm_ref
spl_new_cast()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_cast;
    return tmp;
}

extern sm_ref
spl_new_iteration_statement()
{
    sm_ref tmp = malloc(sizeof(*tmp));
    memset(tmp, 0, sizeof(*tmp));
    tmp->visited = 0;
    tmp->node_type = spl_iteration_statement;
    return tmp;
}

static void spl_apply_list(sm_list node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data)
{
    sm_list orig = node;
    while (node != NULL) {
        spl_apply(node->node, pre_func, post_func, list_func, data);
        node = node->next;
    }
    if (list_func) (list_func)(orig, data);
}

extern void spl_apply(sm_ref node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data)
{
    if (node == NULL) return;
    if (node->visited) return;
    node->visited++;
    if(pre_func) (pre_func)(node, data);
    switch(node->node_type) {
      case spl_selection_statement: {
          spl_apply(node->node.selection_statement.conditional, pre_func, post_func, list_func, data);
          spl_apply(node->node.selection_statement.then_part, pre_func, post_func, list_func, data);
          spl_apply(node->node.selection_statement.else_part, pre_func, post_func, list_func, data);
          break;
      }
      case spl_assignment_expression: {
          spl_apply(node->node.assignment_expression.right, pre_func, post_func, list_func, data);
          spl_apply(node->node.assignment_expression.left, pre_func, post_func, list_func, data);
          break;
      }
      case spl_reference_type_decl: {
          spl_apply_list(node->node.reference_type_decl.type_spec, pre_func, post_func, list_func, data);
          break;
      }
      case spl_type_specifier: {
          spl_apply(node->node.type_specifier.created_type_decl, pre_func, post_func, list_func, data);
          break;
      }
      case spl_constant: {
          break;
      }
      case spl_label_statement: {
          spl_apply(node->node.label_statement.statement, pre_func, post_func, list_func, data);
          break;
      }
      case spl_array_type_decl: {
          spl_apply(node->node.array_type_decl.element_ref, pre_func, post_func, list_func, data);
          spl_apply(node->node.array_type_decl.size_expr, pre_func, post_func, list_func, data);
          spl_apply_list(node->node.array_type_decl.type_spec, pre_func, post_func, list_func, data);
          break;
      }
      case spl_compound_statement: {
          spl_apply_list(node->node.compound_statement.decls, pre_func, post_func, list_func, data);
          spl_apply_list(node->node.compound_statement.statements, pre_func, post_func, list_func, data);
          break;
      }
      case spl_field: {
          spl_apply_list(node->node.field.type_spec, pre_func, post_func, list_func, data);
          break;
      }
      case spl_struct_type_decl: {
          spl_apply_list(node->node.struct_type_decl.fields, pre_func, post_func, list_func, data);
          break;
      }
      case spl_element_ref: {
          spl_apply(node->node.element_ref.expression, pre_func, post_func, list_func, data);
          spl_apply(node->node.element_ref.array_ref, pre_func, post_func, list_func, data);
          break;
      }
      case spl_declaration: {
          spl_apply(node->node.declaration.init_value, pre_func, post_func, list_func, data);
          spl_apply_list(node->node.declaration.params, pre_func, post_func, list_func, data);
          spl_apply_list(node->node.declaration.type_spec, pre_func, post_func, list_func, data);
          break;
      }
      case spl_identifier: {
          break;
      }
      case spl_operator: {
          spl_apply(node->node.operator.right, pre_func, post_func, list_func, data);
          spl_apply(node->node.operator.left, pre_func, post_func, list_func, data);
          break;
      }
      case spl_return_statement: {
          spl_apply(node->node.return_statement.expression, pre_func, post_func, list_func, data);
          break;
      }
      case spl_field_ref: {
          spl_apply(node->node.field_ref.struct_ref, pre_func, post_func, list_func, data);
          break;
      }
      case spl_subroutine_call: {
          spl_apply_list(node->node.subroutine_call.arguments, pre_func, post_func, list_func, data);
          break;
      }
      case spl_expression_statement: {
          spl_apply(node->node.expression_statement.expression, pre_func, post_func, list_func, data);
          break;
      }
      case spl_cast: {
          spl_apply_list(node->node.cast.type_spec, pre_func, post_func, list_func, data);
          spl_apply(node->node.cast.expression, pre_func, post_func, list_func, data);
          break;
      }
      case spl_iteration_statement: {
          spl_apply(node->node.iteration_statement.init_expr, pre_func, post_func, list_func, data);
          spl_apply(node->node.iteration_statement.test_expr, pre_func, post_func, list_func, data);
          spl_apply(node->node.iteration_statement.statement, pre_func, post_func, list_func, data);
          spl_apply(node->node.iteration_statement.iter_expr, pre_func, post_func, list_func, data);
          break;
      }
    }
    node->visited--;
    if(post_func) (post_func)(node, data);
}

static void spl_print_sm_list(sm_list list)
{
    while (list != NULL) {
        printf(" %p", list->node);
        list = list->next;
    }
}

extern void spl_print(sm_ref node)
{
    switch(node->node_type) {
      case spl_selection_statement: {
          printf("0x%p  --  selection_statement ->\n", node);
          printf("	conditional : %p\n", node->node.selection_statement.conditional);
          printf("	then_part : %p\n", node->node.selection_statement.then_part);
          printf("	else_part : %p\n", node->node.selection_statement.else_part);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.selection_statement.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_assignment_expression: {
          printf("0x%p  --  assignment_expression ->\n", node);
          printf("	cg_type : %d\n", node->node.assignment_expression.cg_type);
          printf("	right : %p\n", node->node.assignment_expression.right);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.assignment_expression.lx_srcpos);
          printf("\n");
          printf("	left : %p\n", node->node.assignment_expression.left);
          break;
      }
      case spl_reference_type_decl: {
          printf("0x%p  --  reference_type_decl ->\n", node);
          printf("	cg_referenced_size : %d\n", node->node.reference_type_decl.cg_referenced_size);
          printf("	cg_referenced_type : %d\n", node->node.reference_type_decl.cg_referenced_type);
          printf("	name : %s\n", (node->node.reference_type_decl.name == NULL) ? "<NULL>" : node->node.reference_type_decl.name);
          printf("	type_spec : ");
          spl_print_sm_list(node->node.reference_type_decl.type_spec);
          printf("\n");
          printf("	sm_complex_referenced_type : %p\n", node->node.reference_type_decl.sm_complex_referenced_type);
          printf("	kernel_ref : %d\n", node->node.reference_type_decl.kernel_ref);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.reference_type_decl.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_type_specifier: {
          printf("0x%p  --  type_specifier ->\n", node);
          printf("	token : %d\n", node->node.type_specifier.token);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.type_specifier.lx_srcpos);
          printf("\n");
          printf("	created_type_decl : %p\n", node->node.type_specifier.created_type_decl);
          break;
      }
      case spl_constant: {
          printf("0x%p  --  constant ->\n", node);
          printf("	token : %d\n", node->node.constant.token);
          printf("	const_val : %s\n", (node->node.constant.const_val == NULL) ? "<NULL>" : node->node.constant.const_val);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.constant.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_label_statement: {
          printf("0x%p  --  label_statement ->\n", node);
          printf("	name : %s\n", (node->node.label_statement.name == NULL) ? "<NULL>" : node->node.label_statement.name);
          printf("	statement : %p\n", node->node.label_statement.statement);
          break;
      }
      case spl_array_type_decl: {
          printf("0x%p  --  array_type_decl ->\n", node);
          printf("	sm_complex_element_type : %p\n", node->node.array_type_decl.sm_complex_element_type);
          printf("	cg_element_type : %d\n", node->node.array_type_decl.cg_element_type);
          printf("	element_ref : %p\n", node->node.array_type_decl.element_ref);
          printf("	size_expr : %p\n", node->node.array_type_decl.size_expr);
          printf("	sm_dynamic_size : %p\n", node->node.array_type_decl.sm_dynamic_size);
          printf("	cg_element_size : %d\n", node->node.array_type_decl.cg_element_size);
          printf("	type_spec : ");
          spl_print_sm_list(node->node.array_type_decl.type_spec);
          printf("\n");
          printf("	cg_static_size : %d\n", node->node.array_type_decl.cg_static_size);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.array_type_decl.lx_srcpos);
          printf("\n");
          printf("	static_var : %d\n", node->node.array_type_decl.static_var);
          break;
      }
      case spl_compound_statement: {
          printf("0x%p  --  compound_statement ->\n", node);
          printf("	decls : ");
          spl_print_sm_list(node->node.compound_statement.decls);
          printf("\n");
          printf("	statements : ");
          spl_print_sm_list(node->node.compound_statement.statements);
          printf("\n");
          break;
      }
      case spl_field: {
          printf("0x%p  --  field ->\n", node);
          printf("	string_type : %s\n", (node->node.field.string_type == NULL) ? "<NULL>" : node->node.field.string_type);
          printf("	sm_complex_type : %p\n", node->node.field.sm_complex_type);
          printf("	name : %s\n", (node->node.field.name == NULL) ? "<NULL>" : node->node.field.name);
          printf("	cg_offset : %d\n", node->node.field.cg_offset);
          printf("	cg_type : %d\n", node->node.field.cg_type);
          printf("	type_spec : ");
          spl_print_sm_list(node->node.field.type_spec);
          printf("\n");
          printf("	cg_size : %d\n", node->node.field.cg_size);
          break;
      }
      case spl_struct_type_decl: {
          printf("0x%p  --  struct_type_decl ->\n", node);
          printf("	id : %s\n", (node->node.struct_type_decl.id == NULL) ? "<NULL>" : node->node.struct_type_decl.id);
          printf("	fields : ");
          spl_print_sm_list(node->node.struct_type_decl.fields);
          printf("\n");
          printf("	cg_size : %d\n", node->node.struct_type_decl.cg_size);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.struct_type_decl.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_element_ref: {
          printf("0x%p  --  element_ref ->\n", node);
          printf("	sm_complex_element_type : %p\n", node->node.element_ref.sm_complex_element_type);
          printf("	sm_containing_structure_ref : %p\n", node->node.element_ref.sm_containing_structure_ref);
          printf("	cg_element_type : %d\n", node->node.element_ref.cg_element_type);
          printf("	this_index_dimension : %d\n", node->node.element_ref.this_index_dimension);
          printf("	expression : %p\n", node->node.element_ref.expression);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.element_ref.lx_srcpos);
          printf("\n");
          printf("	array_ref : %p\n", node->node.element_ref.array_ref);
          break;
      }
      case spl_declaration: {
          printf("0x%p  --  declaration ->\n", node);
          printf("	id : %s\n", (node->node.declaration.id == NULL) ? "<NULL>" : node->node.declaration.id);
          printf("	sm_complex_type : %p\n", node->node.declaration.sm_complex_type);
          printf("	is_typedef : %d\n", node->node.declaration.is_typedef);
          printf("	cg_oprnd : %d\n", node->node.declaration.cg_oprnd);
          printf("	init_value : %p\n", node->node.declaration.init_value);
          printf("	params : ");
          spl_print_sm_list(node->node.declaration.params);
          printf("\n");
          printf("	closure_id : %d\n", node->node.declaration.closure_id);
          printf("	addr_taken : %d\n", node->node.declaration.addr_taken);
          printf("	cg_address : %p\n", node->node.declaration.cg_address);
          printf("	is_extern : %d\n", node->node.declaration.is_extern);
          printf("	cg_type : %d\n", node->node.declaration.cg_type);
          printf("	type_spec : ");
          spl_print_sm_list(node->node.declaration.type_spec);
          printf("\n");
          printf("	static_var : %d\n", node->node.declaration.static_var);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.declaration.lx_srcpos);
          printf("\n");
          printf("	param_num : %d\n", node->node.declaration.param_num);
          printf("	is_subroutine : %d\n", node->node.declaration.is_subroutine);
          break;
      }
      case spl_identifier: {
          printf("0x%p  --  identifier ->\n", node);
          printf("	sm_declaration : %p\n", node->node.identifier.sm_declaration);
          printf("	id : %s\n", (node->node.identifier.id == NULL) ? "<NULL>" : node->node.identifier.id);
          printf("	cg_type : %d\n", node->node.identifier.cg_type);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.identifier.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_operator: {
          printf("0x%p  --  operator ->\n", node);
          printf("	operation_type : %d\n", node->node.operator.operation_type);
          printf("	result_type : %d\n", node->node.operator.result_type);
          printf("	right : %p\n", node->node.operator.right);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.operator.lx_srcpos);
          printf("\n");
          printf("	left : %p\n", node->node.operator.left);
          break;
      }
      case spl_return_statement: {
          printf("0x%p  --  return_statement ->\n", node);
          printf("	expression : %p\n", node->node.return_statement.expression);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.return_statement.lx_srcpos);
          printf("\n");
          printf("	cg_func_type : %d\n", node->node.return_statement.cg_func_type);
          break;
      }
      case spl_field_ref: {
          printf("0x%p  --  field_ref ->\n", node);
          printf("	lx_field : %s\n", (node->node.field_ref.lx_field == NULL) ? "<NULL>" : node->node.field_ref.lx_field);
          printf("	sm_field_ref : %p\n", node->node.field_ref.sm_field_ref);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.field_ref.lx_srcpos);
          printf("\n");
          printf("	struct_ref : %p\n", node->node.field_ref.struct_ref);
          break;
      }
      case spl_subroutine_call: {
          printf("0x%p  --  subroutine_call ->\n", node);
          printf("	arguments : ");
          spl_print_sm_list(node->node.subroutine_call.arguments);
          printf("\n");
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.subroutine_call.lx_srcpos);
          printf("\n");
          printf("	sm_func_ref : %p\n", node->node.subroutine_call.sm_func_ref);
          break;
      }
      case spl_expression_statement: {
          printf("0x%p  --  expression_statement ->\n", node);
          printf("	expression : %p\n", node->node.expression_statement.expression);
          break;
      }
      case spl_cast: {
          printf("0x%p  --  cast ->\n", node);
          printf("	sm_complex_type : %p\n", node->node.cast.sm_complex_type);
          printf("	cg_type : %d\n", node->node.cast.cg_type);
          printf("	type_spec : ");
          spl_print_sm_list(node->node.cast.type_spec);
          printf("\n");
          printf("	expression : %p\n", node->node.cast.expression);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.cast.lx_srcpos);
          printf("\n");
          break;
      }
      case spl_iteration_statement: {
          printf("0x%p  --  iteration_statement ->\n", node);
          printf("	init_expr : %p\n", node->node.iteration_statement.init_expr);
          printf("	test_expr : %p\n", node->node.iteration_statement.test_expr);
          printf("	statement : %p\n", node->node.iteration_statement.statement);
          printf("	lx_srcpos : ");
          spl_print_srcpos(node->node.iteration_statement.lx_srcpos);
          printf("\n");
          printf("	iter_expr : %p\n", node->node.iteration_statement.iter_expr);
          break;
      }
    }
    printf("\n");
}

extern void spl_free_list(sm_list list, void *junk)
{
    while (list != NULL) {
        sm_list next = list->next;
        free(list);
        list = next;
    }
}

extern void spl_free(sm_ref node)
{
    switch(node->node_type) {
      case spl_selection_statement: {
          break;
      }
      case spl_assignment_expression: {
          break;
      }
      case spl_reference_type_decl: {
	    free(node->node.reference_type_decl.name);
          break;
      }
      case spl_type_specifier: {
          break;
      }
      case spl_constant: {
	    free(node->node.constant.const_val);
          break;
      }
      case spl_label_statement: {
	    free(node->node.label_statement.name);
          break;
      }
      case spl_array_type_decl: {
          break;
      }
      case spl_compound_statement: {
          break;
      }
      case spl_field: {
	    free(node->node.field.string_type);
	    free(node->node.field.name);
          break;
      }
      case spl_struct_type_decl: {
	    free(node->node.struct_type_decl.id);
          break;
      }
      case spl_element_ref: {
          break;
      }
      case spl_declaration: {
	    free(node->node.declaration.id);
          break;
      }
      case spl_identifier: {
	    free(node->node.identifier.id);
          break;
      }
      case spl_operator: {
          break;
      }
      case spl_return_statement: {
          break;
      }
      case spl_field_ref: {
	    free(node->node.field_ref.lx_field);
          break;
      }
      case spl_subroutine_call: {
          break;
      }
      case spl_expression_statement: {
          break;
      }
      case spl_cast: {
          break;
      }
      case spl_iteration_statement: {
          break;
      }
    }
    free(node);
}

static sm_list free_list = NULL;
extern void spl_make_free(sm_ref node, void *junk)
{
    sm_list new_free = malloc(sizeof(*new_free));
    new_free->next = free_list;
    new_free->node = node;
    free_list = new_free;
    switch(node->node_type) {
      case spl_selection_statement: {
          break;
      }
      case spl_assignment_expression: {
          break;
      }
      case spl_reference_type_decl: {
          node->node.reference_type_decl.type_spec = NULL;
          break;
      }
      case spl_type_specifier: {
          break;
      }
      case spl_constant: {
          break;
      }
      case spl_label_statement: {
          break;
      }
      case spl_array_type_decl: {
          node->node.array_type_decl.type_spec = NULL;
          break;
      }
      case spl_compound_statement: {
          node->node.compound_statement.decls = NULL;
          node->node.compound_statement.statements = NULL;
          break;
      }
      case spl_field: {
          node->node.field.type_spec = NULL;
          break;
      }
      case spl_struct_type_decl: {
          node->node.struct_type_decl.fields = NULL;
          break;
      }
      case spl_element_ref: {
          break;
      }
      case spl_declaration: {
          node->node.declaration.params = NULL;
          node->node.declaration.type_spec = NULL;
          break;
      }
      case spl_identifier: {
          break;
      }
      case spl_operator: {
          break;
      }
      case spl_return_statement: {
          break;
      }
      case spl_field_ref: {
          break;
      }
      case spl_subroutine_call: {
          node->node.subroutine_call.arguments = NULL;
          break;
      }
      case spl_expression_statement: {
          break;
      }
      case spl_cast: {
          node->node.cast.type_spec = NULL;
          break;
      }
      case spl_iteration_statement: {
          break;
      }
    }
}

extern void spl_rfree(sm_ref node) {
    free_list = NULL;
    spl_apply(node, NULL, spl_make_free, spl_free_list, NULL);
    while(free_list != NULL) {
        sm_list next = free_list->next;
        spl_free(free_list->node);
        free(free_list);
        free_list = next;
    }
}
extern void spl_rfree_list(sm_list list, void *junk) {
    free_list = NULL;
    spl_apply_list(list, NULL, spl_make_free, spl_free_list, junk);
    while(free_list != NULL) {
        sm_list next = free_list->next;
        spl_free(free_list->node);
        free(free_list);
        free_list = next;
    }
}
extern sm_list spl_copy_list(sm_list list)
{
    sm_list new_list = NULL;
    if (list != NULL) {
        new_list = malloc(sizeof(*new_list));
        new_list->node = spl_copy(list->node);
        new_list->next = spl_copy_list(list->next);
    }
    return new_list;
}

extern sm_ref spl_copy(sm_ref node)
{
    sm_ref new_node = NULL;
    if (node == NULL) return NULL;

    switch(node->node_type) {
      case spl_selection_statement: {
	    new_node = spl_new_selection_statement();
	    new_node->node.selection_statement = node->node.selection_statement;
	    new_node->node.selection_statement.conditional = spl_copy(node->node.selection_statement.conditional);
	    new_node->node.selection_statement.then_part = spl_copy(node->node.selection_statement.then_part);
	    new_node->node.selection_statement.else_part = spl_copy(node->node.selection_statement.else_part);
          break;
      }
      case spl_assignment_expression: {
	    new_node = spl_new_assignment_expression();
	    new_node->node.assignment_expression = node->node.assignment_expression;
	    new_node->node.assignment_expression.right = spl_copy(node->node.assignment_expression.right);
	    new_node->node.assignment_expression.left = spl_copy(node->node.assignment_expression.left);
          break;
      }
      case spl_reference_type_decl: {
	    new_node = spl_new_reference_type_decl();
	    new_node->node.reference_type_decl = node->node.reference_type_decl;
	    new_node->node.reference_type_decl.name = strdup(node->node.reference_type_decl.name);
	    new_node->node.reference_type_decl.type_spec = spl_copy_list(node->node.reference_type_decl.type_spec);
          break;
      }
      case spl_type_specifier: {
	    new_node = spl_new_type_specifier();
	    new_node->node.type_specifier = node->node.type_specifier;
	    new_node->node.type_specifier.created_type_decl = spl_copy(node->node.type_specifier.created_type_decl);
          break;
      }
      case spl_constant: {
	    new_node = spl_new_constant();
	    new_node->node.constant = node->node.constant;
	    new_node->node.constant.const_val = strdup(node->node.constant.const_val);
          break;
      }
      case spl_label_statement: {
	    new_node = spl_new_label_statement();
	    new_node->node.label_statement = node->node.label_statement;
	    new_node->node.label_statement.name = strdup(node->node.label_statement.name);
	    new_node->node.label_statement.statement = spl_copy(node->node.label_statement.statement);
          break;
      }
      case spl_array_type_decl: {
	    new_node = spl_new_array_type_decl();
	    new_node->node.array_type_decl = node->node.array_type_decl;
	    new_node->node.array_type_decl.element_ref = spl_copy(node->node.array_type_decl.element_ref);
	    new_node->node.array_type_decl.size_expr = spl_copy(node->node.array_type_decl.size_expr);
	    new_node->node.array_type_decl.type_spec = spl_copy_list(node->node.array_type_decl.type_spec);
          break;
      }
      case spl_compound_statement: {
	    new_node = spl_new_compound_statement();
	    new_node->node.compound_statement = node->node.compound_statement;
	    new_node->node.compound_statement.decls = spl_copy_list(node->node.compound_statement.decls);
	    new_node->node.compound_statement.statements = spl_copy_list(node->node.compound_statement.statements);
          break;
      }
      case spl_field: {
	    new_node = spl_new_field();
	    new_node->node.field = node->node.field;
	    new_node->node.field.string_type = strdup(node->node.field.string_type);
	    new_node->node.field.name = strdup(node->node.field.name);
	    new_node->node.field.type_spec = spl_copy_list(node->node.field.type_spec);
          break;
      }
      case spl_struct_type_decl: {
	    new_node = spl_new_struct_type_decl();
	    new_node->node.struct_type_decl = node->node.struct_type_decl;
	    new_node->node.struct_type_decl.id = strdup(node->node.struct_type_decl.id);
	    new_node->node.struct_type_decl.fields = spl_copy_list(node->node.struct_type_decl.fields);
          break;
      }
      case spl_element_ref: {
	    new_node = spl_new_element_ref();
	    new_node->node.element_ref = node->node.element_ref;
	    new_node->node.element_ref.expression = spl_copy(node->node.element_ref.expression);
	    new_node->node.element_ref.array_ref = spl_copy(node->node.element_ref.array_ref);
          break;
      }
      case spl_declaration: {
	    new_node = spl_new_declaration();
	    new_node->node.declaration = node->node.declaration;
	    new_node->node.declaration.id = strdup(node->node.declaration.id);
	    new_node->node.declaration.init_value = spl_copy(node->node.declaration.init_value);
	    new_node->node.declaration.params = spl_copy_list(node->node.declaration.params);
	    new_node->node.declaration.type_spec = spl_copy_list(node->node.declaration.type_spec);
          break;
      }
      case spl_identifier: {
	    new_node = spl_new_identifier();
	    new_node->node.identifier = node->node.identifier;
	    new_node->node.identifier.id = strdup(node->node.identifier.id);
          break;
      }
      case spl_operator: {
	    new_node = spl_new_operator();
	    new_node->node.operator = node->node.operator;
	    new_node->node.operator.right = spl_copy(node->node.operator.right);
	    new_node->node.operator.left = spl_copy(node->node.operator.left);
          break;
      }
      case spl_return_statement: {
	    new_node = spl_new_return_statement();
	    new_node->node.return_statement = node->node.return_statement;
	    new_node->node.return_statement.expression = spl_copy(node->node.return_statement.expression);
          break;
      }
      case spl_field_ref: {
	    new_node = spl_new_field_ref();
	    new_node->node.field_ref = node->node.field_ref;
	    new_node->node.field_ref.lx_field = strdup(node->node.field_ref.lx_field);
	    new_node->node.field_ref.struct_ref = spl_copy(node->node.field_ref.struct_ref);
          break;
      }
      case spl_subroutine_call: {
	    new_node = spl_new_subroutine_call();
	    new_node->node.subroutine_call = node->node.subroutine_call;
	    new_node->node.subroutine_call.arguments = spl_copy_list(node->node.subroutine_call.arguments);
          break;
      }
      case spl_expression_statement: {
	    new_node = spl_new_expression_statement();
	    new_node->node.expression_statement = node->node.expression_statement;
	    new_node->node.expression_statement.expression = spl_copy(node->node.expression_statement.expression);
          break;
      }
      case spl_cast: {
	    new_node = spl_new_cast();
	    new_node->node.cast = node->node.cast;
	    new_node->node.cast.type_spec = spl_copy_list(node->node.cast.type_spec);
	    new_node->node.cast.expression = spl_copy(node->node.cast.expression);
          break;
      }
      case spl_iteration_statement: {
	    new_node = spl_new_iteration_statement();
	    new_node->node.iteration_statement = node->node.iteration_statement;
	    new_node->node.iteration_statement.init_expr = spl_copy(node->node.iteration_statement.init_expr);
	    new_node->node.iteration_statement.test_expr = spl_copy(node->node.iteration_statement.test_expr);
	    new_node->node.iteration_statement.statement = spl_copy(node->node.iteration_statement.statement);
	    new_node->node.iteration_statement.iter_expr = spl_copy(node->node.iteration_statement.iter_expr);
          break;
      }
    }
    return new_node;
}

extern srcpos spl_get_srcpos(expr)
sm_ref expr;
{
    switch(expr->node_type) {
      case spl_selection_statement: return expr->node.selection_statement.lx_srcpos;
      case spl_assignment_expression: return expr->node.assignment_expression.lx_srcpos;
      case spl_reference_type_decl: return expr->node.reference_type_decl.lx_srcpos;
      case spl_type_specifier: return expr->node.type_specifier.lx_srcpos;
      case spl_constant: return expr->node.constant.lx_srcpos;
      case spl_array_type_decl: return expr->node.array_type_decl.lx_srcpos;
      case spl_struct_type_decl: return expr->node.struct_type_decl.lx_srcpos;
      case spl_element_ref: return expr->node.element_ref.lx_srcpos;
      case spl_declaration: return expr->node.declaration.lx_srcpos;
      case spl_identifier: return expr->node.identifier.lx_srcpos;
      case spl_operator: return expr->node.operator.lx_srcpos;
      case spl_return_statement: return expr->node.return_statement.lx_srcpos;
      case spl_field_ref: return expr->node.field_ref.lx_srcpos;
      case spl_subroutine_call: return expr->node.subroutine_call.lx_srcpos;
      case spl_cast: return expr->node.cast.lx_srcpos;
      case spl_iteration_statement: return expr->node.iteration_statement.lx_srcpos;
      default: {
          srcpos tmp;
          tmp.line = 0;
          tmp.character = 0;
          return tmp;
       };
    };
}
