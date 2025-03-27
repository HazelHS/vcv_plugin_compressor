# Rack plugin Makefile

# Remove any spaces from the RACK_DIR path
RACK_DIR_ESCAPED = $(RACK_DIR)

FLAGS += -I$(RACK_DIR_ESCAPED)/include -I$(RACK_DIR_ESCAPED)/dep/include

include $(RACK_DIR_ESCAPED)/arch.mk

SOURCES := $(wildcard src/*.cpp)

# Must include the VCV Rack plugin Makefile for the rules
include $(RACK_DIR_ESCAPED)/plugin.mk 