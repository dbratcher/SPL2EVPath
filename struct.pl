#! /bin/perl
$filename = $ARGV[0];
open (IN_FILE, "< $filename") or die "Failed to open $filename";
sub read_structs {
    while (<IN_FILE>) {
	if (/(\w*):/) {
	    # new structure
	    $name = $1;
	    $obj_ref = {};
	    $obj_ref->{types} = {};
	} elsif (/\s*(\S+.*\W)(\w*);/) {
	    $obj_ref->{types}->{$2} = $1;
	    $obj_ref->{types}->{$2} =~ s/ //g;
	    $structs{$name} = $obj_ref;
	}
    }
}

sub dump_structs {
    foreach $name (reverse keys %structs) {
	print "structure $name ->\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    print "	$structs{$name}->{types}->{$field} $field;\n";
	}
	print "\n";
    }
}

sub gen_typedef {
    my($outfile) = @_;
    print $outfile "struct list_struct {\n";
    print $outfile "    sm_ref node;\n";
    print $outfile "    struct list_struct *next;\n";
    print $outfile "};\n\n";
    print $outfile "typedef enum {\n";
    foreach $name (reverse keys %structs) {
	print $outfile "    spl_$name,\n";
    }	
    print $outfile "    spl_last_node_type\n";
    print $outfile "} spl_node_type;\n\n";
    foreach $name (reverse keys %structs) {
	print $outfile "typedef struct {\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    print $outfile "    $structs{$name}->{types}->{$field} $field;\n";
	}
	print $outfile "} $name;\n\n";
    }
    print $outfile "typedef union {\n";
    foreach $name (reverse keys %structs) {
	print $outfile "   $name $name;\n";
    }
    print $outfile "} sm_union;\n\n";
    print $outfile "struct sm_struct {\n";
    print $outfile "    spl_node_type node_type;\n";
    print $outfile "    int visited;\n";
    print $outfile "    sm_union node;\n";
    print $outfile "};\n";
}

sub gen_create {
    my($houtfile, $coutfile) = @_;
    foreach $name (reverse keys %structs) {
	print $houtfile "extern sm_ref spl_new_$name();\n";
	print $coutfile "extern sm_ref\nspl_new_$name()\n{\n";
	print $coutfile "    sm_ref tmp = malloc(sizeof(*tmp));\n";
	print $coutfile "    memset(tmp, 0, sizeof(*tmp));\n";
	print $coutfile "    tmp->visited = 0;\n";
	print $coutfile "    tmp->node_type = spl_$name;\n";
	print $coutfile "    return tmp;\n";
	print $coutfile "}\n\n";
    }	
}

sub gen_apply {
    my($houtfile, $coutfile) = @_;
    print $houtfile "typedef void (*spl_apply_func)(sm_ref node, void *data);\n";
    print $houtfile "typedef void (*spl_apply_list_func)(sm_list list, void *data);\n";
    print $houtfile "extern void spl_apply(sm_ref node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data);\n";
    print $coutfile "static void spl_apply_list(sm_list node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data)\n";
    print $coutfile "{\n";
    print $coutfile "    sm_list orig = node;\n";
    print $coutfile "    while (node != NULL) {\n";
    print $coutfile "        spl_apply(node->node, pre_func, post_func, list_func, data);\n";
    print $coutfile "        node = node->next;\n";
    print $coutfile "    }\n";
    print $coutfile "    if (list_func) (list_func)(orig, data);\n";
    print $coutfile "}\n\n";
    print $coutfile "extern void spl_apply(sm_ref node, spl_apply_func pre_func, spl_apply_func post_func, spl_apply_list_func list_func, void *data)\n{\n";
    print $coutfile "    if (node == NULL) return;\n";
    print $coutfile "    if (node->visited) return;\n";
    print $coutfile "    node->visited++;\n";
    print $coutfile "    if(pre_func) (pre_func)(node, data);\n";
    print $coutfile "    switch(node->node_type) {\n";
    foreach $name (reverse keys %structs) {
	print $coutfile "      case spl_$name: {\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    if (($structs{$name}->{types}->{$field}  eq "sm_ref") &&
		(substr($field,0,2)  ne "sm")) {
		print $coutfile "          spl_apply(node->node.$name.$field, pre_func, post_func, list_func, data);\n";
	    } elsif ($structs{$name}->{types}->{$field}  eq "sm_list") {
		print $coutfile "          spl_apply_list(node->node.$name.$field, pre_func, post_func, list_func, data);\n";
	    }
	}
	print $coutfile "          break;\n";
	print $coutfile "      }\n";
    }
    print $coutfile "    }\n";
    print $coutfile "    node->visited--;\n";
    print $coutfile "    if(post_func) (post_func)(node, data);\n";
    print $coutfile "}\n\n"
}

