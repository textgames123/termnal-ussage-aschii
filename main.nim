import std/strutils
import std/terminal
import std/os
import math

proc getUssage(): int =
    var memUssageFile: File
    const path = "/proc/meminfo"
    if not fileExists(path):
        echo "The file dosen't exist."
        quit()

    let data = readFile(path)

    let memorySpects = splitLines(data)

    var 
        totalMemory: int
        freeMemory:  int
    
    for spec in memorySpects:
        var separatedSpec = splitWhiteSpace(spec)
        if separatedSpec.contains("MemTotal:"):
            totalMemory = parseInt(separatedSpec[1])
        if separatedSpec.contains("MemFree:"):
            freeMemory = parseInt(separatedSpec[1])
    
    let usedMemory = totalMemory - freeMemory

    let ussage = int(round((usedMemory/totalMemory) * 100))

    return ussage



var terminalAschii = ".........."
when isMainModule:
    while true:
        let ussagePrecent = getUssage()
        let barPrecent = int(ussagePrecent / 10);
        for i in 0 .. 9:
            if i < barPrecent:
                terminalAschii[i] = '#'
            else:
                terminalAschii[i] = '.'

        echo "Memory Ussage: ", "[", terminalAschii, "]", " ", ussagePrecent, "%"
        cursorUp(stdout)
        sleep(1000)