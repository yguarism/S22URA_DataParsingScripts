clear;
addpath("functions\")
path_string = "..\..\..\OneDrive\Documents\University\Fourth Year\4A\URA";
csv_files_obj = FilesFromDirectory(path_string, "csv");
mat_files_obj = FilesFromDirectory(path_string, "mat");
csv_path = csv_files_obj.relative_filepaths(16);
mat_path = mat_files_obj.relative_filepaths(2);


data = IV_Data(mat_path);

res = data.getDataFromVg([0,1]);
res1 = data.getDataFromVd(2);


rmpath("functions\")
fclose('all');