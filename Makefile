# License is in the end of the file
#
# Feel free to change the application name and library name
# Also feel free to change VIMMODELINE
#
APP = Program
LIB = Lib
VIMMODELINE = '// vim: sw=2:sts=2:ai:foldmethod=indent:colorcolumn=80'
#
# DO NOT TOUCH ANYTHING BELOW

MONO = mono
FAKE = $(MONO) packages/FAKE/tools/FAKE.exe
FORGE = sh .forge/forge.sh
FORGE_URL = 'https://github.com/fsharp-editing/Forge/releases/download/1.0.1/forge.zip'
PAKET = $(MONO) .paket/paket.exe
PAKET_BOOTSTRAPPER = 'https://github.com/fsprojects/Paket/releases/download/3.23.2/paket.bootstrapper.exe'
TEST = $(LIB).Test

default: test

# Normal development targets below

# Build the application
build: code_ok
	@$(FAKE)

# Build the application and run it
run: build
	@$(MONO) build/$(APP).exe

# Build the tests and run them
test: code_ok
	@$(FAKE) Test

# Build release version of the application
release: code_ok
	@$(FAKE) ReleaseApp

# Remove everything created by compilation and testing
# Normally you do not want it, fake will clean build directories
clean:
	@rm -rf build/
	@rm -rf src/app/$(APP)/bin
	@rm -rf src/app/$(APP)/obj
	@rm -rf src/lib/$(LIB)/bin
	@rm -rf src/lib/$(LIB)/obj
	@rm -rf src/test/$(TEST)/bin
	@rm -rf src/test/$(TEST)/obj
	@rm -rf test/
	@rm -rf TestResult.xml

# You want to run 'populate' target ONLY ONCE

populate: APPFS = src/app/$(APP)/$(APP).fs
populate: LIBFS = src/lib/$(LIB)/$(LIB).fs
populate: TESTFS = src/test/$(TEST)/$(TEST).fs
populate: no_src create_app create_lib create_test
	@rm -rf src/lib/$(LIB)/*.fsx
	@echo 'module Program' > $(APPFS)
	@echo >> $(APPFS)
	@echo '[<EntryPoint>]' >> $(APPFS)
	@echo 'let main argv =' >> $(APPFS)
	@echo '  printfn "%d" ($(LIB).Foo.f 3)' >> $(APPFS)
	@echo '  0' >> $(APPFS)
	@echo >> $(APPFS)
	@echo $(VIMMODELINE) >> $(APPFS)
	@echo 'namespace $(LIB)' > $(LIBFS)
	@echo >> $(LIBFS)
	@echo 'module Foo =' >> $(LIBFS)
	@echo '  let f x = x * x' >> $(LIBFS)
	@echo >> $(LIBFS)
	@echo $(VIMMODELINE) >> $(LIBFS)
	@echo 'module $(TEST)' > $(TESTFS)
	@echo >> $(TESTFS)
	@echo 'open NUnit.Framework' >> $(TESTFS)
	@echo 'open FsUnit' >> $(TESTFS)
	@echo >> $(TESTFS)
	@echo '[<Test>]' >> $(TESTFS)
	@echo 'let ``Example Test`` () =' >> $(TESTFS)
	@echo '  2 |> $(LIB).Foo.f |> should equal 3' >> $(TESTFS)
	@echo >> $(TESTFS)
	@echo $(VIMMODELINE) >> $(TESTFS)
	@echo
	@echo "Done."
	@echo "Ignored errors are safe to ignore."
	@echo
	@echo "Application source code is in src/app/$(APP)/$(APP).fs"
	@echo "Library source code is in src/lib/$(LIB)/$(LIB).fs"
	@echo "Tests source code is in src/test/$(TEST)/$(TEST).fs"
	@echo "Try 'make test' now."
	@echo "Happy hacking!"

# This target will remove everything created earlier
scorched_earth: clean
	@rm -rf .forge .paket src paket.lock .fake packages

# Below are service targets you never want to run manually

init: init_forge init_paket

init_forge:
	@if [ ! -e .forge ] ; then \
                mkdir -p .forge && \
                pushd .forge && \
                wget $(FORGE_URL) && \
                unzip -q forge.zip && \
                rm forge.zip && \
                popd ; \
        fi

init_paket: .paket/paket.exe

.paket/paket.exe: .paket/paket.bootstrapper.exe
	$(MONO) $<

.paket/paket.bootstrapper.exe:
	@mkdir -p .paket
	@if [ ! -e $@ ] ; then \
                pushd .paket && \
                wget $(PAKET_BOOTSTRAPPER) && \
                popd ; \
        fi

create: create_app create_lib create_test

create_app: init create_lib
	# Forge kinda fails, but really works
	@-echo 'Y' | $(FORGE) new project -n $(APP) --folder src/app -t console --no-fake
	@-echo 'Y' | $(FORGE) add project -n src/lib/$(LIB)/$(LIB).fsproj -p src/app/$(APP)/$(APP).fsproj

no_src:
	@if [ -e src ] ; then \
            echo "if you insist on shooting in your own foot, run \
'make scorched_earth' first. It will destroy EVERYTHING." ; exit 1; fi

create_lib: init
	# Forge kinda fails, but really works
	@-echo 'Y' | $(FORGE) new project -n $(LIB) --folder src/lib -t classlib --no-fake

create_test: init create_lib
	# Forge kinda fails, but really works
	@-echo 'Y' | $(FORGE) new project -n $(TEST) --folder src/test -t fsunit --no-fake
	@-echo 'Y' | $(FORGE) add project -n src/lib/$(LIB)/$(LIB).fsproj -p src/test/$(TEST)/$(TEST).fsproj

paket.lock: init_paket paket.dependencies
	@$(PAKET) install

paket_restore: paket.lock
	@$(PAKET) restore

code_ok:
	@if [ ! -e src ] ; then echo "No code found, you may want to run 'make populate'!" ; exit 1 ; fi

build_test: code_ok
	@$(FAKE) BuildTest


.PHONY: build clean code_ok create create_app create_lib create_test init
.PHONY: init_forge init_paket no_src paket_restore release
.PHONY: run scorched_earth test

# License is for this file only!
#
# Copyright (c) 2016, Alexey Vyskubov alexey@ocaml.nl All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
