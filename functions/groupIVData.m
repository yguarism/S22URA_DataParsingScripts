function grouped_values = groupIVData()
    grouped_values = cell(1, length(values));
    for i=1:length(values)
        loc = (obj.data_vg == values(i));
        if not(loc)
            error("Invalid VG - Vg = %.2f not in measurements", vg_values(i))
        end

        results = zeros(obj.vg_number_of_each, 3);
        results(:, 1) = obj.data_vd(loc);
        results(:, 2) = obj.data_id(loc);
        if ~isempty(obj.data_ig)
            results(:, 3) = obj.data_ig(loc);
        else 
            results(:, 3) = nan(obj.vg_number_of_each, 1);
        end

        grouped_values{1, i} = results;
    end
end