sub gen_dump {
    my($houtfile, $coutfile) = @_;
    print $houtfile "extern void spl_print(sm_ref node);\n";
    print $coutfile "static void spl_print_sm_list(sm_list list)\n{\n";
    print $coutfile "    while (list != NULL) {\n";
    print $coutfile "        printf(\" %p\", list->node);\n";
    print $coutfile "        list = list->next;\n";
    print $coutfile "    }\n";
    print $coutfile "}\n\n";
    print $coutfile "extern void spl_print(sm_ref node)\n{\n";
    print $coutfile "    switch(node->node_type) {\n";
    foreach $name (reverse keys %structs) {
	print $coutfile "      case spl_$name: {\n";
	print $coutfile "          printf(\"0x%p  --  $name ->\\n\", node);\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    print $coutfile "          printf(\"\t$field : ";
	    if ($structs{$name}->{types}->{$field}  eq "sm_ref") {
		print $coutfile "%p\\n\", node->node.$name.$field);\n";
	    } elsif ($structs{$name}->{types}->{$field}  eq "char*") {
		print $coutfile "%s\\n\", (node->node.$name.$field == NULL) ? \"<NULL>\" : node->node.$name.$field);\n";
	    } elsif ($structs{$name}->{types}->{$field}  eq "void*") {
		print $coutfile "%p\\n\", node->node.$name.$field);\n";
	    } elsif ($structs{$name}->{types}->{$field}  eq "int") {
		print $coutfile "%d\\n\", node->node.$name.$field);\n";
	    } else {
		print $coutfile "\");\n";
		print $coutfile "          spl_print_$structs{$name}->{types}->{$field}(node->node.$name.$field);\n";
		print $coutfile "          printf(\"\\n\");\n";
	   }
	}
	print $coutfile "          break;\n";
	print $coutfile "      }\n";
    }
    print $coutfile "    }\n";
    print $coutfile "    printf(\"\\n\");\n";
    print $coutfile "}\n\n"
}

sub gen_free {
    my($houtfile, $coutfile) = @_;
    print $houtfile "extern void spl_free(sm_ref node);\n";
    print $houtfile "extern void spl_free_list(sm_list list, void *junk);\n";
    print $coutfile "extern void spl_free_list(sm_list list, void *junk)\n{\n";
    print $coutfile "    while (list != NULL) {\n";
    print $coutfile "        sm_list next = list->next;\n";
    print $coutfile "        free(list);\n";
    print $coutfile "        list = next;\n";
    print $coutfile "    }\n";
    print $coutfile "}\n\n";
    print $coutfile "extern void spl_free(sm_ref node)\n{\n";
    print $coutfile "    switch(node->node_type) {\n";
    foreach $name (reverse keys %structs) {
	print $coutfile "      case spl_$name: {\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    if ($structs{$name}->{types}->{$field}  eq "char*") {
		print $coutfile "	    free(node->node.$name.$field);\n";
	   }
	    if ($structs{$name}->{types}->{$field}  eq "enc_info") {
		print $coutfile "	    free_enc_info(node->node.$name.$field);\n";
	   }
	}
	print $coutfile "          break;\n";
	print $coutfile "      }\n";
    }
    print $coutfile "    }\n";
    print $coutfile "    free(node);\n";
    print $coutfile "}\n\n";
    print $coutfile "static sm_list free_list = NULL;\n";
    print $coutfile "extern void spl_make_free(sm_ref node, void *junk)\n{\n";
    print $coutfile "    sm_list new_free = malloc(sizeof(*new_free));\n";
    print $coutfile "    new_free->next = free_list;\n";
    print $coutfile "    new_free->node = node;\n";
    print $coutfile "    free_list = new_free;\n";
    print $coutfile "    switch(node->node_type) {\n";
    foreach $name (reverse keys %structs) {
	print $coutfile "      case spl_$name: {\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    if ($structs{$name}->{types}->{$field}  eq "sm_list") {
		print $coutfile "          node->node.$name.$field = NULL;\n";
	    }
	}
	print $coutfile "          break;\n";
	print $coutfile "      }\n";
    }
    print $coutfile "    }\n";
    print $coutfile "}\n\n";
    print $houtfile "extern void spl_rfree(sm_ref node);\n";
    print $houtfile "extern void spl_rfree_list(sm_list list, void *junk);\n";
    print $coutfile "extern void spl_rfree(sm_ref node) {\n";
    print $coutfile "    free_list = NULL;\n";
    print $coutfile "    spl_apply(node, NULL, spl_make_free, spl_free_list, NULL);\n";
    print $coutfile "    while(free_list != NULL) {\n";
    print $coutfile "        sm_list next = free_list->next;\n";
    print $coutfile "        spl_free(free_list->node);\n";
    print $coutfile "        free(free_list);\n";
    print $coutfile "        free_list = next;\n";
    print $coutfile "    }\n";
    print $coutfile "}\n";
    print $coutfile "extern void spl_rfree_list(sm_list list, void *junk) {\n";
    print $coutfile "    free_list = NULL;\n";
    print $coutfile "    spl_apply_list(list, NULL, spl_make_free, spl_free_list, junk);\n";
    print $coutfile "    while(free_list != NULL) {\n";
    print $coutfile "        sm_list next = free_list->next;\n";
    print $coutfile "        spl_free(free_list->node);\n";
    print $coutfile "        free(free_list);\n";
    print $coutfile "        free_list = next;\n";
    print $coutfile "    }\n";
    print $coutfile "}\n";
}

