All: mainProg gcd pow modulo CPubExp CPrivExp Encrypt Decrypt
LIB=RsaLib.o
CC=gcc

mainProg: mainProg.o $(LIB) 
	$(CC) $@.o $(LIB) -g -o $@

gcd: gcd.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

pow: pow.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

modulo: modulo.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

CPubExp: CPubExp.o $(LIB) 
	$(CC) $@.o $(LIB) -g -o $@

CPrivExp: CPrivExp.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

Encrypt: Encrypt.o $(LIB) 
	$(CC) $@.o $(LIB) -g -o $@

Decrypt:Decrypt.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

