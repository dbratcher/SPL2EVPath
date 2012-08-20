 /**
  *    FILE: simple_join.c
  *    AUTHOR: Drew Bratcher
  *
  *
  *
  *     GOAL:     src_a -----
  *                     |
  *           src_b -------------> join ---- > end (sink)
  *
  *
  *     src_a struct: field 1
  *     src_b struct: field 2
  *     end struct: field 1
  *                 field 2
  *
**/
    



#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "config.h"
#include "evpath.h"
#include "ev_dfg.h"
#include "test_support.h"

static int status;
static EVdfg test_dfg;

static int end_handler(CManager cm, void *vevent, void *client_data, attr_list attrs)
{
    end_rec_ptr event = vevent;
    printf("recieved field 1: %d\n",event->field1);
    printf("recieved field 2: %d\n",event->field2);
    EVdfg_shutdown(test_dfg, 0);
    return 0;
}

static FMField src_a_field_list[] =
{
    {"field1", "integer",
     sizeof(int), FMOffset(src_a_rec_ptr, field1)},
    {NULL, NULL, 0, 0}
};

static FMField src_b_field_list[] =
{
    {"field2", "integer",
     sizeof(int), FMOffset(src_b_rec_ptr, field2)},
    {NULL, NULL, 0, 0}
};

static FMStructDescRec join_format_list[] =
{
    {"src_a", src_a_field_list, sizeof(src_a_rec_ptr), NULL},
    {"src_b", src_b_field_list, sizeof(src_b_rec_ptr), NULL},
    {NULL, NULL}
};

const char * join_handler = "{int ret = input.long_field % 2;return ret;}\0\0";

extern int be_test_master(int argc, char **argv)
{
    char *nodes[] = {"src_a", "src_b", "join", "end", NULL};
    CManager cm;
    char *str_contact;
    EVdfg_stone src_a, src_b, join, end;
    EVsource src_a_handle;
    EVsource src_b_handle;
    char *join_action_spec;

    cm = CManager_create();
    CMlisten(cm);

    // setup sources and sinks
    src_a_handle = EVcreate_submit_handle(cm, -1, src_a_format_list);
    src_b_handle = EVcreate_submit_handle(cm, -1, src_b_format_list);
    EVdfg_register_source("src_a", src_a_handle);
    EVdfg_register_source("src_b", src_b_handle);
    EVdfg_register_sink_handler(cm, "end_handler", end_format_list, (EVSimpleHandlerFunc) end_handler);

    //create dfg
    test_dfg = EVdfg_create(cm);
    str_contact = EVdfg_get_contact_list(test_dfg);

    //create stones
    src_a = EVdfg_create_source_stone(test_dfg, "src_a");
    src_b = EVdfg_create_source_stone(test_dfg, "src_b");
    join_action_spec = create_filter_action_spec(join_format_list, join_handler);
    join = EVdfg_create_stone(test_dfg, join_action_spec);
    end = EVdfg_create_sink_stone(test_dfg, "end_handler");
    
    //create links
    EVdfg_link_port(src_a, 0, join);
    EVdfg_link_port(src_b, 0, join);
    EVdfg_link_port(join, 0, end);
    EVdfg_register_node_list(test_dfg, &nodes[0]);
    EVdfg_assign_node(src_a, "src_a");
    EVdfg_assign_node(src_b, "src_b");
    EVdfg_assign_node(join, "join");
    EVdfg_assign_node(join, "end");
	
    //build graph
    EVdfg_realize(test_dfg);

    //declare nodes and fork
    EVdfg_join_dfg(test_dfg, nodes[0], str_contact);
    test_fork_children(&nodes[0], str_contact);
    if (EVdfg_ready_wait(test_dfg) != 1) {
        printf("Initialization Failed!");
	exit(1);
    }

    if (EVdfg_active_sink_count(test_dfg) == 0) {
	EVdfg_ready_for_shutdown(test_dfg);
    }

    if (EVdfg_source_active(source_handle)) {
	int count = repeat_count;
	while (count != 0) {
	    simple_rec rec;
	    generate_simple_record(&rec);
	    EVsubmit(source_handle, &rec, NULL);
	    if ((rec.long_field%2 == 1) && (count != -1)) {
		count--;
	    }
	}
    }
    status = EVdfg_wait_for_shutdown(test_dfg);

    wait_for_children(nodes);

    CManager_close(cm);
    return status;
}


extern int
be_test_child(int argc, char **argv)
{
    CManager cm;
    EVsource src;
    int i;

    cm = CManager_create();
    if (argc != 3) {
	printf("Child usage:  evtest  <nodename> <mastercontact>\n");
	exit(1);
    }
    test_dfg = EVdfg_create(cm);

    src = EVcreate_submit_handle(cm, -1, simple_format_list);
    EVdfg_register_source("master_source", src);
    EVdfg_register_sink_handler(cm, "simple_handler", simple_format_list,
				(EVSimpleHandlerFunc) simple_handler);
    EVdfg_join_dfg(test_dfg, argv[1], argv[2]);
    EVdfg_ready_wait(test_dfg);
    if (EVdfg_active_sink_count(test_dfg) == 0) {
	EVdfg_ready_for_shutdown(test_dfg);
    }

    if (EVdfg_source_active(src)) {
	for (i=0; i < 20 ; i++) {
	    simple_rec rec;
	    generate_simple_record(&rec);
	    EVsubmit(src, &rec, NULL);
	}
    }
    return EVdfg_wait_for_shutdown(test_dfg);
}
