classdef IV_Data
   properties
      file_name
      data_vg
      data_vd
      data_ig
      data_id
      vg_range
      vd_range
      vg_number_of_each
      vd_number_of_each
      vg_step
      vd_step
      ngf
      W
      L
   end

   methods

       function obj = IV_Data(path_string)
           [filepath,name,ext] = fileparts(path_string);
           obj.file_name = name;
           if strcmp(ext, ".mat")
               mat_info = load(path_string);
               info_obj = mat_info.MeasurementIV;
               obj.ngf = info_obj.NGF;
               obj.W = info_obj.W;
               obj.L = info_obj.L;
               obj.vg_range = [info_obj.VGStart, info_obj.VGStop];
               obj.vg_step = info_obj.VGstep;
               obj.data_vg = info_obj.VGset;
               obj.data_vd = info_obj.VDset;
               obj.data_ig = info_obj.IGmeas;
               obj.data_id = info_obj.IDmeas;
           end
           
           if strcmp(ext, ".csv")
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
                obj.vg_step = vg_step;
                obj.vg_range = [vg_start, vg_data(length(vg_data))];

                [ngf, w] = extractDimensionsFromFileName(filepath);
                obj.ngf = ngf;
                obj.W = w;
           end
            
           % Set number of occurences of each Vg and Vd
           gc = groupcounts(obj.data_vg);
           if all(gc == gc(1))
               obj.vg_number_of_each = gc(1);
           end

           gc = groupcounts(obj.data_vd);
           if all(gc == gc(1))
               obj.vd_number_of_each = gc(1);
           end

           obj.vd_range = [max(obj.data_vd), min(obj.data_vd)];
           obj.vd_step = obj.data_vd(2) - obj.data_vd(1); % Should fix to read from file
           
       end

       function results_matrix = getDataFromVg(obj, values)
           results_matrix = cell(1, length(values));
           if (any(values > obj.vg_range(1)) || any(values < obj.vg_range(2)))
            error(" Invalid Values outside range %.2f to %.2f", obj.vg_range(2), obj.vg_range(1))
           end

           for i=1:length(values)
               loc = (obj.data_vg == values(i));
               if not(loc)
                   error("Invalid VG - Vg = %.2f not in measurements", values(i))
               end

               results = zeros(obj.vg_number_of_each, 3);
               results(:, 1) = obj.data_vd(loc);
               results(:, 2) = obj.data_id(loc);
               if ~isempty(obj.data_ig)
                   results(:, 3) = obj.data_ig(loc);
               else 
                   results(:, 3) = nan(obj.vg_number_of_each, 1);
               end

               results_matrix{1, i} = results;
           end

       end

       function results_matrix = getDataFromVd(obj, values)
           results_matrix = cell(1, length(values));
           if (any(values > obj.vd_range(1)) || any(values < obj.vd_range(2)))
            error(" Invalid Values outside range %.2f to %.2f", obj.vd_range(2), obj.vd_range(1))
           end

           for i=1:length(values)
               loc = (obj.data_vd == values(i));
               if not(loc)
                   error("Invalid VD - Vd = %.2f not in measurements", values(i))
               end

               results = zeros(obj.vd_number_of_each, 3);
               results(:, 1) = obj.data_vg(loc);
               results(:, 2) = obj.data_id(loc);
               if ~isempty(obj.data_ig)
                   results(:, 3) = obj.data_ig(loc);
               else 
                   results(:, 3) = nan(obj.vd_number_of_each, 1);
               end

               results_matrix{1, i} = results;
           end

       end
   end
end