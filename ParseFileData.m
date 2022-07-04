clear;
path_string = "..\..\..\OneDrive\Documents\University\Fourth Year\4A\URA";
files_obj = FilesFromDirectory(path_string, "csv");
path = files_obj.relative_filepaths(16);
disp(path)

data_obj = VD_ID_Data(path, "csv");

fclose('all');