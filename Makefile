#
# Les variables d'environnement libG3X, incG3X
# sont definies dans le fichier ~/.bashrc par le script ../install.sh
#
#compilateur
CC = g++

#compil en mode 'debug' ou optmis�e (-O2)
DBG = no

ifeq ($(DBG),yes) #en mode debug
  CFLAGS = -g -Wpointer-arith -Wall -ansi
else               #en mode normal
  CFLAGS = -O2 -ansi
endif

export LD_LIBRARY_PATH=$G3XPP_PATH:$LD_LIBRARY_PATH

# assemblage des infos de lib. et inc.
lib = $(libG3X) -L./lib/libg3x++ -lg3x++
# fichiers *.c locaux
src = src/
Inc = include/
# fichiers *.h locaux et lib.
inc = -I./include $(incG3X) -I./lib/libg3x++/include

exec = main

all : $(exec)

main: main.o PMat.o Particle.o FixedPoint.o Link.o HookSpring.o GlobalAction.o Damper.o Wind.o Camera.o Facet.o

Link.o: $(src)Link.cpp $(Inc)Link.h PMat.o

HookSpring.o: $(src)HookSpring.cpp $(Inc)HookSpring.h Link.o

GlobalAction.o: $(src)GlobalAction.cpp $(Inc)GlobalAction.h Link.o

Damper.o: $(src)Damper.cpp $(Inc)Damper.h Link.o

PMat.o: $(src)PMat.cpp $(Inc)PMat.h

Particle.o: $(src)Particle.cpp $(Inc)Particle.h PMat.o

FixedPoint.o: $(src)FixedPoint.cpp $(Inc)FixedPoint.h PMat.o

Wind.o: $(src)Wind.cpp $(Inc)Wind.h GlobalAction.o

Camera.o: $(src)Camera.cpp $(Inc)Camera.h 

Facet.o: $(src)Facet.cpp $(Inc)Facet.h PMat.o

main.o: $(src)main.cpp

# r�gle g�n�rique de cr�ation de xxx.o � partir de src/xxx.c
%.o : $(src)%.cpp
	@echo "module $@"
	@$(CC) $(CFLAGS) $(inc) -c $< -o $@
	@echo "------------------------"

# r�gle g�n�rique de cr�ation de l'executable xxx � partir de src/xxx.c (1 seul module)
% : %.o
	@echo "assemblage [$^]->$@"
	@$(CC) $^ $(lib) -o $@
	@echo "------------------------"
	
.PHONY : clean cleanall ?

# informations sur les param�tres de compilation       
? :
	@echo "---------compilation informations----------"
	@echo "  processor      : $(PROCBIT)"
	@echo "  compiler       : $(CC)"
	@echo "  options        : $(CFLAGS)"
	@echo "  lib g3x/OpenGl : $(libG3X)$(COMP)"
	@echo "  headers        : $(incG3X)"
clean : 
	@rm -f *.o
cleanall :
	@rm -f *.o $(exec)
	
