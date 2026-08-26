# ---- Phat hien he dieu hanh ----
ifeq ($(OS),Windows_NT)
    TARGET  = program.exe
    RM      = del /Q
    FIXPATH = $(subst /,\,$1)
    NULLDEV = 2>nul
else
    TARGET  = program
    RM      = rm -f
    FIXPATH = $1
    NULLDEV = 2>/dev/null
endif

# ---- Cau hinh ----
CC     = gcc
CFLAGS = -Wall -Wextra -std=c17 -g -Iinclude
SRC    = $(wildcard *.c) $(wildcard src/*.c)
OBJ    = $(SRC:.c=.o)

# ---- Luat build ----
all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	-$(RM) $(call FIXPATH,$(OBJ)) $(TARGET) $(NULLDEV)

show:
	@echo SRC = $(SRC)
	@echo TARGET = $(TARGET)