print ("------------------------None-------------------------")
A = None
print (type(A))
print ("------------------------None-------------------------")

#bool
print ("------------------------bool-------------------------")
B = True
C = False
print (5>6)
print ("------------------------bool-------------------------")
#crear condiciones
print ("------------------------if elif else-------------------------")
D = 151
if D == 150:
    print("Nice, you are tall enough for this ride")
elif D>150:
    print("Nice, you are good to go on this ride")
else:
    print("Sorry kid, you are not tall enough for this ride")
print ("------------------------if elif else-------------------------")

print ("------------------------while-------------------------")
#crear un Loop
E = 1
while (E<15):
    print(E)
    E = E+1
print ("------------------------while-------------------------")
print ("------------------------for (List)-------------------------")
#crear un loop desde una lista
F = [2, 5, 6, 13, 2, 5, 7, 4]
Total = 0
for element in F:
    Total = Total + element
print (Total)
print (type(F))
print ("------------------------for (List)-------------------------")
print ("------------------------continue break & pass-------------------------")
#continuar y detener cierta parte del coding
G = -1 
while G<15:
    if G<0:
        pass
    print(G)
    G = G+1
print ("------------------------continue break & pass-------------------------")
#Bool (Verdadero y Falso) para variables dentro de un objeto
print ("------------------------in & not in-------------------------")
H = ('Orange')
I = [2, "Orange", 3]

print (H in I)
print (H not in I)
print ("------------------------in & not in-------------------------")
#Bool para igualdades
print ("------------------------is & is not-------------------------")
J = 1
K = 2
print (J is K)
print (J is not K)
print ("------------------------is & is not-------------------------")
#condiciones y "not" es el inverso del Bool
print ("------------------------and or & not-------------------------")
L = 5>4 and 5<10
print(L)
M = 5>9 or 5<10
print(M)
N = False
print(not N)
print ("------------------------and or & not-------------------------")
#Importar el modulo, importar una parte del modulo y "as" le da un nombre diferente para hacerle mencion
print ("------------------------import from & as-------------------------")
import datetime
from datetime import time
import datetime as O
print(O)
print ("------------------------import from & as-------------------------")
#Class es para crear objetos y esta keyword es para definirlos
print ("------------------------Class-------------------------")
class Pclass:
    P = 1
print ("------------------------Class-------------------------")
#def sirve para crear funciones y return hace print para luego terminar la funcion
print ("------------------------def & return-------------------------")
def greet(name):
    print ("Hello," + name +", Good morning")
    return 4+4
print ("------------------------def & return-------------------------")
#del sirve para borrar el valor de una variable
print ("------------------------del-------------------------")
Q = 1
del(Q)
print("NameError: name 'Q' is not defined")
print ("------------------------del-------------------------")
#Crear una funcion con solo 1 uso
print ("------------------------lambda-------------------------")
R = lambda S: S + 10
print (R(8))
print ("------------------------lambda-------------------------")
#Escoger el tipo de error o excepcion para los loop/ciclos
print ("------------------------raise-------------------------")
T = 1
if T < 0:
    raise TypeError ("Sorry, no numbers below 0")
print ("------------------------raise-------------------------")
#try prueba un bloque de codigo buscando error, except ayuda a manejarlo y finally ejecuta cualquier resultado
print ("------------------------try except & finally-------------------------")
try:
    K > -5
    print (K)
except:
    print("Whoops, something went wrong")
finally:
    ("The try/except is finished")

print ("------------------------try except & finally-------------------------")
print ("------------------------global, nonlocal, asyn & await son avanzadas-------------------------")
print ("------------------------global, nonlocal, asyn & await son avanzadas-------------------------")