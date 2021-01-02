# [WinDbg Tool](https://developer.microsoft.com/windows/downloads/windows-10-sdk)

- Install WinDbg tool from above link
- Install WintellectPowerShell

### To generated memory dump of the process

- ProcDump tool
- Can generate dump using task manager

### Using WintellectPowerShell module

```
PS> Get-ChildItem -Path <Path to dump file> -Filter *.dmp -Recurse | Get-DumpAnalysis -DebuggingScript .BasicAnalysis.txt
```

### Standalone command execution

Configure enviroment variable to the path of WinDbg installation bin directory.

```
PS> cbd -z "dump_file.dmp" -c "!threads;!runaway;q" > log.log 
```

##### Listing all threads and how long they have been running

!runaway

**Note:** The values displayed by !runaway are accumulated values over the whole lifetime of the program. This just tells you that the thread has worked a lot in the past. It doesn't tell you what it is doing now or will be doing in the future.

##### Listing Managed Threads

!threads

##### Determine which Web Application a thread is running in

!dumpdomain [address]

##### Get a summary information on the Threadpool

!threadpool

##### Get the stack trace of a single thread including passed parameters

~[thread id]e !clrstack –p

##### Get detailed information on an object

!dumpobj [address]

Refrence: 

- https://www.wintellect.com/automating-analyzing-tons-of-minidump-files-with-windbg-and-powershell/
- https://www.leeholmes.com/blog/2009/01/21/scripting-windbg-with-powershell/
- https://github.com/microsoft/DbgShell