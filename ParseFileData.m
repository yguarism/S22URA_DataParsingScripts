clear;
path_string = "..\..\..\OneDrive\Documents\University\Fourth Year\4A\URA";
csv_files_obj = FilesFromDirectory(path_string, "csv");
mat_files_obj = FilesFromDirectory(path_string, "mat");
csv_path = csv_files_obj.relative_filepaths(3);
mat_path = mat_files_obj.relative_filepaths(2);


data = IV_Data(csv_path);





fclose('all');