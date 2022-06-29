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
  provided_directory_path = ""
  
  def __init__(self, file_path, filetype):
    if (os.path.isdir(file_path)):
        self.provided_directory_path = file_path
        if (isinstance(filetype, str)):
          self.file_type = filetype

          path = pathlib.Path(file_path)
          self.file_names = [p.name for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.file_names_no_extension = [p.name.replace("." + filetype, "") for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.absolute_filepaths = [os.path.abspath(p) for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.relative_filepaths = [p.__str__() for p in path.rglob("*") if p.name.endswith("." + filetype)]
          self.num_files = len(self.file_names)

# Utilization Examples in Python
z = FilesFromDirectory(r"www", "csv") # Non-existent directory
print(z.absolute_filepaths)
print(z.relative_filepaths)
print(z.file_names_no_extension)
print(z.num_files)

x = FilesFromDirectory(r"..\\IV Raw Data\\2x40_3p_ChuckFloating\\", "csv")
print(x.absolute_filepaths)
print(x.relative_filepaths)
print(x.file_names_no_extension)
print(x.num_files)

for i, file in enumerate(x.file_names_no_extension):
  if "DieB(57)" in file:
    print(f"File Number with Matching String: {i}")


y = FilesFromDirectory(r"..\\IV Raw Data\\", "mat")
print(y.absolute_filepaths)
print(y.relative_filepaths)
print(y.file_names_no_extension)
print(y.num_files)