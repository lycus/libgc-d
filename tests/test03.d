import gc;

void main()
{
    version (FreeBSD)
    {
    }
    else
    {
        GC_enable_incremental();

        for (auto i = 0; i < 1024; i++)
        {
            auto mem = GC_malloc(size_t.sizeof * 4);
            GC_gcollect();
        }
    }
}
