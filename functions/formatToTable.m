function [data_table, contains_vg] = formatToTable(data_strings)
    tables = array2table(data_strings(2:end,1:end), 'VariableNames', data_strings(1, 1:end));
    column_names = tables.Properties.VariableNames;
    
    for i=2:length(column_names)
        tables.(i) = str2double(tables.(i));
    end
    data_table = rmmissing(tables);
    contains_vg = any(strcmp('Vg', data_table.Properties.VariableNames));
end