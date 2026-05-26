import tkinter as tk
from tkinter import filedialog, messagebox
import re

# DICCIONARIOS MIPS

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

opcodes = {
    'add': '000000', 'sub': '000000', 'and': '000000', 'or': '000000',
    'slt': '000000', 'sll': '000000', 'srl': '000000', 'jr': '000000',
    'addi': '001000', 'andi': '001100', 'ori': '001101', 'slti': '001010',
    'lw': '100011', 'sw': '101011', 'beq': '000100', 'bne': '000101',
    'j': '000010', 'jal': '000011' 
}

funct = {
    'add': '100000', 'sub': '100010', 'and': '100100', 'or': '100101',
    'slt': '101010', 'sll': '000000', 'srl': '000010', 'jr': '001000',
    'nop': '000000'
}


# TRADUCCIÓN

def ensamblar_codigo(ruta_entrada, ruta_salida):
    etiquetas = {} 
    instrucciones = [] 
    pc = 0 

    # Leer el archivo
    with open(ruta_entrada, 'r') as file:
        lineas = file.readlines() 

    # Primera Pasada: Limpiar, ignorar directivas y buscar etiquetas
    for linea in lineas:
        linea_limpia = linea.split('#')[0].strip()
        
        if not linea_limpia: 
            continue

        # Ignorar cualquier directiva de ensamblador o declaración de variables
        if linea_limpia in ['.data', '.text'] or linea_limpia.startswith('.globl') or '.word' in linea_limpia:
            continue

        # Revisar si la etiqueta está pegada a la instrucción (loop: addi, etc)
        if ':' in linea_limpia:
            partes = linea_limpia.split(':')
            etiqueta = partes[0].strip()
            etiquetas[etiqueta] = pc 
            
            instruccion_restante = partes[1].strip()
            if instruccion_restante:
                instrucciones.append(instruccion_restante)
                pc += 1
        else:
            instrucciones.append(linea_limpia) 
            pc += 1 

    # Segunda Pasada: Transformar a binario
    codigo_maquina = []

    for i, instruccion in enumerate(instrucciones):
        inst_limpia = instruccion.replace(',', ' ').replace('(', ' ').replace(')', ' ')
        partes = inst_limpia.split() 
        operacion = partes[0] 

        if operacion in ['add', 'sub', 'and', 'or', 'slt']:
            rd = registros[partes[1]] 
            rs = registros[partes[2]] 
            rt = registros[partes[3]] 
            shamt = '00000' 
            opcode = opcodes[operacion] 
            funct_code = funct[operacion] 
            binario = opcode + rs + rt + rd + shamt + funct_code

        elif operacion in ['sll', 'srl']:
            rd = registros[partes[1]] 
            rt = registros[partes[2]] 
            shamt = format(int(partes[3]), '05b') 
            rs = '00000' 
            opcode = opcodes[operacion] 
            funct_code = funct[operacion] 
            binario = opcode + rs + rt + rd + shamt + funct_code

        elif operacion == 'jr':
            rs = registros[partes[1]] 
            rt = '00000' 
            rd = '00000' 
            shamt = '00000' 
            opcode = opcodes[operacion] 
            funct_code = funct[operacion] 
            binario = opcode + rs + rt + rd + shamt + funct_code

        elif operacion in ['addi', 'andi', 'ori', 'slti']:
            rt = registros[partes[1]] 
            rs = registros[partes[2]] 
            imm = format(int(partes[3]) & 0xFFFF, '016b')
            opcode = opcodes[operacion] 
            binario = opcode + rs + rt + imm

        elif operacion in ['lw', 'sw']:
            rt = registros[partes[1]] 
            rs = registros[partes[3]] 
            imm = format(int(partes[2]) & 0xFFFF, '016b') 
            opcode = opcodes[operacion] 
            binario = opcode + rs + rt + imm

        elif operacion == 'nop':
            binario = '00000000000000000000000000000000'

        elif operacion in ['beq', 'bne']:
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
                raise ValueError(f"Etiqueta '{etiqueta}' no encontrada en la línea: {instruccion}")

        elif operacion in ['j', 'jal']:
            etiqueta = partes[1] 
            if etiqueta in etiquetas:
                direccion_etiqueta = etiquetas[etiqueta] 
                address = format(direccion_etiqueta, '026b') 
                opcode = opcodes[operacion] 
                binario = opcode + address
            else:
                raise ValueError(f"Etiqueta '{etiqueta}' no encontrada en la línea: {instruccion}")
        
        else:
            raise ValueError(f"Instrucción no soportada: '{operacion}' en la línea: {instruccion}")

        codigo_maquina.append(binario)

    # Escribir archivo de instrucciones:
    with open(ruta_salida, 'w') as archivo_salida:
        for binario in codigo_maquina:
            archivo_salida.write(binario + '\n')


# Interfaz gráfica

def seleccionar_entrada():
    ruta = filedialog.askopenfilename(
        title="Selecciona el archivo en Ensamblador",
        filetypes=(("Archivos de texto/ASM", "*.txt *.asm"), ("Todos los archivos", "*.*"))
    )
    if ruta:
        lbl_entrada_var.set(ruta)

def seleccionar_salida():
    ruta = filedialog.asksaveasfilename(
        title="Guardar archivo como...",
        defaultextension=".mem",
        initialfile="TestF2_MemInst.mem",
        filetypes=(("Archivos de Memoria", "*.mem"), ("Todos los archivos", "*.*"))
    )
    if ruta:
        lbl_salida_var.set(ruta)

def procesar():
    ruta_in = lbl_entrada_var.get()
    ruta_out = lbl_salida_var.get()

    if ruta_in == "Ningún archivo seleccionado" or ruta_out == "Ningún archivo seleccionado":
        messagebox.showwarning("Faltan datos", "Por favor selecciona tanto el archivo de entrada como el de salida.")
        return

    try:
        ensamblar_codigo(ruta_in, ruta_out)
        messagebox.showinfo("¡Éxito!", f"Traducción completada correctamente.\nGuardado en:\n{ruta_out}")
    except Exception as e:
        messagebox.showerror("Error de Ensamblado", f"Ocurrió un error al procesar el código:\n\n{str(e)}")

# Configuracion de la ventana principal 

root = tk.Tk()
root.title("Ensamblador MIPS - Fase 2")
root.geometry("500x250")
root.resizable(False, False)
root.config(padx=20, pady=20)

lbl_entrada_var = tk.StringVar(value="Ningún archivo seleccionado")
lbl_salida_var = tk.StringVar(value="Ningún archivo seleccionado")

tk.Label(root, text="Decodificador de Ensamblador a Binario", font=("Arial", 14, "bold")).pack(pady=(0, 15))

frame_in = tk.Frame(root)
frame_in.pack(fill="x", pady=5)
tk.Button(frame_in, text="1. Seleccionar Código (.txt/.asm)", command=seleccionar_entrada, width=30).pack(side="left")
tk.Label(frame_in, textvariable=lbl_entrada_var, fg="gray", wraplength=200).pack(side="left", padx=10)

frame_out = tk.Frame(root)
frame_out.pack(fill="x", pady=5)
tk.Button(frame_out, text="2. Seleccionar Destino (.mem)", command=seleccionar_salida, width=30).pack(side="left")
tk.Label(frame_out, textvariable=lbl_salida_var, fg="gray", wraplength=200).pack(side="left", padx=10)

tk.Button(root, text="Ensamblar Código", command=procesar, bg="#4CAF50", fg="white", font=("Arial", 12, "bold"), pady=5).pack(fill="x", pady=(20, 0))

root.mainloop()
