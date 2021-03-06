# GFlat

## What is it

GFlat is a very easy to use scaffolding solution for simple Mono / F# projects. It uses
[Paket](https://github.com/fsprojects/Paket),
[FAKE](https://fsharp.github.io/FAKE/) and
[Forge](https://github.com/fsharp-editing/Forge). These tools, while powerful,
may be not straightforward to use; GFlat is not powerful but allows you to start
with F# project in a very straightforward manner.

## Assumptions

You are using `mono`, have working `make`, `w3m` and ready to download half of the
Internet.

## How to use

Grab the release; unarchive it. GFlat will create the project consisting of the
following parts: library, main application and tests for the library. You may
want to edit `Makefile` and specify the name for the main application (`APP`, by
default it is `Program`) and for the library (`LIB`, by default it is `Lib`).
The test project will be named automatically, by appending `.Test` to the
library name.

After you have specified desired names, run `make populate` and let it run till
the end. That's it.

## What will you get?

Three projects:
* the library is `src/lib`
* the main application in `src/app`
* the test project in `src/test`, set up for usage of `FsUnit`.

Both the main application and the test project have the library set as a
reference, so you can start using it right away.

Four targets for `make`:
* `make build` compiles the library and main application; you'll find the
  resulting `.exe` file in `build/` directory.
* `make run` does the same as above plus the compiled application will be run
  when it is ready.
* `make test` compiles the library, the tests, and runs the tests with
  [NUnit3](http://nunit.org/) console runner.
* `make release` builds the release (i.e. non-debug) version of the application. 

Notice that the source code will be checked by
[FSharpLint](http://fsprojects.github.io/FSharpLint/) and the build will fail in
case of any warnings.

## Example of usage

1. `make populate` (...runs for ages, downloads half of the internet; in the process you 
will see some ignored errors from Forge...)
        
        Done.
        Ignored errors are safe to ignore.

        Application source code is in src/app/Program/Program.fs
        Library source code is in src/lib/Lib/Lib.fs
        Tests source code is in src/test/Lib.Test/Lib.Test.fs
        Try 'make test' now.
        Happy hacking!

2. `tree src`

        src
        ├── app
        │   └── Program
        │       ├── App.config
        │       ├── Program.fs
        │       ├── Program.fsproj
        │       └── paket.references
        ├── lib
        │   └── Lib
        │       ├── Lib.fs
        │       ├── Lib.fsproj
        │       └── paket.references
        └── test
            └── Lib.Test
                ├── Lib.Test.fs
                ├── Lib.Test.fsproj
                └── paket.references

        6 directories, 10 files

3. `make build && ls build/` (...some noise...)

        FSharp.Core.dll    Lib.dll.mdb        Program.exe.config
        Lib.dll            Program.exe        Program.exe.mdb

4. `make run` (should calculate 3 squared) (...some noise...)

        9

5. `make test` (...some noise...)

        1) Failed : Lib.Test.Example Test
          Expected: 3
          But was:  4

...more noise...

## Disclaimer

I did this only to simplify the things for myself when playing with F#. Tested
only on Mac. If it works for you and you find it useful -- great! If not,
report the problem and I may have a look. Or send a patch.

## License

Summary: BSD 2-clause

Copyright (c) 2016, Alexey Vyskubov <alexey@ocaml.nl>
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
