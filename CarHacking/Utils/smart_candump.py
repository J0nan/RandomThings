# Author: J0nan
# Tool to discover CAN frames

import subprocess
import csv
import os
import sys
import select

# Archivo para almacenar la base de datos
BD_FILE = "bd_candump.csv"

database_updates_enabled = True  # Variable global para controlar las actualizaciones de la base de datos

def get_can_interface():
    interface = input("Ingrese la interfaz CAN que desea usar (por ejemplo, can0 o can1): ")
    print(f"Información de la interfaz {interface}:")
    subprocess.run(["ip", "link", "show", interface])
    return interface

def get_mode():
    print("\n\nSeleccione el modo:")
    print("1. Modo análisis de IDs")
    print("2. Modo descubrimiento")
    while True:
        try:
            mode = int(input("Ingrese el número del modo (1 o 2): "))
            if mode in [1, 2]:
                return mode
        except ValueError:
            pass
        print("Entrada inválida. Por favor ingrese 1 o 2.")

def analyze_ids(can_interface):
    ids = input("Ingrese los IDs de las tramas a mostrar, separados por comas: ").split(",")
    ids = [id.strip() for id in ids]
    print(f"Mostrando solo tramas con los IDs: {ids}")

    process = subprocess.Popen(["candump", can_interface], stdout=subprocess.PIPE, text=True)
    print("Esperando tramas...")
    try:
        for line in process.stdout:
            parts = line.split()
            if len(parts) >= 3:
                frame_id = parts[1].strip()
                if frame_id in ids:
                    data = " ".join(parts[2:])
                    print(f"Trama: {frame_id} {data}")
    except KeyboardInterrupt:
        process.terminate()
        print("\nRegresando al menú principal...")
        return

def reset_database():
    if os.path.exists(BD_FILE):
        os.remove(BD_FILE)
        print("Base de datos reiniciada.")
    else:
        print("No hay base de datos existente para reiniciar.")

def load_database():
    database = set()
    if os.path.exists(BD_FILE):
        with open(BD_FILE, mode="r") as file:
            reader = csv.reader(file)
            for row in reader:
                database.add((row[0], row[1]))
    return database

def save_to_database(frame_id, data):
    if database_updates_enabled:
        with open(BD_FILE, mode="a", newline="") as file:
            writer = csv.writer(file)
            writer.writerow([frame_id, data])

def get_discovery_options_menu():
    print("\n\nMenú de opciones del modo descubrimiento:")
    print(f"1. Alternar la actualización de la BD. Actualmente se encuentra en: {database_updates_enabled}")
    print("2. Mostrar los IDs ignorados.")
    print("3. Salir del menú de opciones y continuar.")
    while True:
        try:
            mode = int(input("Ingrese el número del modo (1, 2 o 3): "))
            if mode in [1, 2, 3]:
                return mode
        except ValueError:
            pass
        print("Entrada inválida. Por favor ingrese 1, 2 o 3.")

def toggle_database_updates():
    global database_updates_enabled
    database_updates_enabled = not database_updates_enabled
    status = "activadas" if database_updates_enabled else "desactivadas"
    print(f"Actualizaciones de la base de datos {status}.")

def show_ignored_ids(ignored_ids):
    print("Los IDs que no se muestran y no se guardan en la BD son:\n")
    print(",".join(map(str, ignored_ids)))

def discovery_options_menu(ignored_ids):
    while True:
        option = get_discovery_options_menu()
        if option == 1:
            toggle_database_updates()
        elif option == 2:
            show_ignored_ids(ignored_ids)
        elif option == 3:
            return

def discovery_mode(can_interface):
    reset = input("¿Desea reiniciar la base de datos? (s/n): ").strip().lower() == 's'
    if reset:
        reset_database()

    database = load_database()
    ignored_ids = set()
    print("Opciones disponibles durante el escaneo")
    print("Presiona d + Enter para entrar en modo de eliminación.")
    print("Presiona o + Enter para entrar en el menú de opciones.")
    input("Presiona Enter para iniciar la captura.")
    print("Modo descubrimiento iniciado. Capturando tramas únicas...")
    process = subprocess.Popen(["candump", can_interface], stdout=subprocess.PIPE, text=True)
    try:
        while True:
            line = process.stdout.readline()
            if not line:
                break

            if sys.stdin in select.select([sys.stdin], [], [], 0)[0]:
                command = sys.stdin.read(1)
                if command.lower() == 'd':
                    print(f"IDs ignorados: {ignored_ids}")
                    new_ignored = input("Ingrese los IDs a ignorar, separados por comas: ").split(",")
                    ignored_ids.update(id.strip() for id in new_ignored)
                    continue
                elif command.lower() == 'o':
                    discovery_options_menu(ignored_ids)
                    continue

            parts = line.split()
            if len(parts) >= 3:
                frame_id = parts[1].strip()
                data = " ".join(parts[2:]).strip()
                id_data = (frame_id, data)
                if frame_id in ignored_ids:
                    continue
                if id_data not in database:
                    database.add(id_data)
                    save_to_database(frame_id, data)
                    print(f"Nueva trama: {frame_id} {data}")
    except KeyboardInterrupt:
        process.terminate()
        print("\nRegresando al menú principal...")
        return

def main_menu(can_interface):
    try:
        while True:
            mode = get_mode()
            if mode == 1:
                analyze_ids(can_interface)
            elif mode == 2:
                discovery_mode(can_interface)
    except KeyboardInterrupt:
        print("\nCerrando programa...")
        return

if __name__ == "__main__":
    print("=== Script CAN Dump ===")

    can_interface = get_can_interface()
    main_menu(can_interface)
