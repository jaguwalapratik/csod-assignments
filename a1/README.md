## Pre-requisite

- Install [WinDbg tool](https://developer.microsoft.com/windows/downloads/windows-10-sdk)
- Install [WintellectPowerShell](https://github.com/Wintellect/WintellectPowerShell) Module

### To generate memory dump of the process have used ProcDump tool

### Using WintellectPowerShell module

Under the hood WintellectPowerShell module uses cdb.exe. It is command line utility of WinDbg

```
PS> Get-ChildItem -Path <Path to dump file> -Filter *.dmp -Recurse | Get-DumpAnalysis -DebuggingScript .BasicAnalysis.txt
```

### Standalone command execution

Configure enviroment variable to the path of WinDbg installation bin directory.

```
PS> cbd -z "dump_file.dmp" -c "!threads;!runaway;q" > log.log 
```

#### Steps

- Generate dump of any process using ProcDump
- Run scraper.ps1 by passing dump file name as an argument
- Script will generate human readable log file which our script parse to find long running threads by text scraping and pattern matching.

![alt Long Running Thread](https://github.com/jaguwalapratik/csod-assignments/blob/master/a1/long-running-thread.png)

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

Reference: 

- https://www.wintellect.com/automating-analyzing-tons-of-minidump-files-with-windbg-and-powershell/
- https://www.leeholmes.com/blog/2009/01/21/scripting-windbg-with-powershell/
- https://github.com/microsoft/DbgShell
