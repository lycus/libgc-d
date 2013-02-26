module gc;

import core.stdc.config;

struct GC_stack_base
{
    version (IA64)
        void* reg_base;

    void* mem_base;
}

enum GC_TIME_UNLIMITED = 999999;
enum GC_PROTECTS_NONE = 0;
enum GC_PROTECTS_POINTER_HEAP = 1;
enum GC_PROTECTS_PTRFREE_HEAP = 2;
enum GC_PROTECTS_STATIC_DATA = 4;
enum GC_PROTECTS_STACK = 8;
enum GC_SUCCESS = 0;
enum GC_DUPLICATE = 1;
enum GC_NO_THREADS = 2;
enum GC_UNIMPLEMENTED = 3;

extern (C) nothrow
{
    alias void function() gc_finalizer_callback_fun;
    alias int function() gc_stop_func_fun;
    alias void function(void*, void*) gc_finalization_proc_fun;
    alias void function(char*, size_t) gc_warn_proc_fun;
    alias void* function(void*) gc_fn_type_fun;
    alias void* function(GC_stack_base*, void*) gc_stack_base_func_fun;

    extern __gshared
    {
        size_t GC_gc_no;
        int GC_parallel;
        int GC_find_leak;
        int GC_all_interior_pointers;
        int GC_finalize_on_demand;
        int GC_java_finalization;
        gc_finalizer_callback_fun GC_finalizer_notifier;
        int GC_dont_gc;
        int GC_dont_expand;
        int GC_use_entire_heap;
        int GC_full_freq;
        size_t GC_non_gc_bytes;
        int GC_no_dls;
        size_t GC_free_space_divisor;
        size_t GC_max_retries;
        char* GC_stackbottom;
        int GC_dont_precollect;
        c_ulong GC_time_limit;
    }

    void GC_init();

    void* GC_malloc(size_t size_in_bytes);

    void* GC_malloc_atomic(size_t size_in_bytes);

    char* GC_strdup(const(char)* str);

    void* GC_malloc_uncollectable(size_t size_in_bytes);

    void* GC_malloc_stubborn(size_t size_in_bytes);

    void* gc_malloc_atomic_uncollectable(size_t size_in_bytes);

    void GC_free(void* object_addr);

    void GC_change_stubborn(void* object_addr);

    void GC_end_stubborn_change(void* object_addr);

    void* GC_base(void* displaced_pointer);

    size_t GC_size(void* object_addr);

    void* GC_realloc(void* old_object,
                     size_t new_size_in_bytes);

    int GC_expand_hp(size_t number_of_bytes);

    void GC_set_max_heap_size(size_t n);

    void GC_exclude_static_roots(void* low_address,
                                 void* high_address_plus_1);

    void GC_clear_roots();

    void GC_add_roots(void* low_address,
                      void* high_address_plus_1);

    void GC_remove_roots(void* low_address,
                         void* high_address_plus_1);

    void GC_register_displacement(size_t n);

    void GC_gcollect();

    int GC_try_to_collect(gc_stop_func_fun stop_func);

    size_t GC_get_heap_size();

    size_t GC_get_free_bytes();

    size_t GC_get_bytes_since_gc();

    size_t GC_get_total_bytes();

    void GC_disable();

    void GC_enable();

    void GC_enable_incremental();

    int GC_incremental_protection_needs();

    int GC_collect_a_little();

    void* GC_malloc_ignore_off_page(size_t lb);

    void* GC_malloc_atomic_ignore_off_page(size_t lb);

    void GC_register_finalizer(void* obj,
                               gc_finalization_proc_fun fn,
                               void* cd,
                               gc_finalization_proc_fun* ofn,
                               void** ocd);

    void GC_register_finalizer_ignore_self(void* obj,
                                           gc_finalization_proc_fun fn,
                                           void* cd,
                                           gc_finalization_proc_fun* ofn,
                                           void** ocd);

    void GC_register_finalizer_no_order(void* obj,
                                        gc_finalization_proc_fun fn,
                                        void* cd,
                                        gc_finalization_proc_fun* ofn,
                                        void** ocd);

    void GC_register_finalizer_unreachable(void* obj,
                                           gc_finalization_proc_fun fn,
                                           void* cd,
                                           gc_finalization_proc_fun* ofn,
                                           void** ocd);

    int GC_register_disappearing_link(void** link);

    int GC_general_register_disappearing_link(void** link,
                                              void* obj);

    int GC_unregister_disappearing_link(void** link);

    int GC_should_invoke_finalizers();

    int GC_invoke_finalizers();

    gc_warn_proc_fun GC_set_warn_proc(gc_warn_proc_fun p);

    size_t GC_set_free_space_divisor(size_t value);

    void* GC_call_with_alloc_lock(gc_fn_type_fun fn,
                                  void* client_data);

    void* GC_call_with_stack_base(gc_stack_base_func_fun fn,
                                  void* arg);

    int GC_register_my_thread(GC_stack_base* sb);

    int GC_unregister_my_thread();

    int GC_get_stack_base(GC_stack_base* sb);

    void GC_dump();

    size_t GC_make_descriptor(size_t*, size_t len);

    void* GC_malloc_explicitly_typed(size_t size_in_bytes,
                                     size_t d);

    void* GC_malloc_explicitly_typed_ignore_off_page(size_t size_in_bytes,
                                                     size_t d);

    void* GC_calloc_explicitly_typed(size_t nelements,
                                     size_t element_size_in_bytes,
                                     size_t d);
}

void* hidePointer(void* ptr)
{
    return cast(void*)~cast(size_t)ptr;
}

void* revealPointer(void* ptr)
{
    return hidePointer(ptr);
}

private __gshared void* dummy;

void reachableHere(void* ptr)
{
    dummy = ptr;
}
