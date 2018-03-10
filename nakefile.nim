import nake
import os
import ospaths
import strutils

proc exe*(path: string): string = path.addFileExt(ExeExt)

task "build-nim", "":
  discard execShellCmd "nim c -d:release -d:emscripten -o:dist/fib-nim-wasm.js src/native/fibonacci.nim"
  discard execShellCmd "nim c -d:release src/native/fibonacci.nim"
  moveFile "src/native/fibonacci".exe, "dist/fib-nim".exe

task "clone-pages", "":
  for path in walkFiles("./src/web/*"):
    let (dir, name, ext) = path.splitFile()
    copyFile path, "dist/" & name & ext

task "build", "":
  runTask "build-nim"
  runTask "clone-pages"

task "server", "":
  discard execShellCmd "nim c -r -d:release local_server.nim"