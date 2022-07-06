classdef IV_Data
   properties
      file_name
      data_vg
      data_vd
      data_ig
      data_id
      vg_range
      vg_number_of_each
      vg_step
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

               gc = groupcounts(obj.data_vg);
               if all(gc == gc(1))
                   obj.vg_number_of_each = gc(1);
               end

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
                gc = groupcounts(obj.data_vg);
                if all(gc == gc(1))
                    obj.vg_number_of_each = gc(1);
                end

                obj.vg_step = vg_step;
                obj.vg_range = [vg_start, vg_data(length(vg_data))];

                [ngf, w] = extractDimensionsFromFileName(filepath);
                obj.ngf = ngf;
                obj.W = w;
           end
           
       end
   end
end