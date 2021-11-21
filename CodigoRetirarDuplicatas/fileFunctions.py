import os
#Sistema de arquivos no servidor.
class fileManipulation:
    def __init__(self):
        self._path = self.getPath()

    # 1 - read Method (file)
    def readFile(self, nome):
        file = self._path + nome
        show = open(file, 'r+')
        print("File Readed")
        return show.read()

    # 2 - rename Method (file)
    def renameFile(self, nome, new_nome):
        file = self._path + nome
        rename_file = self._path + new_nome
        os.rename(file, rename_file)
        print("File Renamed!")

    #3 - create Method (file)
    def createFile(self, nome):
        file = self._path + nome
        open(file, 'w')
        print("File Created!")

    #4 - remove Method (file)
    def removeFile(self, nome):
        file = self._path + nome
        os.remove(file)
        print("File Removed")

    def getPath(self):
        path = os.getcwd().split("\\")
        path.pop()
        return "\\".join(path) + "\\"

    def inserirFile(self, data, nome):
        file = self._path + nome
        insert = open(file, 'a')
        insert.write(data)
        insert.close()
        print("Done!")

    def deleteDuplicatas(self, nome):
        resgatar = []
        i = 1
        file = self._path + nome
        show = open(file, 'r+')
        linhas = show.read().split('\n')
        linhas.pop()
        resgatar.append(linhas.pop(0))
        while True:
            j = 0
            resgatar.append(linhas[0])
            while resgatar[i] in linhas:
                if (resgatar[i] == linhas[j]):
                    linhas.pop(j)
                else:
                    j += 1
            qnt = len(linhas)
            if (qnt == 0):
                break
            i += 1
        colunas = resgatar.pop(0)
        resgatar.sort()
        resgatar = "\n".join(resgatar)
        return colunas + "\n" + resgatar