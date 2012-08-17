/*
 * sm_ref is a pointer to an internal SPL data structure representing a
 * semantic element of a program fragment (E.G. a parameter definition).
 */
typedef struct sm_struct *sm_ref;

typedef struct list_struct *sm_list;

typedef struct parse_struct *spl_parse_context;

typedef struct {
    int line;
    int character;
} srcpos;

typedef struct {
    srcpos lx_srcpos;
    char *string;
} lx_info;

/*!
 *  err_out_func_t is a function pointer type.   Functions matching this
 *  profile can be used as call-out handlers for SPL errors.
 *  \param client_data an uninspected value passed in from 
 *    spl_set_error_func()
 *  \param string the textual representation of the error.
*/
typedef void (*err_out_func_t) (void *client_data, char *string);


