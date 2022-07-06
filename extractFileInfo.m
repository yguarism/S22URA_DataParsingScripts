function [vg_string_data, data_strings] = extractFileInfo(path)
    
    file_contents = textscan(fopen(path), '%s', 'Delimiter', '\n');
    file_contents = file_contents{1,1};

    vg_id = "Analysis.Setup.Vector.Graph.SetupInfo";
    data_title_id = "DataName";
    data_id = "DataValue";
    count_data = 1;
    
    for i=1:length(file_contents)
        temp = file_contents(i);
        t = temp{1};
        num_commas = count(t, ",");
    
        % Make creation of format string dynamic
        if contains(t, data_title_id) == 1
            format_string = repmat('%s', 1, num_commas + 1);
            % Initialize strings array
            data_strings = strings(length(file_contents), num_commas + 1);
            f_data = textscan(t, format_string, 'Delimiter', ',');
            for j = 1:num_commas+1
                data_strings(count_data, j) = f_data{j};
            end
            count_data = count_data + 1;
    
        elseif contains(t, data_id) == 1
            format_string = repmat('%s', 1, num_commas + 1);
            f_data = textscan(t, format_string, 'Delimiter', ',');
            for j = 1:num_commas+1
                data_strings(count_data, j) = f_data{j};
            end
            count_data = count_data + 1;
       
        elseif contains(t, vg_id) == 1
            format_string = repmat('%s', 1, num_commas + 1);
            vg_string_data = textscan(t, format_string, 'Delimiter', ',');
        end
    end

    fclose('all');
end

