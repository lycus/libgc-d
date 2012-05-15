import gc;

void main()
{
    GC_init();

    for (auto i = 0; i < 1024; i++)
    {
        auto mem = GC_malloc(size_t.sizeof * 4);
        GC_free(mem);
    }
}
