CC      = g++
INCL 	= -I/usr/local/include
LIBS	= -L/usr/local/lib/mysql
LINKER	= -lmysqlclient
OBJ = src/help.o src/query.o src/general.o src/config.o main.o

quest_mysql: $(OBJ)
	$(CC) -o quest_mysql $(OBJ) $(INCL) $(LIBS) $(LINKER)
	make clean

%.o: %.cpp
	$(CC) $(INCL) -c -o $@ $<

.PHONY: clean
clean:
	rm $(OBJ)
