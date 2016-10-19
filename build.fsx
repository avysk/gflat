// See license in the end of this file
#r "packages/FAKE/tools/FakeLib.dll"
#r "packages/FSharpLint.Fake/tools/FSharpLint.Core.dll"
#r "packages/FSharpLint.Fake/tools/FSharpLint.Fake.dll"

open Fake
open Fake.Testing

open FSharpLint.Fake

let buildDir = "build/"
let testDir = "test/"

let buildRefs =
  !! "/src/lib/**/*.fsproj"
  ++ "/src/app/**/*.fsproj"

let testRefs =
  !! "/src/test/**/*.fsproj"

let allRefs =
  !! "src/**/*.fsproj"

Target "Clean" (fun _ ->
  CleanDirs [buildDir; testDir]
)

Target "Lint" (fun _ ->
  allRefs |> Seq.iter (FSharpLint (fun options ->
                                   {options with FailBuildIfAnyWarnings=true}))
)

Target "BuildApp" (fun _ ->
  MSBuildDebug buildDir "Build" buildRefs
  |> Log "Build output: "
)
"Clean" ==> "Lint" ==> "BuildApp"

Target "ReleaseApp" (fun _ ->
  MSBuildRelease buildDir "Build" buildRefs
  |> Log "Release build output: "
)
"Clean" ==> "Lint" ==> "ReleaseApp"

Target "BuildTest" (fun _ ->
  MSBuildDebug testDir "Build" testRefs
  |> Log "Test build output: "
)
"BuildApp" ==> "BuildTest"

Target "Test" (fun _ ->
  !! (testDir + "*.Test.dll")
  |> NUnit3 (fun p  ->
    {p with ToolPath = "packages/NUnit.ConsoleRunner/tools/nunit3-console.exe"})
)
"BuildTest" ==> "Test"


RunTargetOrDefault "BuildApp"

// vim: sw=2:sts=2:ai:foldmethod=indent:colorcolumn=80

// License is for this file only!
//
// Copyright (c) 2016, Alexey Vyskubov alexey@ocaml.nl All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
