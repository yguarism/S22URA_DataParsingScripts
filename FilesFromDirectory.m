% Class to Search for all files of a specific type in a directory
% Yrina Guarisma
% June 26, 2022

classdef FilesFromDirectory
   properties
      provided_directory_path % Path passed into class by user
      file_type % File type for class (i.e. csv or mat) - do not include the "."
      file_names % List of all files of file type
      file_names_no_extension % List of all file names without the filetype extension
      absolute_filepaths % List of Absolute Paths to files of file type
      relative_filepaths % List of Absolute Paths to files of file type
      num_files % Number of Found Files
   end

   methods

       function obj = FilesFromDirectory(path_string, filetype)
           if isfolder(path_string)
               obj.provided_directory_path = path_string;
               if isstring(filetype)
                   % Store File Type
                   obj.file_type = filetype;

                   % Get All File Information
                   search_string = '**\*.' +  filetype;
                   filelist = dir(fullfile(path_string, search_string));

                   % Store Number of Files, File Names, and File Names
                   % without Extension
                   obj.num_files = length(filelist);
                   obj.file_names = string({filelist(:).name});
                   obj.file_names_no_extension = erase(obj.file_names, "." + filetype);
                   
                   % Build Absolute File Paths
                   obj.absolute_filepaths = strings;
                   for i = 1:obj.num_files
                       obj.absolute_filepaths(i) = fullfile(filelist(i).folder, filelist(i).name);
                   end
                   
                   % Build Relative File Paths
                   obj.relative_filepaths = strings;
                   home_path = dir(path_string).folder;
                   for i = 1:obj.num_files
                       relative_path = strrep(filelist(i).folder, home_path, path_string);
                       obj.relative_filepaths(i) = fullfile(relative_path, filelist(i).name);
                   end
               
               % File Type must be a String (i.e. "csv" or "mat")
               else
                   error("File Type Must be String")
               
               end
           
           % Path String must be an existing Directory
           else 
               error("Path String Not a Directory")
           end
      end

   end

end
