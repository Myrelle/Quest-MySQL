CC      = g++
LDFLAGS = -I/usr/local/include -L/usr/local/lib/mysql -lmysqlclient
OBJ = src/help.o src/query.o src/general.o src/config.o main.o

quest_mysql: $(OBJ)
	$(CC) -o quest_mysql $(OBJ) $(LDFLAGS)
	make clean

%.o: %.c
	$(CC) -c $<

.PHONY: clean
clean:
	rm $(OBJ)
