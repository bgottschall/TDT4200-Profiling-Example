SOURCE_DIR := src
BUILD_DIR  := build
BINARY := $(BUILD_DIR)/example
OPTIMIZATION := 0

CXX := g++
FLAGS :=
CXXFLAGS := -Wall -Wextra -Wpedantic -std=c++11 -O$(OPTIMIZATION) $(FLAGS)

CHECK_FLAGS := $(BUILD_DIR)/.flags_$(shell echo '$(CXXFLAGS) $(DEFINES)' | md5sum | awk '{print $$1}')

SOURCE_PATHS := $(shell find $(SOURCEDIR) -type f -name '*.cpp')
INCLUDE_DIRS := $(shell find $(SOURCEDIR) -type f -name '*.hpp' -exec dirname {} \; | uniq)
OBJECTS     := $(SOURCE_PATHS:%.cpp=%.o)

INCLUDES := $(addprefix -I,$(INCLUDE_DIRS))

.PHONY: all call clean

help:
	@echo "TDT4200 Profiling Example"
	@echo ""
	@echo "Targets:"
	@echo "	all 		Builds $(BINARY)"
	@echo "	call		executes $(BINARY)"
	@echo "	clean		cleans up everything"
	@echo ""
	@echo "Render Targets:"
	@echo "\t$(OUTPUTS)" | sed 's/ /\n\t/g'
	@echo ""
	@echo "Options:"
	@echo "	FLAGS=$(FLAGS)"
	@echo "	OPTIMIZATION=$(OPTIMIZATION)"
	@echo " ARGUMENTS=$(ARGUMENTS)"
	@echo "	PROFILE=$(PROFILE)"
	@echo ""
	@echo "Compiler Call:"
	@echo "	$(CXX) $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c dummy.cpp -o dummy.o"
	@echo "Binary Call:"
	@echo "	$(PROFILE) $(BINARY) $(ARGUMENTS)"

all:
	@$(MAKE) --no-print-directory $(BINARY)

clean:
	rm -f $(BUILD_DIR)/.flags_*
	rm -f $(BINARY)
	rm -f $(OBJECTS)

call: $(BINARY)
	$(PROFILE) $(BINARY) $(ARGUMENTS)

$(OBJECTS) : %.o : %.cpp $(CHECK_FLAGS)
	$(CXX) $(CXXFLAGS) $(DEFINES) $(INCLUDES) -c $< -o $@

$(CHECK_FLAGS):
	@$(MAKE) --no-print-directory clean
	@mkdir -p $(dir $@)
	@touch $@

$(BINARY): $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(OBJECTS) $(LINKING) -o $@

