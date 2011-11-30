CC = g++
LIBS = -I/usr/local/include -L/usr/local/lib/mysql
LINKER = -lmysqlclient
NAME = quest_mysql

$(NAME): help.o query.o general.o config.o main.o
	$(CC) $(LIBS) $(LINKER) -o $(NAME) src/help.o src/query.o src/general.o src/config.o main.o
	make clean
	
main.o: main.cpp
	$(CC) $(LIBS) -c main.cpp
	
config.o: src/config.cpp
	$(CC) $(LIBS) -c -o src/config.o src/config.cpp
	
general.o: src/general.cpp
	$(CC) $(LIBS) -c -o src/general.o src/general.cpp
	
query.o: src/query.cpp
	$(CC) $(LIBS) -c -o src/query.o src/query.cpp
	
help.o: src/help.cpp
	$(CC) $(LIBS) -c -o src/help.o src/help.cpp 

.PHONY: clean
clean:
	rm main.o
	rm src/config.o
	rm src/general.o
	rm src/query.o
	rm src/help.o
