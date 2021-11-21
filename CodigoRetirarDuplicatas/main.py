from fileFunctions import fileManipulation
import numpy as np
#Pais, Pedido, TransportadoraProduto, VendedorProduto
def main():
    file = fileManipulation()
    nome = input("Digite o nome do arquivo que deseja remover as duplicatas: ")
    content = file.deleteDuplicatas(nome)
    file.removeFile(nome)
    file.createFile(nome)
    file.inserirFile(content, nome)

if __name__ == '__main__':
    main()