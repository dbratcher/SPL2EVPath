#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "evpath.h"
#include "ev_dfg.h"
#include "test_support.h"

int status;
static EVdfg test_dfg;

static char* RawData_filter = "{\n\
int hop_count;\n\
hop_count = attr_ivalue(event_attrs, \"hop_count_atom\");\n\
hop_count++;\n\
printf(\"in  RawData filter with a = %d\\n\", input.a);\n\
input.a+=1;\n\
printf(\"in  RawData filter with b = %d\\n\", input.b);\n\
input.b+=1;\n\
printf(\"in  RawData filter with c = %d\\n\", input.c);\n\
input.c+=1;\n\
printf(\"in  RawData filter with d = %d\\n\", input.d);\n\
input.d+=1;\n\
printf(\"in  RawData filter with e = %d\\n\", input.e);\n\
input.e+=1;\n\
set_int_attr(event_attrs, \"hop_count_atom\", hop_count);\n\
}\0\0";

typedef struct _RawData_rec {
	int a;
	int b;
	int c;
	int d;
	int e;
} RawData_rec, *RawData_rec_ptr;

static FMField RawData_field_list [] = {
	{"a", "integer", 4, FMOffset(RawData_rec_ptr, a)},
	{"b", "integer", 4, FMOffset(RawData_rec_ptr, b)},
	{"c", "integer", 4, FMOffset(RawData_rec_ptr, c)},
	{"d", "integer", 4, FMOffset(RawData_rec_ptr, d)},
	{"e", "integer", 4, FMOffset(RawData_rec_ptr, e)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec RawData_format_list [] = {
	{"RawData", RawData_field_list, sizeof(RawData_rec), NULL},
	{NULL, NULL}
};

static int RawData_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {
	RawData_rec_ptr event = vevent;
	printf("RawData got a struct with the following:\n");
	printf("a:%d\n",event->a);
	printf("b:%d\n",event->b);
	printf("c:%d\n",event->c);
	printf("d:%d\n",event->d);
	printf("e:%d\n",event->e);
	EVdfg_shutdown(test_dfg, 0);
};

void generate_RawData_record(RawData_rec_ptr event)
{
	event->a = 0;
	event->b = 0;
	event->c = 0;
	event->d = 0;
	event->e = 0;
}

static char* Sum_filter = "{\n\
int hop_count;\n\
hop_count = attr_ivalue(event_attrs, \"hop_count_atom\");\n\
hop_count++;\n\
printf(\"in  Sum filter with hops = %d\\n\", input.hops);\n\
input.hops+=1;\n\
printf(\"in  Sum filter with sum = %d\\n\", input.sum);\n\
input.sum+=1;\n\
set_int_attr(event_attrs, \"hop_count_atom\", hop_count);\n\
}\0\0";

typedef struct _Sum_rec {
	int hops;
	int sum;
} Sum_rec, *Sum_rec_ptr;

static FMField Sum_field_list [] = {
	{"hops", "integer", 4, FMOffset(Sum_rec_ptr, hops)},
	{"sum", "integer", 4, FMOffset(Sum_rec_ptr, sum)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec Sum_format_list [] = {
	{"Sum", Sum_field_list, sizeof(Sum_rec), NULL},
	{NULL, NULL}
};

static int Sum_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {
	Sum_rec_ptr event = vevent;
	printf("Sum got a struct with the following:\n");
	printf("hops:%d\n",event->hops);
	printf("sum:%d\n",event->sum);
	EVdfg_shutdown(test_dfg, 0);
};

void generate_Sum_record(Sum_rec_ptr event)
{
	event->hops = 0;
	event->sum = 0;
}

static char* Hop_filter = "{\n\
int hop_count;\n\
hop_count = attr_ivalue(event_attrs, \"hop_count_atom\");\n\
hop_count++;\n\
printf(\"in  Hop filter with hops = %d\\n\", input.hops);\n\
input.hops+=1;\n\
printf(\"in  Hop filter with sum = %d\\n\", input.sum);\n\
input.sum+=1;\n\
set_int_attr(event_attrs, \"hop_count_atom\", hop_count);\n\
}\0\0";

typedef struct _Hop_rec {
	int hops;
	int sum;
} Hop_rec, *Hop_rec_ptr;

static FMField Hop_field_list [] = {
	{"hops", "integer", 4, FMOffset(Hop_rec_ptr, hops)},
	{"sum", "integer", 4, FMOffset(Hop_rec_ptr, sum)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec Hop_format_list [] = {
	{"Hop", Hop_field_list, sizeof(Hop_rec), NULL},
	{NULL, NULL}
};

static int Hop_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {
	Hop_rec_ptr event = vevent;
	printf("Hop got a struct with the following:\n");
	printf("hops:%d\n",event->hops);
	printf("sum:%d\n",event->sum);
	EVdfg_shutdown(test_dfg, 0);
};

void generate_Hop_record(Hop_rec_ptr event)
{
	event->hops = 0;
	event->sum = 0;
}

static char* SinkOp_filter = "{\n\
int hop_count;\n\
hop_count = attr_ivalue(event_attrs, \"hop_count_atom\");\n\
hop_count++;\n\
set_int_attr(event_attrs, \"hop_count_atom\", hop_count);\n\
}\0\0";

typedef struct _SinkOp_rec {
} SinkOp_rec, *SinkOp_rec_ptr;

static FMField SinkOp_field_list [] = {
	{NULL, NULL, 0, 0}
};

static FMStructDescRec SinkOp_format_list [] = {
	{"SinkOp", SinkOp_field_list, sizeof(SinkOp_rec), NULL},
	{NULL, NULL}
};

static int SinkOp_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {
	SinkOp_rec_ptr event = vevent;
	printf("SinkOp got a struct with the following:\n");
	EVdfg_shutdown(test_dfg, 0);
};

void generate_SinkOp_record(SinkOp_rec_ptr event)
{
}



extern int be_test_master(int argc, char **argv) {
	printf("in master\n");
	fflush(stdout);
	char **nodes;
	CManager cm;
	attr_list contact_list;
	char *str_contact;
	EVdfg_stone src, last, tmp, sink;
	EVsource source_handle;
	int node_count = 5;
	int i;
	nodes = malloc(sizeof(nodes[0]) * (node_count+1));
	for (i=0; i < node_count; i++) {
		nodes[i] = malloc(5);
		sprintf(nodes[i], "N%d", i);
	}
	cm = CManager_create();
	CMlisten(cm);
	contact_list = CMget_contact_list(cm);
	str_contact = attr_list_to_string(contact_list);
	source_handle = EVcreate_submit_handle(cm, -1, Sum_format_list);
	EVdfg_register_source("master_source", source_handle);
	EVdfg_register_sink_handler(cm, "Sum_handler", Sum_format_list, (EVSimpleHandlerFunc) Sum_handler);
	test_dfg = EVdfg_create(cm);
	EVdfg_register_node_list(test_dfg, &nodes[0]);
	src = EVdfg_create_source_stone(test_dfg, "master_source");
	EVdfg_assign_node(src, nodes[0]);
	char *filter;
	filter = create_filter_action_spec(NULL, Sum_filter);
	last = src;
	for (i=1; i < node_count -1; i++) {
		tmp = EVdfg_create_stone(test_dfg, filter);
		EVdfg_link_port(last, 0, tmp);
		EVdfg_assign_node(tmp, nodes[i]);
		last = tmp;
	}
	sink = EVdfg_create_sink_stone(test_dfg, "Sum_handler");
	EVdfg_link_port(last, 0, sink);
	EVdfg_assign_node(sink, nodes[node_count-1]);
	EVdfg_realize(test_dfg);
	EVdfg_join_dfg(test_dfg, nodes[0], str_contact);
	test_fork_children(&nodes[0], str_contact);
	if (EVdfg_ready_wait(test_dfg) != 1) {
		/* dfg initialization failed! */
		exit(1);
	}
	if (EVdfg_active_sink_count(test_dfg) == 0) {
		EVdfg_ready_for_shutdown(test_dfg);
	}
	if (EVdfg_source_active(source_handle)) {
		Sum_rec rec;
		atom_t hop_count_atom;
		attr_list attrs = create_attr_list();
		hop_count_atom = attr_atom_from_string("hop_count_atom");
		add_int_attr(attrs, hop_count_atom, 1);
		generate_Sum_record(&rec);
		/* submit would be quietly ignored if source is not active */
		EVsubmit(source_handle, &rec, attrs);
	}
	status = EVdfg_wait_for_shutdown(test_dfg);
	wait_for_children(nodes);
	CManager_close(cm);
	return status;
}

extern int
be_test_child(int argc, char **argv)
{
	printf("in child\n");
	fflush(stdout);
	CManager cm;
	EVsource src;
	cm = CManager_create();
	if (argc != 3) {
		printf("Child usage:  evtest  <nodename> <mastercontact>\n");
		exit(1);
	}
	test_dfg = EVdfg_create(cm);
	src = EVcreate_submit_handle(cm, -1, Sum_format_list);
	EVdfg_register_source("master_source", src);
	EVdfg_register_sink_handler(cm, "Sum_handler", Sum_format_list, (EVSimpleHandlerFunc) Sum_handler);
	EVdfg_join_dfg(test_dfg, argv[1], argv[2]);
	EVdfg_ready_wait(test_dfg);
	if (EVdfg_active_sink_count(test_dfg) == 0) {
		EVdfg_ready_for_shutdown(test_dfg);
	}
	if (EVdfg_source_active(src)) {
		Sum_rec rec;
		generate_Sum_record(&rec);
		/* submit would be quietly ignored if source is not active */
		EVsubmit(src, &rec, NULL);
	}
	return EVdfg_wait_for_shutdown(test_dfg);
}
