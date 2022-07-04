function updated_table = addVgToTable(data_table, vg_data)
    starting_vd = data_table.Vd(1,1);
    
    index = find(data_table.Vd==starting_vd);
    dist = index(2) - index(1);
    
    vg_for_table = zeros(length(data_table.Vd), 1);
    
    for i=1:length(vg_data)
        for j=1:dist
            vg_for_table(dist*(i - 1) + j) = vg_data(i);
        end
    end

    data_table.Vg = vg_for_table;
    updated_table = data_table;
end