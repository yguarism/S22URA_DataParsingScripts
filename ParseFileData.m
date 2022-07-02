clear;
files_obj = FilesFromDirectory("..", "csv");
path = files_obj.relative_filepaths(7);
disp(path)

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
        vg_data = textscan(t, format_string, 'Delimiter', ',');
    end
end

tables = array2table(data_strings(2:end,1:end), 'VariableNames', data_strings(1, 1:end));
column_names = tables.Properties.VariableNames;

for i=2:length(column_names)
    tables.(i) = str2double(tables.(i));
end
tables = rmmissing(tables);

%% Parsing vg data from the row - Hardcoded
first_data = vg_data{1,3};
x = first_data{1};
x_split = split(x);

last_data = vg_data{1,length(vg_data)};
y = last_data{1};
y_split = split(y);
num_data_points = str2double(y_split{length(y_split)});

vg_string_data = strings(num_data_points + 4, 1);
vg_string_data(1) = x_split{2};

for i=4:num_data_points+ 1
    vg_string_data(i) = vg_data{i};
end

vg_string_data(num_data_points + 2) = y_split{1};

vg_string_data = rmmissing(vg_string_data);



%% 

fclose('all');