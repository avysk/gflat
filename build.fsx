#r "packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.Testing

let buildDir = "build/"
let testDir = "test/"

let buildRefs =
  !! "/src/lib/**/*.fsproj"
  ++ "/src/app/**/*.fsproj"

let testRefs =
  !! "/src/test/**/*.fsproj"

Target "Clean" (fun _ ->
  CleanDirs [buildDir; testDir]
)

Target "BuildApp" (fun _ ->
  MSBuildDebug buildDir "Build" buildRefs
  |> Log "Build output: "
)
"Clean" ==> "BuildApp"

Target "ReleaseApp" (fun _ ->
  MSBuildRelease buildDir "Build" buildRefs
  |> Log "Release build output: "
)
"Clean" ==> "ReleaseApp"

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
