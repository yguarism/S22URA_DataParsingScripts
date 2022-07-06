function [vg_data, vg_start, vg_step] = parseVgString(vg_string_data)
    dataBegin = vg_string_data{1,3};
    dataBegin = split(dataBegin{1});
    
    dataEnd = vg_string_data{1,length(vg_string_data)};
    dataEnd = split(dataEnd{1});
    num_data_points = length(vg_string_data);
    vg_count = str2double(dataEnd{4});
    
    vg_data = zeros(vg_count, 1);
    vg_data(1) = str2double(dataBegin{2});
    
    for i=4:num_data_points - 1
        vg_data(i-2) = str2double(vg_string_data{i});
    end
    
    vg_data(vg_count) = str2double(dataEnd{1});
    vg_start = str2double(dataEnd{2});
    vg_step = str2double(dataEnd{3});

end