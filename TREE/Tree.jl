x, y, namen = data_reading()

#node, SSₑ = node_finder(x, y)
#plot(SSₑ)
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.33, random_state=42)
data_size = 2300
RF_list = [RandomForestRegressor(n_estimators=i, min_samples_leaf=1, max_features=data_size) for i in 10:10:200]


Threads.nthreads()
Threads.@threads for RF in RF_list
    println(RF)
    RF.fit(x_train, y_train)
end

function wrapper(RF)
    println(RF)
    RF.fit(x_train, y_train)
end

wrapper(RF_list)


 Please submit a bug report with steps to reproduce this fault, and any error messages that follow (in their entirety). Thanks.
 Exception: EXCEPTION_ACCESS_VIOLATION at 0x7fff5ad84b8f --  at 0x7fff5ad84b8f -- ION with steps to reproduce this fault, and any error messages that follow (in their entirety). Thanks.
 Exception: EXCEPTION_ACCESS_VIOLATION with steps to reproduce this fault, and any error messages that follow (in their entirety). Thanks.      
 Exception: EXCEPTION_ACCESS_VIOLATION at 0x7fff5ae8bc76 --  at 0x7fff5ae8bc76 -- ION at 0x7fff5ae8bc76 -- PyTuple_New at C:\Users\etien\.julia\conda\3\python39.dll (unknown line)
 in expression starting at REPL[19]:1
 in expression starting at REPL[19]:1
 onda\3\python39.dll (unknown line)
 in expression starting at REPL[19]:1
 in expression starting at REPL[19]:1
 onda\3\python39.dll (unknown line)
 PyTuple_New at C:\Users\etien\.julia\conda\3\python39.dll (unknown line)
 macro expansion at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\exception.jl:95 [inlined]
 _pycall! at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:21
 _pycall! at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:21
 .jl:95 [inlined]
 _pycall! at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:21
 _pycall! at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:21
 unknown function (ip: 00000000666b0c55)
 _pycall! at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:11
 unknown function (ip: 00000000666b0c55)
 PyCall\7a7w0\src\pyfncall.jl:86
 unknown function (ip: 00000000666b0c55)
 #_#114 at C:\Users\etien\.julia\packages\PyCall\7a7w0\src\pyfncall.jl:86
 jl_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\julia.h:1788 [inlined]
 jl_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\julia.h:1788 [ijl_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\julia.h:1788 [inlined]
 do_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\builtins.c:do_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\builtins.c:71in expression starting at REPL[19]:1
 ed]
 kage_win64/build/src\builtins.c:713
 in expression starting at REPL[19]:1
 PyObject at C:\Users\etien\.julia\packages#30#threadsfor_fun at .\threadingconstructs.jl:ll\7a7w0\src\pyfncall.jl:86
 PyObject_GC_Del at C:\Users\etien\.julia\conda\3\pmacro expansion at .\REPL[19]:3 [inlined]
 #30#threadsfor_fun at .\threadingconstructs.jl:85
 thon39.dll (unknown line)
 Allocations: 91757410 (Pool: 91707573; Big: 49837)unknown function (ip: 00000000666b01f3)
 g: 49837)#30#threadsfor_fun at .\threadingconstructs.jl:52
  GC: 61
 #30#threadsfor_fun at .\threadingconstru#30#threadsfor_fun at .\threadingconstructs.jl:52
 unknown function (ip: 00000000666b01f3)
 jl_apply at /cygdrive/c/buildbot/worker/package_win64/build/src\julia.h:1788 [inlined]
 start_task at /cygdrive/c/buildbot/worker/package_win64/build/src\task.c:877
 Allocations: 91757410 (Pool: 91707573; Big: 49837); GC: 61
 d/src\task.c:877
 inlined]
 start_task at /cygdrive/c/buildbot/worker/package_win64/build/src\task.c:877
 Allocations: 91757410 (Pool: 91707573; Big: 49837); GC: 61