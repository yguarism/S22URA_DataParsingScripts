# Class to Search for files of a specific type in a directory
# Yrina Guarisma
# June 27, 2022

import os
import pathlib

# provided_directory_path % Path passed into class by user
# file_type % File type for class (i.e. csv or mat) - do not include the "."
# file_names % List of all files of file type
# file_names_no_extension % List of all file names without the filetype extension
# absolute_filepaths % List of Absolute Paths to files of file type
# relative_filepaths % List of Absolute Paths to files of file type
# num_files % Number of Found Files

# Class Definition
class FilesFromDirectory:
  file_names = []
  file_names_no_extension = []
  absolute_filepaths = []
  relative_filepaths = []
  num_files = 0
  file_type = ""
  original_directory_path = ""
  added_directories = []
  
  def __init__(self, file_path, filetype):
    if (os.path.isdir(file_path)):
        self.original_directory_path = file_path
        if (isinstance(filetype, str)):
          self.file_type = filetype

          path = pathlib.Path(file_path)
          self.file_names = [p.name for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.file_names_no_extension = [p.name.replace("." + filetype, "") for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.absolute_filepaths = [os.path.abspath(p) for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.relative_filepaths = [p.__str__() for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.num_files = len(self.file_names)
  
  def addFilesfromPath(self, new_path):
    path = pathlib.Path(new_path)
    for p in path.rglob("*"):
      if (p.name.endswith("." + self.file_type) & ((p.name in self.file_names) == False)):
        self.file_names.append(p.name)
        self.file_names_no_extension.append(p.name.replace("." + self.file_type, ""))
        self.absolute_filepaths.append(os.path.abspath(p))
        self.relative_filepaths.append(p.__str__())
    
    self.num_files = len(self.file_names)
    self.added_directories.append(new_path)


x = FilesFromDirectory(r"..\\IV Raw Data\\2x40_3p_ChuckFloating\\", "csv")
print(x.file_names_no_extension)
print(x.num_files)
print(x.absolute_filepaths)

x.addFilesfromPath(r"..\\IV Raw Data\\")

print("Now with added files")
print(x.file_names)
print(x.num_files)
print(x.absolute_filepaths)