import re
import sys

# Dicionario de registros MIPS, su función es buscar en esta llave el nombre del registro y devolver su valor binario

registros = {
    '$zero': '00000', '$at': '00001', '$v0': '00010', '$v1': '00011',
    '$a0': '00100', '$a1': '00101', '$a2': '00110', '$a3': '00111',
    '$t0': '01000', '$t1': '01001', '$t2': '01010', '$t3': '01011',
    '$t4': '01100', '$t5': '01101', '$t6': '01110', '$t7': '01111',
    '$s0': '10000', '$s1': '10001', '$s2': '10010', '$s3': '10011',
    '$s4': '10100', '$s5': '10101', '$s6': '10110', '$s7': '10111',
    '$t8': '11000', '$t9': '11001', '$k0': '11010', '$k1': '11011',
    '$gp': '11100', '$sp': '11101', '$fp': '11110', '$ra': '11111'
}

#Dicionario de opcodes, contiene todas las instrucciones (R, I y J)

opcodes = {
    #Tipo R:
    'add': '000000', 'sub': '000000', 'and': '000000', 'or': '000000',
    'slt': '000000', 'sll': '000000', 'srl': '000000', 'jr': '000000',
    #Tipo I:    
    'addi': '001000', 'andi': '001100', 'ori': '001101', 'slti': '001010',
    'lw': '100011', 'sw': '101011', 'beq': '000100', 'bne': '000101',
    #Tipo J:
    'j': '000010', 'jal': '000011' 
}

#Dicionario de funct, es le que le dice a la ALU que operación realizar, solo se utiliza para instrucciones tipo R.
funct = {
    'add': '100000', 'sub': '100010', 'and': '100100', 'or': '100101',
    'slt': '101010', 'sll': '000000', 'srl': '000010', 'jr': '001000',
    'nop': '000000'  # El nop a nivel maquina se traduce como puros ceros
}

#Leer el archivo de texto con las instrucciones MIPS

etiquetas = {} #Diccionario para almacenar las etiquetas y sus direcciones
instrucciones = [] #Lista para almacenar las instrucciones en binario
pc = 0 #Contador de programa, se utiliza para asignar direcciones a las etiquetas

#Leer el archivo
with open('instrucciones.txt', 'r') as file:
    lineas = file.readlines() #Esto nos devuelve una lista con cada linea del archivo como un elemento de la lista

#El ciclo for para limpiar y guardar

for linea in lineas:
    linea_limpia = linea.split('#')[0] #Esto nos devuelve la parte de la linea que esta antes del gato
    linea_limpia = linea_limpia.strip() #Esto elimina los espacios en blanco al inicio y al final de la linea
    if not linea_limpia: 
        continue

    #Buscar etiquetas, las etiquetas terminan con dos puntos ":"
    if linea_limpia.endswith(':'):
        etiqueta = linea_limpia[:-1] #Esto nos devuelve la parte de la linea sin el ultimo caracter, que es el ":"
        etiquetas[etiqueta] = pc #Asignamos la dirección actual del contador de programa a la etiqueta
    else:
        instrucciones.append(linea_limpia) #Si no es una etiqueta, la instrucción se guarda en la lista de instrucciones
        pc += 1 #Incrementamos el contador de programa 




#Transformar las instrucciones a binario:


codigo_maquina = []

for i, instruccion in enumerate(instrucciones):
    # Cambiamos comas y parentesis por espacios
    inst_limpia = instruccion.replace(',', ' ').replace('(', ' ').replace(')', ' ')
    # 2. Ahora separamos por espacios y lo guaradamos en una lista
    partes = inst_limpia.split() 
    # 3. El primer elemento es la operación 
    operacion = partes[0] 

    if operacion in ['add', 'sub', 'and', 'or', 'slt']:
        # Instrucciones tipo R: add $d, $s, $t
        rd = registros[partes[1]] 
        rs = registros[partes[2]] 
        rt = registros[partes[3]] 
        shamt = '00000' 
        opcode = opcodes[operacion] 
        funct_code = funct[operacion] 
        binario = opcode + rs + rt + rd + shamt + funct_code

    elif operacion in ['sll', 'srl']:
        # Instrucciones tipo R: sll $d, $t, shamt
        rd = registros[partes[1]] 
        rt = registros[partes[2]] 
        shamt = format(int(partes[3]), '05b') 
        rs = '00000' 
        opcode = opcodes[operacion] 
        funct_code = funct[operacion] 
        binario = opcode + rs + rt + rd + shamt + funct_code

    elif operacion == 'jr':
        # Instrucción tipo R: jr $s
        rs = registros[partes[1]] 
        rt = '00000' 
        rd = '00000' 
        shamt = '00000' 
        opcode = opcodes[operacion] 
        funct_code = funct[operacion] 
        binario = opcode + rs + rt + rd + shamt + funct_code

    elif operacion in ['addi', 'andi', 'ori', 'slti']:
        # Instrucciones tipo I: addi $t, $s, imm
        rt = registros[partes[1]] 
        rs = registros[partes[2]] 
        imm = format(int(partes[3]) & 0xFFFF, '016b')
        opcode = opcodes[operacion] 
        binario = opcode + rs + rt + imm

    elif operacion in ['lw', 'sw']:
        # Instrucciones tipo I: lw $t, offset($s)
        rt = registros[partes[1]] 
        rs = registros[partes[3]] 
        imm = format(int(partes[2]) & 0xFFFF, '016b') 
        opcode = opcodes[operacion] 
        binario = opcode + rs + rt + imm

    elif operacion == 'nop':
        binario = '00000000000000000000000000000000'

    elif operacion in ['beq', 'bne']:
        # Instrucciones tipo I: beq $s, $t, label
        rs = registros[partes[1]] 
        rt = registros[partes[2]] 
        etiqueta = partes[3] 
        if etiqueta in etiquetas:
            direccion_etiqueta = etiquetas[etiqueta] 
            offset = direccion_etiqueta - (i + 1) 
            imm = format(offset & 0xFFFF, '016b') 
            opcode = opcodes[operacion] 
            binario = opcode + rs + rt + imm
        else:
            print(f"Error: Etiqueta '{etiqueta}' no encontrada.")
            sys.exit(1)

    elif operacion in ['j', 'jal']:
        # Instrucciones tipo J: j label
        etiqueta = partes[1] 
        if etiqueta in etiquetas:
            direccion_etiqueta = etiquetas[etiqueta] 
            address = format(direccion_etiqueta, '026b') 
            opcode = opcodes[operacion] 
            binario = opcode + address
        else:
            print(f"Error: Etiqueta '{etiqueta}' no encontrada.")
            sys.exit(1)

    codigo_maquina.append(binario)


#Escribir el codigo maquina en un archivo

with open('TestF2_MemInst.mem', 'w') as archivo_salida:
    for binario in codigo_maquina:
        archivo_salida.write(binario + '\n')

print("Traducción completa. El código máquina se ha guardado en 'TestF2_MemInst.mem'.")