sub gen_copy {
    my($houtfile, $coutfile) = @_;
    print $houtfile "extern sm_ref spl_copy(sm_ref node);\n";
    print $houtfile "extern sm_list spl_copy_list(sm_list list);\n";
    print $coutfile "extern sm_list spl_copy_list(sm_list list)\n{\n";
    print $coutfile "    sm_list new_list = NULL;\n";
    print $coutfile "    if (list != NULL) {\n";
    print $coutfile "        new_list = malloc(sizeof(*new_list));\n";
    print $coutfile "        new_list->node = spl_copy(list->node);\n";
    print $coutfile "        new_list->next = spl_copy_list(list->next);\n";
    print $coutfile "    }\n";
    print $coutfile "    return new_list;\n";
    print $coutfile "}\n\n";
    print $coutfile "extern sm_ref spl_copy(sm_ref node)\n{\n";
    print $coutfile "    sm_ref new_node = NULL;\n";
    print $coutfile "    if (node == NULL) return NULL;\n\n";
    print $coutfile "    switch(node->node_type) {\n";
    foreach $name (reverse keys %structs) {
	print $coutfile "      case spl_$name: {\n";
	print $coutfile "	    new_node = spl_new_$name();\n";
	print $coutfile "	    new_node->node.$name = node->node.$name;\n";
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    if ($structs{$name}->{types}->{$field}  eq "char*") {
		print $coutfile "	    new_node->node.$name.$field = strdup(node->node.$name.$field);\n";
	    } elsif ($structs{$name}->{types}->{$field}  eq "sm_list") {
		print $coutfile "	    new_node->node.$name.$field = spl_copy_list(node->node.$name.$field);\n";
	    } elsif (($structs{$name}->{types}->{$field}  eq "sm_ref") &&
		(substr($field,0,2)  ne "sm")) {
		print $coutfile "	    new_node->node.$name.$field = spl_copy(node->node.$name.$field);\n";
	    }
	}
	print $coutfile "          break;\n";
	print $coutfile "      }\n";
    }
    print $coutfile "    }\n";
    print $coutfile "    return new_node;\n";
    print $coutfile "}\n\n";
}

sub gen_srcpos {
    my($houtfile, $coutfile) = @_;
    print $houtfile "extern srcpos spl_get_srcpos(sm_ref expr);\n";
    print $coutfile "extern srcpos spl_get_srcpos(expr)\nsm_ref expr;\n{\n";
    print $coutfile "    switch(expr->node_type) {\n";
    foreach $name (reverse keys %structs) {
	foreach $field (reverse keys %{$structs{$name}->{types}}) {
	    if ($structs{$name}->{types}->{$field}  eq "srcpos") {
		print $coutfile "      case spl_$name: return expr->node.$name.$field;\n";
	    }
	}
    }
    print $coutfile "      default: {\n";
    print $coutfile "          srcpos tmp;\n";
    print $coutfile "          tmp.line = 0;\n";
    print $coutfile "          tmp.character = 0;\n";
    print $coutfile "          return tmp;\n";
    print $coutfile "       };\n";
    print $coutfile "    };\n";
    print $coutfile "}\n";
}

read_structs();
#dump_structs();
open(HOUTFILE, ">structs.h");
print HOUTFILE "#ifndef __STRUCTS_H\n";
print HOUTFILE "#define __STRUCTS_H\n";
gen_typedef(HOUTFILE);
print HOUTFILE "#endif\n";
open(COUTFILE, ">spl_node.c");
print COUTFILE "#include \"config.h\"\n";
print COUTFILE "#include \<stdio.h\>\n";
print COUTFILE "#include \"spl.h\"\n";
print COUTFILE "#include \"spl_internal.h\"\n";
print COUTFILE "#include \"structs.h\"\n";
print COUTFILE "#ifdef HAVE_MALLOC_H\n";
print COUTFILE "#include <malloc.h>\n";
print COUTFILE "#endif\n";
print COUTFILE "#ifdef HAVE_STDLIB_H\n";
print COUTFILE "#include <stdlib.h>\n";
print COUTFILE "#endif\n";
print COUTFILE "#include \<string.h\>\n";
print COUTFILE "#ifndef NULL\n";
print COUTFILE "#define NULL 0\n";
print COUTFILE "#endif\n";
gen_create(HOUTFILE, COUTFILE);
gen_apply (HOUTFILE, COUTFILE);
gen_dump  (HOUTFILE, COUTFILE);
gen_free  (HOUTFILE, COUTFILE);
gen_copy  (HOUTFILE, COUTFILE);
gen_srcpos(HOUTFILE, COUTFILE);
print "Done\n";
