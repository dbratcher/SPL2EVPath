#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "evpath.h"
#include "ev_dfg.h"
#include "test_support.h"

int status;
static EVdfg test_dfg;

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

void generate_RawData_record(RawData_rec_ptr event)
{
	event->a = 0;
	event->b = 0;
	event->c = 0;
	event->d = 0;
	event->e = 0;
}

static char* RawData_to_Sum_transform = "{\n\
    output.hops = 0;\n\
    output.sum = input.a + input.b + input.c + input.d + input.e;\n\
    return 1;\n\
}";


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

void generate_Sum_record(Sum_rec_ptr event)
{
	event->hops = 0;
	event->sum = 0;
}

static char* Sum_to_Hop_transform = "{\n\
    output.hops = input.hops + 1;\n\
    output.sum = input.sum;\n\
    return 1;\n\
}";


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

void generate_Hop_record(Hop_rec_ptr event)
{
	event->hops = 0;
	event->sum = 0;
}

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
	Hop_rec_ptr event = vevent;
	printf("SinkOp got a struct with the following :\n");
	printf("hops:%d\n",event->hops);
	printf("sum:%d\n",event->sum);
	printf("printing to file SumSink.csv:\n");
	FILE* fp=fopen("SumSink.csv","a");
	fprintf(fp, "%d,%d\n",event->hops,event->sum);
	fclose(fp);
}
void generate_SinkOp_record(SinkOp_rec_ptr event)
{
}



extern int be_test_master(int argc, char **argv) {
   printf("in master\n");
	fflush(stdout);
   /*in graph management structures*/
   CManager cm;
   attr_list contact_list;
   char *str_contact;
   char *transform;
   EVdfg_stone src, dst;
    char **nodes;
    int node_count = 4;
    int i=0;
    nodes = malloc(sizeof(nodes[0]) * (node_count+1));
    /* RawData Stream */
    nodes[i] = strdup("RawData");
    i++;
    EVsource RawData_source_handle;
    /* Sum Stream */
    nodes[i] = strdup("Sum");
    i++;
    /* Hop Stream */
    nodes[i] = strdup("Hop");
    i++;
    /* SinkOp Stream */
    nodes[i] = strdup("SinkOp");
    i++;
    printf("initializing\n");
    fflush(stdout);
    /* management initialization */
    cm = CManager_create();
    CMlisten(cm);
    contact_list = CMget_contact_list(cm);
    str_contact = attr_list_to_string(contact_list);
    printf("-setting up graph\n");
    fflush(stdout);
    /* setup graph */
    test_dfg = EVdfg_create(cm);
    EVdfg_register_node_list(test_dfg, &nodes[0]);
    RawData_source_handle = EVcreate_submit_handle(cm, -1, RawData_format_list);
    EVdfg_register_source("RawData", RawData_source_handle);
    src = EVdfg_create_source_stone(test_dfg, "RawData");
    EVdfg_assign_node(src, nodes[0]);
    transform = create_transform_action_spec(RawData_format_list, Sum_format_list, RawData_to_Sum_transform);
    dst = EVdfg_create_stone(test_dfg, transform);
    EVdfg_link_port(src, 0, dst);
    EVdfg_assign_node(dst, nodes[1]);
    src=dst;
    transform = create_transform_action_spec(Sum_format_list, Hop_format_list, Sum_to_Hop_transform);
    dst = EVdfg_create_stone(test_dfg, transform);
    EVdfg_link_port(src, 0, dst);
    EVdfg_assign_node(dst, nodes[2]);
    src=dst;
    EVdfg_register_sink_handler(cm, "SinkOp_handler", Hop_format_list, (EVSimpleHandlerFunc) SinkOp_handler);
    dst = EVdfg_create_sink_stone(test_dfg, "SinkOp_handler");
    EVdfg_link_port(src, 0, dst);
    EVdfg_assign_node(dst, nodes[3]);   
    EVdfg_realize(test_dfg);
    EVdfg_join_dfg(test_dfg, nodes[0], str_contact);
    test_fork_children(&nodes[0], str_contact);
    if (EVdfg_ready_wait(test_dfg) != 1) {
        /* dfg initialization failed! */
        exit(1);
    }
   if (EVdfg_source_active(RawData_source_handle)) {
       RawData_rec rec;
       attr_list attrs = create_attr_list();
       FILE* file = fopen("SourceData.csv","r");
       if(file) {
           while(!feof(file)) { 
               fscanf(file, "%d,%d,%d,%d,%d",&rec.a,&rec.b,&rec.c,&rec.d,&rec.e);
               EVsubmit(RawData_source_handle, &rec, attrs);
           }
           fclose(file);
        } else {  
           generate_RawData_record(&rec);
           EVsubmit(RawData_source_handle, &rec, attrs);
       }
   }
   if (EVdfg_active_sink_count(test_dfg) == 0) {
       EVdfg_ready_for_shutdown(test_dfg);
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
   src = EVcreate_submit_handle(cm, -1, RawData_format_list);
   EVsource RawData_source_handle;
    RawData_source_handle = EVcreate_submit_handle(cm, -1, RawData_format_list);
    EVdfg_register_source("RawData", RawData_source_handle);
   EVdfg_register_source("RawData", src);
   EVdfg_register_sink_handler(cm, "SinkOp_handler", Hop_format_list, (EVSimpleHandlerFunc) SinkOp_handler);
   EVdfg_join_dfg(test_dfg, argv[1], argv[2]);
   EVdfg_ready_wait(test_dfg);
   if (EVdfg_active_sink_count(test_dfg) == 0) {
       EVdfg_ready_for_shutdown(test_dfg);
   }
   if (EVdfg_source_active(RawData_source_handle)) {
       RawData_rec rec;
       attr_list attrs = create_attr_list();
       FILE* file = fopen("SourceData.csv","r");
       if(file) {
           while(!feof(file)) { 
               fscanf(file, "%d,%d,%d,%d,%d",&rec.a,&rec.b,&rec.c,&rec.d,&rec.e);
               EVsubmit(RawData_source_handle, &rec, attrs);
           }
           fclose(file);
        } else {  
           generate_RawData_record(&rec);
           EVsubmit(RawData_source_handle, &rec, attrs);
       }
   }
   return EVdfg_wait_for_shutdown(test_dfg);
}
