# Find By Id Tag

This extension allows you to use r:find with an 'id' attribute instead of the usual 'path' attribute. This way the r:find tag will stay intact even if the path of the target page changes.
An 'ids' attribute was also added to r:aggregate to use instead of 'paths'.

Important benefit is that this is also much faster than finding a page by path;

    >> Benchmark.measure { Page.find(2546) }
    =>   0.000000   0.000000   0.000000 (  0.003986)

    >> Benchmark.measure { Page.find_by_path('/farm-forestry-model/species/eucalypts/growing-eucalypts-for-timber---videos-and-information/videos/') }
    =>   0.020000   0.010000   0.030000 (  0.027044)


Created by Benny Degezelle for nzffa.org.nz 