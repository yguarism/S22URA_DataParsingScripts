from re import L
import numpy as np
import pandas as pd
import os
import pathlib
import scipy.io as sio
from FilesFromDirectory import FilesFromDirectory

def get_important_data_from_csv(data_path):
    vg_filter = "Analysis.Setup.Vector.Graph.SetupInfo" # in the second column
    data_filter_label = "DataName" # In the first column
    data_filter_vals = "DataValue" # In the first column

    vg_row = []
    data = []

    with open(data_path, 'r') as f:
        for line in f.readlines():
            if vg_filter in line:
                vg_row = [entry.strip() for entry in line.split(",")]
            if data_filter_label in line:
                data.append([entry.strip() for entry in line.split(",")])
            if data_filter_vals in line:
                data.append([entry.strip() for entry in line.split(",")])
    
    return vg_row, data

def calculate_v_num_elem(step, v_range):
    if step < 0: 
        return len(np.arange(v_range[0], v_range[1] , step))
    else:
        return len(np.arange(v_range[1], v_range[0] , step))

def parse_sep_vg_entry(vg_values, vd_num_ea):
    tab_entry_start = vg_values[2].split('\t')
    tab_entry_end = vg_values[len(vg_values) - 1].split('\t')

    vg_data = [float(tab_entry_start[1])] * vd_num_ea
    
    for entry in vg_values[3:-1]:
        vg_data.extend([float(entry)] * vd_num_ea)
    
    vg_data.extend([float(tab_entry_end[0])] * vd_num_ea)
    
    return vg_data

class IV_Data:
    file_name = ""
    data_vg = []
    data_vd = []
    data_ig = []
    data_id = []
    vg_range = []
    vd_range = []
    vg_number_of_each = np.NaN
    vd_number_of_each = np.NaN
    vg_step = np.NaN
    vd_step = np.NaN
    ngf = np.NaN
    W = np.NaN
    L = np.NaN

    def __init__(self, file_path):
        if (os.path.isfile(file_path)):
            path = pathlib.Path(file_path)
            self.file_name = path.name
            extension = path.suffix

            if ".csv" in extension:
                vg, data = get_important_data_from_csv(path)
                df = pd.DataFrame(data[1:], columns = data[0])
                df = df.replace(r'', np.nan, regex=True)

                numeric_columns = [i for i in df.columns if i != 'DataName']
                for column in numeric_columns:
                    df[column] = df[column].astype(float)

                if ("Vd" in df.columns):
                    vd_values = df["Vd"].unique()
                    self.data_vd = df["Vd"].tolist()
                    self.vd_range = [vd_values.max(), vd_values.min()]
                    self.vd_step = vd_values[1] - vd_values[0]               
                    self.vd_number_of_each = calculate_v_num_elem(self.vd_step, self.vd_range)
                    vd_max_indices = df[df["Vd"] == vd_values.max()].index

                if not ("Vg" in df.columns):
                    index_vd_max = vd_max_indices.sort_values()
                    df["Vg"] = parse_sep_vg_entry(vg, index_vd_max[1] - index_vd_max[0])

                vg_values = df["Vg"].unique()
                self.data_vg = df["Vg"].tolist()
                self.vg_range = [max(vg_values), min(vg_values)]
                self.vg_step = vg_values[1] - vg_values[0]
                self.vg_number_of_each = calculate_v_num_elem(self.vg_step, self.vg_range)

                if ("Id" in df.columns):
                    self.data_id = df["Id"].tolist()

                if ("Ig" in df.columns):
                    self.data_ig = df["Ig"].tolist()


            elif ".mat" in extension:
                print("MAT")
                mat_contents = sio.loadmat(path)
                mat_struct = mat_contents["MeasurementIV"][0,0]
                self.ngf = mat_struct["NGF"][0,0]
                self.W = mat_struct["W"][0,0]
                self.L = mat_struct["L"][0,0]
                self.vg_step = mat_struct["VGstep"][0,0]
                self.vd_step = mat_struct["VDstep"][0,0]
                self.vd_step = mat_struct["VDstep"][0,0]
                self.vg_range = [mat_struct["VGStart"][0,0], mat_struct["VGStop"][0,0]]
                self.vd_range = [mat_struct["VDStart"][0,0], mat_struct["VDStop"][0,0]]
                self.data_vg = np.array(mat_struct["VGset"]).squeeze()
                self.data_vd = np.array(mat_struct["VDset"]).squeeze()
                self.data_ig = np.array(mat_struct["IGmeas"]).squeeze()
                self.data_id = np.array(mat_struct["IDmeas"]).squeeze()
                self.vg_number_of_each = np.count_nonzero(self.data_vg == self.vg_range[1])
                self.vd_number_of_each = np.count_nonzero(self.data_vd == self.vd_range[1])
            
            else:
                print("Not Valid Extension - must be csv or mat")

    def print_important_param(self):
        print(f"vg_step: {self.vg_step}, vg_range: {self.vg_range}, vd_step: {self.vd_step}, vd_range: {self.vd_range}, num_vg: {len(self.data_vg)}, num_vd: {len(self.data_vd)}")
        print(f"Number of Points: VG: {self.vg_number_of_each}  VD:{self.vd_number_of_each}")


dir_str = r"..\\..\\..\\OneDrive\\Documents\\University\\Fourth Year\\4A\\URA\\IV Raw Data"
files_obj = FilesFromDirectory(dir_str, "csv")


x = IV_Data(files_obj.relative_filepaths[6])
print(x.file_name)
x.print_important_param()
