classdef VD_ID_Data
   properties
      data_vg
      data_vd
      data_ig
      data_id
      vg_range
      vg_number_of_each
      vg_step
   end

   methods

       function obj = VD_ID_Data(path_string, filetype)

           if strcmp(filetype, "csv")
                [vg_string_data, data_strings] = extractFileInfo(path_string);
                [data_table, contains_vg] = formatToTable(data_strings);
                [vg_data, vg_start, vg_step] = parseVgString(vg_string_data);
                
                if ~contains_vg
                    data_table = addVgToTable(data_table, vg_data);
                end
                
                % Set Data Arrays
                obj.data_vg = data_table.Vg;

                if any(strcmp('Vd', data_table.Properties.VariableNames))
                    obj.data_vd = data_table.Vd;
                end

                if any(strcmp('Ig', data_table.Properties.VariableNames))
                    obj.data_ig = data_table.Ig;
                end

                if any(strcmp('Id', data_table.Properties.VariableNames))
                    obj.data_id = data_table.Id;
                end

                % Set other parameters
                gc = groupcounts(obj.data_vg);
                if all(gc == gc(1))
                    obj.vg_number_of_each = gc(1);
                end

                obj.vg_step = vg_step;
                obj.vg_range = [vg_start, vg_data(length(vg_data))];

           end
           
       end
   end
end