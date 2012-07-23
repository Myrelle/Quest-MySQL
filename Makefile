CC      = g++ -O2 -pipe
INCL 	= -I/usr/local/include
LIBS	= -L/usr/local/lib/mysql
LINKER	= -lmysqlclient
OBJ = src/help.o src/query.o src/general.o src/config.o main.o

quest_mysql: $(OBJ)
	$(CC) -o quest_mysql $(OBJ) $(INCL) $(LIBS) $(LINKER)
	make clean

src/help.o: src/help.cpp
	$(CC) $(INCL) -c -o src/help.o src/help.cpp

src/query.o: src/query.cpp
	$(CC) $(INCL) -c -o src/query.o src/query.cpp

src/general.o: src/general.cpp
	$(CC) $(INCL) -c -o src/general.o src/general.cpp

src/config.o: src/config.cpp
	$(CC) $(INCL) -c -o src/config.o src/config.cpp

main.o: main.cpp
	$(CC) $(INCL) -c -o main.o main.cpp

.PHONY: clean
clean:
	rm $(OBJ)
