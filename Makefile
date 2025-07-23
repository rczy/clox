TARGET_EXEC := clox

BUILD_DIR := ./build
SRC_DIR := ./src

SRCS := $(shell find $(SRC_DIR) -name '*.c')
OBJS := $(SRCS:%.c=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CPPFLAGS := -MMD -MP
CFLAGS := -ggdb3

EXEC_PATH := $(BUILD_DIR)/$(TARGET_EXEC)

$(EXEC_PATH): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: run
run: $(EXEC_PATH)
	@./$<

.PHONY: check
check: $(EXEC_PATH)
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose $<

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

-include $(DEPS)
