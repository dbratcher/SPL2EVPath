#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "evpath.h"
#include "ev_dfg.h"
#include "test_support.h"

int status;
static EVdfg test_dfg;

typedef struct _source1_rec {
	int a;
	int b;
} source1_rec, *source1_rec_ptr;

static FMField source1_field_list [] = {
	{"a", "integer", 4, FMOffset(source1_rec_ptr, a)},
	{"b", "integer", 4, FMOffset(source1_rec_ptr, b)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec source1_format_list [] = {
	{"source1", source1_field_list, sizeof(source1_rec), NULL},
	{NULL, NULL}
};

void generate_source1_record(source1_rec_ptr event)
{
	event->a = 0;
	event->b = 0;
}

static char* source1_to_aSplit1_transform = "{\n\
    output.a = input.a;\n\
    return 1;\n\
}";


typedef struct _aSplit1_rec {
	int a;
} aSplit1_rec, *aSplit1_rec_ptr;

static FMField aSplit1_field_list [] = {
	{"a", "integer", 4, FMOffset(aSplit1_rec_ptr, a)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec aSplit1_format_list [] = {
	{"aSplit1", aSplit1_field_list, sizeof(aSplit1_rec), NULL},
	{NULL, NULL}
};

void generate_aSplit1_record(aSplit1_rec_ptr event)
{
	event->a = 0;
}

static char* source1_to_aSplit2_transform = "{\n\
    output.b = input.b;\n\
    return 1;\n\
}";


typedef struct _aSplit2_rec {
	int b;
} aSplit2_rec, *aSplit2_rec_ptr;

static FMField aSplit2_field_list [] = {
	{"b", "integer", 4, FMOffset(aSplit2_rec_ptr, b)},
	{NULL, NULL, 0, 0}
};

static FMStructDescRec aSplit2_format_list [] = {
	{"aSplit2", aSplit2_field_list, sizeof(aSplit2_rec), NULL},
	{NULL, NULL}
};

void generate_aSplit2_record(aSplit2_rec_ptr event)
{
	event->b = 0;
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
	aSplit1_rec_ptr event = vevent;
	printf("SinkOp got a struct with the following :\n");
	printf("a:%d\n",event->a);
	printf("printing to file Split1.csv:\n");
	FILE* fp=fopen("Split1.csv","a");
	fprintf(fp, "%d\n",event->a);
	fclose(fp);
}
void generate_SinkOp_record(SinkOp_rec_ptr event)
{
}

typedef struct _SinkOp2_rec {
} SinkOp2_rec, *SinkOp2_rec_ptr;

static FMField SinkOp2_field_list [] = {
	{NULL, NULL, 0, 0}
};

static FMStructDescRec SinkOp2_format_list [] = {
	{"SinkOp2", SinkOp2_field_list, sizeof(SinkOp2_rec), NULL},
	{NULL, NULL}
};

static int SinkOp2_handler(CManager cm, void *vevent, void *client_data, attr_list attrs) {
	aSplit2_rec_ptr event = vevent;
	printf("SinkOp2 got a struct with the following :\n");
	printf("b:%d\n",event->b);
	printf("printing to file Split2.csv:\n");
	FILE* fp=fopen("Split2.csv","a");
	fprintf(fp, "%d\n",event->b);
	fclose(fp);
}
void generate_SinkOp2_record(SinkOp2_rec_ptr event)
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
    int node_count = 5;
    int i=0;
    nodes = malloc(sizeof(nodes[0]) * (node_count+1));
    /* source1 Stream */
    nodes[i] = strdup("source1");
    EVdfg_stone source1_stone;
    i++;
    EVsource source1_source_handle;
    /* aSplit1 Stream */
    nodes[i] = strdup("aSplit1");
    EVdfg_stone aSplit1_stone;
    i++;
    /* aSplit2 Stream */
    nodes[i] = strdup("aSplit2");
    EVdfg_stone aSplit2_stone;
    i++;
    /* SinkOp Stream */
    nodes[i] = strdup("SinkOp");
    EVdfg_stone SinkOp_stone;
    i++;
    /* SinkOp2 Stream */
    nodes[i] = strdup("SinkOp2");
    EVdfg_stone SinkOp2_stone;
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
    source1_source_handle = EVcreate_submit_handle(cm, -1, source1_format_list);
    EVdfg_register_source("source1", source1_source_handle);
    source1_stone = EVdfg_create_source_stone(test_dfg, "source1");
    EVdfg_assign_node(source1_stone, nodes[0]);
    transform = create_transform_action_spec(source1_format_list, aSplit1_format_list, source1_to_aSplit1_transform);
    aSplit1_stone = EVdfg_create_stone(test_dfg, transform);
    EVdfg_link_port(source1_stone, 0, aSplit1_stone);
    EVdfg_assign_node(aSplit1_stone, nodes[1]);
    transform = create_transform_action_spec(source1_format_list, aSplit2_format_list, source1_to_aSplit2_transform);
    aSplit2_stone = EVdfg_create_stone(test_dfg, transform);
    EVdfg_link_port(source1_stone, 1, aSplit2_stone);
    EVdfg_assign_node(aSplit2_stone, nodes[2]);
    EVdfg_register_sink_handler(cm, "SinkOp_handler", aSplit1_format_list, (EVSimpleHandlerFunc) SinkOp_handler);
    SinkOp_stone = EVdfg_create_sink_stone(test_dfg, "SinkOp_handler");
    EVdfg_link_port(aSplit1_stone, 0, SinkOp_stone);
    EVdfg_assign_node(SinkOp_stone, nodes[3]);
    EVdfg_register_sink_handler(cm, "SinkOp2_handler", aSplit2_format_list, (EVSimpleHandlerFunc) SinkOp2_handler);
    SinkOp2_stone = EVdfg_create_sink_stone(test_dfg, "SinkOp2_handler");
    EVdfg_link_port(aSplit2_stone, 0, SinkOp2_stone);
    EVdfg_assign_node(SinkOp2_stone, nodes[4]);
    EVdfg_realize(test_dfg);
    EVdfg_join_dfg(test_dfg, nodes[0], str_contact);
    test_fork_children(&nodes[0], str_contact);
    if (EVdfg_ready_wait(test_dfg) != 1) {
        /* dfg initialization failed! */
        exit(1);
    }
   if (EVdfg_source_active(source1_source_handle)) {
       source1_rec rec;
       attr_list attrs = create_attr_list();
       FILE* file = fopen("SourceData.csv","r");
       if(file) {
           while(!feof(file)) { 
               fscanf(file, "%d,%d",&rec.a,&rec.b);
               EVsubmit(source1_source_handle, &rec, attrs);
           }
           fclose(file);
        } else {  
           generate_source1_record(&rec);
           EVsubmit(source1_source_handle, &rec, attrs);
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
   src = EVcreate_submit_handle(cm, -1, source1_format_list);
   EVsource source1_source_handle;
    source1_source_handle = EVcreate_submit_handle(cm, -1, source1_format_list);
    EVdfg_register_source("source1", source1_source_handle);
   EVdfg_register_source("source1", src);
   EVdfg_register_sink_handler(cm, "SinkOp_handler", aSplit1_format_list, (EVSimpleHandlerFunc) SinkOp_handler);
   EVdfg_register_sink_handler(cm, "SinkOp2_handler", aSplit2_format_list, (EVSimpleHandlerFunc) SinkOp2_handler);
   EVdfg_join_dfg(test_dfg, argv[1], argv[2]);
   EVdfg_ready_wait(test_dfg);
   if (EVdfg_active_sink_count(test_dfg) == 0) {
       EVdfg_ready_for_shutdown(test_dfg);
   }
   if (EVdfg_source_active(source1_source_handle)) {
       source1_rec rec;
       attr_list attrs = create_attr_list();
       FILE* file = fopen("SourceData.csv","r");
       if(file) {
           while(!feof(file)) { 
               fscanf(file, "%d,%d",&rec.a,&rec.b);
               EVsubmit(source1_source_handle, &rec, attrs);
           }
           fclose(file);
        } else {  
           generate_source1_record(&rec);
           EVsubmit(source1_source_handle, &rec, attrs);
       }
   }
   return EVdfg_wait_for_shutdown(test_dfg);
}
