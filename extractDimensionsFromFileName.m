function [ngf, w] = extractDimensionsFromFileName(file_path)
    % Assumes the last subdirectory of path will contain the ngf and width
    % values
    path_dirs= split(file_path, filesep);
    expression = "(\d+)x(\d+)";
    dir = path_dirs(length(path_dirs));
    token_results = regexp(dir, expression, 'tokens');
    
    ngf = str2double(token_results{1}(1));
    w = str2double(token_results{1}(2));

end

